package game.ui.lucky_gift.gui
{
	import core.Manager;
	import core.util.Enum;
	import flash.display.*;
	import game.ui.tooltip.TooltipID;
	
	import game.data.model.item.ItemFactory;
	import game.enum.ItemType;
	import game.ui.components.ItemSlot;
	
	/**
	 * ...
	 * @author xxx
	 */
	public class CellGift extends MovieClip
	{
		public var bg:MovieClip;
		public static const NORMAL:String = "normal";
		public static const ACTIVE:String = "active";
		
		private var _status:String;
		
		private var _itemSlot:ItemSlot;
		
		public function CellGift()
		{
			
			status = NORMAL;
			//this.addChild(_itemSlot);
		}
		
		public function set status(value:String):void
		{
			switch (value)
			{
				case NORMAL:
					this.gotoAndStop(NORMAL);
					bg.visible = false;
					break;
				case ACTIVE: 
					this.gotoAndStop(ACTIVE);
					bg.visible = true;
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
			_itemSlot.setConfigInfo(ItemFactory.buildItemConfig(type, id),TooltipID.ITEM_COMMON);
			_itemSlot.setQuantity(quantity);
			_itemSlot.x = 5;
			_itemSlot.y = 5;
			status = NORMAL;
			addChild(_itemSlot);
		}
		
		public function destroy():void {
			if(_itemSlot)
				_itemSlot.reset();
			Manager.pool.push(_itemSlot, ItemSlot);
		}
	
	}

}