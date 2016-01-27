package game.ui.vip_promotion
{

	import components.scroll.VerScroll;

	import core.display.ViewBase;
	import core.event.EventEx;
	import core.util.FontUtil;
	import core.util.Utility;

	import flash.display.MovieClip;

	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.globalization.DateTimeFormatter;
	import flash.text.TextField;

	import game.Game;
	import game.data.vo.discount_shop.DiscountItemVO;
	import game.data.xml.DataType;
	import game.data.xml.VIPDiscountXML;

	import game.enum.Font;
	import game.enum.ItemType;
	import game.net.lobby.response.ResponseDiscountShopItems;
	import game.net.lobby.response.ResponseVIPPromotionPlayerInfo;

	import game.ui.shop_discount.gui.Slot;
	import game.ui.vip_promotion.gui.ListItem;
	import game.utility.TimerEx;

	import game.utility.UtilityUI;

	/**
	 * ...
	 * @author
	 */
	public class VIPPromotionView extends ViewBase
	{
		public static const BUY:String = "VIP_Promotion_BUY_Event";

		public function VIPPromotionView()
		{
			closeBtn = UtilityUI.getComponent(UtilityUI.CLOSE_BTN) as SimpleButton;

			if (closeBtn != null)
			{
				closeBtn.x = 1055;
				closeBtn.y = 76;
				addChild(closeBtn);
				closeBtn.addEventListener(MouseEvent.CLICK, closeHandler);
			}

			FontUtil.setFont(timeTf, Font.ARIAL, true);

			var timeStart:Date = Utility.parseToDate(Game.database.gamedata.getConfigData(272));
			var timeEnd:Date = Utility.parseToDate(Game.database.gamedata.getConfigData(273));
			var formater:DateTimeFormatter = new DateTimeFormatter("en-US");
			formater.setDateTimePattern("HH:mm dd-MM-yyyy");
			timeTf.text = formater.format(timeStart) + " đến " + formater.format(timeEnd);

			vScroller = new VerScroll(masker, content, scrollMov);

		}

		public var timeTf:TextField;

		public var masker:MovieClip;
		public var scrollMov:MovieClip;
		public var content:MovieClip;
		public var vScroller:VerScroll;
		private var closeBtn:SimpleButton;


		private function closeHandler(event:MouseEvent):void
		{
			dispatchEvent(new Event("close", true));
		}

		public function updateInfo(packet:ResponseVIPPromotionPlayerInfo):void
		{
			var vipList:Array = Game.database.gamedata.getAllData(DataType.VIP_DISCOUNT_SHOP);

			reset();

			if(packet.isBuyableList.length == vipList.length)
			{
				for (var i:int = 0; i < vipList.length; i++)
				{
					var xml:VIPDiscountXML = vipList[i] as VIPDiscountXML;
					var item:ListItem = new ListItem();
					item.setData(xml, packet.isBuyableList[i]);
					item.y = i * (ListItem.HEIGHT + ListItem.SPACE);
					content.addChild(item);
				}

				vScroller.updateScroll(content.height + 10);
			}
			else
			{
				Utility.log("updateInfo: VIP Promotion config error");
			}
		}

		private function reset():void
		{
			while(content.numChildren > 0)
			{
				var item:ListItem = content.removeChildAt(0) as ListItem;
				item.reset();
			}
		}
	}
}