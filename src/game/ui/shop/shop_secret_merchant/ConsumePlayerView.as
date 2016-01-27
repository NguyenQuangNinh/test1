package game.ui.shop.shop_secret_merchant 
{
	import core.util.Enum;
	import core.util.FontUtil;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import game.data.model.item.IItemConfig;
	import game.data.model.item.ItemFactory;
	import game.data.xml.DataType;
	import game.data.xml.ShopXML;
	import game.enum.Font;
	import game.enum.PaymentType;
	import game.Game;
	
	/**
	 * ...
	 * @author MaiPTT
	 */
	public class ConsumePlayerView extends MovieClip 
	{
		public var txtDescription	:TextField;
		public var movBg			:MovieClip;
		private var data			:ConsumePlayer;
		
		public function ConsumePlayerView() {
			txtDescription.mouseWheelEnabled = false;
			txtDescription.autoSize = TextFieldAutoSize.LEFT;
		}
		
		public function setData(value:ConsumePlayer):void {
			data = value;
			if (data) {
				var shopXML:ShopXML = Game.database.gamedata.getData(DataType.SHOP, value.shopID) as ShopXML;
				if (shopXML) {
					var str:String = "";
					var itemConfig:IItemConfig = ItemFactory.buildItemConfig(shopXML.type, shopXML.itemID) as IItemConfig;
					if (itemConfig) {
						str = "["+ value.playerName + "] đã dùng " 
									+ (shopXML.price * value.quantity) + " " 
									+ (PaymentType)(Enum.getEnum(PaymentType, shopXML.paymentType.ID)).displayName
									+ " mua: <font color = '#00ff00'>" + itemConfig.getName() + "</font>";	
					}
					txtDescription.htmlText = str;
					FontUtil.setFont(txtDescription, Font.ARIAL);
					movBg.y = txtDescription.textHeight + 10;
				}
			}
		}
	}

}