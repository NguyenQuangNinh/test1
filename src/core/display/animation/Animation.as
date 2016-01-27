package core.display.animation
{
	import flash.geom.Rectangle;

	public class Animation
	{
		public var frames:Array = [];
		public var rect:Rectangle;
		public var isBuilt:Boolean;
		
		public function getTotalTime():Number
		{
			var frameIndex:int;
			var frameTotal:int;
			var frame:AnimationFrame;
			var totalTime:Number = 0;
			for (frameIndex = 0, frameTotal = frames.length; frameIndex < frameTotal; ++frameIndex)
			{
				frame = frames[frameIndex];
				if (frame != null) totalTime += frame.time;
			}
			return totalTime;
		}
	}
}