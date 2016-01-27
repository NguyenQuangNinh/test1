package game.net.lobby.response 
{
	import flash.utils.ByteArray;
	import game.net.ResponsePacket;
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class ResponseQuestDailyState extends ResponsePacket
	{
		
		public var numCompleted:int;
		public var totalCompleted:int;
		public var timeRemain:int;
		
		public var scoreAccumulate:int;
		public var indexAccumulated:int;
		public var state:int;
		
		public function ResponseQuestDailyState() 
		{
			
		}
		
		override public function decode(data:ByteArray):void 
		{
			super.decode(data);
			numCompleted = data.readInt();
			totalCompleted = data.readInt();
			timeRemain = data.readInt();
			scoreAccumulate = data.readInt();
			indexAccumulated = data.readInt();
			state = data.readInt();
		}
		
	}

}