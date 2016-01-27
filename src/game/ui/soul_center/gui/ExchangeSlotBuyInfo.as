package game.ui.soul_center.gui 
{
	import core.util.FontUtil;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import game.enum.Font;
	/**
	 * ...
	 * @author chuongth2
	 */
	public class ExchangeSlotBuyInfo extends MovieClip
	{
		public static const CLICK_BUY_ITEM:String = "click_buy_item";
		
		public var btnBuy:SimpleButton;
		public var priceTf:TextField;
		
		public function ExchangeSlotBuyInfo() 
		{
			FontUtil.setFont(priceTf, Font.ARIAL, true);
			btnBuy.addEventListener(MouseEvent.CLICK, onBtnBuy);
		}
		
		private function onBtnBuy(e:Event):void 
		{
			this.dispatchEvent(new Event(CLICK_BUY_ITEM, true));
		}
		
	}

}