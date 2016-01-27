package game.ui.character_info 
{
	import core.event.EventEx;
	import core.util.FontUtil;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import game.data.model.shop.ShopItem;
	import game.enum.Font;
	import game.ui.shop.ShopEvent;
	
	/**
	 * ...
	 * @author MaiPTT
	 */
	public class ShopHeroInfo extends MovieClip 
	{
		public var txtDescription		:TextField;
		public var movLocked			:MovieClip;
		public var movUnlocked			:MovieClip;
		public var movBuy				:MovieClip;
		
		private var _model				:ShopItem;
		
		public function ShopHeroInfo() {
			btnsVisible = false;
			
			FontUtil.setFont(txtDescription, Font.ARIAL);
			FontUtil.setFont(txtPriceBuyMov, Font.ARIAL);
			FontUtil.setFont(txtPriceUnlockedMov, Font.ARIAL);
			
			btnBuy.addEventListener(MouseEvent.CLICK, onBtnClickHdl);
		}
		
		private function onBtnClickHdl(e:MouseEvent):void {
			switch(e.target) {
				case btnBuy:
					if (_model && _model.shopXML) {
						dispatchEvent(new EventEx(ShopEvent.SHOP_EVENT, { type:ShopEvent.SHOP_HEROES_BUY, shopID:_model.shopXML.ID,
																	shopItemID:_model.shopXML.itemID, quantity:_model.shopXML.maxBuyNum}, true ));	
					}
					break;
			}
		}
		
		public function set model(value:ShopItem):void {
			_model = value;
			if (_model && _model.shopXML) {
				btnsVisible = false;
				switch(_model.status) {
					case ShopItem.ALREADY_BOUGHT:
						movUnlocked.visible = true;
						txtPriceUnlockedMov.text = _model.shopXML.price.toString();
						break;
						
					case ShopItem.BUYABLE:
						movBuy.visible = true;
						txtPriceBuyMov.text = _model.shopXML.price.toString();
						break;
						
					case ShopItem.LOCKED:
						movLocked.visible = true;
						break;
				}
				
			}
		}
		
		private function set btnsVisible(value:Boolean):void {
			movLocked.visible = value;
			movUnlocked.visible = value;
			movBuy.visible = value;
		}
		
		private function get txtPriceUnlockedMov():TextField {
			return movUnlocked.txtPrice;
		}
		
		private function get btnBuy():SimpleButton {
			return movBuy.btnBuy;
		}
		
		private function get txtPriceBuyMov():TextField {
			return movBuy.txtPrice;
		}
	}

}