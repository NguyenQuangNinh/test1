package game.ui.home 
{
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import game.Game;
	
	/**
	 * ...
	 * @author MaiPTT
	 */
	public class FeatureManager extends EventDispatcher 
	{
		private static var instance		:FeatureManager;
		private var timer			:Timer;
		private var triggerTime		:Array;
		private var callbackFuncs	:Array;
		private var index			:int;
		
		public function FeatureManager() {
			triggerTime = [];
			callbackFuncs = [];
			
			index = -1;
			timer = new Timer(0, 1);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerCompleteHandler);
		}
		
		private function onTimerCompleteHandler(e:TimerEvent):void {
			if (callbackFuncs[index] != null) {
				for each (var func:Function in callbackFuncs[index]) {
					func();
				}
				timer.stop();
				if (triggerTime[index + 1] != null) {
					timer.delay = (triggerTime[index + 1] - triggerTime[index]);
					timer.start();
					index ++;
				}
			}
		}
		
		public function init(arrTriggerTime:Array, arrCallbackFuncs:Array):void {
			triggerTime = arrTriggerTime;
			callbackFuncs = arrCallbackFuncs;
			
			start();
		}
		
		public function start():void {
			if (timer.running)	timer.stop();
			var loginTime:Number = Game.database.userdata.loginTime;
			var i:int = 0;
			for each (var value:Number in triggerTime) {
				if (value > loginTime) {
					timer.delay = (value - loginTime);
					index = i;
					timer.start();
					if (callbackFuncs[i - 1] != null) {
						for each (var func:Function in callbackFuncs[i - 1]) {
							func();
						}
					}
					break;
				}
				i++;
			}
		}
		
		public static function getInstance():FeatureManager {
			if (!instance) {
				instance = new FeatureManager();
			}
			
			return instance;
		}
	}

}