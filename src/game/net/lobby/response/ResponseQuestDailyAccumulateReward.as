package game.net.lobby.response 
{
	import flash.utils.ByteArray;
	import game.net.ResponsePacket;
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class ResponseQuestDailyAccumulateReward extends ResponsePacket
	{
		
		public var indexRewards:Array = []
		
		public function ResponseQuestDailyAccumulateReward() 
		{
			
		}
		
		override public function decode(data:ByteArray):void 
		{
			super.decode(data);
			while (data && data.bytesAvailable > 0) {
				indexRewards.push(data.readInt());
			}
		}
	}

}