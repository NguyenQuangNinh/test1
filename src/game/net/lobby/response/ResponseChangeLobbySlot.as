package game.net.lobby.response 
{
	import core.util.ByteArrayEx;
	
	import flash.utils.ByteArray;
	
	import game.net.ResponsePacket;

	/**
	 * ...
	 * @author TrungLNM
	 */
	public class ResponseChangeLobbySlot extends ResponsePacket
	{
		
		public var playerID:int;
		public var playerName:String;
		
		public function ResponseChangeLobbySlot() 
		{
			
		}
		
		override public function decode(data:ByteArray):void 
		{
			super.decode(data);
			playerID = data.readInt();
			playerName = ByteArrayEx(data).readString();
		}
	}

}