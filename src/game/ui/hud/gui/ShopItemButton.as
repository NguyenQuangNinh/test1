package game.ui.hud.gui 
{
	import core.util.FontUtil;
	import flash.display.MovieClip;
	import game.ui.hud.HUDButtonID;
	import game.enum.Font;
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class ShopItemButton extends HUDButton
	{
		public var discountMov:MovieClip;
		public function ShopItemButton() 
		{
			discountMov.visible = false;
			ID = HUDButtonID.SHOP_ITEM;
			FontUtil.setFont(discountMov.tf, Font.ARIAL, true);
		}
		
	}

}