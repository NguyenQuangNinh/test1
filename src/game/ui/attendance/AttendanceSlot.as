package game.ui.attendance 
{
	import core.Manager;
	import flash.display.MovieClip;
	import flash.geom.Point;
	import game.ui.components.ItemSlot;
	
	/**
	 * ...
	 * @author anhpnh2
	 */
	public class AttendanceSlot extends MovieClip 
	{
		private var _itemSlot:ItemSlot;
		public var iconContainerMov:MovieClip;
		
		public function AttendanceSlot() 
		{
			_itemSlot = Manager.pool.pop(ItemSlot) as ItemSlot;
			_itemSlot.x = 10;
			_itemSlot.y = 4;
			iconContainerMov.addChild(_itemSlot);
		}
		
		public function destroy():void {
			if(_itemSlot && _itemSlot.parent)
			{
				_itemSlot.parent.removeChild(_itemSlot);
				_itemSlot.reset();
				Manager.pool.push(_itemSlot, ItemSlot);
			}
		}
		
		public function getGlobalPos():Point {			
			return localToGlobal(new Point(_itemSlot.x, _itemSlot.y));
		}
		
		public function get itemSlot():ItemSlot 
		{
			return _itemSlot;
		}
		
		public function set itemSlot(value:ItemSlot):void 
		{
			_itemSlot = value;
		}

		public function changeState(state:int):void
		{
			switch (state)
			{
				case 2:
					gotoAndStop("DEACTIVE");
					break;
				case 1:
					gotoAndStop("NORMAL");
					break;
			}
		}
	}

}