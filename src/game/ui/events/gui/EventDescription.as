/**
 * Created by NinhNQ on 9/23/2014.
 */
package game.ui.events.gui
{
	import core.util.TextFieldUtil;

	import flash.display.MovieClip;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormatAlign;

	import game.enum.Font;

	public class EventDescription extends MovieClip
	{
		private const PADDING_TOP:int = 5;
		private const PADDING_BOTTOM:int = 5;

		public function EventDescription()
		{
			descTf = TextFieldUtil.createTextfield(Font.ARIAL, 13, 692, 37, 0xFFFFFF, true, TextFormatAlign.CENTER, [new GlowFilter(0, 1, 1.5, 1.5, 10, 3)], 2);

			descTf.multiline = true;
			descTf.wordWrap = true;
			descTf.autoSize = TextFieldAutoSize.CENTER;
			descTf.y = PADDING_TOP;

			addChild(descTf);
		}

		public var descTf:TextField;

		public function set text(value:String):void
		{
			descTf.htmlText = value;

			graphics.clear();
			graphics.beginFill(0x000000, 0.3);
			graphics.drawRoundRectComplex(0, 0, descTf.width, descTf.height + PADDING_BOTTOM + PADDING_TOP, 4, 4, 4, 4);
			graphics.endFill();
		}
	}
}
