package core.time
{
	import flash.display.Stage;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.utils.getTimer;
	
	import core.util.Utility;
	
	public class TimeManager
	{
		private var lastFrameTime:int;
		private var frameDelta:Number;
		private var frameCount:int;
		private var time:int;
		private var fps:int;
		//private var debugFPS:Boolean = true;
		private var debugFPS:Boolean = true;
		private var frameCallbacks:Array = [];
		
		private var _fpsTfCounter:TextField;
		
		public function TimeManager(stage:Stage)
		{
			lastFrameTime = getTimer();
			frameCount = 0;
			time = 0;
			if (stage != null)
				stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			else
				Utility.error("TimeManager: null stage");
		}
		
		public function addFrameCallback(callback:Function):void
		{
			frameCallbacks.push(callback);
		}
		
		public function removeFrameCallback(callback:Function):void
		{
			var index:int = frameCallbacks.indexOf(callback);
			if(index > -1) frameCallbacks.splice(index, 1);
		}
		
		private function onEnterFrame(e:Event):void
		{
			var currentFrameTime:int = getTimer();
			var iFrameDelta:int = currentFrameTime - lastFrameTime;
			frameDelta = iFrameDelta / 1000;
			lastFrameTime = currentFrameTime;
			++frameCount;
			time += iFrameDelta;
			if (time >= 1000)
			{
				//_fpsTfCounter.text = "";
				time -= 1000;
				fps = frameCount;
				if (debugFPS && _fpsTfCounter)
				{
					//Utility.log("FPS=" + fps);
					_fpsTfCounter.text = "FPS = " + fps;
				}
				frameCount = 0;
			}
			for each(var callback:Function in frameCallbacks)
			{
				if(callback != null) callback();
			}
		}
		
		public function getFrameDelta():Number
		{
			return frameDelta;
		}
		
		public function getFPS():int
		{
			return fps;
		}
		
		public function addFPSTf(tf:TextField):void
		{
			_fpsTfCounter = tf;
		}
	}
}