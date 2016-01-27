/**
 * Created by NINH on 1/23/2015.
 */
package game.ui.vip_promotion.gui
{

	import core.Manager;

	import flash.display.MovieClip;

	import game.data.model.item.ItemFactory;

	import game.data.vo.item.ItemInfo;
	import game.enum.ItemType;
	import game.ui.components.ItemSlot;
	import game.ui.tooltip.TooltipID;

	public class RewardItem extends MovieClip
	{
		public static const SPACE:int = 2;
		public static const WIDTH:int = 64;

		public var iconMov:MovieClip;

		public function RewardItem()
		{

		}

		public function setData(info:ItemInfo):void
		{
			var itemSlot:ItemSlot = Manager.pool.pop(ItemSlot) as ItemSlot;
			itemSlot.setConfigInfo(ItemFactory.buildItemConfig(info.type, info.id));
			itemSlot.setQuantity(info.quantity);

			iconMov.addChild(itemSlot);
		}

		public function reset():void
		{
			while(iconMov.numChildren > 0)
			{
				var itemSlot:ItemSlot = iconMov.removeChildAt(0) as ItemSlot;
				itemSlot.reset();
				Manager.pool.push(itemSlot, ItemSlot);
			}
		}
	}
}
