package game.ui.challenge_center
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import game.Game;
	import game.data.xml.DataType;
	import game.data.xml.ModeConfigXML;
	import game.data.xml.config.ChallengeCenterConfig;
	import game.data.xml.config.HeroicTowerXML;
	import game.data.xml.config.XMLConfig;

	public class HeroicTowerData extends EventDispatcher
	{
		public static const UPDATE:String = "update";
		
		private var currentFloor:int;
		private var maxFloor:int;
		
		private var xmlData:HeroicTowerXML;
		
		public function getXMLData():HeroicTowerXML { return xmlData; }
		public function setXMLID(ID:int):void
		{
			var modeData:ModeConfigXML = Game.database.gamedata.getData(DataType.MODE_CONFIG, XMLConfig.CHALLENGE_CENTER) as ModeConfigXML;
			if(modeData != null)
			{
				var config:ChallengeCenterConfig = modeData.xmlConfig as ChallengeCenterConfig;
				if(config != null) xmlData = config.towers[ID];
			}
		}
		
		public function getCurrentMissionID():int
		{
			var missionID:int = 0;
			if(xmlData != null) missionID = xmlData.missionIDs[currentFloor - 1];
			return missionID;
		}
		
		public function nextFloor():void
		{
			if(xmlData != null)
			{
				maxFloor = Math.max(++currentFloor, maxFloor);
				dispatchEvent(new Event(UPDATE));
			}
		}
		
		public function topFloor():void
		{
			if(currentFloor < maxFloor)
			{
				currentFloor = maxFloor;
				dispatchEvent(new Event(UPDATE));
			}
		}
		
		public function getCurrentFloor():int { return currentFloor; }
		public function setCurrentFloor(value:int):void
		{
			currentFloor = value;
			dispatchEvent(new Event(UPDATE));
		}
		
		public function getMaxFloor():int { return maxFloor; }
		public function setMaxFloor(value:int):void
		{
			maxFloor = value;
			dispatchEvent(new Event(UPDATE));
		}
	}
}