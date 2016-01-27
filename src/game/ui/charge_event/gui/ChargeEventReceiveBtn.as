package game.ui.charge_event.gui
{
	import flash.display.MovieClip;
	
	/**
	 * ...
	 * @author chuongth2
	 */
	public class ChargeEventReceiveBtn extends MovieClip
	{
		public static const RECEIVE:String = "receive";
		public static const LOCK:String = "lock";
		public static const RECEIVED:String = "received";
		
		
		public function ChargeEventReceiveBtn()
		{
			this.setStatus(LOCK);
			this.buttonMode = true;
		}
		
		public function setStatus(status:String):void
		{
			switch (status)
			{
				case LOCK: 
				case RECEIVED:
					this.buttonMode = false;
				case RECEIVE: 
					this.gotoAndStop(status);
					break;
				default: 
					this.gotoAndStop(LOCK);
			}
		}
	}
}