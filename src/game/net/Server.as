package game.net
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.Socket;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.Endian;
	import flash.utils.setTimeout;
	import game.net.game.GameResponseType;
	import game.net.lobby.LobbyResponseType;
	
	import core.Manager;
	import core.event.EventEx;
	import core.util.ByteArrayEx;
	import core.util.Enum;
	import core.util.Utility;
	
	import game.enum.ServerResponseType;
	
	public class Server extends EventDispatcher
	{
		public static const SERVER_DATA:String = "server_data";
		public static const SERVER_CONNECTED:String = "server_connected";
		public static const SERVER_DISCONNECTED:String = "server_disconnected";
		public static const SERVER_RETRY:String = "server_retry";
		public static const SERVER_CONNECTION_FAIL:String = "server_connection_fail";
		
		private static const MAX_RETRY:int = 3;
		
		protected var socket:Socket;
		protected var responseTypeClass:Class;
		
		private var sequenceNumber:uint = 0;
		private var currentHeader:PacketHeader = null;
		private var packetHandlers:Dictionary = new Dictionary();
		private var currentRetry:int;
		private var host:String;
		private var port:int;
		protected var serverName:String = "";
		
		public function Server()
		{
			socket = new Socket();
			socket.endian = Endian.LITTLE_ENDIAN;
			socket.addEventListener(Event.CLOSE, onDisconnected);
			socket.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			socket.addEventListener(Event.CONNECT, onConnected);
			socket.addEventListener(ProgressEvent.SOCKET_DATA, onDataReceived);
		}
		
		public function isConnected():Boolean { return socket.connected; }
		
		protected function onSecurityError(event:SecurityErrorEvent):void
		{
			Utility.error(event.text);
			if(currentRetry < MAX_RETRY)
			{
				retry();
			}
			else
			{
				dispatchEvent(new Event(SERVER_CONNECTION_FAIL));
			}
		}
		
		protected function onDisconnected(event:Event):void
		{
			Utility.log(this + " disconnected");
			dispatchEvent(event);
			dispatchEvent(new Event(SERVER_DISCONNECTED));
			sequenceNumber = 0;
		}
		
		protected function onIOError(event:IOErrorEvent):void
		{
			Utility.error(event.text);
			if(currentRetry < MAX_RETRY)
			{
				retry();
			}
			else
			{
				dispatchEvent(new Event(SERVER_CONNECTION_FAIL));
			}
		}
		
		public function fireServerDataEvent(packet:ResponsePacket):void
		{
			dispatchEvent(new EventEx(SERVER_DATA, packet));
		}
		
		protected function onDataReceived(event:ProgressEvent):void	
		{
			try
			{
				readPacket();
			}
			catch(e:Error)
			{
				Utility.log(this + " read packet error on type: " + currentHeader.type);
				Utility.error(e.getStackTrace());
			}
		}
		
		protected function readPacket():void
		{
			if (currentHeader == null) currentHeader = readHeader();
			if (currentHeader != null && socket.bytesAvailable >= currentHeader.length)
			{
				var _data:ByteArray = Manager.pool.pop(ByteArrayEx) as ByteArrayEx;
				_data.clear();
				if(currentHeader.length > 0)
				{
					socket.readBytes(_data, 0, currentHeader.length);
				}
				var serverResponseType:ServerResponseType = Enum.getEnum(responseTypeClass, currentHeader.type) as ServerResponseType;
				
				if (serverResponseType != null)
				{
					if (DebuggerUtil.getInstance().isNetTraced) 
					{
						Utility.log(serverName + " receive packet <<<<<<<<<< 	" + Enum.getEnum(responseTypeClass, serverResponseType.ID).constName + "  " + serverResponseType.ID);
					}
					//Utility.log(this + " RESPONSE packetType=" + currentHeader.type);
					var packetClass:Class = serverResponseType.packetClass;
					var packet:ResponsePacket = new packetClass();
					packet.type = serverResponseType;
					try {
						packet.decode(_data);
					} 
					catch (e:Error) 
					{
						Utility.log(e.getStackTrace());
					}
					if (DebuggerUtil.getInstance().serverDelay == 0) dispatchEvent(new EventEx(SERVER_DATA, packet));
					else setTimeout(dispatchEvent, DebuggerUtil.getInstance().serverDelay, new EventEx(SERVER_DATA, packet));
					var callbacks:Array = packetHandlers[serverResponseType];
					if(callbacks != null)
					{
						for each(var callback:Function in callbacks)
						{
							callback(packet);
						}
					}
				}
				else
				{
					Utility.error(this + " unhandled packet type: " + currentHeader.type);
				}
				currentHeader = null;
				Manager.pool.push(_data, ByteArrayEx);
				if (socket.bytesAvailable > 0) readPacket();
			}
		}
		
		private function retry():void
		{
			currentRetry++;
			dispatchEvent(new EventEx(SERVER_RETRY, currentRetry));
			Utility.log(" retry connecting to server : " + host + ":" + port + " currentRetry: " + currentRetry);
			socket.connect(host, port);
		}
		
		protected function readHeader():PacketHeader
		{
			return null;
		}
		
		public function sendPacket(packet:RequestPacket):void
		{
			if(socket.connected)
			{
				//Utility.log(this + " REQUEST packetType=" + packet.getType());
				var data:ByteArray = packet.encode();
				var header:ByteArray = new ByteArray();
				header.endian = Endian.LITTLE_ENDIAN;
				header.writeUnsignedInt(data.length);
				header.writeUnsignedInt(Utility.crc.make(data));
				header.writeUnsignedInt(sequenceNumber);
				if (packet.getType() > 0)
					sequenceNumber++;
				header.writeShort(packet.getType());
				socket.writeBytes(header);
				socket.writeBytes(data);
				socket.flush();
			}
		}
		
		protected function onConnected(event:Event):void
		{
			socket.writeByte(65);
			socket.flush();
			
			Utility.log(this + " connected");
			dispatchEvent(new Event(SERVER_CONNECTED));
		}
		
		public function connect(host:String, port:int):void
		{
			this.host = host;
			this.port = port;
			currentRetry = 0;
			socket.connect(host, port);
		}
		
		public function disconnect():void
		{
			if (isConnected())
			{
				Utility.log(this + " close connection");
				socket.close();
				sequenceNumber = 0;
			}
		}
		
		public function registerPacketHandler(type:ServerResponseType, callback:Function):void
		{
			var callbacks:Array = packetHandlers[type];
			if(callbacks == null)
			{
				callbacks = [];
				packetHandlers[type] = callbacks;
			}
			callbacks.push(callback);
		}
		
		public function unregisterPacketHandler(type:ServerResponseType, callback:Function):void
		{
			var callbacks:Array = packetHandlers[type];
			if(callbacks != null)
			{
				callbacks.splice(callbacks.indexOf(callback), 1);
			}
		}
	}
}