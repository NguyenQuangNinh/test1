package game.ui.hud.gui 
{
	import core.display.animation.Animator;
	import game.Game;
	import game.ui.hud.HUDButtonID;
	/**
	 * ...
	 * @author chuongth2
	 */
	public class ChargeEventButton extends HUDButton
	{
		private var anim:Animator;
		
		public function ChargeEventButton() 
		{
			ID = HUDButtonID.CHARGE_EVENT;
			
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
			this.visible = Game.database.userdata.nEventCurrentPaymentEventID != 0;
		}
	}

}