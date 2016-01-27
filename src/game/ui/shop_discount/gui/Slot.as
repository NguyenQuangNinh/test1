/**
 * Created by NINH on 1/20/2015.
 */
package game.ui.shop_discount.gui
{

	import core.Manager;
	import core.event.EventEx;
	import core.util.FontUtil;

	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	import game.data.model.item.IItemConfig;

	import game.data.model.item.ItemFactory;

	import game.data.vo.discount_shop.DiscountItemVO;

	import game.enum.Font;
	import game.ui.components.ItemSlot;
	import game.ui.shop_discount.ShopDiscountView;
	import game.ui.tooltip.TooltipID;

	public class Slot extends MovieClip
	{
		public function Slot()
		{
			FontUtil.setFont(buyTimesTf, Font.ARIAL, true);
			FontUtil.setFont(curPriceTf, Font.ARIAL, true);
			FontUtil.setFont(itemLeftTf, Font.ARIAL, true);
			FontUtil.setFont(nameTf, Font.ARIAL, true);
			FontUtil.setFont(orgPriceTf, Font.ARIAL, true);
			FontUtil.setFont(percentTf, Font.ARIAL, true);

			buyBtn.addEventListener(MouseEvent.CLICK, buyClickHdl);
		}

		private function buyClickHdl(event:MouseEvent):void
		{
			dispatchEvent(new EventEx(ShopDiscountView.BUY, data.ID, true));
		}

		public var nameTf:TextField;
		public var percentTf:TextField;
		public var itemLeftTf:TextField;
		public var buyTimesTf:TextField;
		public var orgPriceTf:TextField;
		public var curPriceTf:TextField;
		public var buyBtn:SimpleButton;
		public var iconMov:MovieClip;

		private var data:DiscountItemVO;

		public function setData(data:DiscountItemVO):void
		{
			reset();

			this.data = data;

			var percent:Number = Math.round((data.discountedPrice / data.orgPrice - 1)*100);

			var itemCfg:IItemConfig = ItemFactory.buildItemConfig(data.itemType, data.itemID);
			nameTf.text = itemCfg.getName();
			percentTf.text = percent.toString() + "%";
			itemLeftTf.text = data.numItemLeft.toString();
			buyTimesTf.text = (data.maxBuyTimes - data.numBuyLeft) + "/" + data.maxBuyTimes;
			orgPriceTf.text = data.orgPrice.toString();
			curPriceTf.text = data.discountedPrice.toString();

			var _itemSlot:ItemSlot;
			_itemSlot = Manager.pool.pop(ItemSlot) as ItemSlot;
			_itemSlot.x = 5;
			_itemSlot.y = 5;
			_itemSlot.setConfigInfo(itemCfg, TooltipID.ITEM_COMMON, true);
			_itemSlot.setQuantity(data.quantity);
			iconMov.addChild(_itemSlot);
		}

		public function reset():void
		{
			var _itemSlot:ItemSlot;
			while(iconMov.numChildren > 0)
			{
				_itemSlot = iconMov.removeChildAt(0) as ItemSlot;
				_itemSlot.reset();
			}
		}
	}
}
