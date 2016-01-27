package game.data.xml 
{
	/**
	 * ...
	 * @author bangnd2
	 */
	public class VisualEffectXML extends XMLData 
	{
		public var compositionIDs:Array;
		public var width:int;
		public var offsetY:int;
		
		override public function parseXML(xml:XML):void 
		{
			super.parseXML(xml);
			compositionIDs = xml.ComponentIDs.toString().split(",");
			width = xml.Width.toString();
			offsetY = xml.OffsetY.toString();
		}
	}

}