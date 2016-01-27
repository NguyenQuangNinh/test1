package game.net.lobby.response 
{
	import flash.utils.ByteArray;
	import game.net.ResponsePacket;
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class ResponseTopReceivedReward extends ResponsePacket
	{
		
		public var topType:int;
		public var result:int;
		
		public function ResponseTopReceivedReward() 
		{
			
		}
		
		
		override public function decode(data:ByteArray):void 
		{
			super.decode(data);
			topType = data.readInt();
			result = data.readInt();
		}
	}

}