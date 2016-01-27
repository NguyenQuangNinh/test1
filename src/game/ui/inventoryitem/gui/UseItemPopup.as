/**
 * Created by NinhNQ on 12/19/2014.
 */
package game.ui.inventoryitem.gui
{

	import core.util.FontUtil;

	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	import game.Game;

	import game.data.model.item.Item;
	import game.data.xml.item.ItemXML;

	import game.enum.Font;
	import game.net.lobby.request.RequestUseItems;
	import game.utility.UtilityUI;

	public class UseItemPopup extends MovieClip
	{
		public var quantityTf:TextField;
		public var maxQuantityTf:TextField;
		public var okBtn:SimpleButton;
		private var closeBtn:SimpleButton;
		private var item:Item;
		private var maxQuantity:int;

		public function UseItemPopup()
		{
			FontUtil.setFont(quantityTf, Font.ARIAL, true);
			FontUtil.setFont(maxQuantityTf, Font.ARIAL, true);

			closeBtn = UtilityUI.getComponent(UtilityUI.CLOSE_BTN) as SimpleButton;

			if (closeBtn != null)
			{
				closeBtn.x = 241;
				closeBtn.y = -7;
				addChild(closeBtn);
				closeBtn.addEventListener(MouseEvent.CLICK, closeHandler);
			}

			okBtn.addEventListener(MouseEvent.CLICK, onOkHdl);

			quantityTf.text = "1";
			quantityTf.restrict = "0-9";
			quantityTf.addEventListener(Event.CHANGE, quantityTf_textInputHandler);
			quantityTf.addEventListener(FocusEvent.FOCUS_OUT, quantityTf_focusOutHandler);
			quantityTf.addEventListener(MouseEvent.CLICK, quantityTf_clickHandler);
		}

		private function quantityTf_textInputHandler(event:Event):void
		{
			quantityTf.text = (parseInt(quantityTf.text) <= maxQuantity) ? quantityTf.text : maxQuantity.toString();
		}

		private function quantityTf_focusOutHandler(event:FocusEvent):void
		{
			quantityTf.text = (quantityTf.text == "") ? "1" : quantityTf.text;
		}

		private function quantityTf_clickHandler(event:MouseEvent):void
		{
			quantityTf.setSelection(0, quantityTf.length);
		}

		public function show(item:Item, maxQuantity:int):void
		{
			this.item = item;
			this.maxQuantity = maxQuantity;
			quantityTf.text = "1";
			maxQuantityTf.text = "/ " + maxQuantity;

			this.visible = true;
		}


		public function hide():void
		{
			this.visible = false;
		}

		private function onOkHdl(event:MouseEvent):void
		{
			var quantity:int = parseInt(quantityTf.text);
			Game.network.lobby.sendPacket(new RequestUseItems(item.itemXML.type.ID,item.xmlData.ID, quantity));
			hide();
		}

		private function closeHandler(event:MouseEvent):void
		{
			hide();
		}
	}
}
