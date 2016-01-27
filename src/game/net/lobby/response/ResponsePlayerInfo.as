package game.net.lobby.response 
{
	import core.util.ByteArrayEx;
	
	import flash.utils.ByteArray;
	
	import game.net.ResponsePacket;

	/**
	 * ...
	 * @author anhtinh
	 */
	public class ResponsePlayerInfo extends ResponsePacket
	{
		
		public var playerID : int;
		public var playerName : String;
		public var currentExp : int;
		public var expToNextLevel : int;
		public var level : int;
		public var maxLevel : int;
		public var gold : int;
		public var xu : int;
		public var honor : int;
		public var actionPoint : int;
		public var maxActionPoint : int;
		public var fomationHP : int;
		public var maxFomationHP : int;
		
		public var f_damage:Number;	// f : formation
		public var f_typeID:int;
		public var f_level:Number;
		public var f_hp:Number;
		public var f_physicalDamage:Number;
		public var f_physicalArmor:Number;
		public var f_magicalDamage:Number;
		public var f_magicalArmor:Number;
		
		public var numNormalFormationSlot:int;
		public var numLegendFormationSlot:int;	
		public var nAlchemyInDay:int;	
		public var vip:int;
		public var healedAP:int;
		public var luckyGiftXu:int;
		public var luckyGiftTime:int;
		public var soulExchangePoint:int;
		public var consumeXuInMonth:int;
		public var nStatusGiftOnline:int;
		public var nEventCurrentPaymentEventID:int;
		public var nEventCurrentConsumeEventID:int;
		
		public var nFirstCharge:int;
		
		public var nAttendanceTime:int = 0;
		public var nAttendanceChecked:Boolean = true;
        public var nRemainTimeWaitAlchemy:int = 0;
        public var nElapsedTimeWaitAP:int = 0;
        public var nSweepingMissionID:int = 0;
        public var nElapsedSweepingTime:int = 0; // Thoi gian can quet da troi qua
        public var nMaxSweepTimes:int = 0; // Tong so lan can quet ma user da chon
		
		public var nTransportRefresh:int;
		public var nDailyQuestRefresh:int;
		
		public var nKungfuTrainHostRemainTime:int;
		public var nKungfuTrainPartnerRemainTime:int;
		
		public var guildId:int;
		public var guildMemberType:int;

		public var giveAPCount:int = 0;
		public var receiveAPCount:int = 0;
		public var currDigTreasure:int = 0;
		public var enableTreasure:Boolean = false;
		public var enableMysticBox:Boolean = false;
		public var enableDice:Boolean = false;
		public var enableShopDiscount:Boolean = false;
		public var enableVIPPromotion:Boolean = false;

		//public var numAttackResourcePerDay:int = 0;
		public var numOfRespawnBoss:int = 0;
		public var numUseMysticBoxes:Array;
		public var mysticLuckPoint:int = 0;
		public var numBuyUseMysticBox:int = 0;
		
		public var timeRemainAttackResourceInfo: int = 0;

		override public function decode(data:ByteArray):void 
		{
			playerID = data.readInt();
			playerName = ByteArrayEx(data).readString();
			
			currentExp = data.readInt();
			expToNextLevel = data.readInt();	//-1: Da max level roi
			
			level = data.readInt();
			maxLevel = data.readInt();
			gold = data.readInt();
			xu = data.readInt();
			honor = data.readInt();
			actionPoint = data.readInt();
			maxActionPoint = data.readInt();
			fomationHP = data.readInt();
			maxFomationHP = data.readInt();						
			
			f_damage = data.readInt();
			f_typeID = data.readInt();
			f_level = data.readInt();
			f_hp = data.readInt();
			f_physicalDamage = data.readInt();
			f_physicalArmor = data.readInt();
			f_magicalDamage = data.readInt();
			f_magicalArmor = data.readInt();
			
			numNormalFormationSlot = data.readInt();			
			numLegendFormationSlot = data.readInt();
			
			nAlchemyInDay = data.readInt();
			
			vip = data.readInt();
			healedAP = data.readInt();
			luckyGiftXu = data.readInt();
			luckyGiftTime = data.readInt();
			soulExchangePoint = data.readInt();
			consumeXuInMonth = data.readInt();
			nStatusGiftOnline = data.readInt();
			nEventCurrentPaymentEventID = data.readInt();
			nEventCurrentConsumeEventID = data.readInt();
			
			
			// first charge
			nFirstCharge = data.readInt();
				
			if(data.bytesAvailable)
			{	
				nAttendanceTime = data.readInt();
				nAttendanceChecked = Boolean(data.readByte());
			}

            nRemainTimeWaitAlchemy = data.readInt();
            nElapsedTimeWaitAP = data.readInt();
            nSweepingMissionID = data.readInt();
            nElapsedSweepingTime = data.readInt();
            nMaxSweepTimes = data.readInt();
			
			nDailyQuestRefresh = data.readInt();
			nTransportRefresh = data.readInt();
			
			guildId = data.readInt();
			guildMemberType = data.readInt();

			nKungfuTrainHostRemainTime = data.readInt();
			nKungfuTrainPartnerRemainTime = data.readInt();
			
			giveAPCount = data.readInt();
			receiveAPCount = data.readInt();

			currDigTreasure = data.readInt();
			enableTreasure = data.readBoolean();

			numOfRespawnBoss = data.readInt();
			enableMysticBox = data.readBoolean();

			numUseMysticBoxes = [];
			var size:int = data.readInt();
			for (var i:int = 0; i < size; i++)
			{
				numUseMysticBoxes.push(data.readInt());
			}

			mysticLuckPoint = data.readInt();
			numBuyUseMysticBox = data.readInt();
			
			timeRemainAttackResourceInfo = data.readInt();

			enableDice = data.readBoolean();
			enableShopDiscount = data.readBoolean();
			enableVIPPromotion = data.readBoolean();
		}
		
	}

}