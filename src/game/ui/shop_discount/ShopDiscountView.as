package game.ui.shop_discount
{

	import core.display.ViewBase;
	import core.event.EventEx;
	import core.util.FontUtil;
	import core.util.Utility;

	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.globalization.DateTimeFormatter;
	import flash.text.TextField;

	import game.Game;
	import game.data.vo.discount_shop.DiscountItemVO;

	import game.enum.Font;
	import game.net.lobby.response.ResponseDiscountShopItems;

	import game.ui.shop_discount.gui.Slot;
	import game.utility.TimerEx;

	import game.utility.UtilityUI;

	/**
	 * ...
	 * @author
	 */
	public class ShopDiscountView extends ViewBase
	{
		public static const BUY:String = "SHOP_DISCOUNT_BUY";
		public static const REFRESH_ITEM:String = "SHOP_DISCOUNT_REFRESH_ITEMS";

		public function ShopDiscountView()
		{
			closeBtn = UtilityUI.getComponent(UtilityUI.CLOSE_BTN) as SimpleButton;

			if (closeBtn != null)
			{
				closeBtn.x = 1034;
				closeBtn.y = 78;
				addChild(closeBtn);
				closeBtn.addEventListener(MouseEvent.CLICK, closeHandler);
			}

			FontUtil.setFont(countDownTf, Font.ARIAL, true);
			FontUtil.setFont(timeTf, Font.ARIAL, true);

			var timeStart:Date = Utility.parseToDate(Game.database.gamedata.getConfigData(268));
			var timeEnd:Date = Utility.parseToDate(Game.database.gamedata.getConfigData(269));
			var formater:DateTimeFormatter = new DateTimeFormatter("en-US");
			formater.setDateTimePattern("HH:mm dd-MM-yyyy");
			timeTf.text = formater.format(timeStart) + " đến " + formater.format(timeEnd);


		}

		public var countDownTf:TextField;
		public var timeTf:TextField;
		public var slot1:Slot;
		public var slot2:Slot;
		public var slot3:Slot;
		private var closeBtn:SimpleButton;
		private var timerID:int = -1;
		private var totalTime:int = 0;

		private function closeHandler(event:MouseEvent):void
		{
			dispatchEvent(new Event("close", true));
		}

		public function updateData(packet:ResponseDiscountShopItems):void
		{
			totalTime = packet.countDownTime;

			TimerEx.stopTimer(timerID);
			timerID = TimerEx.startTimer(1000, totalTime, updateCountDown, finishCountDown);

			for (var i:int = 0; i < packet.list.length; i++)
			{
				var data:DiscountItemVO = packet.list[i] as DiscountItemVO;
				var slot:Slot;
				if(this["slot" + (i+1)])
				{
					slot = this["slot" + (i+1)] as Slot;
					slot.setData(data);
				}
			}
		}

		private function finishCountDown():void
		{
			dispatchEvent(new EventEx(ShopDiscountView.REFRESH_ITEM, null, true));
		}

		private function updateCountDown():void
		{
			countDownTf.text = Utility.math.formatTime("H-M-S", --totalTime);
		}
	}
}