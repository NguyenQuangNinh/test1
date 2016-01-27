package game.data.xml
{
	import core.util.Utility;
	public class MissionXML extends XMLData
	{
		public var name			:String	= "";
		public var campaignID	:int	= -1;
		public var image		:String	= "";
		public var aPRequirement:int	= -1;
		public var waves		:Array 	= [];
		public var waveMobLevels:Array 	= [];
		public var fixRewardIDs	:Array 	= [];
		public var randomRewardIDs:Array;
		public var backgroundID	:int	= -1;
		public var prevMissionID:int	= -1;
		public var nextMissionID:int 	= -1;
		public var levelRequired:int 	= -1;
		public var quality: int			= 1;
		public var maxLevelRequirement: int = -1;
		
		override public function parseXML(xml:XML):void
		{
			super.parseXML(xml);
			name = xml.Name.toString();
			campaignID = xml.CampaignID.toString();
			image = xml.Image.toString();
			aPRequirement = xml.APRequirement.toString();
			prevMissionID = xml.PrevMission.toString();
			nextMissionID = xml.NextMission.toString();
			fixRewardIDs = Utility.parseToIntArray(xml.FixRewards.toString(), ",");
			randomRewardIDs = Utility.toIntArray(xml.Rewards.toString());
			
			var xmlList:XMLList = xml.Formations.Formation;
			var xmlList2:XMLList = xml.FormationsLevel.FormationLevel;
			for (var i:int = 0; i < xmlList.length(); ++i)
			{
				waves[i] = xmlList[i].toString().split(",");
				waveMobLevels[i] = xmlList2[i].toString().split(",");
			}
			
			backgroundID = xml.BackgroundID.toString();
			levelRequired = parseInt(xml.LevelRequirement.toString());
			maxLevelRequirement = int(xml.MaxLevelRequirement.toString());			
			quality = int(xml.Quality.toString());
		}
		
		public function getLastModID() : int {
			
			if (waves.length == 0) return 0;
			
			var childWaves : Array = waves[waves.length - 1];
			
			if (!childWaves || childWaves.length == 0) return 0;
			
			return childWaves[childWaves.length - 1];
			
		}
	}
}