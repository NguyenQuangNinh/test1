package game.ui.hud.gui
{

	import game.Game;
	import game.ui.hud.HUDButtonID;

	/**
	 * ...
	 * @author chuongth2
	 */
	public class VIPPromotionButton extends HUDButton
	{

		public function VIPPromotionButton()
		{
			ID = HUDButtonID.VIP_PROMOTION;
		}

		override public function checkVisible():void
		{
//			this.visible = true;
			this.visible = Game.database.userdata.enableVIPPromotion;
		}
	}

}