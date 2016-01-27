package core.resource.loader 
{
	import core.util.Utility;
	
	

	/**
	 * ...
	 * @author bangnd2
	 */
	public class LoaderXML extends LoaderBase 
	{	
		override public function processData(data:*):void
		{
			try
			{
				resource = XML(data);
			}
			catch(error:Error)
			{
				Utility.log("ERROR > invalid XML file: " + getURL());
			}
			complete();
		}
	}

}