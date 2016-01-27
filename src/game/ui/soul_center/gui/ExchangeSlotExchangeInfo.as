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
	public class ExchangeSlotExchangeInfo extends MovieClip
	{
		public static const CLICK_EXCHANGE_ITEM:String = "click_exchange_item";
		
		public var btnExchange:SimpleButton;
		public var priceTf:TextField;
		
		public function ExchangeSlotExchangeInfo()
		{
			FontUtil.setFont(priceTf, Font.ARIAL, true);
			btnExchange.addEventListener(MouseEvent.CLICK, onBtnExchange);
		}
		
		private function onBtnExchange(e:Event):void
		{
			this.dispatchEvent(new Event(CLICK_EXCHANGE_ITEM, true));
		}
	
	}

}