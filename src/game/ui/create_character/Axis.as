package game.ui.create_character
{
	import flash.display.MovieClip;
	import flash.geom.Point;
	
	import core.util.MathUtil;
	
	public class Axis extends MovieClip
	{
		public var dot:MovieClip;
		
		private var dotPoint:Point;
		
		public function Axis()
		{
			dotPoint = new Point();
		}
		
		public function setValue(value:int):void
		{
			dot.x = value / 100 * 108;
			var radianRotation:Number = MathUtil.degreeToRadian(rotation);
			dotPoint.x = dot.x * Math.cos(radianRotation);
			dotPoint.y = dot.x * Math.sin(radianRotation);
		}
		
		public function getPoint():Point { return dotPoint; }
	}
}