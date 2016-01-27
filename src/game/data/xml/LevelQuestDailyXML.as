package game.data.xml 
{
	import core.util.Utility;
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class LevelQuestDailyXML extends XMLData
	{
		/*<ID><![CDATA[1]]></ID>
		<LevelFrom><![CDATA[1]]></LevelFrom>
		<LevelTo><![CDATA[24]]></LevelTo>
		<ArrRewardDailyQuest><![CDATA[0,86,87,88,89]]></ArrRewardDailyQuest>
		<ArrDailyQuestScore><![CDATA[10,15,20,25,30]]></ArrDailyQuestScore>
		<ArrDailyQuestRewardByScore><![CDATA[100,101,102,103,104]]></ArrDailyQuestRewardByScore>*/
		public var levelFrom:int;
		public var levelTo:int;
		public var arrReward:Array = [];
		public var arrScore:Array = [];
		public var arrRewardByScore:Array = [];
		
		public function LevelQuestDailyXML() 
		{
			
		}
		
		override public function parseXML(xml:XML):void 
		{
			super.parseXML(xml);
			
			levelFrom = parseInt(xml.LevelFrom.toString());
			levelTo = parseInt(xml.LevelTo.toString());
			arrReward = Utility.parseToIntArray(xml.ArrRewardDailyQuest.toString());
			arrScore = Utility.parseToIntArray(xml.ArrDailyQuestScore.toString());
			arrRewardByScore = Utility.parseToIntArray(xml.ArrDailyQuestRewardByScore.toString());
		}
	}

}