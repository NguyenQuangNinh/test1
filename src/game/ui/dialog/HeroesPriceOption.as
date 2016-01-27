package game.ui.dialog 
{
	import core.util.Enum;
	import core.util.FontUtil;
	import core.util.Utility;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import game.data.model.item.ItemFactory;
	import game.data.xml.ShopXML;
	import game.enum.Font;
	import game.enum.ItemType;
	import game.ui.components.CheckBox;
	import game.ui.components.ItemSlot;
	import game.ui.tooltip.TooltipID;
	
	/**
	 * ...
	 * @author MaiPTT
	 */
	public class HeroesPriceOption extends MovieClip 
	{
		public var checkbox		:CheckBox;
		public var txtExpired	:TextField;
		public var txtPrice		:TextField;
		public var movPrice		:MovieClip;
		private var itemSlot	:ItemSlot;
		private var ID			:int;
		
		public function HeroesPriceOption() {
			checkbox.setEnableToogle(false);
			checkbox.setBackgroundStype(CheckBox.BACKGROUND_STYLE_ROUND);
			FontUtil.setFont(txtExpired, Font.ARIAL, true);
			FontUtil.setFont(txtPrice, Font.ARIAL, true);
			itemSlot = new ItemSlot();
			movPrice.addChild(itemSlot);
		}
		
		public function setData(ID:int, expirationTime:int, itemType:ItemType, itemID:int, price:int):void {
			this.ID = ID;
			if (expirationTime > 0) {
				if (expirationTime < (999 * 24 * 60)) {
					txtExpired.text = Utility.math.formatTime("DD", expirationTime * 60);	
				} else {
					txtExpired.text = "Vĩnh Viễn";	
				}
			} else if (expirationTime == -1) {
				txtExpired.text = "Vĩnh Viễn";
			}
			
			itemSlot.setConfigInfo(ItemFactory.buildItemConfig(itemType, itemID), TooltipID.ITEM_COMMON);
			itemSlot.setQuantity(price, false);
			txtPrice.text = "x" + Utility.math.formatInteger(price);
		}
		
		public function getID():int {
			return ID;
		}
	}

}