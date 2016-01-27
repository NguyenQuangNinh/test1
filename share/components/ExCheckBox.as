/**
 * ...
 * @author Vu Anh
 */

package components
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	public class ExCheckBox extends MovieClip 
	{
		public var selected:Boolean = false;
		
        function ExCheckBox() {
			this.gotoAndStop(1);
			this.addEventListener( MouseEvent.CLICK, mouseClickHdl );
		}
		
		protected function mouseClickHdl(e:MouseEvent):void
		{
			if (!selected) {
				selected = true;
				gotoAndStop("check");
			} else {
				selected = false;
				gotoAndStop("uncheck");
			}
		}
		
		public function setSelected(s:Boolean):void
		{
			selected = s;
			if (selected) {
				gotoAndStop("check");
			} else {
				gotoAndStop("uncheck");
			}
		}
		
		public function lock():void
		{
			this.alpha = 0.5;
			this.mouseEnabled = false;
		}
		
		public function unlock():void
		{
			this.alpha = 1;
			this.mouseEnabled = true;
		}
	}
}