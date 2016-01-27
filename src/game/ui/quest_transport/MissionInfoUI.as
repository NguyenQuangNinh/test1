package game.ui.quest_transport 
{
	import core.event.EventEx;
	import core.util.FontUtil;
	import core.util.Utility;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.utils.getDefinitionByName;
	import flash.utils.Timer;

	import game.Game;

	import game.ui.tutorial.TutorialEvent;
	import game.utility.UtilityUI;
	import game.data.vo.quest_transport.MissionInfo;
	import game.enum.Font;
	import game.enum.QuestState;
	import game.ui.components.SmallStar;
	import game.ui.components.StarChain;
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class MissionInfoUI extends MovieClip
	{
		public static const MISSION_COMPLETED:String = "missionCompleted";
		private static const MAX_DIFFICULTY_GOLD:int = 5;
		private static const GOLD_START_FROM_X:int = 232;
		private static const GOLD_START_FROM_Y:int = 10;
		
		public var missionTf:TextField;
		public var timeTf:TextField;
		public var bgMov:MovieClip;
		
		public var skipBtn:SimpleButton;
		public var finishMov:MovieClip;
		
		public var processTimeMov:MovieClip;
		public var hitMov:MovieClip;
		
		private var _info:MissionInfo;
		
		private var _timer:Timer;
		private var _remainCount:int;		
		
		private var _golds:Array = [];
		private var _glow: GlowFilter;
		
		public function MissionInfoUI() 
		{
			/*if (stage)
				init();
			else addEventListener(Event.ADDED_TO_STAGE, init);	*/
			initUI();
		}
		
		/*private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
		}*/
		
		private function initUI():void 
		{
			//gotoAndStop("normal");
			
			//set fonts
			FontUtil.setFont(missionTf, Font.ARIAL, false);
			//FontUtil.setFont(difficultTf, Font.ARIAL, true);
			FontUtil.setFont(timeTf, Font.ARIAL, false);
			
			//create component
			for (var i:int = 0; i < MAX_DIFFICULTY_GOLD; i++) {
				var gold:MovieClip = new (getDefinitionByName("Gold") as Class)();
				gold.x = GOLD_START_FROM_X + (gold.width - 2) * i;
				gold.y = GOLD_START_FROM_Y;
				gold.visible = false;
				addChild(gold);
				_golds.push(gold);
			}
			
			//add events
			swapChildren(gold,hitMov)
			hitMov.buttonMode = true;
			hitMov.addEventListener(MouseEvent.CLICK, onSelectedHdl);
			skipBtn.addEventListener(MouseEvent.CLICK, onBtnClickHdl);
			
			//hide component
			processTimeMov.visible = false;
			skipBtn.visible = false;			
			
			//init timer
			_timer = new Timer(1000);
			_timer.addEventListener(TimerEvent.TIMER, onTimerUpdateHdl);
			
			_glow = new GlowFilter();
			_glow.strength = 10;
			_glow.blurX = _glow.blurY = 2;
		}
		
		public function onSelectedHdl(e:MouseEvent = null):void 
		{
			dispatchEvent(new EventEx(QuestTransportEventName.MISSION_SELECTED, _info, true));
			Game.stage.dispatchEvent(new EventEx(TutorialEvent.EVENT, {type: TutorialEvent.SELECT_TRANSPORT_QUEST}, true));
		}
		
		private function onTimerUpdateHdl(e:TimerEvent):void 
		{
			_remainCount = _remainCount > 0 ? _remainCount - 1 : 0;
			timeTf.text = Utility.math.formatTime("M-S", _remainCount);
			//Utility.log("mission on update timer from missionInfoUI: " + timeTf.text);
			
			if (_remainCount == 0) {
				_timer.stop();
				dispatchEvent(new EventEx(MISSION_COMPLETED, _info, true));
			}
		}
		
		private function onBtnClickHdl(e:MouseEvent):void 
		{
			switch(e.target) {
				case skipBtn:
					_info.timeCurrent = _remainCount;
					dispatchEvent(new EventEx(QuestTransportEventName.SKIP_MISSION, _info, true));
					break;
			}
		}
		
		
		public function update(info:MissionInfo):void {
			_info =	info;
			
			if (_info && _info.xmlData) {
				//missionTf.text = _info.xmlData.name.toString();
				var htmlText:String = "<font color = '" + UtilityUI.getTxtColor(info.difficulty, false, info.difficulty == 5) + "'>" + info.xmlData.name + "</font>";
				_glow.color = UtilityUI.getTxtGlowColor(info.difficulty, false, info.difficulty == 5);
				//_glow.color = UtilityUI.getTxtGlowColor(quest.difficulty, false, true);
				missionTf.filters = [_glow];
				missionTf.htmlText = htmlText;
				FontUtil.setFont(missionTf, Font.ARIAL, false);
				
				_timer.stop();
				//difficultTf.text = _info.difficulty.toString();
				setDifficulty(_info.difficulty - 1);
				_remainCount = info.timeCurrent;
				processTimeMov.visible = info.state == QuestState.STATE_ACTIVED ? true : false;
				finishMov.visible = info.state == QuestState.STATE_FINISHED_SUCCESS ? true : false;
				skipBtn.visible = processTimeMov.visible;
				
				if (info.state == QuestState.STATE_ACTIVED) {					
					timeTf.text = Utility.math.formatTime("M-S", _remainCount);
					startCountDown();
				}
			}
		}
		
		private function setDifficulty(diff:int): void {
			for (var i:int = 0; i < MAX_DIFFICULTY_GOLD ; i++) {
				var gold:MovieClip = _golds[i];
				gold.visible = i <= diff ? true : false;
			}
		}
		
		public function setSelected(select:Boolean): void {
			bgMov.gotoAndStop(select ? "selected" : "normal");
		}
		
		public function stopCountDown():void {
			_timer.stop();
		}
		
		public function startCountDown():void {
			Utility.log( "MissionInfoUI.startCountDown " + _remainCount);
			_timer.start();
		}

		public function isActivated():Boolean
		{
			return _info && _info.state == QuestState.STATE_ACTIVED;
		}
	}

}