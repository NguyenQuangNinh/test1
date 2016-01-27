package game.ui.inventoryitem.gui
{
	import core.event.EventEx;
	import core.Manager;
	import core.util.Utility;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import game.data.model.item.Item;
	import game.enum.DragDropEvent;
	import game.enum.ItemType;
	import game.ui.components.ItemSlot;
	import game.ui.inventoryitem.InventoryItemEvent;
	import game.ui.tooltip.TooltipID;
	
	/**
	 * ...
	 * @author anhtinh
	 */
	public class ItemCell extends MovieClip
	{
		public static const LOCK:String = "lock";
		public static const UNLOCK:String = "unlock";
		public static const UNLOCK_GUILD:String = "unlock_guild";
		
		static public const ITEM_CELL_CLICK:String = "item_slot_click";
		static public const ITEM_CELL_DOUBLE_CLICK:String = "item_cell_double_click";
		static public const ITEM_SLOT_DRAG:String = "item_slot_drag";
		
		private var _isMouseDown:Boolean = false;
		private var _clickStarted:int = -1;
		private var _mouseTimeOut:int;
		
		private var _status:String;
		private var _item:Item;
		
		private var _itemSlot:ItemSlot;
		
		public function ItemCell()
		{
			status = LOCK;
			this.buttonMode = true;
			this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownHdl);
			this.addEventListener(MouseEvent.CLICK, onMouseClickHdl);
			this.addEventListener(ItemSlot.ITEM_SLOT_DOUBLE_CLICK, onItemSlotDoubleClick);
			//mouseChildren = false;
		}
		
		private function onItemSlotDoubleClick(e:EventEx):void
		{
			if (status == UNLOCK)
			{
				if (_itemSlot && _item)
				{
					this.dispatchEvent(new EventEx(ITEM_CELL_DOUBLE_CLICK, _item, true));
				}
			}
		}
		
		private function onMouseClickHdl(e:MouseEvent):void
		{
			if (status == UNLOCK_GUILD) {
				confirmUnlockSlot();
			} else {
				dispatchEvent(new EventEx(ITEM_CELL_CLICK, _item, true));
			}
		}
		
		private function onMouseDownHdl(e:MouseEvent):void
		{
			addEventListener(MouseEvent.MOUSE_OUT, onMouseOutHdl);
			addEventListener(MouseEvent.MOUSE_UP, onMouseUpHdl);
			_isMouseDown = true;
		}
		
		private function onMouseUpHdl(e:MouseEvent):void
		{
			removeEventListener(MouseEvent.MOUSE_UP, onMouseUpHdl);
			removeEventListener(MouseEvent.MOUSE_OUT, onMouseOutHdl);
			_isMouseDown = false;
		}
		
		private function onMouseOutHdl(e:MouseEvent):void
		{
			removeEventListener(MouseEvent.MOUSE_UP, onMouseUpHdl);
			removeEventListener(MouseEvent.MOUSE_OUT, onMouseOutHdl);
			
			if (_isMouseDown)
			{
				//reset flag
				_isMouseDown = false;
				
				//this is a drag
				if (_item && _item.itemXML)
				{
					var objDrag:ItemSlot = new ItemSlot();
					objDrag.setConfigInfo(_item.itemXML);
					objDrag.name = "mov_drag";
					dispatchEvent(new EventEx(ITEM_SLOT_DRAG, {target: objDrag, data: _item, x: e.stageX, y: e.stageY, coordinate: "center", from: DragDropEvent.FROM_SOUL_INVENTORY}, true));
				}
			}
		}
		
		public function getData():Item
		{
			return _item;
		}
		
		public function setData(item:Item):void
		{
			this._item = item;
			
			if (item && item.itemXML && item.itemXML.type != ItemType.EMPTY_SLOT)
			{
				_itemSlot = Manager.pool.pop(ItemSlot) as ItemSlot;
				if (item.itemXML.type == ItemType.LUCKY_CHEST)
					_itemSlot.setConfigInfo(item.itemXML, TooltipID.ITEM_SET);
				else
					_itemSlot.setConfigInfo(item.itemXML, TooltipID.ITEM_COMMON);
				
				_itemSlot.setQuantity(item.quantity);
				//_itemSlot.quantityTf.text = "in:" + item.index;
				
				_itemSlot.x = 5;
				_itemSlot.y = 5;
				this.addChild(_itemSlot);
				
				//var rectangle:Shape = new Shape; // initializing the variable named rectangle
				//rectangle.graphics.beginFill(0xFF0000); // choosing the colour for the fill, here it is red
				//var rec:Rectangle = this.getRect(this);
				//rectangle.graphics.drawRect(rec.x, rec.y, CellPanel.CELL_WIDTH, CellPanel.CELL_HEIGHT); // (x spacing, y spacing, width, height)
				//rectangle.graphics.endFill(); // not always needed but I like to put it in to end the fill
				//addChild(rectangle);
			}
		
		}
		
		private function confirmUnlockSlot():void
		{
			dispatchEvent(new EventEx(InventoryItemEvent.UNLOCK_SLOT, null, true));
		
		}
		
		public function get status():String
		{
			return _status;
		}
		
		public function set status(value:String):void
		{
			switch (value)
			{
				case LOCK: 
					this.gotoAndStop(LOCK);
					break;
				
				case UNLOCK: 
					this.gotoAndStop(UNLOCK);
					break;
				
				case UNLOCK_GUILD: 
					this.gotoAndStop(UNLOCK_GUILD);
					break;
				
				default: 
					value = LOCK;
			
			}
			
			_status = value;
		}
		
		public function destroy():void
		{
			if (_itemSlot)
			{
				_itemSlot.reset();
				Manager.pool.push(_itemSlot, ItemSlot);
			}
		}
		
		public function checkContains(x:int, y:int):Boolean
		{
			var rec:Rectangle = this.getRect(stage);
			return new Rectangle(rec.x, rec.y, CellPanel.CELL_WIDTH, CellPanel.CELL_HEIGHT).contains(x, y);
		}
	}

}