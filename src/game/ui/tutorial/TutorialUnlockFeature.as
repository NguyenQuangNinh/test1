package game.ui.tutorial 
{
	import core.util.FontUtil;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import game.enum.Font;
	
	/**
	 * ...
	 * @author MaiPTT
	 */
	public class TutorialUnlockFeature extends MovieClip 
	{
		public var txtContent		:TextField;
		public var closeBtn			:SimpleButton;
		
		public function TutorialUnlockFeature() {
			FontUtil.setFont(txtContent, Font.ARIAL);
			closeBtn.addEventListener(MouseEvent.CLICK, onBtnClickHdl);
		}
		
		private function onBtnClickHdl(e:MouseEvent):void {
			if (parent) {
				parent.removeChild(this);
			}
		}
		
		public function setContent(value:String):void {
			txtContent.text = value;
		}
	}

}