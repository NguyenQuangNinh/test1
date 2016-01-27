package game.ui.dialog.dialogs 
{
	import core.util.Enum;
	import core.util.FontUtil;
	import flash.text.TextField;
	import game.data.model.item.ItemFactory;
	import game.enum.Font;
	import game.enum.ItemType;
	import game.ui.components.ItemSlot;
	
	/**
	 * ...
	 * @author MaiPTT
	 */
	public class GlobalBossYesNoDialog extends Dialog 
	{
		public var txtMessage		:TextField;
		public var txtPrice			:TextField;
		private var itemSlot		:ItemSlot;
		
		public function GlobalBossYesNoDialog() {
			FontUtil.setFont(txtPrice, Font.ARIAL);
			txtMessage.mouseEnabled = false;
			txtPrice.mouseEnabled = false;
		}
		
		override public function onShow():void {
			if (data) {
				txtMessage.htmlText = data.content;
				FontUtil.setFont(txtMessage, Font.ARIAL);
				
				if (itemSlot && itemSlot.parent) {
					itemSlot.parent.removeChild(itemSlot);
				}
				txtPrice.text = "";
				
				var paymentType:int = data.paymentType;
				if (data.txtPrice && paymentType) {
					txtPrice.y = txtMessage.y + txtMessage.textHeight + 20;
					var itemType:ItemType = Enum.getEnum(ItemType, paymentType) as ItemType;
					if (itemType) {
						txtPrice.text = data.txtPrice;
						if (!itemSlot) itemSlot = new ItemSlot();
						itemSlot.setConfigInfo(ItemFactory.buildItemConfig(itemType, -1), "", false);
						itemSlot.x = txtPrice.x + (txtPrice.width + txtPrice.textWidth) / 2 + 20;
						itemSlot.y = txtPrice.y - 20;
						addChild(itemSlot);
					} 
				}
				
			}
		}
	}

}