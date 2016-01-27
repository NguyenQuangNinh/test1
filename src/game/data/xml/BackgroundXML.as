package game.data.xml
{
	import core.util.Utility;

	public class BackgroundXML extends XMLData
	{
		public var layerIDs:Array = [];
		
		override public function parseXML(xml:XML):void
		{
			super.parseXML(xml);
			layerIDs = Utility.parseToIntArray(xml.LayerIDs.toString());
		}
	}
}