package game.ui.consume_event.gui
{
	import flash.display.MovieClip;
	
	/**
	 * ...
	 * @author chuongth2
	 */
	public class ConsumeEventReceiveBtn extends MovieClip
	{
		public static const RECEIVE:String = "receive";
		public static const RECEIVED:String = "received";
		public static const LOCK:String = "lock";
		
		
		public function ConsumeEventReceiveBtn()
		{
			this.setStatus(LOCK);
			this.buttonMode = true;
		}
		
		public function setStatus(status:String):void
		{
			switch (status)
			{
				case LOCK: 
					this.buttonMode = false;
					case RECEIVED:
				case RECEIVE: 		 
					this.gotoAndStop(status);
					break;
				default: 
					this.gotoAndStop(LOCK);
			}
		}
	}
}