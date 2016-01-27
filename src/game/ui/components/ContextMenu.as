package game.ui.components
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	public class ContextMenu extends MovieClip
	{
		private var items:Array;
		private var data:Object;
		
		public function ContextMenu()
		{
			items = [];
			
			addEventListener(MouseEvent.CLICK, onClicked);
			
			reset();
		}
		
		protected function onClicked(event:MouseEvent):void
		{
			if(event.target is ContextMenuItem)
			{
				var item:ContextMenuItem = event.target as ContextMenuItem;
				item.execute(data);
			}
		}
		
		public function reset():void
		{
			
		}
		
		public function addItem(item:ContextMenuItem):void
		{
			item.y = items.length * ContextMenuItem.HEIGHT;
			addChild(item);
			items.push(item);
		}
		
		public function setData(data:Object):void
		{
			this.data = data;
		}
	}
}