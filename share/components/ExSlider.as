package components 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author Vu Anh
	 */
	public class ExSlider extends EventDispatcher
	{
		public var minimum:int;
		public var maximum:int;
		private var _value:int;
		public var enable:Boolean = true;
		public var slideBar:MovieClip;
		public var slideFace:MovieClip;
		public function ExSlider() 
		{				
		}
		public function init( pSlideFace:MovieClip, pSlideBar:MovieClip, pMin:int = 0, pMax:int = 100 ) {
			minimum = pMin;
			maximum = pMax;
			slideBar = pSlideBar;
			slideFace = pSlideFace;
			slideFace.buttonMode = true;
			slideFace.addEventListener(MouseEvent.MOUSE_DOWN, slideBarMouseDownHdl);
			slideFace.stage.addEventListener(MouseEvent.MOUSE_UP, stageMouseUpHdl);
			slideFace.stage.addEventListener(MouseEvent.MOUSE_MOVE, stageMouseMoveHdl);
			_value = minimum + (slideFace.x - slideBar.x) / slideBar.width * (maximum - minimum);
		}
		
		private function stageMouseMoveHdl(e:MouseEvent):void 
		{
			var newVal:int = minimum + (slideFace.x - slideBar.x) / slideBar.width * (maximum - minimum);
			if (newVal != _value) {
				_value = newVal;
				dispatchEvent(new Event(Event.CHANGE));
			}
		}
		
		private function stageMouseUpHdl(e:MouseEvent):void 
		{
			slideFace.stopDrag();
		}
		
		private function slideBarMouseDownHdl(e:MouseEvent):void 
		{
			if (!enable) return;
			slideFace.startDrag(false, new Rectangle(slideBar.x, slideBar.y, slideBar.width, 0));
		}
		
		public function get value():int { return _value; }
		
		public function set value(value:int):void 
		{
			_value = value;
		}
	}
	
}