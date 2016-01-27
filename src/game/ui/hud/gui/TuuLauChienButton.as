package game.ui.hud.gui 
{
	import core.event.EventEx;
	import core.util.Utility;
	import flash.display.MovieClip;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import game.Game;
	import game.ui.hud.HUDButtonID;

	/**
	 * ...
	 * @author anhtinh
	 */
	public class TuuLauChienButton extends HUDButton
	{
		public var notify:MovieClip;
		
		
		public function TuuLauChienButton() 
		{
			notify.visible = false;
			ID = HUDButtonID.TUULAUCHIEN;
		}

		override public function setNotify(val:Boolean, jsonData:Object):void
		{
			super.setNotify(val, jsonData);
			Utility.log("set tuu lau chien button enable notify " + val);
			notify.visible = val;
		}			
	}

}