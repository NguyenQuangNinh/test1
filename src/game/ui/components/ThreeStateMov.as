package game.ui.components 
{
	import flash.display.MovieClip;
	/**
	 * ...
	 * @author anhtinh
	 */
	public class ThreeStateMov extends MovieClip
	{
		public static const INACTIVE_STATE : String = "inactive";
		public static const ACTIVE_STATE : String = "active";
		public static const COMPLETE_STATE : String = "complete";
		
		private var _state : String = "";
		
		public function ThreeStateMov() 
		{
			state = INACTIVE_STATE;
		}
		
		public function get state():String 
		{
			return _state;
		}
		
		public function set state(value:String):void 
		{
			_state = value;
			
			switch (_state) 
			{
				case INACTIVE_STATE:
				case ACTIVE_STATE:
				case COMPLETE_STATE:
					this.gotoAndStop(_state);
					break;
				default:
					_state = INACTIVE_STATE;
					this.gotoAndStop(_state);
			}
			
			
		}
		
	}

}