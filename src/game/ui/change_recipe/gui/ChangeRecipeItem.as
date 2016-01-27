package game.ui.change_recipe.gui
{
	import core.event.EventEx;
	import core.Manager;
	import core.util.Enum;
	import flash.display.*;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import game.ui.tooltip.TooltipID;
	
	import game.data.model.item.ItemFactory;
	import game.enum.ItemType;
	import game.ui.components.ItemSlot;
	
	/**
	 * ...
	 * @author chuongth2
	 */
	public class ChangeRecipeItem extends MovieClip
	{
		public static const SELECTED:String = "SELECTED";
		
		public var _itemSlot:ItemSlot;
		public var _id:int;
		public var _type:ItemType;
		public var _quantity:int;
		
		public function ChangeRecipeItem()
		{
		
		}
		
		public function init(id:int, type:ItemType, quantity:int):void
		{
			reset();
			this._id = id;
			this._type = type;
			this._quantity = quantity;
			_itemSlot = Manager.pool.pop(ItemSlot) as ItemSlot;
			_itemSlot.setConfigInfo(ItemFactory.buildItemConfig(type, id), TooltipID.ITEM_COMMON);
			_itemSlot.setQuantity(quantity);
			_itemSlot.buttonMode = true;
			//_itemSlot.setPositionBitmap(0, 0);
			this.addChild(_itemSlot);
			this.addEventListener(MouseEvent.CLICK, onSelectedHandler);
			this.addEventListener(ItemSlot.ICON_LOADED, onIconLoaded);
		}
		
		private function onIconLoaded(e:Event):void
		{
			if (_itemSlot)
			{
				//_itemSlot.setPositionBitmap(0, 0);
			}
		}
		
		public function setQuantity(quantity:int):void
		{
			if (_itemSlot)
			{
				this._quantity = quantity;
				_itemSlot.setQuantity(quantity);
			}
		}
		
		private function onSelectedHandler(e:Event):void
		{
			this.dispatchEvent(new EventEx(SELECTED, this, true));
		}
		
		public function destroy():void
		{	
			reset();
			if (_itemSlot)
			{
				this.removeChild(_itemSlot);
				Manager.pool.push(_itemSlot, ItemSlot);
			}
		}
		
		public function reset():void
		{
			_id = 0;
			_type = ItemType.EMPTY_SLOT;
			_quantity = 0;
			if (_itemSlot && _itemSlot.iconBmp)
			{
				_itemSlot.reset();
				_itemSlot.iconBmp.reset();
			}
		}
	
	}

}