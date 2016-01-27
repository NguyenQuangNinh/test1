package components.tab 
{
	import components.event.BaseEvent;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author hailua54@gmail.com
	 */
	public class Tab extends MovieClip
	{
		private var btnIndex:int;
		private var nextPos:int;
		private var activeBtn:TabButton;
		private var tabBtnArr:Array;
		public function Tab() 
		{
			btnIndex = 0;
			nextPos = 0;
			tabBtnArr = new Array();
		}
		
		public function addTab(title:String, page:Sprite):void
		{
			var tabBtn:TabButton = new TabButton();
			tabBtn.tf.text = title;
			tabBtn.tf.mouseEnabled = false;
			tabBtn.x = nextPos;
			nextPos += tabBtn.bg.width - 7;
			tabBtn.index = btnIndex;
			btnIndex++;
			
			tabBtn.page = page;
			addChild(tabBtn);
			
			tabBtn.addEventListener(MouseEvent.MOUSE_DOWN, tabBtnMouseDownHdl);
			tabBtnArr.push(tabBtn);
		}
		
		public function setActive(ind:uint):void
		{
			var btn:TabButton = tabBtnArr[ind];
			if (activeBtn) 
			{
				activeBtn.bg.gotoAndStop("normal");
				activeBtn.page.visible = false;
				this.setChildIndex(activeBtn, activeBtn.index);
			}
			btn.bg.gotoAndStop("active");
			btn.page.visible = true;
			this.setChildIndex(btn, numChildren - 1)
			activeBtn = btn;
			dispatchEvent(new BaseEvent(Event.CHANGE, btn.page));
		}
			
		private function tabBtnMouseDownHdl(e:MouseEvent):void 
		{
			var btn:TabButton = TabButton(e.currentTarget);
			setActive(btn.index);
		}
	}

}