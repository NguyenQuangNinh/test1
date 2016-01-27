package game.ui.mail.gui 
{
	import flash.display.MovieClip;
	/**
	 * ...
	 * @author chuongth2
	 */
	public class MailItemIcon extends MovieClip
	{
		public static const NEW:String = "new";
		public static const READED:String = "readed";
		
		public function MailItemIcon() 
		{
			this.gotoAndStop(NEW);
		}
		
		public function setStatus(label:String):void
		{
			this.gotoAndStop(label);
		}
	}

}