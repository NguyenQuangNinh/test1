package game.data.xml 
{
	import core.util.Utility;
	import game.data.model.item.Item;
	import game.data.model.item.ItemFactory;
	import game.data.vo.quest_transport.ConditionInfo;
	import game.data.xml.item.ItemXML;
	import game.Game;
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class QuestMainXML extends XMLData	
	{
		public var type:int;
		public var name:String;
		public var desc:String;
		
		public var conditionsFinish:Array = [];
		public var fixRewardIDs:Array = [];
		public var optionalRewardIDs:Array = [];
		
		public function QuestMainXML() 
		{
			
		}
		
		override public function parseXML(xml:XML):void 
		{
			super.parseXML(xml);
			
			type = parseInt(xml.Type.toString());	
			name = xml.Name.toString();
			desc = xml.Desc.toString();
			
			//var conditionsFinishID:Array = xml.ArrConditionsFinish.toString().split(",");
			//Utility.convertToIntArray(conditionsFinishID);
			var conditionsFinishID:Array = Utility.parseToIntArray(xml.ArrConditionsFinish.toString());
			for (var i:int = 0; i < conditionsFinishID.length; i++) {
				var condition:ConditionInfo = new ConditionInfo(conditionsFinishID[i]);
				conditionsFinish.push(condition);
			}
			
			//fixRewardIDs = xml.FixRewards.toString().split(",");
			//Utility.convertToIntArray(fixRewardIDs);
			fixRewardIDs = Utility.parseToIntArray(xml.FixRewards.toString());
			
			//optionalRewardIDs = xml.OptionalReward.toString().split(",");
			//Utility.convertToIntArray(optionalRewardIDs);
			optionalRewardIDs = Utility.parseToIntArray(xml.OptionalReward.toString());
		}
		
		public function getFixRewardXMLs():Array {
			var result:Array = [];
			for (var i:int = 0; i < fixRewardIDs.length; i++) {
				var rewardXML:RewardXML = Game.database.gamedata.getData(DataType.REWARD, fixRewardIDs[i]) as RewardXML;
				result.push(rewardXML);
			}
			return result;
		}
		
		public function getOptionalRewardXMLs():Array {
			var result:Array = [];
			for (var i:int = 0; i < optionalRewardIDs.length; i++) {
				var rewardXML:RewardXML = Game.database.gamedata.getData(DataType.REWARD, optionalRewardIDs[i]) as RewardXML;
				result.push(rewardXML);
			}
			return result;
		}
	}

}