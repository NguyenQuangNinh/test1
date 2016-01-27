package game.ui.tooltip.tooltips 
{
	import core.Manager;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import game.data.vo.reward.RewardInfo;
	import game.data.xml.DataType;
	import game.data.xml.MissionXML;
	import game.Game;
	import game.ui.components.ItemSlot;
	import game.ui.tooltip.TooltipBase;
	import game.utility.GameUtil;
	
	/**
	 * ...
	 * @author MaiPTT
	 */
	public class HeroicRewardTooltip extends TooltipBase 
	{
		public var movBackground	:MovieClip;
		public var movContent		:MovieClip;
		public var txtTitle			:TextField;
		private var itemSlots		:Array;
		
		public function HeroicRewardTooltip() {
			itemSlots = [];
		}
		
		public function setRewards(arr:Array):void {
			for each (var itemSlot:ItemSlot in itemSlots) {
				movContent.removeChild(itemSlot);
				itemSlot.reset();
				Manager.pool.push(itemSlot, ItemSlot);
			}
			
			itemSlots.splice(0);
			
			var missionXML:MissionXML;
			var i:int = 0;
			for each (var missionID:int in arr) {
				missionXML = Game.database.gamedata.getData(DataType.MISSION, missionID) as MissionXML;
				if (missionXML) {
					var rewardInfos:Array = GameUtil.getRewardConfigs(missionXML.fixRewardIDs);
					for (var k:int = 0; k < rewardInfos.length; k++) {
						var rewardSlot:ItemSlot = Manager.pool.pop(ItemSlot) as ItemSlot;
						rewardSlot.x = (k % 5) * 65;
						rewardSlot.y = i * 60;
						rewardSlot.setConfigInfo(RewardInfo(rewardInfos[k]).itemConfig);
						rewardSlot.setQuantity(RewardInfo(rewardInfos[k]).quantity);
						movContent.addChild(rewardSlot);
						itemSlots.push(rewardSlot);
					}
					i++;
				}
			}
			
			movBackground.width = movContent.width + 40;
			movBackground.height = movContent.height + 60;
		}
	}

}