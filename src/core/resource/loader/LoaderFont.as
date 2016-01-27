package core.resource.loader 
{
	import ru.etcs.utils.FontLoader;
	/**
	 * ...
	 * @author bangnd
	 */
	public class LoaderFont extends LoaderBase
	{
		override public function processData(data:*):void
		{
			var fontLoader:FontLoader = new FontLoader();
			fontLoader.loadBytes(data);
			complete();
		}
	}
}