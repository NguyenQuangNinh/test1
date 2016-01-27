package game.ui.arena 
{
	import core.util.FontUtil;
	import core.util.MovieClipUtils;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import game.data.model.item.IItemConfig;
	import game.data.model.item.ItemFactory;
	import game.data.xml.DataType;
	import game.data.xml.item.ItemChestXML;
	import game.data.xml.RewardXML;
	import game.enum.Font;
	import game.enum.ItemType;
	import game.Game;
	import game.utility.GameUtil;
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class RewardModeInfoItem extends MovieClip
	{		
		public var rankTf:TextField;
		public var dailyContainer:MovieClip;
		public var weeklyContainer:MovieClip;
		private var dailyRewards:Array;
		private var weeklyRewards:Array;
		
		private var _data:Object;
		
		private static const MAX_ITEM_PER_LINE:int = 3;
		
		private var DISTANCE_X_PER_REWARD_ITEM:int = 65;
		private var DISTANCE_Y_PER_REWARD_ITEM:int = 30;
		
		public function RewardModeInfoItem() 
		{
			initUI();	
		}
		
		private function initUI():void 
		{
			//set fonst
			FontUtil.setFont(rankTf, Font.ARIAL, true);
			dailyContainer.x -= 5;
			weeklyContainer.x -= 5;
			dailyRewards = [];
			weeklyRewards = [];
		}
		
		public function updateInfo(data:Object):void {
			if (data) {
				_data = data;
				
				var rankFrom:int = data.from;
				var rankTo:int = data.to;
				
				rankTf.text = rankFrom < rankTo ? (rankFrom.toString() + "-" + rankTo.toString())
							: rankFrom == rankTo ? (rankFrom.toString())
							: ("Từ " + rankFrom.toString());
				
				
				//var rewardItems:Array = getItemRewardsByID(data.rewardDaily);
				var rewardItems:Array = GameUtil.getItemRewardsByID(data.rewardDaily);
				var rewardItem:RewardModeInfoElement;
				
				for each (rewardItem in dailyRewards) {
					if (rewardItem.parent) {
						rewardItem.parent.removeChild(rewardItem);
					}
					rewardItem.reset();
					rewardItem = null;
				}
				dailyRewards.splice(0);
				
				for (var i:int = 0; i < rewardItems.length; i++) {
					//var rewardXML:RewardXML = Game.database.gamedata.getData(DataType.REWARD, rewardItems[i] as int) as RewardXML;
					var rewardXML:RewardXML = rewardItems[i] as RewardXML;
					if(rewardXML) {
						rewardItem = new RewardModeInfoElement();
						var itemConfig:IItemConfig = ItemFactory.buildItemConfig(rewardXML.type, rewardXML.itemID) as IItemConfig;
						if(itemConfig) {
							rewardItem.setConfigInfo(itemConfig);
							rewardItem.setQuantity(rewardXML.quantity);
							rewardItem.x = DISTANCE_X_PER_REWARD_ITEM * (i % MAX_ITEM_PER_LINE);
							rewardItem.y = DISTANCE_Y_PER_REWARD_ITEM * (int) (i / MAX_ITEM_PER_LINE);
							dailyRewards.push(rewardItem);
							dailyContainer.addChild(rewardItem);
						}
					}
				}
				
				
				rewardItems = GameUtil.getItemRewardsByID(data.rewardWeekly);
				
				for each (rewardItem in weeklyRewards) {
					if (rewardItem.parent) {
						rewardItem.parent.removeChild(rewardItem);
					}
					rewardItem.reset();
					rewardItem = null;
				}
				weeklyRewards.splice(0);
				
				for (i = 0; i < rewardItems.length; i++) {
					//rewardXML = Game.database.gamedata.getData(DataType.REWARD, rewardItems[i] as int) as RewardXML;
					rewardXML = rewardItems[i] as RewardXML;
					if(rewardXML) {
						rewardItem = new RewardModeInfoElement();
						itemConfig = ItemFactory.buildItemConfig(rewardXML.type, rewardXML.itemID) as IItemConfig;
						if(itemConfig) {
							rewardItem.setConfigInfo(itemConfig);
							rewardItem.setQuantity(rewardXML.quantity);
							rewardItem.x = DISTANCE_X_PER_REWARD_ITEM * (i % MAX_ITEM_PER_LINE);
							rewardItem.y = DISTANCE_Y_PER_REWARD_ITEM * (int) (i / MAX_ITEM_PER_LINE);
							weeklyRewards.push(rewardItem);
							weeklyContainer.addChild(rewardItem);
						}
					}
					
				}
			}
		}
		
		/*private function getItemRewardsByID(id:int):Array {
			var result:Array = [];
			var rewardXML:RewardXML = Game.database.gamedata.getData(DataType.REWARD, id) as RewardXML;
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
		}*/
	}

}