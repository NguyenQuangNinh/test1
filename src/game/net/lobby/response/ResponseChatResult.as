package game.net.lobby.response 
{
	import core.util.ByteArrayEx;
	
	import flash.utils.ByteArray;
	
	import game.net.ResponsePacket;

	/**
	 * ...
	 * @author ...
	 */
	public class ResponseChatResult extends ResponsePacket 
	{
		public var chatType:int;
		public var errorCode:int;
		public var playerID:int;
		public var name:String;
		public var mes:String;
		
		override public function decode(data:ByteArray):void 
		{
			if (data)
			{
				chatType = data.readInt();
				errorCode = data.readInt();
				playerID = data.readInt();
				name = ByteArrayEx(data).readString();
				mes = ByteArrayEx(data).readString();
			}			
		}		
	}

}