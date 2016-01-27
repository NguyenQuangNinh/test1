package game.net.lobby.response 
{
	import flash.utils.ByteArray;
	import game.net.ResponsePacket;
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class ResponsePVP1vs1MMState extends ResponsePacket
	{			
		//respone
		public var numMatchPlayed:int;
		public var rank:int;
		public var honorPoint:int;
		public var eloPoint:int;
		
		public var rewardDaily:int;
		public var receivedRewardDaily:Boolean;
		public var rewardWeekly:int;
		public var receivedRewardWeekly:Boolean;
		//time calculate in minute
		public var timeRemainRewardDaily:int;
		public var timeRemainRewardWeekly:int;
		
		public function ResponsePVP1vs1MMState() 
		{
			
		}
		
		override public function decode(data:ByteArray):void 
		{
			super.decode(data);
			
			numMatchPlayed = data.readInt();
			rank = data.readInt();
			eloPoint = data.readInt();
			honorPoint = data.readInt();
			
			rewardDaily = data.readInt();
			receivedRewardDaily = data.readByte() == 1;
			rewardWeekly = data.readInt();
			receivedRewardWeekly = data.readByte() == 1;
			
			timeRemainRewardDaily = data.readInt();
			timeRemainRewardWeekly = data.readInt();
		}
	}

}