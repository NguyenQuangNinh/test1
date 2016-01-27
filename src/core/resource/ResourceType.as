package core.resource 
{
	import core.resource.loader.LoaderFont;
	import core.resource.loader.LoaderImage;
	import core.resource.loader.LoaderPixma;
	import core.resource.loader.LoaderSWF;
	import core.resource.loader.LoaderTXT;
	import core.resource.loader.LoaderXML;
	import core.resource.loader.LoaderZIP;
	import core.util.Enum;

	/**
	 * ...
	 * @author bangnd2
	 */
	public class ResourceType extends Enum
	{
		static public const XML		:ResourceType = new ResourceType(1, ["xml"]				, LoaderXML);
		static public const IMAGE	:ResourceType = new ResourceType(2, ["png","jpg","bmp"]	, LoaderImage);
		static public const SWF		:ResourceType = new ResourceType(3, ["swf"]				, LoaderSWF);
		static public const ANIM	:ResourceType = new ResourceType(4, ["banim"]			, LoaderPixma);
		static public const FONT	:ResourceType = new ResourceType(5, ["font"]			, LoaderFont);
		static public const TXT		:ResourceType = new ResourceType(6, ["txt"]				, LoaderTXT);
		static public const ZIP		:ResourceType = new ResourceType(7, ["dat"]				, LoaderZIP);
		
		public var urlExts:Array;
		public var loaderClass:Class;
		
		public function ResourceType(ID:int, urlExts:Array, loaderClass:Class):void
		{
			super(ID);
			this.urlExts = urlExts;
			this.loaderClass = loaderClass;
		}
	}
}