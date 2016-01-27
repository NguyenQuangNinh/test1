package components.listbox 
{
	import components.scroll.VerScroll;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Vu Anh
	 */
	public class ExList extends MovieClip
	{
		
		public var list:MovieClip;
		public var scrollBar:MovieClip;
		public var bg:MovieClip;
		public var masked:MovieClip;
		
		private var startY:int = 0;
		private var itemArr:Array;
		private var _selectedIndex:int = -1;
		private var _selectedItem:Object;
		
		private var exWidth:Number;
		private var scroll:VerScroll;
		
		private var fullMask:MovieClip;
		
		public function ExList() 
		{
			itemArr = new Array();
			
			list = new MovieClip();
			addChildAt(list, 1);

			masked = new MovieClip();
			this.addChild(masked);
			masked.graphics.beginFill(0x000000);
			masked.y = 1;
			masked.graphics.drawRect(0, 0, bg.width, bg.height - 3);
			
			fullMask = new MovieClip();
			this.addChild(fullMask);
			fullMask.graphics.beginFill(0x000000);
			fullMask.y = 1;
			fullMask.graphics.drawRect(0, 0, bg.width + 100, bg.height);
			
			list.mask = masked;
			this.mask = fullMask;
			
			scroll = new VerScroll(masked, list, scrollBar);
			
			this.addEventListener(MouseEvent.MOUSE_OVER, mouseOverHdl);
			this.addEventListener(MouseEvent.MOUSE_OUT, mouseOutHdl);
		}
		
		private function mouseOutHdl(e:MouseEvent):void 
		{
		}
		
		private function mouseOverHdl(e:MouseEvent):void 
		{
		}
		
		public function addItem(itemInfo:Object):void {
			var item:Item = new Item();
			list.addChild(item);
			item.setInfo(itemInfo);
			item.y = startY;
			item.index = itemArr.length;
			item.setWidth(exWidth - scrollBar.width);
			item.addEventListener(MouseEvent.CLICK, itemMouseClickHdl);
			item.addEventListener(MouseEvent.MOUSE_OVER, itemMouseOverHdl);
			item.addEventListener(MouseEvent.MOUSE_OUT, itemMouseOutHdl);
			startY += item.height;
			itemArr.push(item);
			scroll.updateScroll();
			
			if (list.height < bg.height)
			{
				fullMask.height = list.height;
			}
			else {
				fullMask.height = bg.height;
			}
		}
		
		private function itemMouseClickHdl(e:MouseEvent):void 
		{
			var item:Item = Item(e.currentTarget);
			if (_selectedIndex == item.index) return;
			setActiveItem(item);
		}
		
		private function setActiveItem(item:Item):void {
			if (selectedIndex != -1) Item(itemArr[_selectedIndex]).bg.gotoAndStop("normal");
			_selectedIndex = item.index;
			_selectedItem = item.info;
			item.bg.gotoAndStop("active");
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		private function itemMouseOverHdl(e:MouseEvent):void 
		{
			var item:Item = Item(e.currentTarget);
			if (_selectedIndex == item.index) return;
			item.bg.gotoAndStop("over");
		}
		
		private function itemMouseOutHdl(e:MouseEvent):void 
		{
			var item:Item = Item(e.currentTarget);
			if (_selectedIndex == item.index) return;
			item.bg.gotoAndStop("out");
		}
		
		public function get selectedIndex():int { return _selectedIndex; }
		
		public function set selectedIndex(value:int):void 
		{
			if (value < 0 || value >= itemArr.length) return;
			_selectedIndex = value;
			setActiveItem(itemArr[selectedIndex]);
		}
		
		public function get selectedItem():Object { return _selectedItem; }
		
		public function set selectedItem(value:Object):void 
		{
			_selectedItem = value;
		}
		
		public function setSize(pWidth:Number = -1, pHeight:Number = -1):void {
			masked.graphics.clear();
			masked.graphics.beginFill(0x000000);
			masked.y = 1;
			if (pWidth == -1) pWidth = list.width;
			if (pHeight == -1) pHeight = list.height;
			masked.graphics.drawRect(0, 0, pWidth + 10, pHeight + 10);
			exWidth = pWidth;
			bg.width = pWidth;
			bg.height = pHeight;
			list.mask = masked;
			scrollBar.x = pWidth - scrollBar.width;
			scrollBar.track.height = pHeight;
			scroll.updateScroll();
		}
		
		public function getHeight():Number
		{
			return list.height < bg.height ? list.height : bg.height;
		}
		
	}
	
}