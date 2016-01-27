package components.popups 
{
	import components.enum.PopupAction;
	import components.HoverButton;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	/**
	 * ...
	 * @author 
	 */
	public class MessageOkPopup extends MessagePopup
	{
		public var okBtn:MovieClip;
		
		public function MessageOkPopup() 
		{
			HoverButton.initHover(okBtn);
			okBtn.addEventListener(MouseEvent.CLICK, okBtnClickHdl);
		}
		
		private function okBtnClickHdl(e:Event):void 
		{
			hide(PopupAction.OK);
		}
		
	}

}