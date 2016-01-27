package game.ui.tooltip 
{
	import core.Manager;
	
	import flash.display.MovieClip;
	
	import game.Game;
	
	/**
	 * ...
	 * @author MaiPTT
	 */
	public class TooltipBase extends MovieClip 
	{
		
		public function TooltipBase() {
			mouseEnabled = false;
			mouseChildren = false;
		}
		
		override public function set visible(value:Boolean):void {
			super.visible = value;
			if (value && stage) {
				x = Manager.display.getMouseX() + 30;
				y = Manager.display.getMouseY() + 10;
			}
		}
		
		override public function set y(value:Number):void {
			if (value <= 0) {
				value = 30;
			} 
			
			if (value + height > Game.HEIGHT) {
				value = Game.HEIGHT - height - 30;
			}
			super.y = value;
		}
		
		override public function set x(value:Number):void {
			if (value < 0) {
				value = 30;
			} 
			
			if (value + width > Game.WIDTH) {
				value = Manager.display.getMouseX() - width - 30;
			}
			
			super.x = value;
		}
	}

}