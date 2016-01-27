package game.ui.hud.gui 
{
	import flash.display.MovieClip;

	import game.ui.hud.HUDButtonID;

	/**
	 * ...
	 * @author chuongth2
	 */
	public class ActivityButton extends HUDButton
	{
		public var notify:MovieClip;

		public function ActivityButton() 
		{
			notify.visible = false;
			ID = HUDButtonID.ACTIVITY;
		}

		override public function setNotify(val:Boolean, jsonData:Object):void
		{
			super.setNotify(val, jsonData);
			notify.visible = val;
		}
	}

}