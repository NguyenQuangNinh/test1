package game.ui.shop.shop_secret_merchant 
{
	import core.util.FontUtil;
	import core.util.Utility;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import game.data.model.item.IItemConfig;
	import game.data.model.item.ItemFactory;
	import game.data.xml.ShopXML;
	import game.enum.Font;
	import game.enum.PaymentType;
	import game.Game;
	import game.net.lobby.LobbyRequestType;
	import game.net.lobby.request.RequestBuyItem;
	import game.ui.components.ItemSlot;
	import game.ui.tooltip.TooltipID;
	import game.utility.UtilityUI;
	
	/**
	 * ...
	 * @author MaiPTT
	 */
	public class ShopItem extends MovieClip 
	{
		public var movPaymentType	:MovieClip;
		public var movItem			:MovieClip;
		public var movSoldOut		:MovieClip;
		public var btnBuy			:SimpleButton;
		public var txtName			:TextField;
		public var txtPrice			:TextField;
		public var txtQuantity		:TextField;
		private var itemSlot		:ItemSlot;
		private var item			:ShopXML;
		
		public function ShopItem() {
			initUI();
		}
		
		public function setData(value:ShopXML):void {
			item = value;
			if (item) {
				var itemConfig:IItemConfig = ItemFactory.buildItemConfig(item.type, item.itemID) as IItemConfig;
				itemSlot.setConfigInfo(itemConfig, TooltipID.ITEM_COMMON, false);
				itemSlot.setQuantity(value.stackOneBuy);
				txtName.text = itemConfig.getName();
				txtPrice.text = item.price.toString();
				setPaymentType(item.paymentType.ID);
			}
		}
		
		public function setQuantity(value:int):void {
			var isSoldOut:Boolean = false;
			value > 0 ? isSoldOut = false : isSoldOut = true;
			value >= 0 ? txtQuantity.text = value.toString() : txtQuantity.text = "0";
			isSoldOut == false ? txtQuantity.textColor = 0xffff99 : txtQuantity.textColor = 0xff0000;
			movSoldOut.visible = isSoldOut;
			UtilityUI.enableDisplayObj(!isSoldOut, btnBuy, MouseEvent.CLICK, onBtnClickHdl);
		}
		
		public function reset():void {
			itemSlot.reset();
			movSoldOut.visible = false;
		}
		
		private function initUI():void {
			FontUtil.setFont(txtName, Font.ARIAL);
			FontUtil.setFont(txtPrice, Font.ARIAL);
			FontUtil.setFont(txtQuantity, Font.ARIAL, true);
			itemSlot = new ItemSlot();
			movItem.addChild(itemSlot);
			movSoldOut.visible = false;
			movSoldOut.mouseChildren = false;
			movSoldOut.mouseEnabled = false;
		}
		
		private function setPaymentType(value:int):void {
			switch(value) {
				case PaymentType.GOLD.ID:
					movPaymentType.gotoAndStop(1);
					break;
					
				case PaymentType.XU_NORMAL.ID:
					movPaymentType.gotoAndStop(2);
					break;
					
				case PaymentType.HONOR.ID:
					movPaymentType.gotoAndStop(3);
					break;
			}
		}
		
		private function onBtnClickHdl(e:MouseEvent):void {
			if (item) {
				var buyable:Boolean = false;
				switch(item.paymentType) {
					case PaymentType.XU_NORMAL:
						Game.database.userdata.xu >= item.price ? buyable = true : buyable = false;
						break;
						
					case PaymentType.GOLD:
						Game.database.userdata.getGold() >= item.price ? buyable = true : buyable = false;
						break;
						
					case PaymentType.HONOR:
						Game.database.userdata.honor >= item.price ? buyable = true : buyable = false;
						break;
						
					default:
						Utility.log("Shop Secret Merchant buy item with not defined payment type >> id: " + item.ID);
						break;
				}
				
				if (buyable) {
					Game.network.lobby.sendPacket(new RequestBuyItem(LobbyRequestType.SHOP_BUY_SINGLE_ITEM,
																	item.ID,
																	1));	
				}
			}
		}
	}

}