package game.main
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	public class ListPanel extends Sprite
	{
		public static const SELECTION_CHANGED:String = "selection_changed";
		
		private var items:Array = [];
		private var selected:int = -1;
		
		public function ListPanel()
		{
			addEventListener(MouseEvent.CLICK, onMouseClicked);
		}
		
		protected function onMouseClicked(event:MouseEvent):void
		{
			if(event.target is ListItem)
			{
				setSelected(items.indexOf(event.target));
			}
		}
		
		public function addItem(item:ListItem):void
		{
			item.y = items.length*item.height;
			items.push(item);
			addChild(item);
			graphics.beginFill(0xffffff);
			graphics.drawRect(0, 0, 200, 500);
		}
		
		public function setSelected(index:int):void
		{
			if(index != selected)
			{
				selected = index;
				for(var i:int = 0; i < numChildren; ++i)
				{
					var item:ListItem = items[i];
					item.txtName.border = (i == index);
				}
				dispatchEvent(new Event(SELECTION_CHANGED));
			}
		}
		
		public function getSelected():ListItem
		{
			return items[selected];
		}
		
		public function clear():void
		{
			for each(var item:ListItem in items)
			{
				removeChild(item);
			}
			items = [];
			selected = -1;
		}
		
		public function getSize():int { return items.length; }
	}
}