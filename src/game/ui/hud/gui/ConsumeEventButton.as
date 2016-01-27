package game.ui.hud.gui 
{
	import core.display.animation.Animator;
	import game.Game;
	import game.ui.hud.HUDButtonID;
	/**
	 * ...
	 * @author chuongth2
	 */
	public class ConsumeEventButton extends HUDButton
	{
		private var anim:Animator;
		
		public function ConsumeEventButton() 
		{
			ID = HUDButtonID.CONSUME_EVENT;
			
			anim = new Animator();
			anim.setCacheEnabled(true);
			anim.load("resource/anim/ui/fx_button.banim");
			anim.mouseEnabled = false;
			anim.mouseChildren = false;
			anim.x = 27;
			anim.y = 40;
			anim.play();
			this.addChild(anim);
		}
		
		override public function checkVisible():void
		{
			this.visible = Game.database.userdata.nEventCurrentConsumeEventID != 0;
		}
	}

}