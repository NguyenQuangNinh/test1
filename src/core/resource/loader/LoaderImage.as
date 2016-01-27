package core.resource.loader 
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.utils.ByteArray;
	
	import core.Manager;

	//import flash.utils.setTimeout;

	/**
	 * ...
	 * @author bangnd2
	 */
	public class LoaderImage extends LoaderBase 
	{
		override public function processData(data:*):void
		{
			var byteArray:ByteArray = data as ByteArray;
			var loader:Loader = Manager.pool.pop(Loader) as Loader;
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadBytesComplete);
			loader.loadBytes(byteArray);
		}
		
		private function onLoadBytesComplete(event:Event):void 
		{
			var loaderInfo:LoaderInfo = LoaderInfo(event.target);
			loaderInfo.removeEventListener(Event.COMPLETE, onLoadBytesComplete);
			Manager.pool.push(loaderInfo.loader, Loader);
			resource = Bitmap(loaderInfo.loader.content).bitmapData;
			complete();
		}
	}
}