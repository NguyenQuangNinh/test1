package game.ui.attendance
{
	import core.Manager;
	import core.util.MovieClipUtils;

	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.geom.Point;

	import game.data.model.item.IItemConfig;
	import game.data.model.item.ItemFactory;
	import game.data.xml.RewardXML;
	import game.ui.components.HorScroll;
	import game.ui.components.ItemSlot;
	import game.ui.tooltip.TooltipID;
	import game.utility.UtilityEffect;

	/**
	 * ...
	 * @author anhpnh2
	 */
	public class AttendanceTable extends MovieClip
	{
		public function AttendanceTable()
		{
			_hScroll = new HorScroll(maskMovie, contentMovie, scrollbar);
			_hScroll.x = scrollbar.x;
			_hScroll.y = scrollbar.y;
			this.addChild(_hScroll);

			contentMovie.x = maskMovie.x;
			contentMovie.y = maskMovie.y;
			this.addChild(contentMovie);

			arrReward = [];
		}

		public var maskMovie:MovieClip;
		public var scrollbar:MovieClip;
		public var checkInBtn:SimpleButton;
		private var contentMovie:MovieClip = new MovieClip();
		private var _hScroll:HorScroll;
		private var arrReward:Array;
		private var arrRewardEffect:Array;

		public function update(tab:AttendanceTap, state:int):void
		{
			for each(var obj:AttendanceSlot in arrReward)
				obj.destroy();
			MovieClipUtils.removeAllChildren(contentMovie);

			arrReward = [];
//			changeState(state);
			var i:int = 0;
			var slot:AttendanceSlot;
			for each(var reward:RewardXML in tab.arrReward)
			{
				var itemConfig:IItemConfig = ItemFactory.buildItemConfig(reward.type, reward.itemID) as IItemConfig;
				if (itemConfig)
				{
					slot = new AttendanceSlot();
					slot.x = 8 + i * 80;
					slot.y = 12;
					slot.itemSlot.setConfigInfo(itemConfig, TooltipID.ITEM_COMMON);
					slot.itemSlot.setQuantity(reward.quantity);
					slot.changeState(state);

					contentMovie.addChild(slot);
					arrReward.push(slot);
					i++;
				}
			}
			_hScroll.updateScroll(contentMovie.width);
		}

		public function showEffectGetReward():void
		{
			arrRewardEffect = [];
			var point:Point;
			for each(var slot:AttendanceSlot in arrReward)
			{
				point = slot.getGlobalPos();
				var itemSlot:ItemSlot = Manager.pool.pop(ItemSlot) as ItemSlot;
				if (itemSlot)
				{
					itemSlot.x = point.x;
					itemSlot.y = point.y;
					itemSlot.setConfigInfo(slot.itemSlot.getItemConfig(), TooltipID.ITEM_COMMON);
					itemSlot.setQuantity(slot.itemSlot.quantity);
					arrRewardEffect.push(itemSlot);
				}
			}
			UtilityEffect.tweenItemEffects(arrRewardEffect, onshowEffectGetRewardCompleted, true);
		}

		private function onshowEffectGetRewardCompleted():void
		{
			for each(var slot:ItemSlot in arrRewardEffect)
			{
				slot.reset();
				Manager.pool.push(slot, ItemSlot);
			}

			arrRewardEffect = [];
		}

		private function changeState(state:int):void
		{
			switch (state)
			{
				case 2:
					gotoAndStop("DEACTIVE");
					break;
				case 1:
					gotoAndStop("NORMAL");
					break;
			}
		}
	}

}