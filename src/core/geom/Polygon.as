package core.geom
{
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import core.Manager;

	public class Polygon
	{
		public var points:Array = [];
		
		public function addPoint(point:Point):void
		{
			if(point != null) points.push(point);
		}
		
		public function transform(matrix:Matrix):void
		{
			if(matrix != null)
			{
				var point:Point;
				var x:Number;
				var y:Number;
				for(var i:int = 0; i < points.length; ++i)
				{
					point = points[i];
					x = point.x;
					y = point.y;
					point.x = matrix.a * x + matrix.c * y + matrix.tx;
					point.y = matrix.b * x + matrix.d * y + matrix.ty;
				}
			}
		}
		
		public function getAABB():Rectangle
		{
			var rect:Rectangle = Manager.pool.pop(Rectangle) as Rectangle;
			rect.left 	=  Number.MAX_VALUE;
			rect.right 	= -Number.MAX_VALUE;
			rect.top 	=  Number.MAX_VALUE;
			rect.bottom = -Number.MAX_VALUE;
			var i:int;
			var length:int;
			var point:Point;
			for (i = 0, length = points.length; i < length; ++i)
			{
				point = points[i];
				if(point.x < rect.left) rect.left = point.x;
				if(point.x > rect.right) rect.right = point.x;
				if(point.y < rect.top) rect.top = point.y;
				if(point.y > rect.bottom) rect.bottom = point.y;
			}
			return rect;
		}
	}
}