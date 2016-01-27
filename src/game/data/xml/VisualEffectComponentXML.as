package game.data.xml 
{
	/**
	 * ...
	 * @author bangnd2
	 */
	public class VisualEffectComponentXML extends XMLData 
	{
		public var animURL:String;
		public var indexes:Array;
		public var layers:Array;
		public var repeats:Array;
		public var offsetY:int;
		
		override public function parseXML(xml:XML):void 
		{
			super.parseXML(xml);
			animURL = xml.AnimURL.toString();
			indexes = xml.Indexes.toString().split(",");
			layers = xml.Layers.toString().split(",");
			repeats = xml.Repeats.toString().split(",");
			offsetY = xml.OffsetY.toString();
		}
	}

}