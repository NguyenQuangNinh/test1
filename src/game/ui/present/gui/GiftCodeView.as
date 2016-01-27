package game.ui.present.gui
{
	import core.event.EventEx;
	import core.util.FontUtil;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import game.enum.Font;
	import game.ui.present.PresentModule;
	
	/**
	 * ...
	 * @author chuongth2
	 */
	public class GiftCodeView extends MovieClip
	{
		public var btnGiftCode:SimpleButton;
		public var giftcodeTf:TextField;
		
		public function GiftCodeView()
		{
			FontUtil.setFont(giftcodeTf, Font.ARIAL, true);
			giftcodeTf.addEventListener(Event.CHANGE, toUpperCase);
			btnGiftCode.addEventListener(MouseEvent.CLICK, btnRequestGiftCodeHandler);
		}
		
		private function toUpperCase(evt:Event):void
		{
			evt.target.text = evt.target.text.toUpperCase();
		}
		
		private function btnRequestGiftCodeHandler(e:MouseEvent):void
		{
			//kiem tra dieu kien
			giftcodeTf.text = giftcodeTf.text.toUpperCase();
			btnGiftCode.mouseEnabled = false;
			this.dispatchEvent(new EventEx(PresentModule.REQUEST_REWARD_GIFT_CODE, giftcodeTf.text, true));
		}
	}

}