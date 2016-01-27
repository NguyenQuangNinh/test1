/**
 * Created by NinhNQ on 9/19/2014.
 */
package game.data.model.event
{
	import game.Game;
	import game.data.model.item.ItemFactory;
	import game.data.vo.reward.RewardInfo;
	import game.data.xml.DataType;
	import game.data.xml.RewardXML;
	import game.data.xml.event.MilestoneStatus;

	public class Milestone
	{
		public var index:int;
		public var value:int;
		public var title:String;
		public var status:int = MilestoneStatus.NOT_READY;
		public var rewardInfos:Array;

		public function get enableReward():Boolean {return status == MilestoneStatus.READY;}

		public function set rewards(value:Array):void
		{
			rewardInfos = [];

			for (var i:int = 0; i < value.length; i++)
			{
				var id:int = value[i] as int;
				var xml:RewardXML = Game.database.gamedata.getData(DataType.REWARD, id) as RewardXML;

				if (xml)
				{
					var itemData:RewardInfo = new RewardInfo();
					itemData.itemType = xml.type;
					itemData.itemID = xml.itemID;
					itemData.quantity = xml.quantity;
					itemData.itemConfig = ItemFactory.buildItemConfig(itemData.itemType, itemData.itemID);

					rewardInfos.push(itemData);
				}
			}
		}
	}
}
