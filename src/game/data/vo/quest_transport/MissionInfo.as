package game.data.vo.quest_transport 
{
	import game.data.model.Character;
	import game.data.model.item.IItemConfig;
	import game.data.model.item.ItemFactory;
	import game.data.xml.DataType;
	import game.data.xml.item.ItemChestXML;
	import game.data.xml.QuestTransportXML;
	import game.data.xml.RewardXML;
	import game.enum.ItemType;
	import game.Game;
	import game.utility.GameUtil;
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class MissionInfo 
	{
		//static info
		public var ID:int;
		public var type:int;
		public var xmlData:QuestTransportXML;
		
		//dynamic info:
		public var numCompleted:int;
		public var timeExpire:int;
		
		public var index:int;
		public var state:int;
		
		public var levelReceived:int;
		public var difficulty:int;
		
		public var timeCurrent:int;
		public var timeTotal:int;
		
		public var unitAttend:Array = [];
		
		public var rewardID:int = -1;
		
		public function MissionInfo(missionID:int) 
		{
			ID = missionID;
			xmlData = Game.database.gamedata.getData(DataType.QUEST_TRANSPORT, missionID) as QuestTransportXML;
		}		
		
		public function getUnitInfoByIndex(index:int) : Character {
			var result:Character = null;
			if (index >= 0 && index < unitAttend.length) {
				var unitID:int = unitAttend[index];
				//result = Game.database.userdata.getCharacterInfoByID(unitID);
				result = Game.database.userdata.getCharacter(unitID);
			}
			
			return result;
		}
		
		public function updateUnitIDAtIndex(index:int, id:int): void {
			//if (index >= 0 && index < unitAttend.length) {
				unitAttend[index] = id;
			//}
		}
		
		public function getItemRewards():Array {
			var result:Array = [];
			var rewardXML:RewardXML = Game.database.gamedata.getData(DataType.REWARD, rewardID) as RewardXML;
			if (rewardXML) {
				switch(rewardXML.type) {
					case ItemType.ITEM_SET:
						var chestXML:ItemChestXML = Game.database.gamedata.getData(DataType.ITEMCHEST, rewardXML.itemID) as ItemChestXML;
						if (chestXML) {
							var arrRewardXML:Array = GameUtil.getRewardXMLs(chestXML.rewardIDs);
							result = result.concat(arrRewardXML);
						}
						break;
					default:
						result.push(rewardXML);
						break;
				}
			}
			return result;
		}

		public function hasUnit():Boolean
		{
			for (var i:int = 0; i < unitAttend.length; i++)
			{
				var id:int = unitAttend[i];
				if(id != -1) return true;
			}
			return false;
		}
	}

}