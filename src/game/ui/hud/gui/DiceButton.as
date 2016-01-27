package game.ui.hud.gui 
{
	import core.display.animation.Animator;
	import game.Game;
	import game.ui.hud.HUDButtonID;
	/**
	 * ...
	 * @author chuongth2
	 */
	public class DiceButton extends HUDButton
	{

		public function DiceButton()
		{
			ID = HUDButtonID.DICE;
		}

		override public function checkVisible():void
		{
//			this.visible = true;
			this.visible = Game.database.userdata.enableDice;
		}
	}

}