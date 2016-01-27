package game.ui.dialog
{
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	
	import game.ui.dialog.dialogs.Dialog;
	
	public class DialogHelp extends Dialog
	{
		public var btnClose:SimpleButton;
		
		public function DialogHelp()
		{
			btnClose.addEventListener(MouseEvent.CLICK, btnClose_onClicked);
		}
		
		protected function btnClose_onClicked(event:MouseEvent):void
		{
			close();
		}
	}
}