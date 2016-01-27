package game.ui.home.gui 
{
	//import core.display.BitmapEx;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	/**
	 * ...
	 * @author anhtinh
	 */
	public class MiniMapUI extends Sprite
	{
		//fla properties
		public var mapNameTf : TextField;
		
		private var mapName : String;
		//private var miniMapBmp : BitmapEx;
		
		
		public function MiniMapUI() 
		{
			//miniMapBmp = new BitmapEx();
			//miniMapBmp.x = 0;
			//miniMapBmp.y = 0;
			//this.addChild(miniMapBmp);
			
			mapNameTf.text = "LONG HỔ MÔN";
		}
		
		public function setName(name : String) : void {
			
		}
		
		public function loadMap(url : String) : void {
			//miniMapBmp.addEventListener(BitmapEx.LOADED, onBitmapLoaded);
			//miniMapBmp.load(url);
			
		}
		
		private function onBitmapLoaded(e:Event):void 
		{
			
		}
	}

}