package components.pagemanager
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author ...
	 */
	public class PagesManager extends MovieClip
	{
		public var pageNum:int;
		public var pageItemArr:Array;
		public var viewNum:int;
		public var contentMc:MovieClip;
		
		public var next:SimpleButton;
		public var back:SimpleButton;
		public var begin:SimpleButton;
		public var end:SimpleButton;
		
		public var currentIndex:int = 0;
		public var startIndex:int = 0;
		public var activeItem:PageItem;
		
		public function PagesManager() 
		{
			if (begin) begin.visible = false;
			if (end) end.visible = false;
			viewNum = 5;
			next.addEventListener(MouseEvent.CLICK, onNext);
			back.addEventListener(MouseEvent.CLICK, onBack);
			if (begin) begin.addEventListener(MouseEvent.CLICK, onif (begin) begin);
			if (end) end.addEventListener(MouseEvent.CLICK, onif (end) end);
		}
		
		private function onNext(e:MouseEvent):void 
		{
			if (currentIndex == startIndex + viewNum - 1) {
				if (currentIndex + 1 <= pageNum -1) {
					currentIndex++;
					startIndex++;
					updateIndex();
				}
			} else {
				currentIndex++;
				updateIndex();
			}
			
		}
		
		private function onBack(e:MouseEvent):void 
		{
			if (currentIndex == startIndex) {
				if (currentIndex - 1 >= 0) {
					currentIndex--;
					startIndex--;
					updateIndex();
				}
			} else {
				currentIndex--;
				updateIndex();
			}
		}
		
		private function onBegin(e:MouseEvent):void 
		{
			if (currentIndex != 0) {
				currentIndex = 0;
				startIndex = 0;
				updateIndex();
			}
		}
		
		private function onEnd(e:MouseEvent):void 
		{
			if (currentIndex != pageNum - 1) {
				currentIndex = pageNum - 1;
				startIndex = pageNum - viewNum;
				updateIndex();
			}			
		}
		
		private function updateIndex(): void {
			if (currentIndex == pageNum - 1) {
				next.visible = false;
				//if (end) end.visible = false;
			} else {
				next.visible = true;
				//if (end) end.visible = true;				
			}
			if (currentIndex == 0) {
				back.visible = false;
				//if (begin) begin.visible = false;
			} else {
				back.visible = true;
				//if (begin) begin.visible = true;
			}
			activeItem.tf.textColor = 0x333333;
			
			activeItem = pageItemArr[currentIndex - startIndex];
			
			activeItem.tf.textColor = 0x7DAA07;
			for (var i:int = startIndex; i < startIndex + viewNum; i++ ) {
				var ind:PageItem = pageItemArr[i - startIndex];
				ind.tf.text = (i + 1).toString();
				ind.index = i;
			}
			var event:PageManagerEvent = new PageManagerEvent(PageManagerEvent.CHANGE_INDEX);
			event.index = currentIndex;
			dispatchEvent(event);
		}
		
		public function initPage(num:int): void 
		{
			if (num <= 1)
			{
				this.visible = false;
				return;
			} else this.visible = true;
			pageItemArr = new Array();
			while (contentMc.numChildren)
			{
				contentMc.removeChildAt(0);
			}
			
			back.visible = false;
			//if (begin) begin.visible = false;
			if (num == 0) {
				this.visible = false;
				return;
			}
			if (num < 2) this.visible = false;
			else this.visible = true;
			pageNum = num;
			viewNum = (pageNum > viewNum)? viewNum:pageNum;
			var posX:Number = 0;
			for (var i:int = 0; i < viewNum; i++ ) {
				var ind:PageItem = new PageItem();
				ind.x = posX;
				contentMc.addChild(ind);
				ind.tf.text = (i + 1).toString();
				ind.index = i;
				
				ind.bg.gotoAndStop("normal");
				ind.addEventListener(MouseEvent.CLICK, onIndexClick);
				pageItemArr.push(ind);
				posX += ind.width + 5;
			}
			activeItem = pageItemArr[0];
			activeItem.tf.textColor = 0x7DAA07;
			next.x = posX + 32;
		}

		private function onIndexClick(e:MouseEvent):void 
		{
			var ind:MovieClip = MovieClip(e.currentTarget);
			if (ind.index != currentIndex) {
				activeItem.tf.textColor = 0x333333;
				activeItem = pageItemArr[ind.index - startIndex];
				activeItem.tf.textColor = 0x7DAA07;
				currentIndex = ind.index;
				
				var event:PageManagerEvent = new PageManagerEvent(PageManagerEvent.CHANGE_INDEX);
				event.index = ind.index;
				dispatchEvent(event);
			}
			if (currentIndex == pageNum - 1) {
				next.visible = false;
				//if (end) end.visible = false;
			} else {
				next.visible = true;
				//if (end) end.visible = true;				
			}
			if (currentIndex == 0) {
				back.visible = false;
				//if (begin) begin.visible = false;
			} else {
				back.visible = true;
				//if (begin) begin.visible = true;
			}
		}
	}
	
}