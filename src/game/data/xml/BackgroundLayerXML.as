package game.data.xml
{
	import core.util.Enum;
	
	import game.ui.ingame.BackgroundLayerDock;

	public class BackgroundLayerXML extends XMLData
	{
		public var url:String;
		public var offsetY:int;
		public var speed:int;
		public var topLayer:Boolean;
		public var useAlphaMask:Boolean;
		public var dock:BackgroundLayerDock;
		
		override public function parseXML(xml:XML):void
		{
			super.parseXML(xml);
			
			url 		= xml.URL.toString();
			offsetY 	= xml.OffsetY.toString();
			speed 		= xml.ScrollSpeed.toString();
			topLayer 	= (xml.TopLayer.toString() == "true");
			useAlphaMask = (xml.UseAlphaMask.toString() == "true");
			dock = Enum.getEnum(BackgroundLayerDock, xml.Dock.toString()) as BackgroundLayerDock;
		}
	}
}