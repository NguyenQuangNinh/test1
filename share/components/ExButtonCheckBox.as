package components 
{
	import flash.events.MouseEvent;
	import flash.text.TextField;
	/**
	 * ...
	 * @author 
	 */
	public class ExButtonCheckBox extends ExCheckBox
	{
		public var labelTf:TextField;
		public var info:Object;
		public function ExButtonCheckBox() 
		{
			if (labelTf) labelTf.mouseEnabled = false;
		}
		
		override protected function mouseClickHdl(e:MouseEvent):void
		{
			if (!selected) {
				selected = true;
				gotoAndStop("check");
			}
		}
	}

}