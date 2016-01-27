package core.resource.loader 
{	
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	
	import core.Manager;

	/**
	 * ...
	 * @author bangnd2
	 */
	public class LoaderSWF extends LoaderBase 
	{
		
		override public function processData(data:*):void
		{
			var byteArray:ByteArray = data as ByteArray;
			var loader:Loader = Manager.pool.pop(Loader) as Loader;
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadBytesComplete);
			loader.loadBytes(byteArray, new LoaderContext(false, ApplicationDomain.currentDomain));
		}
		
		private function onLoadBytesComplete(event:Event):void 
		{
			var loaderInfo:LoaderInfo = LoaderInfo(event.target);
			loaderInfo.removeEventListener(Event.COMPLETE, onLoadBytesComplete);
			resource = loaderInfo.loader;
			complete();
		}
	}
}