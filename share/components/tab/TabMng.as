package components.tab
{
	import components.event.BaseEvent;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author Vu Anh
	 */
	public class TabMng extends EventDispatcher
	{
		public static const EVENT_TAB_CHANGE:String = "EVENT_TAB_CHANGE";
		public var tabBtnArr:Array;
		public var activeTabBtn:MovieClip;
		
		public function TabMng() 
		{
			tabBtnArr = new Array();
		}
		
		public function addTab(tabBtn:MovieClip, page:Sprite):void
		{
			page.visible = false;
			tabBtn.gotoAndStop("normal");
			tabBtn.page = page;
			tabBtn.index = tabBtnArr.length;
			tabBtnArr.push(tabBtn);
			tabBtn.addEventListener(MouseEvent.CLICK, tabBtnClickHdl);
		}
		
		private function tabBtnClickHdl(e:MouseEvent):void 
		{
			var tabBtn:MovieClip = MovieClip(e.currentTarget);
			setActive(tabBtn.index);
		}
		
		public function setActive(index:uint):void
		{
			if (index < 0 || index >= tabBtnArr.length) throw new Error("TabMng setActive() out of range!");
			if (activeTabBtn)
			{
				if (activeTabBtn.index == index) return;
				activeTabBtn.gotoAndStop("normal");
				activeTabBtn.page.visible = false;
			}
			activeTabBtn = tabBtnArr[index];
			activeTabBtn.gotoAndStop("active");
			activeTabBtn.page.visible = true;
			dispatchEvent(new BaseEvent(EVENT_TAB_CHANGE, index));
		}
		
	}

}