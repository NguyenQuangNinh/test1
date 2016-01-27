package game.ui.character_enhancement
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	
	public class TabGroup extends EventDispatcher
	{
		public static const TAB_CHANGED:String = "tabChanged";
		
		private var tabs:Array = [];
		private var currentTab:int = -1;
		
		public function TabGroup()
		{
			super();
		}
		
		public function add(tab:Tab):void
		{
			if(tab != null)
			{
				tabs.push(tab);
				if(tab.getButton() != null) tab.getButton().addEventListener(MouseEvent.CLICK, tab_onClicked);
			}
		}
		
		protected function tab_onClicked(event:Event):void
		{
			for(var i:int = 0; i < tabs.length; ++i)
			{
				var tab:Tab = tabs[i];
				if(tab.getButton() == event.target)
				{
					selectTab(i);
					break;
				}
			}
		}
		
		public function selectTab(index:int):void
		{
			for(var i:int = 0; i < tabs.length; ++i)
			{
				var tab:Tab = tabs[i];
				if(i == index)
				{
					tab.activate();
				}
				else
				{
					if(tab.isActivate())
					{
						tab.deactivate();
					}
				}
			}
			currentTab = index;
			dispatchEvent(new Event(TAB_CHANGED));
		}
		
		public function getCurrentTab():int { return currentTab; }
	}
}