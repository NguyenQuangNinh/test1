package game.ui.dialog
{
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import core.util.FontUtil;
	
	import game.enum.Font;
	import game.ui.dialog.dialogs.Dialog;
	
	public class HeroicTowerDialog extends Dialog
	{
		public var btnClose:SimpleButton;
		public var btnOK:SimpleButton;
		public var txtQuantity:TextField;
		
		public function HeroicTowerDialog()
		{
			FontUtil.setFont(txtQuantity, Font.ARIAL, true);
			
			btnClose.addEventListener(MouseEvent.CLICK, btnClose_onClicked);
			btnOK.addEventListener(MouseEvent.CLICK, btnOK_onClicked);
		}
		
		protected function btnClose_onClicked(event:MouseEvent):void
		{
			close();
		}
		
		protected function btnOK_onClicked(event:MouseEvent):void
		{
			onOK();
		}		
		
		override public function onShow():void
		{
			if(data != null && data.quantity != undefined)
			{
				txtQuantity.text = data.quantity.toString();
			}
			else
			{
				txtQuantity.text = "0";
			}
		}
	}
}