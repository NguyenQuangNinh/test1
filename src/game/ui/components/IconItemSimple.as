package game.ui.components
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import core.display.BitmapEx;
	import core.event.EventEx;
	
	import game.data.model.item.Item;
	import game.ui.tooltip.TooltipEvent;
	import game.ui.tooltip.TooltipID;
	
	
	public class IconItemSimple extends MovieClip
	{
		private var icon:BitmapEx;
		private var data:Item;
		
		public function IconItemSimple()
		{
			icon = new BitmapEx();
			icon.addEventListener(BitmapEx.LOADED, icon_onLoaded);
			addChild(icon);
			
			addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
		}
		
		protected function onMouseOver(event:MouseEvent):void
		{
			if(data != null)
			{
				dispatchEvent(new EventEx(TooltipEvent.SHOW_TOOLTIP, {type:TooltipID.ITEM_COMMON, value:data.itemXML, quantity:data.quantity}, true));
			}
		}
		
		protected function onMouseOut(event:MouseEvent):void
		{
			dispatchEvent(new EventEx(TooltipEvent.HIDE_TOOLTIP, null, true));
		}
		
		protected function icon_onLoaded(event:Event):void
		{
			icon.x = -icon.width / 2;
			icon.y = -icon.height / 2;
		}
		
		public function setData(item:Item):void
		{
			data = item;
			if(data != null && data.itemXML != null)
			{
				icon.load(item.itemXML.iconURL);
			}
			else
			{
				icon.reset();
			}
		}
	}
}