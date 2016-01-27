package core.resource.loader 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import game.Game;
	
	import core.Manager;
	import core.event.EventEx;
	import core.resource.ResourceRequest;
	import core.util.Utility;

	/**
	 * ...
	 * @author bangnd2
	 */
	public class LoaderBase extends EventDispatcher
	{
		static public const LOADER_BASE_COMPLETE:String = "loader_base_complete";
		static public const LOADER_BASE_ERROR:String = "loader_base_error";
		static public const LOADER_BASE_PROGRESS:String = "loader_base_progress";
		static public const LOADER_BASE_READY:String = "loader_base_ready";
		
		public static const MAX_LOAD_RETRY: int = 3;	
		public static const MAX_CONNECTION: int = 6;	
		public static const TIME_OUT_PER_RETRY: int = 1000;
		protected var _currentRetry:int = 0;
		
		protected var url:String = "";
		//protected var completeHandlers:Array = [];
		//protected var errorHandlers:Array = [];
		protected var resource:Object;
		
		protected var requests:Array = [];
		protected var _isLoading:Boolean = false;
		
		private var ID:int;
		private var bytesTotal:int;
		private var bytesLoaded:int;
		private var urlLoader:URLLoader;
		
		protected var loading:Boolean;
		
		public function LoaderBase():void
		{
			urlLoader = new URLLoader();
			urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
			urlLoader.addEventListener(Event.COMPLETE, onLoadComplete);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, onErrorLoadHandler);
			urlLoader.addEventListener(ProgressEvent.PROGRESS, onProgressHandler);
		}
		
		public function reset():void
		{
			loading = false;
			bytesTotal = 0;
			bytesLoaded = 0;
			_currentRetry = 0;
		}
		
		public function addRequest(request:ResourceRequest):void
		{
			requests.push(request);
		}
		
		public function removeRequest(request:ResourceRequest):void
		{
			var index:int = requests.indexOf(request);
			if(index > -1) requests.splice(index, 1);
		}
		
		public function load():void
		{
			loading = true;
			//urlLoader.load(new URLRequest(Manager.resource.getLongURL(url)));
			//urlLoader.load(new URLRequest(url));
			LoadingQueue.load(urlLoader, url);
		}
		
		private function retry():void {
			if (_currentRetry < MAX_LOAD_RETRY) 
			{
				LoadingQueue.load(urlLoader, url);
				_currentRetry++;
				Utility.error("Retry load " + url + ", retry: " + _currentRetry);
			}
			else 
			{
				Utility.error("ERROR load " + url + " after " + _currentRetry + " times retry");
				loading = false;
				dispatchEvent(new Event(LOADER_BASE_ERROR));
			}
		}
		
		private function onProgressHandler(e:ProgressEvent):void 
		{
			var loader:URLLoader = e.target as URLLoader;
			if(bytesTotal == 0)
			{
				bytesTotal = e.bytesTotal;
				//loader.close();
				//loading = false;
				dispatchEvent(new EventEx(LOADER_BASE_READY, bytesTotal));
			}
			else
			{
				var bytesProgress:int = e.bytesLoaded - bytesLoaded;
				bytesLoaded = e.bytesLoaded;
				dispatchEvent(new EventEx(LOADER_BASE_PROGRESS, bytesProgress));
			}
		}
		
		private function onErrorLoadHandler(e:IOErrorEvent):void 
		{
			retry();
		}
		
		private function onLoadComplete(event:Event):void 
		{
			try
			{
				processData(urlLoader.data);
			}
			catch(e:Error)
			{
				Logger.error("LoaderBase: ProcessData Error: " + url);
			}
		}
		
		public function processData(data:*):void
		{
			complete();
		}
		
		protected function complete():void
		{
			loading = false;
			urlLoader.data = null;
			dispatchEvent(new Event(LOADER_BASE_COMPLETE));
		}
		
		public function setURL(url:String):void
		{
			this.url = url;
		}
		
		public function isReady():Boolean { return bytesTotal > 0; }
		public function isLoading():Boolean { return loading; }
		public function getURL():String { return url; }
		public function getResource():* { return resource; }
		public function getRequests():Array { return requests; }
		public function getID():int { return ID; }
		public function setID(value:int):void { ID = value; }
		public function getBytesTotal():int { return bytesTotal; }
	}

}