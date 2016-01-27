package game.ui.hud.gui 
{
	import game.ui.hud.HUDButtonID;

	/**
	 * ...
	 * @author dinhhq
	 */
	public class DivineWeaponButton extends HUDButton
	{
		public function DivineWeaponButton()
		{
			ID = HUDButtonID.DIVINE_WEAPON;
		}

        override public function checkVisible():void {
            this.visible = false;
        }
    }

}