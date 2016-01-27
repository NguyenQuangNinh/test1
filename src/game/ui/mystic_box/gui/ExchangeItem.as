/**
 * Created by NinhNQ on 12/17/2014.
 */
package game.ui.mystic_box.gui
{

	import core.Manager;
	import core.event.EventEx;
	import core.util.FontUtil;

	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	import game.Game;

	import game.data.model.item.ItemFactory;

	import game.data.xml.item.ItemXML;

	import game.enum.Font;
	import game.enum.ItemType;

	public class ExchangeItem extends MovieClip
	{
		public static const EXCHANGE:String = "exchange_mystic_box_item_exchange_event";

		public var nameTf:TextField;
		public var quantityTf:TextField;
		public var exchangeBtn:SimpleButton;
		private var xml:ItemXML;
		private var requiredQuantityToNextLv:int = 0;

		public function ExchangeItem()
		{
			FontUtil.setFont(nameTf, Font.ARIAL, true);
			FontUtil.setFont(quantityTf, Font.ARIAL, true);

			quantityTf.text = "0";
			quantityTf.restrict = "0-9";
			quantityTf.addEventListener(Event.CHANGE, quantityTf_textInputHandler);
			quantityTf.addEventListener(FocusEvent.FOCUS_OUT, quantityTf_focusOutHandler);
			quantityTf.addEventListener(MouseEvent.CLICK, quantityTf_clickHandler);

			exchangeBtn.addEventListener(MouseEvent.CLICK, exchangeBtn_clickHandler);
		}

		public function setData(boxID:int, level:int):void
		{
			var texts:Array = Game.database.gamedata.getConfigData(255);
			xml = ItemFactory.buildItemConfig(ItemType.NORMAL_CHEST, boxID) as ItemXML;
			nameTf.text = texts[level];
			requiredQuantityToNextLv = Game.database.gamedata.getConfigData(246)[level];

			var boxIDs:Array = Game.database.gamedata.getConfigData(243);
			var itemID:int = boxIDs[level - 1];
			var numOfItems:int = Game.database.inventory.getItemQuantity(ItemType.NORMAL_CHEST, itemID);
			quantityTf.text = numOfItems.toString();
		}

		public function updateInput():void
		{
			var boxIDs:Array = Game.database.gamedata.getConfigData(243);
			var index:int = boxIDs.indexOf(xml.ID);
			if(index > 0)
			{
				var itemID:int = boxIDs[index - 1];
				var numOfItems:int = Game.database.inventory.getItemQuantity(ItemType.NORMAL_CHEST, itemID);
				quantityTf.text = numOfItems.toString();
			}
			else
			{
				quantityTf.text = "0";
			}
		}

		private function quantityTf_textInputHandler(event:Event = null):void
		{
			var boxIDs:Array = Game.database.gamedata.getConfigData(243);
			var index:int = boxIDs.indexOf(xml.ID);
			if(index > 0)
			{
				var itemID:int = boxIDs[index - 1];
				var numOfItems:int = Game.database.inventory.getItemQuantity(ItemType.NORMAL_CHEST, itemID);
				quantityTf.text = (parseInt(quantityTf.text) <= numOfItems) ? quantityTf.text : numOfItems.toString();
			}
			else
			{
				quantityTf.text = "0";
			}
		}

		private function quantityTf_focusOutHandler(event:FocusEvent):void
		{
			quantityTf.text = (quantityTf.text == "") ? "0" : quantityTf.text;
		}

		private function quantityTf_clickHandler(event:MouseEvent):void
		{
			quantityTf.setSelection(0, quantityTf.length);
		}

		private function exchangeBtn_clickHandler(event:MouseEvent):void
		{
			var quantity:int = parseInt(quantityTf.text);
			quantity = Math.floor(quantity / requiredQuantityToNextLv);
			if(quantity != 0)
			{
				dispatchEvent(new EventEx(EXCHANGE, {id:xml.ID, quantity: quantity}, true));
			}
			else
			{
				Manager.display.showMessageID(158);
			}
		}
	}
}
