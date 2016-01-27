/**
 * Created by NinhNQ on 9/24/2014.
 */
package game.ui.events.gui
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
	import flash.text.TextFieldAutoSize;

	import game.Game;

	import game.data.model.event.EventData;
	import game.data.model.event.ExchangeEventData;
	import game.data.model.event.Variable;
	import game.data.model.item.IItemConfig;
	import game.data.model.item.ItemFactory;
	import game.data.xml.event.ExchangeEventXML;
	import game.enum.Font;
	import game.enum.ItemType;
	import game.ui.components.ItemSlot;
	import game.ui.tooltip.TooltipID;
	import game.utility.TimerEx;

	public class EventEquationPanel extends MovieClip
	{
		public function EventEquationPanel()
		{
			FontUtil.setFont(nameTf1, Font.ARIAL, true);
			FontUtil.setFont(nameTf2, Font.ARIAL, true);
			FontUtil.setFont(nameTf3, Font.ARIAL, true);
			FontUtil.setFont(descTf1, Font.ARIAL, true);
			FontUtil.setFont(descTf2, Font.ARIAL, true);
			FontUtil.setFont(descTf3, Font.ARIAL, true);
			FontUtil.setFont(quantityTf, Font.ARIAL, true);

			nameTf1.autoSize = TextFieldAutoSize.LEFT;
			nameTf2.autoSize = TextFieldAutoSize.LEFT;
			nameTf3.autoSize = TextFieldAutoSize.LEFT;
			descTf1.autoSize = TextFieldAutoSize.LEFT;
			descTf2.autoSize = TextFieldAutoSize.LEFT;
			descTf3.autoSize = TextFieldAutoSize.LEFT;

			descTf1.wordWrap = true;
			descTf2.wordWrap = true;
			descTf3.wordWrap = true;

			quantityTf.restrict = "0-9";
			quantityTf.addEventListener(MouseEvent.CLICK, quantityTf_clickHandler);
			quantityTf.addEventListener(Event.CHANGE, quantityTf_textInputHandler);
			quantityTf.addEventListener(FocusEvent.FOCUS_OUT, quantityTf_focusOutHandler);

			combineBtn.addEventListener(MouseEvent.CLICK, combineBtn_clickHandler);
		}

		private function quantityTf_focusOutHandler(event:FocusEvent):void
		{
			quantityTf.text = (quantityTf.text == "") ? "1" : quantityTf.text;
		}

		private function quantityTf_textInputHandler(event:Event):void
		{
			quantityTf.text = (parseInt(quantityTf.text) <= data.maxCombination) ? quantityTf.text : data.maxCombination.toString();
			quantityTf.text = (parseInt(quantityTf.text) != 0) ? quantityTf.text : "1";
		}

		public var nameTf1:TextField;
		public var nameTf2:TextField;
		public var nameTf3:TextField;
		public var descTf1:TextField;
		public var descTf2:TextField;
		public var descTf3:TextField;
		public var quantityTf:TextField;
		public var iconEquation1:MovieClip;
		public var iconEquation2:MovieClip;
		public var iconEquation3:MovieClip;
		public var iconItem1:MovieClip;
		public var iconItem2:MovieClip;
		public var iconItem3:MovieClip;
		public var combineBtn:SimpleButton;

		private var data:ExchangeEventData;

		public function setData(eventData:EventData):void
		{
			reset();

			data = eventData as ExchangeEventData;

			var config:IItemConfig;

			for (var i:int = 0; i < data.exchangeEventXML.equation.source.length; i++)
			{
				var variable:Variable = data.exchangeEventXML.equation.source[i] as Variable;
				var eContainerMov:MovieClip = this["iconEquation" + (i + 1)] as MovieClip;
				var iContainerMov:MovieClip = this["iconItem" + (i + 1)] as MovieClip;
				var nameTf:TextField = this["nameTf" + (i + 1)] as TextField;
				var descriptionTf:TextField = this["descTf" + (i + 1)] as TextField;

				if (eContainerMov)
				{
					config = addIconTo(eContainerMov, ItemType.ITEM_EVENT_RECIPE, variable.itemID, variable.quantity);
					nameTf.text = config.getName();
					descriptionTf.text = config.getDescription();
				}

				if (iContainerMov)
				{
					addIconTo(iContainerMov, ItemType.ITEM_EVENT_RECIPE, variable.itemID);
				}
			}

			config = addIconTo(iconEquation3, ItemType.NORMAL_CHEST, data.exchangeEventXML.equation.dest.itemID, data.exchangeEventXML.equation.dest.quantity);

			nameTf3.text = config.getName();
			descTf3.text = config.getDescription();
			quantityTf.text = data.maxCombination.toString();
			combineBtn.mouseEnabled = true;
			combineBtn.visible = !eventData.isMax;
			quantityTf.visible = !eventData.isMax;

			addIconTo(iconItem3, ItemType.NORMAL_CHEST, data.exchangeEventXML.equation.dest.itemID);
		}

		private function addIconTo(containerMov:MovieClip, type:ItemType, itemID:int, quantity:int = -1):IItemConfig
		{
			var config:IItemConfig = ItemFactory.buildItemConfig(type, itemID);
			var slot:ItemSlot = Manager.pool.pop(ItemSlot) as ItemSlot;
			var visible:Boolean = (quantity > 0);
			slot.setConfigInfo(config, TooltipID.ITEM_COMMON);
			slot.setQuantity(quantity, visible);
			containerMov.addChild(slot);

			return config;
		}

		private function reset():void
		{
			for (var i:int = 0; i < 3; i++)
			{
				var eContainerMov:MovieClip = this["iconEquation" + (i + 1)] as MovieClip;
				var iContainerMov:MovieClip = this["iconItem" + (i + 1)] as MovieClip;

				while (eContainerMov.numChildren > 0)
				{
					var slot:ItemSlot = eContainerMov.removeChildAt(0) as ItemSlot;
					slot.reset();
					Manager.pool.push(slot, ItemSlot);
				}

				while (iContainerMov.numChildren > 0)
				{
					slot = iContainerMov.removeChildAt(0) as ItemSlot;
					slot.reset();
					Manager.pool.push(slot, ItemSlot);
				}
			}

			data = null;
		}

		private function quantityTf_clickHandler(event:MouseEvent):void
		{
			quantityTf.setSelection(0, quantityTf.length);
		}

		private function validate():Boolean
		{
			var variable1:Variable = data.exchangeEventXML.equation.source[0];
			var variable2:Variable = data.exchangeEventXML.equation.source[1];
			var currentQuantity1:int = Game.database.inventory.getItemQuantity(ItemType.ITEM_EVENT_RECIPE, variable1.itemID);
			var currentQuantity2:int = Game.database.inventory.getItemQuantity(ItemType.ITEM_EVENT_RECIPE, variable2.itemID);

			if(currentQuantity1 < variable1.quantity)
			{
				var config:IItemConfig = ItemFactory.buildItemConfig(ItemType.ITEM_EVENT_RECIPE, variable1.itemID);
				Manager.display.showMessage("Còn thiếu " + (variable1.quantity - currentQuantity1) + " " +  config.getName());
				return false;
			}

			if(currentQuantity2 < variable2.quantity)
			{
				config = ItemFactory.buildItemConfig(ItemType.ITEM_EVENT_RECIPE, variable2.itemID);
				Manager.display.showMessage("Còn thiếu " + (variable2.quantity - currentQuantity2) + " " + config.getName());
				return false;
			}

			if(parseInt(quantityTf.text) <= 0)
			{
				Manager.display.showMessage("Số lượng ghép không hợp lệ");
				return false;
			}

			return true;
		}

		private function combineBtn_clickHandler(event:MouseEvent):void
		{
			if(validate())
			{
				combineBtn.mouseEnabled = false;
				TimerEx.startTimer(1000, 1, null, enableCombineBtn);
				data.currentCombination = parseInt(quantityTf.text);
				dispatchEvent(new EventEx(EventPanel.COMBINE, {quantity: data.currentCombination, eventID:data.exchangeEventXML.ID}, true));
			}
		}

		private function enableCombineBtn():void
		{
			combineBtn.mouseEnabled = true;
		}
	}
}
