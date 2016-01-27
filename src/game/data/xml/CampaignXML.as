package game.data.xml
{
	import com.adobe.utils.DictionaryUtil;
	import core.util.Utility;
	import flash.utils.Dictionary;
	import game.data.model.CampaignRewardData;
	import game.Game;

	public class CampaignXML extends XMLData
	{
		public var name:String;
		public var posX : Number;
		public var posY : Number;
		public var levelRequirement: int;
		public var maxLevelRequirement: int;
		public var uiBtn: String;
		private var rewardIDs:Array = [];		
		
		override public function parseXML(xml:XML):void
		{
			super.parseXML(xml);
			name = xml.Name.toString();
			posX = Number(xml.PosX.toString());
			posY = Number(xml.PosY.toString());
			uiBtn = xml.UIButton.toString();			
			levelRequirement = int(xml.LevelRequirement.toString());		
			maxLevelRequirement = int(xml.MaxLevelRequirement.toString());
			
			rewardIDs = Utility.parseToIntArray(xml.Rewards.toString(), ",");					
		}
		
		public function get rewards() : Array {
			var rs : Array = [];
			for each (var rewardID: int in rewardIDs) 
			{
				var rewardXml : RewardXML = Game.database.gamedata.getData(DataType.REWARD, rewardID) as RewardXML;
				rs.push(rewardXml);
			}
			return rs;
		}
		
		public function get missionIDs() : Array {
			
			var rs : Array = [];
			var missionTable : Dictionary = Game.database.gamedata.getTable(DataType.MISSION);
			
			for each (var missionXML: MissionXML in missionTable) 
			{
				if (missionXML.campaignID == this.ID) rs.push(missionXML.ID);
			}
			
			return rs;
		}
	}
	
	
}