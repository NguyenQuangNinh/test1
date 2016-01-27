package game.data.xml
{
	import core.util.Utility;
	import flash.utils.Dictionary;
	import game.Game;
	import game.ui.heroic.world_map.CampaignData;
	
	import game.data.model.ModeConfigGlobalBoss;
	import game.enum.GameMode;
	import game.data.xml.config.XMLConfig;
	
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class ModeConfigXML extends XMLData
	{
		public var name:String;
		public var type:int;
		//public var modeID:int;
		public var desc:String;
		public var display:Boolean;
		public var timeOpen:Array = [];
		public var timeClose:Array = [];
		public var shortImage:String;
		public var fullImage:String;
		public var backGroundID:int;
		public var fixRewards:Array = [];
		public var randomRewards:Array = [];
		public var heroicConfig:Dictionary;
		
		//private var _topReward:Array = [];
		
		//private var coolDownPerPlay:int = -1;
		//private var costSkipCoolDownPerPlay:int = -1;		
		//private var maxHornorDaily:int = -1;
		
		//private var maxFreePlay:int = -1;
		//private var maxPayPlay:int = -1;
		
		private var _groupReward:Array = [];
		
		public var xmlData:XML;
		public var globalBossConfig:ModeConfigGlobalBoss;
		
		public var xmlConfig:XMLConfig;
		
		public var nLevelRequirement:int;
		
		public function ModeConfigXML()
		{
		
		}
		
		override public function parseXML(xml:XML):void
		{
			super.parseXML(xml);
			xmlData = xml;
			
			name = xml.Name.toString();
			type = parseInt(xml.Type.toString());
			//modeID = parseInt(xml.ModeID.toString());			
			desc = xml.Desc.toString();
			display = parseInt(xml.Display.toString()) == 1;
			shortImage = xml.ShortImage.toString();
			fullImage = xml.FullImage.toString();
			backGroundID = parseInt(xml.BackgroundID.toString());
			fixRewards = Utility.parseToIntArray(xml.FixRewards.toString(), ",");
			randomRewards = Utility.parseToIntArray(xml.RandomRewards.toString(), ",");
			
			timeOpen = Utility.parseToIntArray(xml.TimeOpen.toString(), ",");
			timeClose = Utility.parseToIntArray(xml.TimeClose.toString(), ",");
			
			if (ID == GameMode.PVP_1vs1_FREE.ID 
				|| ID == GameMode.PVP_3vs3_FREE.ID
				|| ID == GameMode.PVP_2vs2_MM.ID
				|| ID == GameMode.PVP_3vs3_MM.ID
				|| ID == GameMode.PVP_1vs1_MM.ID
				|| ID == GameMode.PVP_FREE.ID)
			{
				nLevelRequirement = parseInt(xml.LevelRequirement.toString());
			}
			
			switch (ID)
			{
				case GameMode.PVE_GLOBAL_BOSS.ID: 
					parseGlobalBossConfig(xmlData);
					break;
				
				case GameMode.PVE_HEROIC.ID: 
					parsePVEHeroic(xmlData);
					break;
			}
			
			initGroupReward();
			
			var configClass:Class = XMLConfig.getConfigClass(ID);
			if (configClass != null)
			{
				xmlConfig = new configClass();
				xmlConfig.parse(xml);
			}
		}
		
		public function getCoolDownPerPlay():int
		{
			var result:int = -1;
			if (xmlData.TimeCoolDownPerGame.length() > 0)
				result = parseInt(xmlData.TimeCoolDownPerGame.toString());
			
			return result;
		}
		
		public function getCostSkipCoolDown():int
		{
			var result:int = -1;
			if (xmlData.SkipWaitPrice.length() > 0)
				result = parseInt(xmlData.SkipWaitPrice.toString());
			
			return result;
		}
		
		public function getMaxFreeGame():int
		{
			var result:int = -1;
			if (xmlData.MaxFreeGame.length() > 0)
				result = parseInt(xmlData.MaxFreeGame.toString());
			
			return result;
		}
		
		public function getMaxPayGame():int
		{
			var result:int = -1;
			if (xmlData.MaxPayGame.length() > 0)
				result = parseInt(xmlData.MaxPayGame.toString());
			
			return result;
		}
		
		public function getMaxHornorInDay():int
		{
			var result:int = -1;
			if (xmlData.MaxHonorInDay.length() > 0)
				result = parseInt(xmlData.MaxHonorInDay.toString());
			
			return result;
		}
		
		public function getCostPlayGame():int
		{
			var result:int = -1;
			if (xmlData.PayGamePrice.length() > 0)
				result = parseInt(xmlData.PayGamePrice.toString());
			
			return result;
		}
		
		private function initGroupReward():void
		{
			if (xmlData.Groups.length() > 0)
			{
				var listGroupRewards:XML = xmlData.Groups[0] as XML;
				for each (var groupReward:XML in listGroupRewards.Group as XMLList)
				{
					var group:Object = {};
					group.id = parseInt(groupReward.GroupID.toString());
					group.count = parseInt(groupReward.GameCount.toString());
					group.name = groupReward.GroupName.toString();
					group.reward = parseInt(groupReward.Reward.toString());
					this._groupReward.push(group);
				}
			}
		}
		
		public function getGroupReward():Array
		{
			return _groupReward;
		}
		
		private function parseGlobalBossConfig(xml:XML):void
		{
			var date:Date = new Date();
			globalBossConfig = new ModeConfigGlobalBoss();
			globalBossConfig.mode = GameMode.PVE_GLOBAL_BOSS;
			for each (var value:int in timeOpen)
			{
				globalBossConfig.timeOpen.push(new Date(date.getFullYear(), date.getMonth(), date.getDate(), value).getTime() + Game.database.userdata.serverTimeDifference);
			}
			for each (value in timeClose)
			{
				globalBossConfig.timeClose.push(new Date(date.getFullYear(), date.getMonth(), date.getDate(), value).getTime() + Game.database.userdata.serverTimeDifference);
			}
			globalBossConfig.damageRequired = Utility.parseToIntArray(xml.DamageRequirement.toString(), ",");
			globalBossConfig.goldBuff = parseInt(xml.GoldBuff.toString());
			globalBossConfig.goldBuffPercent = parseInt(xml.GoldBuffPercent.toString());
			globalBossConfig.xuBuff = parseInt(xml.XuBuff.toString());
			globalBossConfig.xuBuffPercent = parseInt(xml.XuBuffPercent.toString());
			globalBossConfig.defaultReviveTime = parseInt(xml.TimeRespawn.toString());
			globalBossConfig.xuRevive = Utility.parseToIntArray(xml.XuRespawn.toString(), ",");
			globalBossConfig.xuAutoRevive = parseInt(xml.XuAutoRespawn.toString());
			globalBossConfig.xuAutoPlay = parseInt(xml.XuAutoPlay.toString());
			globalBossConfig.topRewardsXML = xml.TopRewards[0];
			var goldByDmg:int = parseInt(xml.GoldByDamage.toString());
			var dmgByGold:int = parseInt(xml.DamageOfGold.toString());
			if (dmgByGold != 0)
			{
				globalBossConfig.dmgToGoldRatio = (Number)(goldByDmg / dmgByGold);
			}
		}
		
		private function parsePVEHeroic(xmlData:XML):void
		{
			heroicConfig = new Dictionary(false);
			var caves:XMLList = xmlData.Caves.Cave as XMLList;
			var campaignData:CampaignData;
			for each (var xml:XML in caves)
			{
				campaignData = new CampaignData();
				campaignData.campaignID = parseInt(xml.ID.toString());
				campaignData.freeMax = parseInt(xml.MaxFreeGame.toString());
				campaignData.premiumMax = parseInt(xml.MaxPayGame.toString());
				campaignData.playingCost = parseInt(xml.PriceOnePayGame.toString());
				campaignData.name = xml.Name.toString();
				campaignData.posX = parseInt(xml.PosX.toString());
				campaignData.posY = parseInt(xml.PosY.toString());
				var missionsList:XMLList = xml.GroupMissions.MissionIDs as XMLList;
				for each (var missionXML:XML in missionsList)
				{
					campaignData.missionIDs.push(Utility.parseToIntArray(missionXML.toString(), ","));
				}
				campaignData.levelRequired = int.MAX_VALUE;
				for each (var missionIDs:Array in campaignData.missionIDs)
				{
					var difficultyLevelRequired:int = 0;
					for each (var missionID:int in missionIDs)
					{
						var missionData:MissionXML = Game.database.gamedata.getData(DataType.MISSION, missionID) as MissionXML;
						difficultyLevelRequired = Math.max(difficultyLevelRequired, missionData.levelRequired);
					}
					campaignData.levelRequired = Math.min(campaignData.levelRequired, difficultyLevelRequired);
				}
				
				heroicConfig[campaignData.campaignID] = campaignData;
			}
		}
		
		public function checkValidTimeRequire(currentDate:Date):Boolean
		{
			var result:Boolean = false;
			
			for (var i:int = 0; i < timeOpen.length; i++)
			{
				result ||= (currentDate.getHours() < timeClose[i]) && (currentDate.getHours() >= timeOpen[i]);
			}
			return result;
		}
	
	}

}