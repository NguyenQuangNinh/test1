package game.ui.components.tab
{
	import core.event.EventEx;
	import core.event.EventEx;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author 
	 */
	public class Tab extends MovieClip
	{
		public static const CHANGE_TAB:String = "changeTab";
		
		//private var btnIndex:int;
		//private var nextPos:int;
		private var activeBtn:MovieClip;
		private var tabBtnArr:Array;		
		
		public function Tab() 
		{
			//btnIndex = 0;
			//nextPos = 0;
			tabBtnArr = new Array();
		}
		
		public function addTab(title:String, page:Sprite, tabBtn:MovieClip):void
		{
			/*
			var tabBtn:MovieClip = new MovieClip();
			tabBtn.tf.text = title;
			tabBtn.tf.mouseEnabled = false;
			tabBtn.tf.width = tabBtn.tf.textWidth + 5;
			tabBtn.bg.width = tabBtn.tf.width + 20;
			tabBtn.x = nextPos;
			nextPos += tabBtn.bg.width - 7;
			addChild(tabBtn);
			*/
			//tabBtn.index = btnIndex;
			//btnIndex++;
			tabBtn.index = tabBtnArr.length;
			
			//update name and page
			//page.visible = false;
			tabBtn.page = page;			
			
			tabBtn.addEventListener(MouseEvent.MOUSE_DOWN, tabBtnMouseDownHdl);
			tabBtnArr.push(tabBtn);
		}
		
		public function setActive(ind:uint):void
		{
			var btn:MovieClip = tabBtnArr[ind];
			if (activeBtn) 
			{
				activeBtn.bg.gotoAndStop("normal");
				activeBtn.page.visible = false;
				//this.setChildIndex(activeBtn, activeBtn.index);
			}
			btn.bg.gotoAndStop("active");
			btn.page.visible = true;
			//this.setChildIndex(btn, numChildren - 1)
			activeBtn = btn;
			dispatchEvent(new EventEx(CHANGE_TAB, btn.index, true));
		}
			
		private function tabBtnMouseDownHdl(e:MouseEvent):void 
		{
			var btn:MovieClip = MovieClip(e.currentTarget);
			setActive(btn.index);
		}
		
		public function activeTabIndex():int {
			return activeBtn ? activeBtn.index : 0;
		}
	}

}