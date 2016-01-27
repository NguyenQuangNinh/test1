package game.data.xml.item 
{
	import core.util.Utility;
	import game.data.vo.item.ItemChestInfo;
	import game.data.xml.DataType;
	import game.data.xml.RewardXML;
	import game.Game;
	/**
	 * ...
	 * @author anhtinh
	 */
	public class ItemChestXML extends ItemXML
	{
		public var rewardIDs:Array = [];
		
		override public function parseXML(xml : XML) : void {
			
			super.parseXML(xml);
			
			rewardIDs =  Utility.parseToIntArray(xml.Rewards.toString(), ",");
			
		}
		
		public function get items() : Array {
			var rs : Array = [];
			for each (var rewardID: int in rewardIDs) 
			{
				var rewardXml : RewardXML = Game.database.gamedata.getData(DataType.REWARD, rewardID) as RewardXML;
				
				var itemChestInfo : ItemChestInfo = new ItemChestInfo();
				itemChestInfo.id = rewardXml.itemID;
				itemChestInfo.type = rewardXml.type;
				itemChestInfo.quantity = rewardXml.quantity;
				itemChestInfo.rate = rewardXml.rate;
				
				rs.push(itemChestInfo);
			}
			return rs;
		}
	}

}