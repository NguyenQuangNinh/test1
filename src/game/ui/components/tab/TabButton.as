package game.ui.components.tab
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;
	/**
	 * ...
	 * @author 
	 */
	public class TabButton extends MovieClip
	{
		//public var tf:TextField;
		public var bg:MovieClip;
		
		public var index:uint;
		public var page:Sprite;
		
		public function TabButton() 
		{
			bg.gotoAndStop("normal");
		}
		
		/*public function toogle():void {
			bg.gotoAndStop(currentFrameLabel == "normal" ? "active" : "normal");
		}*/
	}

}