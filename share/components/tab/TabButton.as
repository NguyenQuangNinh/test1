package components.tab 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;
	/**
	 * ...
	 * @author hailua54@gmail.com
	 */
	public class TabButton extends MovieClip
	{
		public var tf:TextField;
		public var bg:MovieClip;
		
		public var index:uint;
		public var page:Sprite;
		
		public function TabButton() 
		{
			bg.gotoAndStop("normal");
		}
		
	}

}