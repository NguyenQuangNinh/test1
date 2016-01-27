package game.net.lobby.response 
{
	import flash.utils.ByteArray;
	import game.net.ResponsePacket;
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class ResponseJoinRoomPvP extends ResponsePacket
	{
		public var errorCode:int;
		public var mode:int;
		
		public function ResponseJoinRoomPvP() 
		{
			
		}		
		
		override public function decode(data:ByteArray):void 
		{
			super.decode(data);
			errorCode = data.readInt();
			mode = data.readInt();
		}
	}

}