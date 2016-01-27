package core.resource 
{
	import core.display.animation.PixmaData;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	import core.Manager;
	import core.event.EventEx;
	import core.resource.loader.LoaderBase;
	import core.util.Enum;
	import core.util.Utility;

	/**
	 * ...
	 * @author bangnd2
	 */
	public class ResourceManager
	{					
		private var urlRefCountMap:Dictionary;
		private var cache:Dictionary = new Dictionary();
		private var requests:Array = [];
		private var loaders:Array = [];
		private var version:String = "";
		private var rootURL:String = "";
		private var currentLoaders:Array = [];
		
		private static var nextRequestID:int = 0;
		private static var nextLoaderID:int = 0;
		
		public function ResourceManager(rootURL:String, version:String):void
		{
			this.rootURL = rootURL;
			this.version = version;
			urlRefCountMap = new Dictionary();
		}
		
		public function setRootURL(rootURL:String):void
		{
			this.rootURL = rootURL;
		}
		
		public function increaseAnimRefCount(pixma:PixmaData):void
		{
			/*if (!urlRefCountMap[pixma]) urlRefCountMap[pixma] = 1;
			else urlRefCountMap[pixma]++;*/
			urlRefCountMap[pixma] = 1
		}
		
		public function descreaseAnimRefCount(pixma:PixmaData):void
		{
			if (urlRefCountMap[pixma] && urlRefCountMap[pixma] >= 1) urlRefCountMap[pixma]--;
		}
		
		public function getAnimRefCount(pixma:PixmaData):int
		{
			return urlRefCountMap[pixma];
		}
		
		public function cleanAnimRef():void
		{
			var pixma:PixmaData;
			for (var i:* in urlRefCountMap) 
			{
				pixma = i as PixmaData;
				//if (urlRefCountMap[pixma] == 0) 
				{
					pixma.clean();
				}
			}
			//urlRefCountMap = new Dictionary();
		}
		
		public function load(urls:Array, onComplete:Function, onProgress:Function = null, onError:Function = null):void
		{
			var request:ResourceRequest = Manager.pool.pop(ResourceRequest) as ResourceRequest;
			request.reset();
			request.setID(nextRequestID++);
			request.setCompleteCallback(onComplete);
			request.setProgressCallback(onProgress);
			for(var i:int = 0; i < urls.length; ++i)
			{
				var url:String = urls[i];
				var resourceType:ResourceType = getResourceType(url);
				
				if(cache[url] == undefined)
				{
					var loader:LoaderBase = null;
					for(var j:int = 0; j < loaders.length; ++j)
					{
						loader = loaders[j];
						if(loader.getURL() == url) break;
						else loader = null;
					}
					
					if(loader == null)
					{
						if(resourceType != null)
						{
							loader = Manager.pool.pop(resourceType.loaderClass) as LoaderBase;
							loader.reset();
							loader.setURL(url);
							loader.addEventListener(LoaderBase.LOADER_BASE_COMPLETE, loader_onComplete);
							loader.addEventListener(LoaderBase.LOADER_BASE_ERROR, loader_onError);
							loader.addEventListener(LoaderBase.LOADER_BASE_READY, loader_onReady);
							loader.addEventListener(LoaderBase.LOADER_BASE_PROGRESS, loader_onProgress);
							loader.setID(nextLoaderID++);
							loaders.push(loader);
						}
						else
						{
							Utility.error("ERROR> unsupported URL file extension: " + url);
						}
					}
					if(loader != null)
					{
						request.addLoader(loader);
						loader.addRequest(request);
					}
				}
			}
			if(request.getLoaders().length > 0)
			{
				requests.push(request);
				request.start();
			}
			else
			{
				Manager.pool.push(request, ResourceRequest);
				if(onComplete!=null)
					onComplete();
			}
		}
		
		public function unload(urls:Array):void
		{
			if(urls == null || urls.length == 0) return;
			for(var i:int = 0; i < urls.length; ++i)
			{
				var url:String = urls[i];
				if(cache[url] != undefined)
				{
					var resourceType:ResourceType = getResourceType(url);
					switch(resourceType)
					{
						case ResourceType.SWF:
							var loader:Loader = cache[url];
							loader.unloadAndStop();
							Manager.pool.push(loader, Loader);
							break;
						case ResourceType.ANIM:
							
							break;
						case ResourceType.IMAGE:
							var bitmapData:BitmapData = cache[url];
							bitmapData.dispose();
							bitmapData = null;
							break;
						case ResourceType.XML:
							cache[url] = null;
							break;
						case ResourceType.TXT:
							cache[url] = null;
							break;
					}
				}
			}
		}
		
		protected function loader_onProgress(event:EventEx):void
		{
			var loader:LoaderBase = event.target as LoaderBase;
			var thisRequests:Array = loader.getRequests();
			for each(var request:ResourceRequest in thisRequests)
			{
				request.addBytesLoaded(int(event.data));
				var callback:Function = request.getProgressCallback();
				if(callback != null) callback(request.getProgress());
			}
		}
		
		protected function loader_onReady(event:Event):void
		{
			var loader:LoaderBase = event.target as LoaderBase;
			var thisRequests:Array = loader.getRequests();
			for each(var request:ResourceRequest in thisRequests)
			{
				request.addBytesTotal(loader.getBytesTotal());
				//if(request.isReady()) request.start();
			}
		}
		
		protected function loader_onError(event:Event):void
		{
			var loader:LoaderBase = event.target as LoaderBase;
			var thisRequests:Array = loader.getRequests();
			for each(var request:ResourceRequest in thisRequests)
			{
				request.removeLoader(loader);
				if(request.isReady())
				{
					if(request.getLoaders().length > 0)
					{
						request.start();
					}
					else
					{
						var callback:Function = request.getCompleteCallback();
						if(callback != null) callback();
						removeRequest(request);
					}
				}
			}
			thisRequests.splice(0);
			removeLoader(loader);
		}
		
		protected function loader_onComplete(event:Event):void
		{
			var loader:LoaderBase = event.target as LoaderBase;			
			cache[loader.getURL()] = loader.getResource();
			var thisRequests:Array = loader.getRequests();
			for each(var request:ResourceRequest in thisRequests)
			{
				request.removeLoader(loader);
				if(request.getLoaders().length == 0)
				{
					request.stop();
					var callback:Function = request.getCompleteCallback();
					if(callback != null) callback();
					removeRequest(request);
				}
			}
			thisRequests.splice(0);
			removeLoader(loader);
		}
		
		private function removeLoader(loader:LoaderBase):void
		{
			loader.removeEventListener(LoaderBase.LOADER_BASE_COMPLETE, loader_onComplete);
			loader.removeEventListener(LoaderBase.LOADER_BASE_ERROR, loader_onError);
			loader.removeEventListener(LoaderBase.LOADER_BASE_READY, loader_onReady);
			loader.removeEventListener(LoaderBase.LOADER_BASE_PROGRESS, loader_onProgress);
			var index:int = loaders.indexOf(loader);
			if (index > -1) {
				loaders.splice(index, 1);
				//Utility.log( "ResourceManager.removeLoader : " + loader.getURL() + " // " + loaders.length);
			}
			Manager.pool.push(loader);
		}
		
		private function removeRequest(request:ResourceRequest):void
		{
			var index:int = requests.indexOf(request);
			if(index > -1) requests.splice(index, 1);
			Manager.pool.push(request, ResourceRequest);
		}
		
		public function addResource(url:String, resource:*):void
		{
			cache[url] = resource;
		}
		
		public function getResourceType(url:String):ResourceType
		{
			var urlExt:String = url.substring(url.lastIndexOf(".") + 1).toLowerCase();
			var resourceTypes:Array = Enum.getAll(ResourceType);
			var resourceType:ResourceType = null;
			for each(var e:ResourceType in resourceTypes)
			{
				if(e.urlExts.indexOf(urlExt) != -1)
				{
					resourceType = e;
					break;
				}
			}
			return resourceType;
		}
		
		public function getRootURL():String { return rootURL; }
		public function getLongURL(url:String):String 
		{ 
			//return url;
			return rootURL + url + "?version=" + version; 
		}
		
		public function getResourceByURL(url:String):*
		{
			return cache[url];
		}		
	}
}