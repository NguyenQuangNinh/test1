package game.ui.quest_main 
{
	import components.scroll.VerScroll;
	import core.display.animation.Animator;
	import core.display.ViewBase;
	import core.event.EventEx;
	import core.Manager;
	import core.util.FontUtil;
	import core.util.MovieClipUtils;
	import core.util.Utility;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import game.data.model.item.ItemFactory;
	import game.data.xml.DataType;
	import game.data.xml.QuestMainXML;
	import game.data.xml.RewardXML;
	import game.enum.Direction;
	import game.enum.ItemType;
	import game.enum.QuestState;
	import game.Game;
	import game.data.vo.quest_main.QuestInfo;
	import game.enum.Font;
	import game.net.IntRequestPacket;
	import game.net.lobby.LobbyRequestType;
	import game.ui.components.ItemSlot;
	import game.ui.components.Reward;
	import game.ui.components.ScrollBar;
	import game.ui.quest_transport.QuestTransportEventName;
	import game.ui.tooltip.TooltipID;
	import game.ui.tutorial.TutorialEvent;
	import game.utility.UtilityEffect;
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class QuestMainView extends ViewBase
	{
		public static const FINISH_MAIN_QUEST:String = "finishMainQuest";
		public static const SHOW_QUEST_MAIN_EFFECT_COMPLETED:String = "showQuestMainEffectCompleted";
		public static const SHOW_QUEST_MAIN_FINISH_COMPLETED:String = "showQuestMainFinishCompleted";
		
		public var descTf:TextField;
		public var scroller:VerScroll;
		public var scroll:MovieClip;
		public var maskMov:MovieClip;
		public var conditionsMov:MovieClip;
		public var rewardsMov:MovieClip;
		public var optionRewardsMov:MovieClip;
		
		public var closeBtn:SimpleButton;
		public var receiveBtn:SimpleButton;
		
		private var _questsMov:MovieClip;
		
		private var _quests:Array = [];
		private var _questSelectedIndex:int = -1;
		private var _optionalRewardSelectedIndex:int = -1;
		
		private static const DISTANCE_PER_QUEST:int = 5 + 28;
		private static const DISTANCE_PER_CONDITION:int = 5;
		private static const DISTANCE_X_PER_REWARD:int = -20 + 110;
		//private static const DISTANCE_X_PER_REWARD:int = -20 /*+ 80*/;
		
		private var _animComplete:Animator;
		private var _rewardSlotArr:Array = [];
		
		public function QuestMainView() 
		{
			if (stage)
				init();
			else addEventListener(Event.ADDED_TO_STAGE, init);			
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			initUI();
		}
		
		private function initUI():void 
		{
			//set font
			FontUtil.setFont(descTf, Font.ARIAL, false);
			
			//quest container
			_questsMov = new MovieClip();
			_questsMov.x = maskMov.x;
			_questsMov.y = maskMov.y;
			addChild(_questsMov);
			
			//add events
			closeBtn.addEventListener(MouseEvent.CLICK, onBtnClickHdl);
			receiveBtn.addEventListener(MouseEvent.CLICK, onBtnClickHdl);
			_questsMov.addEventListener(QuestMainUI.QUEST_MAIN_SELECTED, onQuestSelectedHdl);
			optionRewardsMov.addEventListener(Reward.SELECTED, onOptionRewardSelectedHdl);
			
			_animComplete = new Animator();			
			_animComplete.load("resource/anim/ui/hoanthanhnv.banim");
			_animComplete.x = 580;
			_animComplete.y = 300;
			_animComplete.stop();
			_animComplete.visible = false;
			_animComplete.addEventListener(Event.COMPLETE, onAnimCompleteHdl);
			//_animComplete.addEventListener(Animator.LOADED, onAnimLoadCompleteHdl);
			addChild(_animComplete);
		}
		
		/*private function onAnimLoadCompleteHdl(e:Event):void 
		{
			_animComplete.x = (Game.WIDTH - _animComplete.width) / 2;
			_animComplete.y = (Game.HEIGHT - _animComplete.height) / 2;
			Utility.log( "_animComplete : " + _animComplete.x + " // " + _animComplete.y );
		}*/
		
		private function onAnimCompleteHdl(e:Event):void 
		{
			_animComplete.visible = false;
			showEffectCompleted();
			//dispatchEvent(new Event(SHOW_QUEST_MAIN_FINISH_COMPLETED));
		}
		
		private function onOptionRewardSelectedHdl(e:Event):void 
		{
			//reset selected
			for (var i:int = 0; i < optionRewardsMov.numChildren; i++) {
				var child:Reward = optionRewardsMov.getChildAt(i) as Reward;
				child.setSelected(false);
			}
			//set seleted
			_optionalRewardSelectedIndex = optionRewardsMov.getChildIndex(e.target as DisplayObject);
			if (_optionalRewardSelectedIndex > -1) {
				child = optionRewardsMov.getChildAt(_optionalRewardSelectedIndex) as Reward;
				child.setSelected(true);
			}			
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
					dispatchEvent(new EventEx(TutorialEvent.EVENT, { type:TutorialEvent.CLOSE_QUEST_PANEL }, true));
					dispatchEvent(new Event(Event.CLOSE));
					break;
				case receiveBtn:
					if (_questSelectedIndex > -1) {
						var quest:QuestInfo = _quests[_questSelectedIndex] as QuestInfo;
						_optionalRewardSelectedIndex = quest && quest.xmlData &&
													quest.xmlData.optionalRewardIDs.length > 0
													? _optionalRewardSelectedIndex : -2;
						Utility.log("quest main optional reward sending :" + _optionalRewardSelectedIndex);
						dispatchEvent(new EventEx(TutorialEvent.EVENT, { type:TutorialEvent.CLOSE_QUEST }, true));
					}
					dispatchEvent(new EventEx(FINISH_MAIN_QUEST, { questIndex: _questSelectedIndex, optionIndex: _optionalRewardSelectedIndex } ));
					break;
			}
		}
		
		public function updateQuests(data:Array):void {
			_quests = data;
			if (_quests) {
				//reset all quest
				MovieClipUtils.removeAllChildren(_questsMov);
				//update desc
				descTf.text = "";
				//update receive btn
				receiveBtn.visible = false;
				//update condition
				MovieClipUtils.removeAllChildren(conditionsMov);
				//update fix rewards
				MovieClipUtils.removeAllChildren(rewardsMov);
				
				var quest:QuestMainUI;
				for (var i:int = 0; i < _quests.length; i++) {
					quest = new QuestMainUI();
					quest.y = (DISTANCE_PER_QUEST /*+ quest.height*/) * i;
					_questsMov.addChild(quest);
					quest.updateInfo(data[i]);
				}
				

				scroller = new VerScroll(maskMov, _questsMov, scroll);
				scroller.updateScroll();
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
			}			
		}
		
		public function showComplete():void {
			if (!_animComplete.visible) {
				_animComplete.visible = true;
				_animComplete.play(0, 1);
			}			
		}
		
		public function updateQuestSelected(info:QuestInfo): void {
			var index:int = _quests.indexOf(info);
			if (index >= 0) {
				var quest:QuestMainUI;
				//reset current quest selected
				if (_questSelectedIndex >= 0 && _questSelectedIndex < _questsMov.numChildren) {
					quest = _questsMov.getChildAt(_questSelectedIndex) as QuestMainUI;
					quest.setSelected(false);
				}
				//update quest selected and UI
				_questSelectedIndex = index;
				quest = _questsMov.getChildAt(index) as QuestMainUI;
				quest.setSelected(true);
				
				//update desc
				descTf.text = info && info.xmlData ? info.xmlData.desc : "";				
				
				//update receive btn
				receiveBtn.visible = info.state == QuestState.STATE_FINISHED_SUCCESS ? true : false;
				
				//update condition
				MovieClipUtils.removeAllChildren(conditionsMov);
				var conditionUI:ConditionMainUI;
				for (var i:int = 0; i < info.xmlData.conditionsFinish.length; i++) {
					conditionUI = new ConditionMainUI();
					conditionUI.y = (DISTANCE_PER_CONDITION + conditionUI.height) * i;
					conditionsMov.addChild(conditionUI);
					conditionUI.updateInfo(info.xmlData.conditionsFinish[i]);
				}
				
				//update fix rewards
				MovieClipUtils.removeAllChildren(rewardsMov);
				var rewards:Array = info.xmlData.getFixRewardXMLs();				
				for (i = 0; i < rewards.length; i++)  {
					var reward:Reward = new Reward();
					reward.changeType(Reward.QUEST);
					rewardsMov.addChild(reward);
					reward.x = (DISTANCE_X_PER_REWARD /*+ reward.width*/) * i;
					reward.updateInfo((rewards[i] as RewardXML).getItemInfo(), (rewards[i] as RewardXML).quantity);
				}
				
				//update optional rewards
				MovieClipUtils.removeAllChildren(optionRewardsMov);
				_optionalRewardSelectedIndex = -1;
				rewards = info.xmlData.getOptionalRewardXMLs();				
				for (i = 0; i < rewards.length; i++)  {
					reward = new Reward();
					reward.changeType(Reward.QUEST);
					reward.enableSelect(true);
					optionRewardsMov.addChild(reward);
					reward.x = (DISTANCE_X_PER_REWARD /*+ reward.width*/) * i;
					reward.updateInfo((rewards[i] as RewardXML).getItemInfo(), (rewards[i] as RewardXML).quantity);
				}		
				
				//request server to toogle quest new state
				if(info.isNew)
					Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.QUEST_MAIN_NEW_INFO, info.index));
			}
		}
		
		public function showEffectCompleted(): void {
			var child:Reward;
			var childPos:Point;
			//var childType:ItemType;
			
			for (var i:int = 0; i < rewardsMov.numChildren; i++) {
				child = rewardsMov.getChildAt(i) as Reward;
				//childType = child.getItemConfig().type;
				childPos = child.getGlobalPos();
				var itemSlot:ItemSlot = Manager.pool.pop(ItemSlot) as ItemSlot;
				if (/*childType && */itemSlot) {					
					itemSlot.x = childPos.x;
					itemSlot.y = childPos.y;
					itemSlot.setConfigInfo(child.getItemConfig(), TooltipID.ITEM_COMMON);
					itemSlot.setQuantity(child.getQuantity());
					_rewardSlotArr.push(itemSlot);
				}
			}
			
			//option reward
			if(_optionalRewardSelectedIndex >= 0 && _optionalRewardSelectedIndex < optionRewardsMov.numChildren) {
				child = optionRewardsMov.getChildAt(_optionalRewardSelectedIndex) as Reward;
				//childType = child.getItemConfig().type;
				childPos = child.getGlobalPos();
				itemSlot = Manager.pool.pop(ItemSlot) as ItemSlot;
				if (/*childType && */itemSlot) {					
					itemSlot.x = childPos.x;
					itemSlot.y = childPos.y;
					itemSlot.setConfigInfo(child.getItemConfig(), TooltipID.ITEM_COMMON);
					itemSlot.setQuantity(child.getQuantity());
					_rewardSlotArr.push(itemSlot);
				}
			}
			
			UtilityEffect.tweenItemEffects(_rewardSlotArr, onShowEffectCompleted, true);
		}
		
		private function onShowEffectCompleted():void 
		{
			for each(var slot:ItemSlot in _rewardSlotArr) {
				slot.reset();
				Manager.pool.push(slot, ItemSlot);
			}
			
			_rewardSlotArr = [];
			
			dispatchEvent(new Event(SHOW_QUEST_MAIN_EFFECT_COMPLETED));
		}

		//TUTORIAL
		public function showHintButton():void
		{
			Game.hint.showHint(receiveBtn, Direction.LEFT, receiveBtn.x + receiveBtn.width, receiveBtn.y + receiveBtn.height/2, "Click chuột nhận thưởng");
		}
	}

}