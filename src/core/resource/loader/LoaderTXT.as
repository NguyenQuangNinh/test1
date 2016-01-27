package core.resource.loader 
{
	import core.util.Utility;
	import flash.utils.ByteArray;
	
	

	/**
	 * ...
	 * @author anhpnh2
	 */
	public class LoaderTXT extends LoaderBase 
	{	
		override public function processData(data:*):void
		{
			try
			{
				var byteArr:ByteArray = data as ByteArray;
				var fileContents:String = byteArr.readUTFBytes(byteArr.bytesAvailable);
				resource = fileContents.split(/\r\n/);
			}
			catch(error:Error)
			{
				Utility.log("ERROR > invalid TXT file: " + getURL());
			}
			complete();
		}
	}

}