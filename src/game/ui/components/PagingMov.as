package game.ui.components 
{
	import core.util.FontUtil;
	import core.util.MovieClipUtils;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import game.enum.Font;
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class PagingMov extends MovieClip
	{
		public static const INDEX_CHANGED:String = "indexChanged";
		public static const GO_TO_NEXT:String = "goToNext";
		public static const GO_TO_PREV:String = "goToBack";
		
		public var prevBtn:SimpleButton;
		public var nextBtn:SimpleButton;
		public var pageTf:TextField;
		
		private var maxIndex:int;
		private var currentIndex:int;
		
		//private var _currentPage:int;
		
		public function PagingMov() 
		{
			init();
		}
		
		public function reset():void
		{
			maxIndex = 1;
			currentIndex = 1;
			updateText();
		}
		
		public function setMaxIndex(value:int):void
		{
			if(value > 0)
			{
				maxIndex = value;
				updateText();
			}
		}
		
		public function getCurrentIndex():int { return currentIndex; }
		public function setCurrentIndex(value:int):void
		{
			currentIndex = value;
			updateText();
			dispatchEvent(new Event(INDEX_CHANGED));
		}
		
		private function updateText():void
		{
			pageTf.text = currentIndex + "/" + maxIndex;
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			initUI();
			reset();
		}
		
		private function initUI():void 
		{
			//set font
			FontUtil.setFont(pageTf, Font.ARIAL, true);
			
			//add events
			prevBtn.addEventListener(MouseEvent.CLICK, onBtnClickHdl);
			nextBtn.addEventListener(MouseEvent.CLICK, onBtnClickHdl);
		}
		
		private function onBtnClickHdl(e:MouseEvent):void 
		{
			switch(e.target) {
				case nextBtn:
					dispatchEvent(new Event(GO_TO_NEXT, true));
					next();
					break;
				case prevBtn:
					dispatchEvent(new Event(GO_TO_PREV, true));
					previous();
					break;
			}
		}
		
		private function next():void
		{
			if(currentIndex < maxIndex)
			{
				setCurrentIndex(currentIndex + 1);
			}
		}
		
		private function previous():void
		{
			if(currentIndex > 1)
			{
				setCurrentIndex(currentIndex - 1);
			}
		}
		
		public function update(current:int, total:int):void {
			//_currentPage = current;
			pageTf.text = current + ((total > 0 && current <= total) ? "/" + total : "").toString();
			prevBtn.mouseEnabled = current > 1;	// || total == 0;
			nextBtn.mouseEnabled = current < total || total == 0;
			
			if (!prevBtn.mouseEnabled)
				MovieClipUtils.applyGrayScale(prevBtn);
			else 
				MovieClipUtils.removeAllFilters(prevBtn);
				
			if (!nextBtn.mouseEnabled)
				MovieClipUtils.applyGrayScale(nextBtn);
			else 
				MovieClipUtils.removeAllFilters(nextBtn);	
		}
	}
}