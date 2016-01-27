package game.enum
{
	import game.data.xml.LevelCommonXML;
	import game.data.xml.LevelQuestDailyXML;
	import game.data.xml.LevelQuestTransportXML;
	import game.data.xml.LevelRewardRequireLevelXML;
	import game.data.xml.XMLData;
	
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class FeatureEnumType
	{
		
		public static const COMMON:int = 1;
		public static const QUEST_TRANSPORT:int = 2;
		public static const QUEST_DAILY:int = 3;
		public static const REWARD_REQUIRE_LEVEL:int = 4;
		
		public static function createXMLByType(featureType:int):XMLData
		{
			var result:XMLData = null;
			switch (featureType)
			{
				case COMMON: 
					result = new LevelCommonXML();
					break;
				case QUEST_DAILY: 
					result = new LevelQuestDailyXML();
					break;
				case QUEST_TRANSPORT: 
					result = new LevelQuestTransportXML();
					break;
				case REWARD_REQUIRE_LEVEL: 
					result = new LevelRewardRequireLevelXML();
					break;
			}
			
			return result;
		}
	}

}