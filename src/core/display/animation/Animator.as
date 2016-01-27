package core.display.animation
{
	import core.Manager;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.geom.Transform;
	import flash.utils.Dictionary;
	
	
	public dynamic class Animator extends Sprite
	{
		public static const LOADED:String = "loaded";
		
		static private var matrix:Matrix = new Matrix();
		
		private var data:PixmaData;
		private var displayFrames:Array;
		public var rect:Rectangle;
		private var currentAnimation:int;
		private var currentFrame:DisplayFrame;
		private var currentFrameIndex:int;
		private var currentFrameTime:Number;
		private var isPlaying:Boolean;
		private var url:String;
		private var loaded:Boolean = false;
		private var animationSpeed:Number = 1;
		private var loop:int = 0;
		private var reverse:Boolean = false;
		private var currentLoop:int = 0;
		private var delay:Number;
		private var dummy:DisplayObject;
		
		private var cacheEnabled:Boolean;
		private var replaceModuleDict:Dictionary;
		private var replaceBitmapDict:Dictionary;
		
		public function Animator()
		{
			displayFrames = [];
			replaceBitmapDict = new Dictionary();
			
			reset();
		}
		
		public function isCacheEnabled():Boolean { return cacheEnabled; }
		public function setCacheEnabled(value:Boolean):void
		{
			cacheEnabled = value;
		}
		
		public function reset():void
		{
			releaseDisplayFrames();
			alpha = 1;
			visible = true;
			scaleX = 1;
			scaleY = 1;
			reverse = false;
			currentAnimation = -1;
			currentFrameIndex = 0;
			currentFrameTime = 0;
			isPlaying = false;
			loaded = false;
			animationSpeed = 1;
			loop = 0;
			currentLoop = 0;
			delay = 0;
			x = 0;
			y = 0;
			cacheEnabled = true;
			dummy = null;
			url = "";
		}
		
		public function getAnimationTime(index:int):Number
		{
			var totalTime:Number = 0;
			if (data != null)
			{
				totalTime = data.getAnimationTime(index);
			}
			return totalTime;
		}
		
		public function load(url:String, dummy:DisplayObject = null):void
		{
			if (url == null || url.length == 0) return;
			//if (data) data.clean();
			this.url = url;
			var data:PixmaData = Manager.resource.getResourceByURL(url);
			if(data != null)
			{
				setData(data);
				dispatchEvent(new Event(LOADED, true));
			}
			else
			{
				this.dummy = dummy;
				Manager.resource.load([url], onAnimationLoaded);
			}
		}
		
		private function onAnimationLoaded():void
		{
			if (dummy && dummy.parent) removeChild(dummy);
			setData(Manager.resource.getResourceByURL(url));
			dispatchEvent(new Event(LOADED, true));
		}
		
		public function setAnimationSpeed(animationSpeed:Number):void
		{ 
			this.animationSpeed = Math.abs(animationSpeed);
		}
		public function getAnimationSpeed():Number { return animationSpeed; }
		
		public function getCurrentAnimation():int { return currentAnimation; }
		public function getAnimationCount():int
		{ 
			if (data != null) return data.getAnimationTotal();
			return 0; 
		}
		
		public function setData(data:PixmaData):void
		{
			if (!data) return;
			this.data = data;
			Manager.resource.increaseAnimRefCount(data);
			loaded = true;
			if(isPlaying) play(currentAnimation, loop, delay);
		}
		
		public function render():void
		{
			if(isPlaying) play(currentAnimation, loop, delay);
		}
		
		public function replaceFMBitmapData(arrIndex:Array, arrBitmapData:Array, arrScaleX:Array = null, arrScaleY:Array = null):void {
			
			if (arrScaleX && arrScaleY) {
				var length : int = Math.min(arrIndex.length, arrBitmapData.length, arrScaleX.length, arrScaleY.length);
				
				for (var i:int = 0; i < length; i++) {
					var obj:Object = { };
					obj.bitmapData = arrBitmapData[i];
					obj.scaleX = arrScaleX[i];
					obj.scaleY = arrScaleY[i];
					replaceBitmapDict[arrIndex[i]] = obj;
				}
			} else {
				length = Math.min(arrIndex.length, arrBitmapData.length);
				for (i = 0; i < length; i++) {
					obj = { };
					obj.bitmapData = arrBitmapData[i];
					obj.scaleX = 1;
					obj.scaleY = 1;
					replaceBitmapDict[arrIndex[i]] = obj;
				}
			}
			
		}
		
		public function replaceModules(srcModules : Array , desModules : Array) : void {
			
			var length : int = Math.min(srcModules.length, desModules.length);
			replaceModuleDict = new Dictionary();
			for (var i:int = 0; i < length; i++) 
			{
				replaceModuleDict[srcModules[i]] = desModules[i];
			}
		}

		public function play(animationIndex:int = 0, loop:int = 0, delay:Number = 0, randomFrame:Boolean = false, reverse:Boolean = false):void
		{
			currentAnimation = animationIndex;
			this.loop = loop;
			currentLoop = loop;
			this.reverse = reverse;
			this.delay = delay;
			resume();
			releaseDisplayFrames();
			if (data != null)
			{
				var animation:Animation = data.getAnimation(currentAnimation);
				
				if (animation != null)
				{
					//if(cacheEnabled && animation.isBuilt == false)	data.buildAnimation(currentAnimation);
					rect = animation.rect;
					var frameIndex:int;
					var frameTotal:int;
					var animationFrame:AnimationFrame;
					var displayFrame:DisplayFrame;
					var bitmap:Bitmap;
					var replaceIndex:int;
					var alignCenter:Boolean;
					for (frameIndex = 0, frameTotal = animation.frames.length; frameIndex < frameTotal; ++frameIndex)
					{
						animationFrame = animation.frames[frameIndex];
						if (animationFrame != null && animationFrame.frame != null)
						{
							displayFrame = Manager.pool.pop(DisplayFrame) as DisplayFrame;
							
							displayFrame.mouseEnabled = false;
							if (cacheEnabled)
							{
								/*
								bitmap = Manager.pool.pop(Bitmap) as Bitmap;
								resetBitmap(bitmap);
								bitmap.smoothing = true;
								if (!animationFrame.frame.bitmapData) data.buildAnimationFrame(animationFrame);
								
								bitmap.bitmapData = animationFrame.frame.bitmapData;
								displayFrame.addChild(bitmap);*/
								
								displayFrame.x = animationFrame.frame.rect.x + animationFrame.x;
								displayFrame.y = animationFrame.frame.rect.y + animationFrame.y;
								displayFrame.animationFrame = animationFrame;
							}
							else
							{
								var moduleIndex:int;
								var moduleTotal:int;
								var frameModule:FrameModule;
								var bitmapScaleX:Number;
								var bitmapScaleY:Number;
								for (moduleIndex = 0, moduleTotal = animationFrame.frame.frameModules.length; moduleIndex < moduleTotal; ++moduleIndex)
								{
									frameModule = animationFrame.frame.frameModules[moduleIndex];
									bitmapScaleX = 1.0;
									bitmapScaleY = 1.0;
									if (frameModule != null)
									{
										bitmap = Manager.pool.pop(Bitmap) as Bitmap;
										resetBitmap(bitmap);
										alignCenter = false;
										var isModuleReplaced:Boolean = false;
										if (replaceBitmapDict[frameModule.id] != null)
										{
											alignCenter = true;
											bitmap.bitmapData = (replaceBitmapDict[frameModule.id]).bitmapData;
											bitmapScaleX = (replaceBitmapDict[frameModule.id]).scaleX;
											bitmapScaleY = (replaceBitmapDict[frameModule.id]).scaleY;
											isModuleReplaced = true;
										}
										
										if ((!isModuleReplaced) && replaceModuleDict != null && replaceModuleDict[frameModule.id] != null)
										{		
											bitmap.bitmapData = data.moduleBitmapDatas[replaceModuleDict[frameModule.id]];
											isModuleReplaced = true;
										}
										
										if(!isModuleReplaced) bitmap.bitmapData = frameModule.bitmapData;
										
										var transform:Transform = Manager.pool.pop(Transform) as Transform;
										if(transform == null) transform = bitmap.transform;
										if (frameModule.matrix != null)
										{
											var matrix:Matrix = Manager.pool.pop(Matrix) as Matrix;
											matrix.copyFrom(frameModule.matrix);
											if (alignCenter) {
												matrix.scale(bitmapScaleX, bitmapScaleY);
												matrix.tx = matrix.tx 
															+ frameModule.bitmapData.width / 2 
															- bitmap.width / 2;
															
												matrix.ty =  matrix.ty 
															+ frameModule.bitmapData.height / 2 
															- bitmap.height / 2;
											}
											transform.matrix = matrix;
											Manager.pool.push(matrix, Matrix);
										}
										var colorTransform:ColorTransform = Manager.pool.pop(ColorTransform) as ColorTransform;
										if (frameModule.colorTransform != null)
										{
											colorTransform.alphaMultiplier 	= frameModule.colorTransform.alphaMultiplier;
											colorTransform.alphaOffset 		= frameModule.colorTransform.alphaOffset;
											colorTransform.redMultiplier 	= frameModule.colorTransform.redMultiplier;
											colorTransform.redOffset 		= frameModule.colorTransform.redOffset;
											colorTransform.greenMultiplier 	= frameModule.colorTransform.greenMultiplier;
											colorTransform.greenOffset 		= frameModule.colorTransform.greenOffset;
											colorTransform.blueMultiplier 	= frameModule.colorTransform.blueMultiplier;
											colorTransform.blueOffset 		= frameModule.colorTransform.blueOffset;
										}
										else
										{
											colorTransform.alphaMultiplier 	= 1;
											colorTransform.alphaOffset 		= 0;
											colorTransform.redMultiplier 	= 1;
											colorTransform.redOffset 		= 0;
											colorTransform.greenMultiplier 	= 1;
											colorTransform.greenOffset 		= 0;
											colorTransform.blueMultiplier 	= 1;
											colorTransform.blueOffset 		= 0;
										}
										transform.colorTransform = colorTransform;
										Manager.pool.push(colorTransform, ColorTransform);
										bitmap.transform = transform;
										bitmap.smoothing = true;
										Manager.pool.push(transform, Transform);
										if (frameModule.blendmode != null) bitmap.blendMode = frameModule.blendmode;
										displayFrame.addChild(bitmap);
									} 
								}
								displayFrame.x = animationFrame.x;
								displayFrame.y = animationFrame.y;
							}
							displayFrames[frameIndex] = displayFrame;
						}
					}
					if(randomFrame)
					{
						setCurrentFrame(Math.random()*animation.frames.length);
					}
					else
					{
						(reverse) ? setCurrentFrame(animation.frames.length - 1) : setCurrentFrame(0);
					}
				}
			} else if(dummy && !dummy.parent) {
				//show dummy image
				dummy.x = -dummy.width / 2;
				dummy.y = -dummy.height;
				addChild(dummy);
			}
		}
		
		private function releaseDisplayFrames():void
		{
			if (currentFrame != null) 
			{
				removeChild(currentFrame);
				currentFrame = null;
			}
			var frameIndex:int;
			var frameTotal:int;
			var displayFrame:DisplayFrame;
			var bitmap:Bitmap;
			
			for (frameIndex = 0, frameTotal = displayFrames.length; frameIndex < frameTotal; ++frameIndex)
			{
				displayFrame = displayFrames[frameIndex];
				if (displayFrame != null)
				{
					displayFrame.mouseEnabled = true;
					displayFrame.clean();
					while (displayFrame.numChildren > 0) 
					{
						var obj:Object = displayFrame.removeChildAt(0);
						if (obj is Bitmap) 
						{
							obj.bitmapData = null;
							Manager.pool.push(obj);
						}
					}
					Manager.pool.push(displayFrame, DisplayFrame);
				}
			}
			displayFrames.splice(0);
		}
		
		private function resetBitmap(bitmap:Bitmap):void
		{
			if(bitmap == null) return;
			bitmap.bitmapData = null;
			var transform:Transform = Manager.pool.pop(Transform) as Transform;
			var matrix:Matrix = Manager.pool.pop(Matrix) as Matrix;
			matrix.identity();
			transform.matrix = matrix;
			Manager.pool.push(matrix, Matrix);
			var colorTransform:ColorTransform = Manager.pool.pop(ColorTransform) as ColorTransform;
			colorTransform.alphaMultiplier 	= 1;
			colorTransform.alphaOffset 		= 0;
			colorTransform.redMultiplier 	= 1;
			colorTransform.redOffset 		= 0;
			colorTransform.greenMultiplier 	= 1;
			colorTransform.greenOffset 		= 0;
			colorTransform.blueMultiplier 	= 1;
			colorTransform.blueOffset 		= 0;
			transform.colorTransform = colorTransform;
			Manager.pool.push(colorTransform, ColorTransform);
			bitmap.transform = transform;
			Manager.pool.push(transform, Transform);
			bitmap.blendMode = BlendMode.NORMAL;
			bitmap.x = 0;
			bitmap.y = 0;
		}
		
		public function stop():void
		{
			pause();
			currentFrameIndex = 0;
			currentFrameTime = 0;
		}
		
		public function pause():void
		{
			isPlaying = false;
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		public function resume():void
		{
			isPlaying = true;
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		public function isLoaded():Boolean { return loaded; }
		
		protected function onEnterFrame(event:Event):void
		{
			if (data != null && isPlaying)
			{
				var frameDelta:Number = Manager.time.getFrameDelta();
				if (delay <= 0)
				{
					currentFrameTime += frameDelta;
					var animation:Animation = data.getAnimation(currentAnimation);
					if (animation != null)
					{
						var frame:AnimationFrame = animation.frames[currentFrameIndex];
						if (frame != null)
						{
							var lastFrameIndex:int = currentFrameIndex;
							var frameTime:Number = frame.time * animationSpeed;
							if (currentFrameTime >= frameTime)
							{
								currentFrameTime -= frameTime;
								if (currentFrameTime >= frameTime) currentFrameTime = 0;
								if(reverse)
								{
									if (--lastFrameIndex == -1)
									{
										lastFrameIndex = animation.frames.length;
										if (loop > 0 && --currentLoop == 0)
										{
											stop();
											dispatchEvent(new Event(Event.COMPLETE));
											return;
										}
									}
									setCurrentFrame(lastFrameIndex);
								}
								else
								{
									if (++lastFrameIndex == animation.frames.length)
									{
										lastFrameIndex = 0;
										if (loop > 0 && --currentLoop == 0)
										{
											stop();
											dispatchEvent(new Event(Event.COMPLETE));
											return;
										}
									}
									setCurrentFrame(lastFrameIndex);
								}
							}
						}
					}
				}
				else
				{
					delay -= frameDelta;
				}
			}
		}
		
		private function setCurrentFrame(index:int):void
		{
			currentFrameIndex = index;
			if (currentFrame != null) 
			{
				removeChild(currentFrame);
			}
			currentFrame = displayFrames[currentFrameIndex];
			
			if (currentFrame != null) 
			{
				if (cacheEnabled && !currentFrame.isHasBitmap && currentFrame.animationFrame && currentFrame.animationFrame.frame)
				{
					var bitmap:Bitmap = Manager.pool.pop(Bitmap) as Bitmap;
					resetBitmap(bitmap);
					bitmap.smoothing = true;
					var animationFrame:AnimationFrame = currentFrame.animationFrame;
					data.buildAnimationFrame(animationFrame);

					bitmap.bitmapData = animationFrame.frame.bitmapData;
					currentFrame.addBitmap(bitmap);
				}
				addChild(currentFrame);
			}
		}
		
		private function getCurrentFrameTime():Number
		{
			if (data != null)
			{
				var currentAnim:Animation = data[currentAnimation];
				if (currentAnim != null && currentAnim.frames[currentFrameIndex] != null) return currentAnim.frames[currentFrameIndex].time;
			}
			return 0;
		}
	}
}