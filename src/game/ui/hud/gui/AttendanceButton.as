package game.ui.hud.gui 
{
	import core.display.animation.Animator;
	import game.Game;
	import game.ui.hud.HUDButtonID;
	/**
	 * ...
	 * @author anhpnh2
	 */
	public class AttendanceButton extends HUDButton
	{
		private var anim:Animator;
		
		public function AttendanceButton() 
		{
			ID = HUDButtonID.ATTENDANCE;
			
			anim = new Animator();
			anim.setCacheEnabled(true);
			anim.load("resource/anim/ui/fx_button.banim");
			anim.mouseEnabled = false;
			anim.mouseChildren = false;
			anim.x = 20;
			anim.y = 40;
			anim.play();
			this.addChild(anim);
		}
		
		override public function checkVisible():void
		{
			this.visible = Game.database.userdata.nAttendanceState == 1;
			anim.visible = !Game.database.userdata.attendanceChecked;
		}
	}

}