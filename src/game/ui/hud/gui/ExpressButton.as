/**
 * Created by NinhNQ on 12/24/2014.
 */
package game.ui.hud.gui
{

	import game.ui.hud.HUDButtonID;

	public class ExpressButton extends HUDButton
	{
		public function ExpressButton()
		{
			ID = HUDButtonID.EXPRESS;
		}


		override public function checkVisible():void
		{
			this.visible = false;
		}
	}
}
