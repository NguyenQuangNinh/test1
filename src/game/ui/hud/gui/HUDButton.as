package game.ui.hud.gui 
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	
	import core.util.MovieClipUtils;
	
	import game.ui.hud.HUDButtonID;

	/**
	 * ...
	 * @author anhtinh
	 */
	public class HUDButton extends MovieClip
	{
		
		private static const YELLOW_GLOW : GlowFilter =  new GlowFilter(0xFFFF00, 1, 10, 10, 3);	
		
		private var _isSelected : Boolean;
		public var _nPositionIndex:int = 0;
		public var bgMov:MovieClip;
		//public var myTween:TweenMax;
		
		protected var ID:HUDButtonID;
		public function getID():HUDButtonID { return ID; }
		
		protected var _focusable:Boolean = false;
		
		public function HUDButton() 
		{
			
			this.buttonMode = true;
			isSelected = false;
			this.addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			this.addEventListener(MouseEvent.ROLL_OUT, onRollOut);
			gotoAndStop("unselected");
		}
		
		private function onRollOver(e:MouseEvent):void 
		{
			this.filters = [YELLOW_GLOW];
		}
		
		private function onRollOut(e:MouseEvent):void 
		{
			this.filters = null;
		}
		
		public function get isSelected():Boolean 
		{
			return _isSelected;
		}
		
		public function set isSelected(value:Boolean):void 
		{
			_isSelected = value;
			/*if (_isSelected) this.gotoAndStop("selected");
			else this.gotoAndStop("unselected");*/
			if (bgMov) {
				MovieClipUtils.starHueAdjust(bgMov, _isSelected ? 128 : 0);
			}else {
				gotoAndStop(_isSelected ? "selected" : "unselected");				
			}
		}
		
		public function setNotify(val:Boolean, jsonData:Object):void
		{
			
		}
		
		public function checkVisible():void
		{
			this.visible = true;//default = true
		}
		
		protected function get focusable():Boolean {
			return _focusable;
		}
		
		protected function set focusable(able:Boolean):void {
			_focusable = able;
		}
	}

}