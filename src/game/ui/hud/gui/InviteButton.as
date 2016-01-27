package game.ui.hud.gui 
{
	import core.sound.SoundManager;
	import core.util.MovieClipUtils;
	import core.util.Utility;
	import flash.events.Event;
	import flash.events.MouseEvent;

	import game.Game;
	import game.ui.hud.HUDButtonID;
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class InviteButton extends HUDButton
	{
		private var _enable:Boolean = true;
		
		public static const INVITE_TOOGLE:String = "invite_toogle";
		
		public function InviteButton()
		{
			ID = HUDButtonID.INVITE;
			_enable = Game.database.gamedata.enableReceiveInvitation;
			isSelected = _enable;
			addEventListener(MouseEvent.CLICK, onClickHdl);
		}
		
		private function onClickHdl(e:MouseEvent = null):void 
		{
			onToggle();
		}			
		
		public function onToggle():void
		{
			_enable = !_enable;
			isSelected = _enable;
			
			if (bgMov) {
				MovieClipUtils.starHueAdjust(bgMov, _enable ? 128 : 0);
			}else {
				gotoAndStop(_enable ? "selected" : "unselected");				
			}
			Utility.log("invite button toogle enable: " + _enable);
			dispatchEvent(new Event(INVITE_TOOGLE, true));
		}
	}

}