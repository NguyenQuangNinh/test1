package game.net.lobby.response 
{
	import core.util.ByteArrayEx;
	import flash.utils.ByteArray;
	import game.net.ResponsePacket;
	/**
	 * ...
	 * @author vuanh
	 */
	public class ResponseGetActivityInfo extends ResponsePacket
	{
		public var nActivityPoint:int;

		public var nRewardIndexs:Array;
		
		public var nFinishDailyQuestCount:int;
		public var nFinishTransporterQuestCount:int;
		public var nFinishCampaignCount:int;
		public var nFinishPVP1vs1Count:int;
		public var nFinishPVP3vs3MMCount:int;
		public var nFinishPVP1vs1MMCount:int;
		public var nFinishHeroicCount:int;
		public var nFinishGlobalBossCount:int;
		public var nFinishTowerCount:int;
		public var nFinishTransmitExpCount:int;
		public var nFinishAlchemyCount:int;
		public var nFinishSoulCount:int;
		public var nFinishUpgradeSkillCount:int;
		

		override public function decode(data:ByteArray):void 
		{
			if (!data.bytesAvailable) return;
			
			nActivityPoint = data.readInt();
			var rewardSize:int = data.readInt();
			nRewardIndexs = [];
			for (var i:int = 0; i < rewardSize; i++) 
			{
				nRewardIndexs.push(data.readInt());
			}
			nFinishDailyQuestCount = data.readInt();
			nFinishTransporterQuestCount = data.readInt();
			nFinishCampaignCount = data.readInt();
			nFinishPVP1vs1Count = data.readInt();
			nFinishPVP3vs3MMCount = data.readInt();
			nFinishPVP1vs1MMCount = data.readInt();
			nFinishHeroicCount = data.readInt();
			nFinishGlobalBossCount = data.readInt();
			nFinishTowerCount = data.readInt();
			nFinishTransmitExpCount = data.readInt();
			nFinishAlchemyCount = data.readInt();
			nFinishSoulCount = data.readInt();
			nFinishUpgradeSkillCount = data.readInt();
			
		}
		
	}

}