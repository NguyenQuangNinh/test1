package game.ui.dialog
{

	import core.event.EventEx;

	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import core.util.FontUtil;

	import game.Game;
	import game.enum.Direction;

	import game.enum.Font;
	import game.ui.dialog.dialogs.Dialog;
	import game.ui.tutorial.TutorialEvent;

	public class HeroicTowerItemDialog extends Dialog
	{
		public var btnCancel:SimpleButton;
		public var btnOK:SimpleButton;
		public var txtQuantity:TextField;
		
		public function HeroicTowerItemDialog()
		{
			FontUtil.setFont(txtQuantity, Font.ARIAL, true);
			
			btnCancel.addEventListener(MouseEvent.CLICK, btnCancel_onClicked);
			btnOK.addEventListener(MouseEvent.CLICK, btnOK_onClicked);
		}
		
		protected function btnCancel_onClicked(event:MouseEvent):void
		{
			onCancel();
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

			Game.stage.dispatchEvent(new EventEx(TutorialEvent.EVENT, {type: TutorialEvent.OPEN_HEROIC_TOWER_ITEM_DLG}, true));
		}

		//TUTORIAL
		override public function showHint():void
		{
			super.showHint();
			Game.hint.showHint(btnCancel, Direction.UP, btnCancel.x + btnCancel.width/2, btnCancel.y + btnCancel.height, "Click Chuột");
		}
	}
}