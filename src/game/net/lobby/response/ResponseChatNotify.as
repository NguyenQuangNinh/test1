package game.net.lobby.response 
{
	import core.util.ByteArrayEx;
	
	import flash.utils.ByteArray;
	
	import game.net.ResponsePacket;

	/**
	 * ...
	 * @author ...
	 */
	public class ResponseChatNotify extends ResponsePacket 
	{
		public var chatType:int;
		public var playerId:int;
		public var name:String;
		public var mes:String;
		
		override public function decode(data:ByteArray):void 
		{
			chatType = data.readInt();
			playerId = data.readInt();
			name = ByteArrayEx(data).readString();
			mes = ByteArrayEx(data).readString();
		}
		
	}

}