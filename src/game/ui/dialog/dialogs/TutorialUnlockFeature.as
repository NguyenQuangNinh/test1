package game.ui.dialog.dialogs 
{
	import core.util.FontUtil;
	import flash.text.TextField;
	import game.enum.Font;
	
	/**
	 * ...
	 * @author MaiPTT
	 */
	public class TutorialUnlockFeature extends Dialog 
	{
		public var txtContent		:TextField;
		
		public function TutorialUnlockFeature() {
			FontUtil.setFont(txtContent, Font.ARIAL);
		}
		
		override public function onShow():void {
			super.onShow();
			if (data) {
				txtContent.text = data.content;
			}
		}
	}

}