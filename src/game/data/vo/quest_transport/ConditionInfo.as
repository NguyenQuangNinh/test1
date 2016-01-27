package game.data.vo.quest_transport 
{
	import game.data.xml.DataType;
	import game.data.xml.GameConditionXML;
	import game.Game;
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class ConditionInfo 
	{
		//dynamic info
		public var value:int;
		public var elapseTimeToFinish:int;
		
		//static info
		public var ID:int;
		public var xmlData:GameConditionXML;
			
		public function ConditionInfo(conditionID:int) 
		{
			ID = conditionID;			
			xmlData = Game.database.gamedata.getData(DataType.GAME_CONDITION, conditionID) as GameConditionXML;			
		}
		
	}

}