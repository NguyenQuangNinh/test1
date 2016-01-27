package game.ui.components 
{
	import core.event.EventEx;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import game.ui.tooltip.TooltipEvent;
	import game.ui.tooltip.TooltipID;
	
	/**
	 * ...
	 * @author MaiPTT
	 */
	public class CharacterStar extends StarBase 
	{
		private var _id:int = -1;
		
		public function set enable(value:Boolean):void {
			if (value) {
				gotoAndStop("upClass");
				if (!hasEventListener(MouseEvent.ROLL_OVER)) {
					addEventListener(MouseEvent.ROLL_OVER, onMouseOverHdl);
				}
				if (!hasEventListener(MouseEvent.ROLL_OUT)) {
					addEventListener(MouseEvent.ROLL_OUT, onMouseOutHdl);
				}
			} else {
				if (hasEventListener(MouseEvent.ROLL_OVER)) {
					removeEventListener(MouseEvent.ROLL_OVER, onMouseOverHdl);
				}
				if (hasEventListener(MouseEvent.ROLL_OUT)) {
					removeEventListener(MouseEvent.ROLL_OUT, onMouseOutHdl);
				}
			}
		}
		
		public function setID(value:int):void {
			_id = value;
		}
		
		private function onMouseOutHdl(e:MouseEvent):void {
			dispatchEvent(new EventEx(TooltipEvent.HIDE_TOOLTIP, null, true));
		}
		
		private function onMouseOverHdl(e:MouseEvent):void {
			dispatchEvent(new EventEx(TooltipEvent.SHOW_TOOLTIP, { type:TooltipID.SIMPLE, value: ("Chuyển chức trách ở sao: " + (_id + 1)) }, true));
		}
	}
}