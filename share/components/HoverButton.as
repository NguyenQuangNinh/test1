package components 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author 
	 */
	public class HoverButton
	{
		public function HoverButton() 
		{
		}
		
		public static function initHover(btn:MovieClip):void
		{
			if (btn.tf) btn.activeColor = btn.tf.textColor;
			btn.mouseChildren = false;
			btn.buttonMode = true;
			btn.addEventListener(MouseEvent.MOUSE_OVER, mouseOverHdl);
			btn.addEventListener(MouseEvent.MOUSE_OUT, mouseOutHdl);
			btn.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHdl);
			btn.addEventListener(MouseEvent.MOUSE_UP, mouseUpHdl);
		}
		
		private static function mouseOverHdl(e:MouseEvent):void 
		{
			MovieClip(e.currentTarget).gotoAndStop("over");
		}
		
		private static function mouseOutHdl(e:MouseEvent):void 
		{
			if (e.currentTarget.currentLabel != "disable") MovieClip(e.currentTarget).gotoAndStop("up");
		}
		
		private static function mouseDownHdl(e:MouseEvent):void 
		{
			MovieClip(e.currentTarget).gotoAndStop("down");
		}
		
		private static function mouseUpHdl(e:MouseEvent):void 
		{
			MovieClip(e.currentTarget).gotoAndStop("over");
		}
		
		public static function disableBtn(btn:MovieClip):void
		{
			btn.mouseChildren = false;
			btn.mouseEnabled = false;
			btn.gotoAndStop("disable");
			if (btn.tf) btn.tf.textColor = 0x333333;
		}

		public static function enableBtn(btn:MovieClip):void
		{
			btn.mouseChildren = true;
			btn.mouseEnabled = true;
			btn.gotoAndStop("up");
			if (btn.tf) btn.tf.textColor = btn.activeColor;
		}
	}

}