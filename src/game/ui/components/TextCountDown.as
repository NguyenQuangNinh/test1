package game.ui.components 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.utils.Timer;
	/**
	 * ...
	 * @author vu anh
	 */
	public class TextCountDown extends EventDispatcher
	{
		public static const TEXT_COUNT_DOWN_TIMER:String = "TEXT_COUNT_DOWN_TIMER";
		public static const TEXT_COUNT_DOWN_COMPLETE:String = "TEXT_COUNT_DOWN_COMPLETE";
		public var tf:TextField;
		public var timer:Timer;
		private var duration:int;
		private var isShowHour:Boolean;
		public function TextCountDown(tf:TextField, isShowHour:Boolean = false) 
		{
			this.isShowHour = isShowHour;
			this.tf = tf;
			timer = new Timer(1000);
			timer.addEventListener(TimerEvent.TIMER, timerHdl);
		}
		
		private function timerHdl(e:TimerEvent):void 
		{
		
			var t:int = duration - timer.currentCount;
			updateTf(t);
			
			dispatchEvent(new Event(TEXT_COUNT_DOWN_TIMER));
			
			if (timer.currentCount == duration) 
			{
				timer.stop();
				timer.reset();

				dispatchEvent(new Event(TEXT_COUNT_DOWN_COMPLETE));
			}
			
		}
		
		public function startCountDown(duration:int):void
		{
			this.duration = duration;
			timer.reset();
			timer.start();
		}
		
		public function stopCountDown():void
		{
			timer.stop();
			timer.reset();
		}
		
		public function updateTf(t:int):void
		{
			var h:String = int(t / 3600).toString();
			if (h.length < 2) h = "0" + h;
			t = t % 3600;
			
			var m:String = int(t / 60).toString();
			if (m.length < 2) m = "0" + m;
			t = t % 60;
			
			var s:String = t.toString();
			if (s.length < 2) s = "0" + s;
			
			tf.text = (isShowHour ? h + ":" : "") + m + ":" + s;
		}
		
		public function isRunning():Boolean
		{
			return timer.running;
		}
		
	}

}