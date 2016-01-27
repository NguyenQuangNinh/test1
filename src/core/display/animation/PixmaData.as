package core.display.animation 
{
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	
	import core.Manager;

	/**
	 * ...
	 * @author bangnd2
	 */
	public class PixmaData 
	{
		private var animations:Array;
		public var moduleBitmapDatas:Array;
		
		public function PixmaData() 
		{
			animations = [];
			reset();
		}
		
		public function reset():void
		{
		}
		
		public function clean():void
		{
			var frameIndex:int;
			var frameTotal:int;
			for (var i:int = 0; i < animations.length; i++) 
			{
				var animation:Animation = animations[i];
				if (!animation) continue; 
				for (frameIndex = 0, frameTotal = animation.frames.length; frameIndex < frameTotal; ++frameIndex)
				{
					var animationFrame:AnimationFrame = animation.frames[frameIndex];
					if (animationFrame != null && animationFrame.frame != null)
					{
						if (animationFrame.frame.bitmapData) 
						{
							animationFrame.frame.bitmapData.dispose();
							animationFrame.frame.bitmapData = null;
						}
					}
				}
				animation.isBuilt = false;
			}
		}
		
		public function destroy():void
		{
			reset();
			animations = null;
		}
		
		public function setAnimation(animation:Animation, index:int):void
		{
			if (animation != null) animations[index] = animation;
		}
		
		public function setAnimations(animations:Array):void
		{
			this.animations = animations;
		}
		
		public function getAnimation(index:int):Animation
		{
			return animations[index];
		}
		
		public function getAnimationTotal():int { return animations.length; }
		
		public function buildAnimation(index:int):void
		{
			var animation:Animation = animations[index];
			if (animation != null)
			{
				var frameIndex:int;
				var frameTotal:int;
				var animationFrame:AnimationFrame;
				var frame:Frame;
				var matrix:Matrix = Manager.pool.pop(Matrix) as Matrix;
				for (frameIndex = 0, frameTotal = animation.frames.length; frameIndex < frameTotal; ++frameIndex)
				{
					animationFrame = animation.frames[frameIndex];
					if (animationFrame != null && animationFrame.frame != null)
					{
						buildAnimationFrame(animationFrame);
					}
				}
				animation.isBuilt = true;
			}
		}
		
		public function buildAnimationFrame(animationFrame:AnimationFrame):void
		{
			var frame:Frame;
			var matrix:Matrix = Manager.pool.pop(Matrix) as Matrix;
			
			frame = animationFrame.frame;
			
			// don't rebuild bitmap data of frame if it is built already - only build after clean() method is called ------------------------------
			if (frame.bitmapData || frame.frameModules.length == 0) return;
			// ------------------------------------------------------------------------------------------------------------------------------------
			
			frame.bitmapData = new BitmapData(frame.rect.width, frame.rect.height, true, 0);
			var moduleIndex:int;
			var moduleTotal:int;
			var frameModule:FrameModule;
			for (moduleIndex = 0, moduleTotal = animationFrame.frame.frameModules.length; moduleIndex < moduleTotal; ++moduleIndex)
			{
				frameModule = animationFrame.frame.frameModules[moduleIndex];
				if (frameModule != null)
				{
					matrix.copyFrom(frameModule.matrix);
					matrix.translate(-frame.rect.x, -frame.rect.y);
					frame.bitmapData.draw(frameModule.bitmapData, matrix, frameModule.colorTransform, frameModule.blendmode, null, true);
				}
			}
			Manager.pool.push(matrix, Matrix);
		}
		
		public function getAnimationTime(index:int):Number
		{
			var animationTime:Number = 0;
			var animation:Animation = animations[index];
			if (animation != null)
			{
				var frameIndex:int;
				var frameTotal:int;
				var animationFrame:AnimationFrame;
				for (frameIndex = 0, frameTotal = animation.frames.length; frameIndex < frameTotal; ++frameIndex)
				{
					animationFrame = animation.frames[frameIndex];
					if (animationFrame != null) animationTime += animationFrame.time;
				}
			}
			return animationTime;
		}
	}

}