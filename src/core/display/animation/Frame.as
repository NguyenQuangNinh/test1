package core.display.animation
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	
	public class Frame
	{
		public var frameModules:Array = [];
		public var rect:Rectangle;
		public var bitmapData:BitmapData;
		
		public function Frame():void
		{
			rect = new Rectangle();
			rect.left 	=  Number.MAX_VALUE;
			rect.right 	= -Number.MAX_VALUE;
			rect.top 	=  Number.MAX_VALUE;
			rect.bottom = -Number.MAX_VALUE;
		}
	}
}