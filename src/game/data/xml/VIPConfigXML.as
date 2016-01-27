package game.data.xml
{
	import core.util.Utility;
	import game.enum.GameConfigType;
	import game.Game;
	
	/**
	 * ...
	 * @author MaiPTT
	 */
	public class VIPConfigXML extends XMLData
	{
		public var xuRequirement:int = -1;
		public var dailyQuestAddCount:int = -1;
		public var dailyQuestCloseFree:int = -1;
		public var dailyQuestGotoPlay:Boolean = false;
		public var transporterQuestAddCount:int = -1;
		public var transporterQuestGotoPlay:Boolean = false;
		public var towerModeAutoPlay:Boolean = false;
		public var soulCraftAddCount:int = -1;
		public var soulCraftAuto:Boolean = false;
		public var arrRewardSetGiftOnline:Array = [];
		public var additionAPFillingInDay:int = 0;
		public var additionAlchemyInDay:int = 0;
		public var arrItemShopVip:Array = [];
		
		override public function parseXML(xml:XML):void
		{
			super.parseXML(xml);
			Game.database.gamedata.maxVIP = Math.max(Game.database.gamedata.maxVIP, ID);
			xuRequirement = parseInt(xml.XuRequirement.toString());
			dailyQuestAddCount = parseInt(xml.DailyQuestAddCount.toString());
			dailyQuestCloseFree = parseInt(xml.DailyQuestCloseFree.toString());
			dailyQuestGotoPlay = parseInt(xml.DailyQuestGotoPlay.toString()) == 1;
			transporterQuestAddCount = parseInt(xml.TransporterQuestAddCount.toString());
			transporterQuestGotoPlay = parseInt(xml.TransporterQuestGotoPlay.toString()) == 1;
			towerModeAutoPlay = parseInt(xml.TowerModeAutoPlay.toString()) == 1;
			soulCraftAddCount = parseInt(xml.SoulCraftAddCount.toString());
			soulCraftAuto = parseInt(xml.SoulCraftAuto.toString()) == 1;		
			arrRewardSetGiftOnline = Utility.parseToIntArray(xml.GiftOnline.toString(), ",");
			additionAPFillingInDay = parseInt(xml.AdditionAPFillingInDay.toString());
			additionAlchemyInDay = parseInt(xml.AdditionAlchemyInDay.toString());
			arrItemShopVip = Utility.parseToIntArray(xml.ItemShopVip.toString(), ",");
		}
	}

}