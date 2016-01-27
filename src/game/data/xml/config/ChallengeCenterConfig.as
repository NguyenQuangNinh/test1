package game.data.xml.config
{
	import core.util.Utility;

	public class ChallengeCenterConfig extends XMLConfig
	{
		public var towers:Array = [];
		public var autoTime:int;
		public var instantFinishCost:int;
		public var itemID:int;
		public var itemPrice:int;
		public var extraTurnPrice:int;
		
		override public function parse(xml:XML):void
		{
			var xmlList:XMLList = xml.Towers.Tower;
			var towerConfig:HeroicTowerXML;
			for each(var towerXML:XML in xmlList)
			{
				towerConfig = new HeroicTowerXML();
				towerConfig.ID = towerXML.ID;
				towerConfig.name = towerXML.Name.toString();
				towerConfig.missionIDs = Utility.toIntArray(towerXML.Floors.toString());
				towers[towerConfig.ID] = towerConfig;
			}
			autoTime = xml.TimeWaitPerFloor.toString();
			instantFinishCost = xml.PriceFinishAutoPlayPerFloor.toString();
			itemID = xml.BonusItemID.toString();
			itemPrice = xml.PriceUseBonusItem.toString();
			extraTurnPrice = xml.PriceRevive.toString();
		}
	}
}