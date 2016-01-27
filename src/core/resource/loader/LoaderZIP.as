package core.resource.loader
{
	import flash.events.Event;
	import flash.utils.ByteArray;
	
	import core.Manager;
	import core.resource.ResourceType;
	
	import deng.fzip.FZip;
	import deng.fzip.FZipFile;
	
	import game.data.xml.GameData;

	public class LoaderZIP extends LoaderBase
	{
		private var loaders:Array = [];
		private var completeCount:int = 0;
		
		override public function processData(data:*):void
		{
			var byteArray:ByteArray = data as ByteArray;
			byteArray.position = 0;
			byteArray.writeInt(0x504b0304);
			var zip:FZip = new FZip();
			zip.addEventListener(Event.COMPLETE, zip_onComplete);
			zip.loadBytes(byteArray);
		}
		
		protected function zip_onComplete(event:Event):void
		{
			var zip:FZip = event.target as FZip;
			loaders.splice(0);
			for(var i:int = 0, size:int = zip.getFileCount(); i < size; ++i)
			{
				var file:FZipFile = zip.getFileAt(i);
				var resourceType:ResourceType = Manager.resource.getResourceType(file.filename);
				if(resourceType != null)
				{
					var loader:LoaderBase = new resourceType.loaderClass();
					loader.addEventListener(LoaderBase.LOADER_BASE_COMPLETE, loader_onComplete);
					loader.setURL(file.filename);
					loaders.push(loader);
				}
			}
			completeCount = 0;
			for each(loader in loaders)
			{
				loader.processData(zip.getFileByName(loader.getURL()).content);
			}
		}
		
		protected function loader_onComplete(event:Event):void
		{
			var loader:LoaderBase = event.target as LoaderBase;
			loader.removeEventListener(LoaderBase.LOADER_BASE_COMPLETE, loader_onComplete);
			Manager.resource.addResource(GameData.RESOURCE_URL + loader.getURL(), loader.getResource());
			if(++completeCount == loaders.length)
			{
				complete();
			}
		}
	}
}