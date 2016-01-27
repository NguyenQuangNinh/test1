package game.net.lobby.response 
{
	import flash.utils.ByteArray;
	import game.net.ResponsePacket;
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class ResponsePVP1vs1AIState extends ResponsePacket
	{
		public var numMatchFreePlayed:int;
		public var numMatchPaid:int;
		public var timeRemain:int;
		
		public var numMatchPlayedInWeek:int;
		public var groupRank:int;
		public var rank:int;
		
		public var rewardGroupWeekly:int;
		public var rewardRankWeekly:int;
		public var rewardRankDaily:int;
		
		public var receivedRewardGroupWeekly:Boolean;
		public var receivedRewardRankDaily:Boolean;
		public var receivedRewardRankWeekly:Boolean;
		
		public var timeRemainWeekly:int;
		public var timeRemainDaily:int;
		
		//dynamic variable
		public var maxMatchFreePlay:int;
		
		public function ResponsePVP1vs1AIState() 
		{
			
		}
		
		override public function decode(data:ByteArray):void 
		{
			super.decode(data);
			numMatchFreePlayed = data.readInt();
			numMatchPaid = data.readInt();
			timeRemain = data.readInt();
			
			numMatchPlayedInWeek = data.readInt();
			groupRank = data.readInt();
			rank = data.readInt();
			
			rewardGroupWeekly = data.readInt();
			//receivedRewardGroupWeekly = data.readByte() == 1;
			
			rewardRankWeekly = data.readInt();
			receivedRewardRankWeekly = data.readByte() == 1;
			timeRemainWeekly = data.readInt();
			
			rewardRankDaily = data.readInt();
			receivedRewardRankDaily = data.readByte() == 1;
			timeRemainDaily = data.readInt();
		}
	}

}