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
	import flash.utils.IDataOutput;
	import game.net.game.GameResponseType;
	import game.net.lobby.LobbyResponseType;
	
	import core.Manager;
	import core.event.EventEx;
	import core.util.ByteArrayEx;
	import core.util.Enum;
	import core.util.Utility;
	
	import game.enum.ServerResponseType;
	
	public class ExServer extends EventDispatcher
	{
		protected var responseTypeClass:Class;
		
		private var currentHeader:PacketHeader = null;
		protected var serverName:String;
		
		public function ExServer()
		{
		}
		
		public function readPacket(ba:ByteArray):ResponsePacket
		{
			if (currentHeader == null) currentHeader = readHeader(ba);
			if (currentHeader != null)
			{
				var _data:ByteArray = Manager.pool.pop(ByteArrayEx) as ByteArrayEx;
				_data.clear();
	
				if(currentHeader.length > 0)
				{
					ba.readBytes(_data, 0, currentHeader.length);
				}
				var serverResponseType:ServerResponseType = Enum.getEnum(responseTypeClass, currentHeader.type) as ServerResponseType;
				
				if (serverResponseType != null)
				{
					
					Utility.log(serverName + " decode packet ========== 	" + Enum.getEnum(responseTypeClass, serverResponseType.ID).constName + "  " + serverResponseType.ID);
					
					var packetClass:Class = serverResponseType.packetClass;
					var packet:ResponsePacket = new packetClass();
					packet.type = serverResponseType;

					try 
					{
						packet.decode(_data);
					} 
					catch (e:Error) 
					{
						Utility.log(e.getStackTrace());
					}
					currentHeader = null;
					return packet;
				}
				else
				{
					Utility.error(this + " unhandled decode packet type: " + currentHeader.type);
				}
				currentHeader = null;
				Manager.pool.push(_data, ByteArrayEx);
			}
			return null;
		}
		
		protected function readHeader(ba:ByteArray):PacketHeader
		{
			return null;
		}
	}
}