package game.data.vo.quest_main 
{
	import game.data.vo.quest_transport.ConditionInfo;
	import game.data.xml.DataType;
	import game.data.xml.QuestMainXML;
	import game.Game;
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class QuestInfo 
	{
		//static info
		public var id:int;
		public var type:int;
		public var xmlData:QuestMainXML;
		
		//dynamic info
		public var index:int;
		public var state:int;
		public var numCompleted:int;
		public var difficulty:int;
		public var isNew:Boolean = false;
		//unit value is second
		public var timeExpire:int;
		public var playerLevelReceivedQuest:int;
		//public var conditions:Array = [];
		
		public function QuestInfo(questID:int) 
		{
			id = questID;
			xmlData = Game.database.gamedata.getData(DataType.QUEST_MAIN, questID) as QuestMainXML;
		}
		
		public function updateCondtionByID(id:int, value:int, timeRemain:int): void {
			if (xmlData) {
				for (var i:int = 0; i < xmlData.conditionsFinish.length; i++) {
					var condition:ConditionInfo = xmlData.conditionsFinish[i] as ConditionInfo;
					if (condition.ID == id) {
						condition.value = value;
						condition.elapseTimeToFinish = timeRemain;						
						break;
					}
				}
			}
		}
		
	}

}