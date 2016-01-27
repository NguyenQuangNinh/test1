package game.net.lobby.response 
{
	import flash.utils.ByteArray;
	import game.net.ResponsePacket;
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class ResponseCreateRoom extends ResponsePacket
	{
		public var errorCode:int;
		public var roomID:int;
		
		public function ResponseCreateRoom() 
		{
			
		}		
		
		override public function decode(data:ByteArray):void 
		{
			errorCode = data.readInt();			
			roomID = data.readInt();
		}
	}

}