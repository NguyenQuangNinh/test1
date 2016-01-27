/**
 * Created by NinhNQ on 9/23/2014.
 */
package game.ui.events.gui
{
	import core.util.TextFieldUtil;
	import core.util.Utility;

	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormatAlign;

	import game.data.model.event.Milestone;
	import game.data.xml.event.MilestoneStatus;
	import game.enum.Font;

	public class EventMilestone extends MovieClip
	{
		public static const WIDTH:int = 159;
		public static const HEIGHT:int = 71;

		public function EventMilestone()
		{
			titleTf = TextFieldUtil.createTextfield(Font.ARIAL, 13, 122, 20, 0xFFE996, true, TextFormatAlign.CENTER, [new GlowFilter(0x3C2A13, 1, 2, 2, 9, 3)]);

			titleTf.autoSize = TextFieldAutoSize.CENTER;
			titleTf.wordWrap = true;
			titleTf.mouseEnabled = false;
			titleTf.x = 18;

			addChildAt(titleTf, 1);

			mouseEnabled = true;
			buttonMode = true;

			select(false);
		}

		public var titleTf:TextField;
		public var background:SimpleButton;
		public var data:Milestone;

		public function select(value:Boolean):void
		{
			var label:String = (value) ? "select" : "unselect";
			gotoAndStop(label);
		}

		public function setData(data:Milestone):void
		{
			this.data = data;

			titleTf.htmlText = data.title;
			titleTf.y = (background.height - titleTf.textHeight) / 2;

			if (data.status == MilestoneStatus.RECEIVED)
			{
				Utility.setGrayscale(background, true);
			}
		}

	}
}
