package game.ui.hud.gui 
{
	import core.display.animation.Animator;

	import flash.display.MovieClip;

	import game.Game;
	import game.ui.hud.HUDButtonID;
	/**
	 * ...
	 * @author chuongth2
	 */
	public class ShopDiscountButton extends HUDButton
	{
		public var notify:MovieClip;

		public function ShopDiscountButton()
		{
			ID = HUDButtonID.SHOP_DISCOUNT;
		}

		override public function checkVisible():void
		{
			//this.visible = false;
			this.visible = Game.database.userdata.enableShopDiscount;
		}

		override public function setNotify(val:Boolean, jsonData:Object):void
		{
			super.setNotify(val, jsonData);
			notify.visible = val;
		}
	}

}