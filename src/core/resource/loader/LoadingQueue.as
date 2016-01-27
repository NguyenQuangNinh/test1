package core.resource.loader 
{
	import core.Manager;
	import core.util.Utility;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	/**
	 * ...
	 * @author ...
	 */
	public class LoadingQueue 
	{
		public static var queue:Array = new Array();
		public static var numOfConnection:int = 0;
				
		public static function load(loader:URLLoader, url:String):void {
			//Utility.log(" load: " + url + ",queue length: " + queue.length + ",numOfConnection: " + numOfConnection);
			
			if (numOfConnection < LoaderBase.MAX_CONNECTION) {
				startLoad(loader, url);
			} else {
				//Utility.log(" push: " + url + ",queue length: " + queue.length + ",numOfConnection: " + numOfConnection);
				queue.push({l:loader, u:url});
			}
		}
		
		static private function onFinished(e:Event):void 
		{
			var loader:URLLoader = e.target as URLLoader;
			loader.removeEventListener(Event.COMPLETE, onFinished);
			loader.removeEventListener(IOErrorEvent.IO_ERROR, onLoadError);
			numOfConnection--;
			
			//Utility.log("      onFinished: " + " ,queue length: " + queue.length + ",numOfConnection: " + numOfConnection);
			
			var data:Object = queue.shift();
			if(data) {
				startLoad(data.l as URLLoader, data.u as String);
			}
		}
		
		static private function onLoadError(e:Event):void 
		{
			onFinished(e);
		}
		
		static private function startLoad(loader:URLLoader = null, url:String = ""):void {
			if (loader && url != "") {
				//Utility.log("      startLoad: " + url + ",queue length: " + queue.length + ",numOfConnection: " + numOfConnection);
				loader.addEventListener(Event.COMPLETE, onFinished);
				loader.addEventListener(IOErrorEvent.IO_ERROR, onLoadError);
				loader.load(new URLRequest(Manager.resource.getLongURL(url)));
				numOfConnection++;
			}
		}
	}

}