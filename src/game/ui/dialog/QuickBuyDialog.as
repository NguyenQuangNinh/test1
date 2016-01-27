package game.ui.dialog
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import core.display.BitmapEx;
	import core.util.FontUtil;
	
	import game.data.model.item.ItemFactory;
	import game.data.vo.item.ItemInfo;
	import game.data.xml.item.ItemXML;
	import game.enum.Font;
	import game.ui.dialog.dialogs.Dialog;
	
	public class QuickBuyDialog extends Dialog
	{
		public var txtTitle:TextField;
		public var txtItemName:TextField;
		public var txtQuantity:TextField;
		public var containerItem:MovieClip;
		public var containerResourceItem:MovieClip;
		public var btnClose:SimpleButton;
		public var btnConfirm:SimpleButton;
		
		private var itemIcon:BitmapEx;
		private var resourceItemIcon:BitmapEx;
		
		public function QuickBuyDialog()
		{
			itemIcon = new BitmapEx();
			containerItem.addChild(itemIcon);
			
			resourceItemIcon = new BitmapEx();
			containerResourceItem.addChild(resourceItemIcon);
			
			FontUtil.setFont(txtTitle, Font.ARIAL);
			FontUtil.setFont(txtItemName, Font.ARIAL, true);
			FontUtil.setFont(txtQuantity, Font.ARIAL, true);
			
			btnClose.addEventListener(MouseEvent.CLICK, btnClose_onClicked);
			btnConfirm.addEventListener(MouseEvent.CLICK, btnConfirm_onClicked);
		}
		
		protected function btnClose_onClicked(event:MouseEvent):void
		{
			close();
		}
		
		protected function btnConfirm_onClicked(event:MouseEvent):void
		{
			onOK();
		}
		
		override public function onShow():void
		{
			if(data != null)
			{
				txtTitle.text = "Thông báo";
				var item:ItemInfo = data.item;
				var resourceItem:ItemInfo = data.resourceItem;
				if(item != null && resourceItem != null)
				{
					var xmlData:ItemXML = ItemFactory.buildItemConfig(item.type, item.id) as ItemXML;
					if(xmlData != null)
					{
						txtItemName.text = "Không đủ " + xmlData.name;
						itemIcon.load(xmlData.iconURL);
						
					}
					xmlData = ItemFactory.buildItemConfig(resourceItem.type, resourceItem.id) as ItemXML;
					if(xmlData != null)
					{
						resourceItemIcon.load(xmlData.iconURL);
						txtQuantity.text = resourceItem.quantity.toString();
					}
				}
			}
		}
	}
}