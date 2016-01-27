package game.ui.ingame
{
	import flash.events.Event;
	
	import core.display.BitmapEx;
	
	import game.Game;
	import game.data.xml.BackgroundLayerXML;
	import game.data.xml.DataType;
	import game.enum.ObjectLayer;

	public class BackgroundLayer extends BaseObject
	{
		public static const LOADED	:String = "background_layer_loaded";
		public var loaded:Boolean;
		private var scrollDirection:int;
		private var bitmap:BitmapEx;
		private var xmlData:BackgroundLayerXML;
		private var scrolling:Boolean;
		
		public function BackgroundLayer():void
		{
			bitmap = new BitmapEx(Game.WIDTH, 0);
			addChild(bitmap);
			mouseEnabled = false;
			mouseChildren = false;
			loaded = false;
			reset();
		}
		
		public function setScrollDirection(direction:int):void
		{
			scrollDirection = direction;
		}
		
		override public function reset():void
		{
			super.reset();
			bitmap.scrollTo(0, 0);
		}
		
		public function destroy():void
		{
			reset();
			removeChild(bitmap);
			bitmap.destroy();
			bitmap = null;
		}
		
		public function setScrolling(value:Boolean):void
		{
			scrolling = value;
		}
		
		override public function update(delta:Number):void
		{
			if(xmlData != null && scrolling)
			{
				bitmap.scroll(scrollDirection * delta * xmlData.speed, 0);
			}
		}
		
		public function setXMLID(ID:int):void
		{
			xmlData = Game.database.gamedata.getData(DataType.BACKGROUND_LAYER, ID) as BackgroundLayerXML;
			if(xmlData != null)
			{
				bitmap.addEventListener(BitmapEx.LOADED, onBitmapLoadedHdl);
				bitmap.load(xmlData.url, xmlData.useAlphaMask);
				switch(xmlData.dock)
				{
					case BackgroundLayerDock.TOP:
						bitmap.y = 0;
						break;
					case BackgroundLayerDock.BOTTOM:
						bitmap.y = Game.HEIGHT - bitmap.height;
						break;
					case BackgroundLayerDock.NONE:
						bitmap.y = xmlData.offsetY;
						break;
				}
				
				if(xmlData.topLayer) layer = ObjectLayer.FOREGROUND;
				else layer = ObjectLayer.BACKGROUND;
			}
		}
		
		private function onBitmapLoadedHdl(e:Event):void {
			loaded = true;
			dispatchEvent(new Event(LOADED, true));
		}
	}
}