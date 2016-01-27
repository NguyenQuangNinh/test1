package game.ui.quest_daily 
{
	import core.event.EventEx;
	import core.Manager;
	import core.util.FontUtil;
	import core.util.MovieClipUtils;
	import core.util.Utility;

	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.text.TextField;

	import game.Game;
	import game.data.vo.quest_main.QuestInfo;
	import game.data.vo.quest_transport.ConditionInfo;
	import game.data.xml.LevelQuestDailyXML;
	import game.data.xml.RewardXML;
	import game.enum.Direction;
	import game.enum.FeatureEnumType;
	import game.enum.Font;
	import game.enum.QuestState;
	import game.ui.components.ItemSlot;
	import game.ui.components.Reward;
	import game.ui.message.MessageID;
	import game.ui.quest_transport.QuestTransportEventName;
	import game.ui.tooltip.TooltipEvent;
	import game.ui.tooltip.TooltipID;
	import game.ui.tutorial.TutorialEvent;
	import game.utility.GameUtil;
	import game.utility.UtilityEffect;
	import game.utility.UtilityUI;
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class QuestDailyUI extends MovieClip
	{
		
		public var nameTf:TextField;
		public var conditionTf:TextField;
		public var countTf:TextField;
		public var finishMov:MovieClip;
		public var hitMov:MovieClip;
		
		public var goToBtn:SimpleButton;
		public var receiveBtn:MovieClip;
		public var quickCompleteBtn:MovieClip;
		
		public var rewardsMov:MovieClip;
		
		public static const QUEST_DAILY_SELECTED:String = "questDailySelected";
		public static const FINISH_DAILY_QUEST:String = "finishDailyQuest";
		public static const QUICK_COMPLETE_DAILY_QUEST:String = "quickCompleteDailyQuest";
		public static const SHOW_QUEST_DAILY_EFFECT_COMPLETED:String = "showQuestDailyEffectCompleted";
		public static const GO_TO_DAILY_ACTION:String = "go_to_daily_action";
		
		private static const DISTANCE_X_PER_REWARD:int = -20 + 100;
		
		private var _info:QuestInfo;
		
		private var _glow: GlowFilter;
		private var _rewardSlotArr:Array = [];
		
		private var _numCompleted:int;
		private var _totalComplete:int;
		private var _index:int = -1;
		
		public function QuestDailyUI() 
		{
			initUI();
		}
		
		private function initUI():void 
		{
			gotoAndStop("normal");
			//set fonts
			FontUtil.setFont(nameTf, Font.ARIAL, false);
			FontUtil.setFont(conditionTf, Font.ARIAL, false);
			FontUtil.setFont(countTf, Font.ARIAL, false);	
			nameTf.mouseEnabled = false;
			conditionTf.mouseEnabled = false;
			finishMov.visible = false;	
			
			hitMov.buttonMode = true;
			hitMov.addEventListener(MouseEvent.CLICK, onClickHdl);
			
			_glow = new GlowFilter();
			_glow.strength = 10;
			_glow.blurX = _glow.blurY = 4;
			
			receiveBtn.buttonMode = true;
			quickCompleteBtn.buttonMode = true;
			receiveBtn.addEventListener(MouseEvent.CLICK, onBtnClickHdl);			
			quickCompleteBtn.addEventListener(MouseEvent.CLICK, onBtnClickHdl);
			
			//add events
			goToBtn.addEventListener(MouseEvent.CLICK, onStartClickHdl);
			goToBtn.addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			goToBtn.addEventListener(MouseEvent.ROLL_OUT, onRollOut);
		}
		
		private function onRollOut(e:MouseEvent):void
		{
			dispatchEvent(new EventEx(TooltipEvent.HIDE_TOOLTIP, null, true));
		}
		
		private function onRollOver(e:MouseEvent):void
		{
			switch (e.target)
			{
				case goToBtn:
						dispatchEvent(new EventEx(TooltipEvent.SHOW_TOOLTIP, {type: TooltipID.SIMPLE, value: "VIP: Tới ngay nơi làm nhiệm vụ."}, true));
					break;
				default: 
			}
		
		}
		
		private function onStartClickHdl(e:MouseEvent):void 		
		{
			var condition:ConditionInfo = _info && _info.xmlData && _info.xmlData.conditionsFinish.length > 0 ? _info.xmlData.conditionsFinish[0] : null;
			dispatchEvent(new EventEx(GO_TO_DAILY_ACTION, condition, true));
			dispatchEvent(new EventEx(TutorialEvent.EVENT, {type: TutorialEvent.START_DAILY_QUEST}, true));
		}
		
		private function onClickHdl(e:MouseEvent = null):void 
		{			
			dispatchEvent(new EventEx(QUEST_DAILY_SELECTED, _info, true));
		}
		
		private function onBtnClickHdl(e:MouseEvent):void 
		{
			switch(e.target) {				
				case receiveBtn:
					dispatchEvent(new EventEx(FINISH_DAILY_QUEST, _index, true ));
					dispatchEvent(new EventEx(TutorialEvent.EVENT, {type: TutorialEvent.FINISH_DAILY_QUEST}, true));
					break;
				case quickCompleteBtn:
					//if (_numCompleted == _totalComplete)
						//Manager.display.showMessageID(MessageID.QUEST_DAILY_REACH_MAX_COMPLETED);
					//else 
						dispatchEvent(new EventEx(QUICK_COMPLETE_DAILY_QUEST, _index, true));
					break;
			}
		}

		public function showHintStart():void
		{
			Game.hint.showHint(goToBtn, Direction.LEFT, goToBtn.x+ goToBtn.width, goToBtn.y + goToBtn.height/2, "Đến nơi làm nhiệm vụ");
		}

		public function showHintFinish():void
		{
			Game.hint.showHint(receiveBtn, Direction.LEFT, receiveBtn.x+ receiveBtn.width, receiveBtn.y + receiveBtn.height/2, "Click chuột");
		}

		public function updateInfo(index:int, quest:QuestInfo):void {
			_index = index;
			_info = quest;
			
			if (_info) {
				var htmlText:String = "<font color = '" + UtilityUI.getTxtColor(quest.difficulty, false, quest.difficulty == 4) + "'>" + (quest.xmlData ? quest.xmlData.name : "") + "</font>";
				_glow.color = UtilityUI.getTxtGlowColor(quest.difficulty, false, quest.difficulty == 4);
				//_glow.color = UtilityUI.getTxtGlowColor(quest.difficulty, false, true);
				nameTf.filters = [_glow];
				nameTf.htmlText = htmlText;
				FontUtil.setFont(nameTf, Font.ARIAL, false);
				finishMov.visible = quest.state == QuestState.STATE_FINISHED_SUCCESS 
									|| quest.state == QuestState.STATE_CLOSED ? true : false;
				if (_info.state == QuestState.STATE_CLOSED)
					MovieClipUtils.applyGrayScale(this);
			}
			
			//update condition
			var condition:ConditionInfo = _info.xmlData.conditionsFinish[0] as ConditionInfo;
			conditionTf.text = condition && condition.xmlData ? condition.xmlData.name : "";
			countTf.text = condition.value + "/" + condition.xmlData.quantity;					
			goToBtn.visible = GameUtil.checkGoToActionValid(condition.xmlData.type) && condition.value < condition.xmlData.quantity;	
			
			//update receive btn
			//quickCompleteBtn.visible = info.state == QuestState.QUEST_STATE_RECEIVED;
			//receiveBtn.visible = info.state == QuestState.QUEST_STATE_FINISHED_SUCCESS;
			if (_info.state == QuestState.STATE_FINISHED_SUCCESS) {
				receiveBtn.mouseEnabled = true;
//				receiveBtn.gotoAndStop("active");
				Utility.setGrayscale(receiveBtn, false);
			}else {
				receiveBtn.mouseEnabled = false;
//				receiveBtn.gotoAndStop("inactive");
				Utility.setGrayscale(receiveBtn, true);
			}
			
			if (_info.state != QuestState.STATE_CLOSED) {
				quickCompleteBtn.mouseEnabled = true;
//				quickCompleteBtn.gotoAndStop("active");
				Utility.setGrayscale(quickCompleteBtn, false);
			}else {
				quickCompleteBtn.mouseEnabled = false;
				Utility.setGrayscale(quickCompleteBtn, true);
			}
			
			//update fix rewards
			//var rewards:Array = getItemRewardsByID(itemID);
			var levelXML:LevelQuestDailyXML = GameUtil.getLevelInRange(FeatureEnumType.QUEST_DAILY, _info.playerLevelReceivedQuest) as LevelQuestDailyXML;
			var rewardID:int = levelXML ? levelXML.arrReward[_info.difficulty] : -1;
			var rewards:Array = GameUtil.getItemRewardsByID(rewardID);
			
			MovieClipUtils.removeAllChildren(rewardsMov);
			//var rewards:Array = _info.xmlData.getFixRewards();				
			for (var i:int = 0; i < rewards.length; i++)  {
				var reward:Reward = new Reward();
				reward.changeType(Reward.QUEST);
				rewardsMov.addChild(reward);
				reward.x = (DISTANCE_X_PER_REWARD) * i;
				reward.y = -15;
				reward.updateInfo((rewards[i] as RewardXML).getItemInfo(), (rewards[i] as RewardXML).quantity);
			}
		}
		
		public function setSelected(selected:Boolean):void {
			gotoAndStop(selected && _info.state != QuestState.STATE_CLOSED ? "selected" : "normal");
		}
		
		public function showEffectCompleted(bonus:Boolean = false): void {
			var child:Reward;
			var childPos:Point;
			//var childType:ItemType;					
			
			for (var i:int = 0; i < rewardsMov.numChildren; i++) {
				child = rewardsMov.getChildAt(i) as Reward;
				//childType = child.getItemConfig().getType();
				childPos = child.getGlobalPos();
				var itemSlot:ItemSlot = Manager.pool.pop(ItemSlot) as ItemSlot;
				if (itemSlot) {
					itemSlot.x = childPos.x;
					itemSlot.y = childPos.y;
					if (bonus) {
						itemSlot.setBonusquantity("x 2");
					}
					itemSlot.setConfigInfo(child.getItemConfig(), TooltipID.ITEM_COMMON);
					itemSlot.setQuantity(child.getQuantity());
					_rewardSlotArr.push(itemSlot);
				}
			}
			//Utility.log("num reward to show effect is " + _rewardSlotArr.length);
			UtilityEffect.tweenItemEffects(_rewardSlotArr, onShowEffectCompleted, true);
		}
		
		private function onShowEffectCompleted():void 
		{		
			for each(var slot:ItemSlot in _rewardSlotArr) {
				slot.reset();
				Manager.pool.push(slot, ItemSlot);
			}			
			_rewardSlotArr = [];
			dispatchEvent(new Event(SHOW_QUEST_DAILY_EFFECT_COMPLETED, true));
		}
	}

}