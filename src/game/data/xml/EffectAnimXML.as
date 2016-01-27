package game.data.xml 
{
	import core.util.Utility;
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class EffectAnimXML extends XMLData
	{
		public var animURL:String = "";
		public var layers:Array = [];
		public var delays:Array = [];
		public var loops:Array = [];
		public var name:String = "";
		
		public function EffectAnimXML() 
		{
			
		}
		
		override public function parseXML(xml:XML):void 
		{
			super.parseXML(xml);
			animURL = xml.AnimURL.toString();
			layers = xml.Layers.toString().split(",");
			Utility.convertToIntArray(layers);
			delays = xml.Delays.toString().split(",");
			for (var i:int = 0; i < delays.length; ++i)
			{
				var delay:Number = delays[i];
				if (delay > 0) delay = delay / 1000;
				delays[i] = delay;
			}
			loops = xml.Loops.toString().split(",");
			Utility.convertToIntArray(loops);
			name = xml.Name.toString();			
			//getString(1);
		}
	}

}