package game.ui.arena 
{
	import core.util.FontUtil;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.utils.Timer;
	import game.enum.Font;
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class MatchingCount extends MovieClip
	{
		public static const CANCEL_MATCHING_COUNT:String = "cancelMatchingCount";
		
		public var cancelBtn:SimpleButton;
		public var countTf:TextField;
		
		private var _timer:Timer;
		private var _currentCount:int;
		
		public function MatchingCount() 
		{
			initUI();
		}
		
		private function initUI():void 
		{
			//set fonts
			FontUtil.setFont(countTf, Font.ARIAL, false);
			
			//add events
			cancelBtn.addEventListener(MouseEvent.CLICK, onCancelClickHdl);
			
			//init timer
			_timer = new Timer(1000);
			_timer.addEventListener(TimerEvent.TIMER, onTimerUpdateHdl);
		}
		
		private function onCancelClickHdl(e:MouseEvent):void 
		{
			this.visible = false;
			stopCount();
			dispatchEvent(new Event(CANCEL_MATCHING_COUNT, true));
		}
		
		public function stopCount():void {
			_timer.stop();
			
			cancelBtn.visible = true;
		}
		
		public function startCount(isHost:Boolean = true):void {
			_currentCount = 1;
			countTf.text = _currentCount.toString();
			_timer.start();
			
			cancelBtn.visible = isHost;
		}
		
		private function onTimerUpdateHdl(e:TimerEvent):void 
		{
			_currentCount++;
			countTf.text = _currentCount.toString();			
		}
	}

}