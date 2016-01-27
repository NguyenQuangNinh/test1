/**
 * Created by NinhNQ on 11/17/2014.
 */
package game.ui.mystic_box.gui
{

	import core.util.FontUtil;

	import flash.display.MovieClip;
	import components.scroll.VerScroll;

	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

	import game.enum.Font;

	/**
	 * ...
	 * @author ninhnq
	 */
	public class RewardLog extends MovieClip
	{
		public var vScroller:VerScroll;
		public var masker:MovieClip;
		public var content:MovieClip;
		public var scrollMov:MovieClip;

		public function RewardLog()
		{
			if (!stage) addEventListener(Event.ADDED_TO_STAGE, onStageInit);
			else onStageInit();
		}

		private function onStageInit(event:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onStageInit);
			vScroller = new VerScroll(masker, content, scrollMov);
			content.mask = masker;
			content.x = masker.x;
			content.y = masker.y;

			FontUtil.setFont(logText, Font.ARIAL, true);
			logText.mouseWheelEnabled = false;
			logText.mouseEnabled = false;
			logText.wordWrap = true;
			logText.autoSize = TextFieldAutoSize.LEFT;
		}

		public function setContent(value:String):void
		{
			logText.text = value;
			vScroller.updateScroll(content.height + 10);

			if(content.height > masker.height)
			{
				var pos:Number = masker.y - (content.height - masker.height);
				vScroller.setContentPos(pos, 0);
			}
			else
			{
				vScroller.setContentPos(masker.y, 0);
			}
		}

		public function appendContent(value:String):void
		{
			logText.appendText(value);
			vScroller.updateScroll(content.height + 10);

			if(content.height > masker.height)
			{
				var pos:Number = masker.y - (content.height - masker.height);
				vScroller.setContentPos(pos, 0);
			}
			else
			{
				vScroller.setContentPos(masker.y, 0);
			}
		}

		private function get logText():TextField
		{
			return content.logTf as TextField;
		}
	}
}
