package game.ui.open_present_vip.gui
{
	import core.Manager;
	import flash.display.*;
	import game.data.model.item.ItemFactory;
	import game.enum.ItemType;
	import game.ui.components.ItemSlot;
	import game.ui.tooltip.TooltipID;
	
	/**
	 * ...
	 * @author xxx
	 */
	public class CellGiftVip extends MovieClip
	{
		public static const NORMAL:String = "normal";
		public static const ACTIVE:String = "active";
		
		private var _status:String;
		
		private var _itemSlot:ItemSlot;
		
		public function CellGiftVip()
		{
			status = NORMAL;
		}
		
		public function set status(value:String):void
		{
			switch (value)
			{
				case NORMAL: 
				case ACTIVE: 
					this.gotoAndStop(value);
					break;
				default: 
					this.gotoAndStop(NORMAL);
			}
			_status = value;
		}
		
		public function get status():String
		{
			return _status;
		}
		
		public function init(id:int, type:ItemType, quantity:int):void
		{
			_itemSlot = Manager.pool.pop(ItemSlot) as ItemSlot;
			_itemSlot.setConfigInfo(ItemFactory.buildItemConfig(type, id), TooltipID.ITEM_COMMON);
			_itemSlot.setQuantity(quantity);
			_itemSlot.x = 5;
			_itemSlot.y = 5;
			addChild(_itemSlot);
		}
		
		public function destroy():void
		{
			if (_itemSlot)
				_itemSlot.reset();
			Manager.pool.push(_itemSlot, ItemSlot);
		}
	
	}

}