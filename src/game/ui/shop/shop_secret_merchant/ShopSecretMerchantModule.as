package game.ui.shop.shop_secret_merchant 
{
	import core.display.ModuleBase;
	
	/**
	 * ...
	 * @author MaiPTT
	 */
	public class ShopSecretMerchantModule extends ModuleBase 
	{
		
		public function ShopSecretMerchantModule() {
			
		}
		
		override protected function createView():void {
			super.createView();
			baseView = new ShopSecretMerchantView();
		}
	}

}