package game.data.model 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	/**
	 * ...
	 * @author MaiPTT
	 */
	public class GlobalBossData extends EventDispatcher
	{
		static public const REVIVE_COUNT_DOWN	:String = "reviveCountDown";
		public var missionIDs			:Array = [];
		public var autoRevive			:Boolean = false;
		public var autoPlay				:Boolean = false;
		public var buffPercent			:int = -1;
		public var currentMissionStatus	:int = -1;
		public var currentDmg			:int = 0;
		public var rewards				:Array = [];
		public var timeUp				:Boolean = false;
		public var currentGoldBuff		:int = -1;
		public var maxGoldBuff			:int = -1;
		public var currentXuBuff		:int = -1;
		public var maxXuBuff			:int = -1;
		public var currentMissionID		:int = -1;
		
		private var reviveCountDown		:int = -1;
		private var timer				:Timer = new Timer(1000, 0);
		private var isReviveCountDown	:Boolean = false;
		
		public function setReviveCountDown(value:int):void {
			if (!autoRevive) {
				reviveCountDown = value;
				if (timer.running) {
					timer.stop();
				}
				if (!timer.hasEventListener(TimerEvent.TIMER)) {
					timer.addEventListener(TimerEvent.TIMER, onReviveTimer);
				}
				isReviveCountDown = true;
				timer.start();
			} else {
				reviveCountDown = -1;
			}
		}
		
		public function getReviveCountDown():int {
			return reviveCountDown;
		}
		
		public function getIsReviveCountDown():Boolean {
			return isReviveCountDown;
		}
		
		public function setIsReviveCountDown(value:Boolean):void {
			isReviveCountDown = value;
			if (!isReviveCountDown) {
				if (timer.running) {
					timer.stop();
				}
				if (timer.hasEventListener(TimerEvent.TIMER)) {
					timer.removeEventListener(TimerEvent.TIMER, onReviveTimer);
				}
				reviveCountDown = 0;
				dispatchEvent(new Event(REVIVE_COUNT_DOWN, true));
			}
		}
		
		private function onReviveTimer(e:TimerEvent):void {
			if (reviveCountDown > 0) {
				reviveCountDown --;
			} else {
				isReviveCountDown = false;
				timer.stop();
				timer.removeEventListener(TimerEvent.TIMER, onReviveTimer);
			}
			dispatchEvent(new Event(REVIVE_COUNT_DOWN, true));
		}
	}

}