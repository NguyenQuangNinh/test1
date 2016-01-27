/**
 * Created by NinhNQ on 9/23/2014.
 */
package game.ui.events.gui
{
	import core.Manager;
	import core.event.EventEx;
	import core.util.Utility;

	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;

	import game.data.model.event.Milestone;
	import game.data.vo.reward.RewardInfo;
	import game.ui.components.ItemSlot;
	import game.ui.tooltip.TooltipID;

	public class EventReward extends MovieClip
	{
		public function EventReward()
		{
			receiveBtn.addEventListener(MouseEvent.CLICK, receiveBtn_clickHandler);
		}

		public var receiveBtn:SimpleButton;
		public var containerMov:MovieClip;
		private var data:Milestone;

		public function setData(data:Milestone):void
		{
			reset();

			this.data = data;

			for (var i:int = 0; i < data.rewardInfos.length; i++)
			{
				var info:RewardInfo = data.rewardInfos[i] as RewardInfo;

				var rewardSlot:ItemSlot = Manager.pool.pop(ItemSlot) as ItemSlot;
				rewardSlot.x = i * 65;
				rewardSlot.setConfigInfo(info.itemConfig, TooltipID.ITEM_COMMON);
				rewardSlot.setQuantity(info.quantity);
				containerMov.addChild(rewardSlot);
			}

			enableReward(data.enableReward);

		}

		private function enableReward(value:Boolean =true):void
		{
			Utility.setGrayscale(receiveBtn, !value);
			receiveBtn.mouseEnabled = value;
		}

		private function reset():void
		{
			while (containerMov.numChildren > 0)
			{
				var rewardSlot:ItemSlot = containerMov.removeChildAt(0) as ItemSlot;
				rewardSlot.reset();

				Manager.pool.push(rewardSlot, ItemSlot);
			}

			enableReward(false);

			this.data = null;
		}

		private function receiveBtn_clickHandler(event:MouseEvent):void
		{
			dispatchEvent(new EventEx(EventPanel.RECEIVE_REWARD, data, true));
		}
	}
}
