package game.ui.challenge 
{
	import components.scroll.VerScroll;
	import core.util.MovieClipUtils;
	import flash.display.MovieClip;
	import flash.events.Event;
	import game.data.vo.challenge.HistoryInfo;
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class HistoryContainer extends MovieClip
	{
		private static const MAX_HISTORY_IN_VIEW:int = 10;		
		
		private static const DISTANCE_Y_PER_HISTORY:int = 10;
		
		//private var _historys:Array = []
		public var contentMov:MovieClip;
		public var masker:MovieClip;
		public var scroller:VerScroll;
		public var scrollMov:MovieClip;
		
		public function HistoryContainer() 
		{
			if (stage)
				init();
			else addEventListener(Event.ADDED_TO_STAGE, init);	
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			scroller = new VerScroll(masker, contentMov, scrollMov);
			//init UI
			/*var history:History;
			for (var i:int = 0; i < MAX_HISTORY_IN_VIEW; i++) {
				history = new History();
				history.y = (history.height + DISTANCE_Y_PER_HISTORY) * i
				_historys.push(history);
				addChild(history);
			}*/
		}
		
		public function updateInfo(info:Array):void 
		{
			if (info) {				
				//clear content
				MovieClipUtils.removeAllChildren(contentMov);
				var history:History;	
				info.reverse();
				for (var i:int = 0; i < info.length; i++)  {
					history = new History();
					//update new one
					history.update(i, info[i] as HistoryInfo);
					history.y = (history.height + DISTANCE_Y_PER_HISTORY) * i;
					//_historys.push(history);
					contentMov.addChild(history);			
				}	
				scroller.updateScroll(contentMov.height + 10);
			}
		}
		
		public function lock():void
		{
			this.mouseEnabled = false;
			this.mouseChildren = false;
		}
		
		public function unlock():void
		{
			this.mouseEnabled = true;
			this.mouseChildren = true;
		}
	}

}