package game.ui.components
{
	import flash.display.MovieClip;
	
	public class IconElement extends MovieClip
	{
		public function setData(element:int):void
		{
			gotoAndStop(element + 1);
		}
	}
}