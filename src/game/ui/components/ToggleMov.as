package game.ui.components 
{
	import flash.display.MovieClip;
	/**
	 * ...
	 * @author anhtinh
	 */
	public class ToggleMov extends MovieClip
	{
		protected var _isActive : Boolean;
		
		public function ToggleMov() 
		{
			isActive = false;
		}
		
		public function get isActive():Boolean 
		{
			return _isActive;
		}
		
		public function set isActive(value:Boolean):void 
		{
			_isActive = value;
			if (_isActive) this.gotoAndStop("active");
			else this.gotoAndStop("inactive");
		}
		
	}

}