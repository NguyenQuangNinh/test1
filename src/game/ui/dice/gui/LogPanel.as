/**
 * Created by NINH on 1/16/2015.
 */
package game.ui.dice.gui
{

	import core.util.FontUtil;

	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

	import game.enum.Font;

	import game.utility.UtilityUI;

	public class LogPanel extends MovieClip
	{
		public var logTf:TextField
		private var closeBtn:SimpleButton;

		public function LogPanel()
		{
			FontUtil.setFont(logTf, Font.ARIAL, true);
			logTf.mouseWheelEnabled = false;
			logTf.mouseEnabled = false;
			logTf.wordWrap = true;
			logTf.autoSize = TextFieldAutoSize.LEFT;

			closeBtn = UtilityUI.getComponent(UtilityUI.CLOSE_BTN) as SimpleButton;

			if (closeBtn != null)
			{
				closeBtn.x = 616;
				closeBtn.y = 7;
				addChild(closeBtn);
				closeBtn.addEventListener(MouseEvent.CLICK, close);
			}
		}

		public function close(event:MouseEvent = null):void
		{
			this.visible = false;
		}

		public function show(data:String):void
		{
			this.visible = true;
			logTf.text = data;
		}
	}
}
