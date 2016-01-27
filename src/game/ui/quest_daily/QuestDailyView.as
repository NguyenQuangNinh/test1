package game.ui.quest_daily 
{

	import com.greensock.TimelineLite;
	import com.greensock.TweenAlign;
	import com.greensock.TweenLite;

	import core.display.animation.Animator;
	import core.display.ViewBase;
	import core.event.EventEx;
	import core.Manager;
	import core.util.FontUtil;
	import core.util.MathUtil;
	import core.util.MovieClipUtils;
	import core.util.Utility;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import flash.utils.Timer;
	import flash.utils.setTimeout;

	import game.data.model.item.ItemFactory;
	import game.data.xml.LevelQuestDailyXML;
	import game.data.xml.VIPConfigXML;
	import game.enum.Direction;
	import game.enum.FeatureEnumType;
	import game.enum.GameConfigID;
	import game.net.IntRequestPacket;
	import game.net.lobby.LobbyRequestType;
	import game.ui.components.ItemSlot;
	import game.ui.tooltip.TooltipEvent;
	import game.ui.tooltip.TooltipID;
	import game.ui.tutorial.TutorialEvent;
	import game.utility.UtilityEffect;
	//import game.data.enum.quest.QuestState;
	import game.data.vo.quest_main.QuestInfo;
	import game.data.xml.DataType;
	//import game.data.xml.item.ItemChestXML;
	import game.data.xml.RewardXML;
	import game.enum.Font;
	import game.enum.ItemType;
	import game.enum.QuestState;
	import game.Game;
	import game.ui.components.Reward;
	import game.ui.message.MessageID;
	import game.utility.GameUtil;
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class QuestDailyView extends ViewBase
	{
		
		public static const QUICK_REFRESH_DAILY_QUEST:String = "quickRefreshDailyQuest";
		public static const COMPLETED_COUNT_DOWN:String = "completedCountDown";			
		
		public var numCompletedTf:TextField;
		public var freeTimeTf:TextField;
		public var timeTf:TextField;
		public var vipTf:TextField;
		public var moreTf:TextField;
		public var questsMov:MovieClip;
		
		public var closeBtn:SimpleButton;
		public var refreshBtn:SimpleButton;
		public var accumulateMov:AccumulateBarUI;
		//public var rewardsMov:MovieClip;
		//public var receiveBtn:SimpleButton;
		//public var quickCompleteBtn:SimpleButton;
		
		//private var _questsMov:MovieClip;
		//private var _ropesMov:MovieClip;
		
		private var _quests:Array = [];
		private var _questSelectedIndex:int = -1;
		
		private static const DISTANCE_PER_QUEST:int = 0;	// -16 + 15;
		private static const QUEST_START_FROM_X:int = 370;	// 73 + 180 + 27;
		private static const QUEST_START_FROM_Y:int = 170;	// 132 + 108; 
		//private static const DISTANCE_PER_CONDITION:int = 5;		
		
		//private static const ROPE_DELTA_X:int = 4;
		//private static const ROPE_DELTA_Y:int = -13;
		
		private static const EFFECT_START_FROM_X:int = 330;
		private static const EFFECT_START_FROM_Y:int = 480;
			
		private var _timer:Timer;
		private var _remainCount:int;
		private var _numCompleted:int;
		private var _totalComplete:int;
		
		private var _firstShow:Boolean = true;		
		
		public function QuestDailyView() 
		{
			initUI();
		}
		
		private function initUI():void 
		{
			//set font
			FontUtil.setFont(numCompletedTf, Font.ARIAL, false);
			FontUtil.setFont(timeTf, Font.ARIAL, false);
			FontUtil.setFont(vipTf, Font.ARIAL, false);
			FontUtil.setFont(moreTf, Font.ARIAL, false);
			FontUtil.setFont(freeTimeTf, Font.ARIAL, false);
			
			//quest container
			/*_questsMov = new MovieClip();
			_questsMov.x = QUEST_START_FROM_X;
			_questsMov.y = QUEST_START_FROM_Y;
			addChild(_questsMov);*/
			
			//rope container
			/*_ropesMov = new MovieClip();
			_ropesMov.x = QUEST_START_FROM_X;
			_ropesMov.y = QUEST_START_FROM_Y;
			_ropesMov.mouseEnabled = false;
			_ropesMov.mouseChildren = false;
			addChild(_ropesMov);*/
			
			accumulateMov.mouseEnabled = false;
			
			//add events
			closeBtn.addEventListener(MouseEvent.CLICK, onBtnClickHdl);
			refreshBtn.addEventListener(MouseEvent.CLICK, onBtnClickHdl);
			//receiveBtn.addEventListener(MouseEvent.CLICK, onBtnClickHdl);
			//quickCompleteBtn.addEventListener(MouseEvent.CLICK, onBtnClickHdl);
			addEventListener(QuestDailyUI.QUEST_DAILY_SELECTED, onQuestSelectedHdl);
			
			//init timer
			_timer = new Timer(1000);
			_timer.addEventListener(TimerEvent.TIMER, onTimerUpdateHdl);
			
			refreshBtn.addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			refreshBtn.addEventListener(MouseEvent.ROLL_OUT, onRollOut);
		}

		private function onRollOut(e:MouseEvent):void
		{
			dispatchEvent(new EventEx(TooltipEvent.HIDE_TOOLTIP, null, true));
		}
		
		private function onRollOver(e:MouseEvent):void
		{
			switch (e.target)
			{
				case refreshBtn:
						dispatchEvent(new EventEx(TooltipEvent.SHOW_TOOLTIP, {type: TooltipID.SIMPLE, value: "Tạo nhiệm vụ mới."}, true));
					break;
			}
		}
		
		private function onTimerUpdateHdl(e:TimerEvent):void 
		{
			_remainCount = _remainCount > 0 ? _remainCount - 1 : 0;
			timeTf.text = Utility.math.formatTime("M-S", _remainCount);
			//Utility.log("mission on update timer from missionInfoUI: " + timeTf.text);
			
			if (_remainCount == 0) {
				_timer.stop();
				dispatchEvent(new EventEx(COMPLETED_COUNT_DOWN, true));
			}
		}	
		
		public function stopCountDown():void {
			_timer.stop();
		}
		
		public function startCountDown():void {
			//Utility.log( "QuestDailyView.startCountDown " + _remainCount);
			_timer.start();
		}
		
		private function onQuestSelectedHdl(e:EventEx):void 
		{
			if (e.data) {
				updateQuestSelected(e.data as QuestInfo);
			}
		}
		
		private function onBtnClickHdl(e:MouseEvent):void 
		{
			switch(e.target) {
				case closeBtn:
					dispatchEvent(new Event(Event.CLOSE));
					break;
				case refreshBtn:
					if (_numCompleted == _totalComplete)
						Manager.display.showMessageID(MessageID.QUEST_DAILY_REACH_MAX_COMPLETED);
					else 
						dispatchEvent(new EventEx(QUICK_REFRESH_DAILY_QUEST));
					break;
			}
		}
		
		public function updateQuests(data:Array):void {
			_quests = data;
			if (_quests) {
				//reset all quest
				MovieClipUtils.removeAllChildren(questsMov);
				var quest:QuestDailyUI;
				//var rope:MovieClip;
				for (var i:int = 0; i < _quests.length; i++) {
					quest = new QuestDailyUI();
					quest.y = (DISTANCE_PER_QUEST + quest.height) * i;
					questsMov.addChild(quest);
					//rope = new (getDefinitionByName("Rope") as Class)();
					//rope.x = ROPE_DELTA_X;
					//rope.y = quest.y + ROPE_DELTA_Y;
					//_ropesMov.addChild(rope);
					quest.updateInfo(i, data[i]);
				}
				
				//set quest auto selected
				var info:QuestInfo;
				if (_quests.length > 0) {
					if (_questSelectedIndex < 0 || _questSelectedIndex >= _quests.length) {
						info = _quests[0];
					}else {
						info = _quests[_questSelectedIndex];
					}
					updateQuestSelected(info);
				}
				
				
				//update total score and reward accumalate // current point target
			}			
		}
		
		public function updateState(current:int, total:int, remain:int, accumulatePoint:int, indexAccumulated:int):void {
			var prices: Array = Game.database.gamedata.getConfigData(GameConfigID.QUEST_DAILY_PRICE_REFRESH) as Array; 
			var freeTimeNum:int = 0;
			for (var i:int = 1; i < prices.length; i++) 
			{
				if (prices[i] == 0) freeTimeNum++;
			}
			// the first element of array is not used
//			if (freeTimeNum > 0) freeTimeNum--;
			var dailyRefreshTime:int = Game.database.userdata.nDailyQuestRefresh;
			var remainFreeTime:int =  dailyRefreshTime > freeTimeNum ? 0 : freeTimeNum - dailyRefreshTime;
			freeTimeTf.text = remainFreeTime.toString();
			//update num quests completed and time remain to refresh
			_numCompleted = current;
			_totalComplete = total;
			_remainCount = remain;
			
			numCompletedTf.text = "Số lần nhận hôm nay: " + current + "/" + total;
			timeTf.text = Utility.math.formatTime("M-S", remain);
			if(remain > 0)
				startCountDown();
				
			accumulateMov.setAccumulatePoint(accumulatePoint, indexAccumulated, _firstShow);
			_firstShow = false;
			
			//update vip info to display
			var currentVip:int = Game.database.userdata.vip;
			var currentVipInfo:VIPConfigXML = Game.database.gamedata.getData(DataType.VIP, currentVip) as VIPConfigXML;
			var numQuestAdd:int = currentVipInfo ? currentVipInfo.dailyQuestAddCount : 0;
			
			var vipInfoDic:Dictionary = Game.database.gamedata.getTable(DataType.VIP);
			var numQuestAccumulate:int = 0;
			for each(var vipXML:VIPConfigXML in vipInfoDic) {				
				numQuestAccumulate = vipXML.dailyQuestAddCount;
				if (vipXML.ID > currentVip && numQuestAccumulate > numQuestAdd)
					break;				
			}
			
			vipTf.text = vipXML.ID.toString();
			moreTf.text = (vipXML.dailyQuestAddCount - numQuestAdd).toString();
		}
		
		public function updateQuestSelected(info:QuestInfo): void {
			var index:int = _quests.indexOf(info);
			if (index >= 0) {
				var quest:QuestDailyUI;
				//reset current quest selected
				if (_questSelectedIndex >= 0 && _questSelectedIndex < questsMov.numChildren) {
					quest = questsMov.getChildAt(_questSelectedIndex) as QuestDailyUI;
					quest.setSelected(false);
				}
				//update quest selected and UI
				_questSelectedIndex = index;
				quest = questsMov.getChildAt(index) as QuestDailyUI;
				quest.setSelected(true);
			}
		}
		
		public function updateRewardAccumulate(level:int):void {
			var levelXML:LevelQuestDailyXML = GameUtil.getLevelInRange(FeatureEnumType.QUEST_DAILY, level) as LevelQuestDailyXML;
			accumulateMov.updateRewardAccumulate(levelXML);
		}
		
		public function selectQuest(index:int):void {
			if (index >= 0 && index < _quests.length) {
				//_questSelectedIndex = index;
				updateQuestSelected(_quests[index] as QuestInfo);
			}
		}
		
		public function showEffectCompleted(bonus:Boolean = false): void {
			if(_questSelectedIndex >= 0 && _questSelectedIndex < questsMov.numChildren) {
				var quest:QuestDailyUI = questsMov.getChildAt(_questSelectedIndex) as QuestDailyUI;
				quest.showEffectCompleted(bonus);
			}
		}

		//TUTORIAL

		public function showHintButton():void
		{
			var info:QuestInfo;
			var item:QuestDailyUI;
			var i:int = 0;

			for (i = 0; i < _quests.length; i++)
			{
				info = _quests[i] as QuestInfo;
				if(info.state == QuestState.STATE_FINISHED_SUCCESS)
				{
					item = questsMov.getChildAt(i) as QuestDailyUI;
					break;
				}
			}

			if(item)
			{
				//Co quest hoan thanh roi.
				item.showHintFinish();
			}
			else
			{
				//Huong dan lam 1 quest chua hoan thanh
				for (i = 0; i < _quests.length; i++)
				{
					info = _quests[i] as QuestInfo;
					if(info.state == QuestState.STATE_RECEIVED)
					{
						item = questsMov.getChildAt(i) as QuestDailyUI;
						break;
					}
				}
				if(item)
				{
					item.showHintStart();
				}
				else
				{
					Game.hint.hideHint();
				}
			}
		}

		public function showHintAccumulateBar():void
		{
			Game.hint.showHint(accumulateMov, Direction.DOWN, accumulateMov.x + accumulateMov.width/2, accumulateMov.y + 20, "Tích lũy điểm để nhận thưởng.");
			setTimeout(Game.hint.hideHint, 5000);
			hilightAccBar();
		}

		public function hilightAccBar():void
		{
			var timeLine:TimelineLite = new TimelineLite({ onComplete: onCompleteTween});
			timeLine.insertMultiple([new TweenLite(accumulateMov, 1, { glowFilter:{color:0xFFFFFF, alpha:1, blurX:20, blurY:20, strength:2, quality:3}}),
						new TweenLite(accumulateMov, 0.8, { glowFilter:{color:0xFFFFFF, alpha:0, blurX:0, blurY:0, strength:2, quality:3}})],
					0,
					TweenAlign.SEQUENCE,
					4);
		}

		private function onCompleteTween():void
		{
			accumulateMov.filters = [];
			Game.stage.dispatchEvent(new EventEx(TutorialEvent.EVENT, {type: TutorialEvent.HILIGHT_ACC_BAR_DAILY_QUEST}, true));
		}
	}

}