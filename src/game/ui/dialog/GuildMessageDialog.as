package game.ui.dialog 
{
	import flash.text.TextField;
	import game.ui.dialog.dialogs.Dialog;

	/**
	 * ...
	 * @author vu anh
	 */
	public class GuildMessageDialog extends Dialog
	{
		public var titleTf:TextField;
		public var messageTf:TextField;
		
		public function GuildMessageDialog() 
		{
			
		}
		
		override public function onShow():void 
		{
			messageTf.text = this.data.message;
		}
		
		override public function onHide():void 
		{ 
		}
		
	}

}