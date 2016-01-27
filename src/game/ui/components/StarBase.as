package game.ui.components 
{
	import flash.display.MovieClip;
	/**
	 * ...
	 * @author anhtinh
	 */
	public class StarBase extends MovieClip
	{
		private var _isActive : Boolean;
		
		public function StarBase() 
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