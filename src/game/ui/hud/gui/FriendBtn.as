package game.ui.hud.gui 
{
	import flash.display.MovieClip;

	import game.ui.hud.HUDButtonID;

	/**
	 * ...
	 * @author chuongth2
	 */
	public class FriendBtn extends HUDButton
	{
		public var notify:MovieClip;

		public function FriendBtn() 
		{
			ID = HUDButtonID.FRIEND;
			notify.visible = false;
		}

		override public function setNotify(val:Boolean, jsonData:Object):void
		{
			super.setNotify(val, jsonData);
			notify.visible = val;
		}
	}

}