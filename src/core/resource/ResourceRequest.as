package core.resource
{
	import core.util.Utility;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import core.Manager;
	import core.resource.loader.LoaderBase;

	public class ResourceRequest extends EventDispatcher
	{
		public static const COMPLETE:String = "complete";
		
		private var completeCallback:Function = null;
		private var progressCallback:Function = null;
		private var loaders:Array = [];
		private var ID:int;
		private var bytesTotal:int;
		private var bytesLoaded:int;
		private var fileLoaded:int;
		private var fileTotal:int;
		private var currentLoaderIndex:int;
		private var fileReady:int = 0;
		private var currentPercent:Number = 0;
		
		public function addLoader(loader:LoaderBase):void
		{
			loaders.push(loader);
			loader.addEventListener(LoaderBase.LOADER_BASE_COMPLETE, onFinished);
			loader.addEventListener(LoaderBase.LOADER_BASE_ERROR, onFinished);
			fileTotal++;
		}
		
		private function onFinished(e:Event):void 
		{
			var loader:LoaderBase = e.target as LoaderBase;
			fileLoaded++;
			loader.removeEventListener(LoaderBase.LOADER_BASE_COMPLETE, onFinished);
			loader.removeEventListener(LoaderBase.LOADER_BASE_ERROR, onFinished);
		}
		
		public function reset():void
		{
			bytesLoaded = 0;
			bytesTotal = 0;
			fileLoaded = 0;
			fileTotal = 0;
			fileReady = 0;
			currentPercent = 0;
		}
		
		public function removeLoader(loader:LoaderBase):void
		{
			var index:int = loaders.indexOf(loader);
			if(index > -1) loaders.splice(index, 1);
		}
		
		public function getCompleteCallback():Function { return completeCallback; }
		public function setCompleteCallback(callback:Function):void { completeCallback = callback; }
		public function getProgressCallback():Function { return progressCallback; }
		public function setProgressCallback(callback:Function):void { progressCallback = callback; }
		public function getLoaders():Array { return loaders; }
		public function getID():int { return ID; }
		public function setID(value:int):void { this.ID = value; }
		
		public function start():void
		{
			Manager.time.addFrameCallback(onEnterFrame);
		}
		
		public function stop():void
		{
			Manager.time.removeFrameCallback(onEnterFrame);
		}
		
		private function onEnterFrame():void
		{
			if(loaders.length > 0)
			{
				var loader:LoaderBase = loaders[0];
				if(loader.isLoading() == false)
				{
					loader.load();
				}
			}
		}
		
		public function isReady():Boolean
		{
			for(var i:int = 0; i < loaders.length; ++i)
			{
				var loader:LoaderBase = loaders[i];
				if(loader.isReady() == false) return false;
			}
			return true;
		}
		
		public function addBytesTotal(value:int):void { bytesTotal += value; fileReady++; }
		public function addBytesLoaded(value:int):void { bytesLoaded += value; }
		public function getProgress():Number {
			var per:Number = (bytesLoaded / bytesTotal) * (fileReady / fileTotal);
			currentPercent = Math.max(per, currentPercent);
			
			return currentPercent <= 1 ? currentPercent : 1; 
		}
		//public function getProgress():Number { return bytesLoaded / bytesTotal; }
	}
}