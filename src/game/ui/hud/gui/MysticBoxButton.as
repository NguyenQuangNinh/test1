package game.ui.hud.gui 
{
	import core.display.animation.Animator;
	import game.Game;
	import game.ui.hud.HUDButtonID;
	/**
	 * ...
	 * @author chuongth2
	 */
	public class MysticBoxButton extends HUDButton
	{
		private var anim:Animator;
		
		public function MysticBoxButton()
		{
			ID = HUDButtonID.MYSTIC_BOX;
			anim = new Animator();
			anim.setCacheEnabled(true);
			anim.scaleX = anim.scaleY = 0.8;
			anim.load("resource/anim/ui/fx_button.banim");
			anim.mouseEnabled = false;
			anim.mouseChildren = false;
			anim.x = 25;
			anim.y = 30;
			anim.play();
			this.addChild(anim);
		}

		override public function checkVisible():void
		{
			this.visible = Game.database.userdata.enableMysticBox;
		}
	}

}