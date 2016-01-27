/**
 * Created by NinhNQ on 9/22/2014.
 */
package game.ui.events.gui
{

	import core.util.FontUtil;

	import flash.display.MovieClip;
	import flash.text.TextField;

	import game.data.model.event.EventData;
	import game.enum.Font;

	public class EventTab extends MovieClip
	{
		public static const HEIGHT:int = 59;

		public function EventTab()
		{
			this.buttonMode = true;
			this.mouseEnabled = true;
			this.mouseChildren = false;
			setActive(false);

			FontUtil.setFont(this.nameTf, Font.ARIAL, true);
		}

		public var content:MovieClip;
		public var data:EventData;

		public function set text(value:String):void { content.nameTf.text = value.toUpperCase(); }

		private function get nameTf():TextField { return content.nameTf as TextField; }

		public function setActive(value:Boolean = true):void
		{
			var label:String = (value) ? "active" : "passive";
			gotoAndStop(label);
		}
	}
}
