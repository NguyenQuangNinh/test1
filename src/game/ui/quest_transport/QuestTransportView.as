package game.ui.quest_transport 
{
	import core.display.BitmapEx;
	import core.display.ViewBase;
	import core.event.EventEx;
	import core.Manager;
	import core.util.Enum;
	import core.util.FontUtil;
	import core.util.MovieClipUtils;
	import core.util.Utility;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.utils.clearTimeout;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	import game.data.model.item.IItemConfig;
	import game.data.model.item.ItemFactory;
	import game.data.xml.DataType;
	import game.data.xml.VIPConfigXML;
	import game.enum.Direction;
	import game.enum.DragDropEvent;
	import game.enum.GameConfigID;
	import game.enum.ItemType;
	import game.Game;
	import game.ui.components.ItemSlot;
	import game.ui.message.MessageID;
	import game.data.model.Character;
	import game.data.vo.quest_transport.MissionInfo;
	import game.data.vo.url.ImageURL;
	import game.data.xml.RewardXML;
	import game.enum.Font;
	import game.enum.QuestState;
	import game.net.lobby.response.ResponseQuestTransportInfo;
	import game.net.lobby.response.ResponseReputePoint;
	import game.ui.components.CharacterSlot;
	import game.ui.components.FormationSlot;
	import game.ui.components.Reward;
	import game.ui.components.ScrollBar;
	import game.ui.quest_transport.MissionInfoUI;
	import game.ui.tooltip.TooltipEvent;
	import game.ui.tooltip.TooltipID;
	import game.ui.tutorial.TutorialEvent;
	import game.utility.UtilityEffect;
	import game.utility.UtilityUI;
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class QuestTransportView extends ViewBase
	{
		private static const DISTANCE_PER_MISSION:int = 2;
		private static const DISTANCE_X_PER_REWARD:int = 80;
		
		private static const UNIT_SLOT_WIDTH:int = 60;
		private static const UNIT_SLOT_HEIGHT:int = 90;
		
		private static const UNIT_SLOT_1_START_FROM_X:int = 865;
		private static const UNIT_SLOT_2_START_FROM_X:int = 945;
		
		private static const REWARD_START_FROM_X:int = 685;
		private static const REWARD_START_FROM_Y:int = 410;
		
		public static const REMOVE_UNIT_SLOT:String = "removeUnitSlot";
		public static const CLEAR_QUEST:String = "clearQuest";
		public static const SHOW_QUEST_TRANSPORT_EFFECT_COMPLETED:String = "showQuestTransportEffectCompleted";
		
		public var confirmMov:ConfirmDialog;
		
		public var questMaskMov:MovieClip;
		public var rewardMaskMov:MovieClip;
		public var questScroll:ScrollBar;
		public var rewardScroll:ScrollBar;
		
		public var descTf:TextField;
		public var finishTf:TextField;
		public var vipTf:TextField;
		public var moreTf:TextField;
		public var freeTimeTf:TextField;
		
		public var actionBtn:SimpleButton;
		public var confirmBtn:SimpleButton;
		public var receiveBtn:SimpleButton;
		public var refreshBtn:SimpleButton;
		
		public var resultMov:MovieClip;
		
		private var _infoUnit_1:Character;
		private var _infoUnit_2:Character;
		
		
		static public const UNIT_SLOT_CLICK	:String = "unit_click";
		static public const UNIT_SLOT_DCLICK	:String = "unit_double_click";	
		//static public const UNIT_SLOT_DRAG		:String = "unit_drag";
		public var unit_1:MovieClip;
		public var unit_2:MovieClip;
		private var _isMouseDown:Boolean = false;
		private var _clickStarted:int = -1;
		private var _mouseTimeOut:int;
		
		private var _quests:Array = [];
		private var _questContainer:MovieClip;		
		private var _rewardContainer:MovieClip;		
		private var _btnBack		:SimpleButton;
		
		private var _missionSelected:int = -1;
		
		private var _rewardSlotArr:Array = [];
		
		private var _numQuestCompleted:int;
		private var _maxBasicQuestCompletedInDay:int;
		
		public var searchBtn:SimpleButton;
		
		public function QuestTransportView() 
		{
			/*if (stage)
				init();
			else addEventListener(Event.ADDED_TO_STAGE, init);	*/
			initUI();
		}
		
		/*private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			initUI();
		}*/
		
		private function initUI():void 
		{
			var avatar:BitmapEx = new BitmapEx();
			unit_1.addChild(avatar);
			unit_1.addEventListener(BitmapEx.LOADED, onLoadCompletedHdl);
			unit_1.buttonMode = true;

			avatar = new BitmapEx();
			unit_2.addChild(avatar);
			unit_2.addEventListener(BitmapEx.LOADED, onLoadCompletedHdl);
			
			//set font
			FontUtil.setFont(descTf, Font.ARIAL, false);
			FontUtil.setFont(finishTf, Font.ARIAL, false);
			FontUtil.setFont(vipTf, Font.ARIAL, false);
			FontUtil.setFont(moreTf, Font.ARIAL, false);
			FontUtil.setFont(freeTimeTf, Font.ARIAL, false);
			
			//init container
			_questContainer = new MovieClip();
			_questContainer.x = questMaskMov.x;
			_questContainer.y = questMaskMov.y;
			addChild(_questContainer);
			
			//init reward
			_rewardContainer = new MovieClip();
			//_rewardContainer.x = rewardMaskMov.x;
			//_rewardContainer.y = rewardMaskMov.y;
			_rewardContainer.x = REWARD_START_FROM_X;
			_rewardContainer.y = REWARD_START_FROM_Y;
			addChild(_rewardContainer);
			
			//back btn
			_btnBack = UtilityUI.getComponent(UtilityUI.CLOSE_BTN) as SimpleButton;
			_btnBack.x = 1000;
			_btnBack.y = 100;
			addChild(_btnBack);
			
			//init events
			_btnBack.addEventListener(MouseEvent.CLICK, onBackClickHdl);	
			
			unit_1.addEventListener(MouseEvent.CLICK, onMouseClickHdl);
			unit_1.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownHdl);
			unit_2.addEventListener(MouseEvent.CLICK, onMouseClickHdl);
			unit_2.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownHdl);					
			
			addEventListener(UNIT_SLOT_CLICK, onUnitClickHdl);
			addEventListener(UNIT_SLOT_DCLICK, onUnitDClickHdl);
			
			confirmBtn.visible = false;
			actionBtn.addEventListener(MouseEvent.CLICK, onActionClickHdl);
			confirmBtn.addEventListener(MouseEvent.CLICK, onConfirmCloseHdl);
			receiveBtn.addEventListener(MouseEvent.CLICK, onConfirmCloseHdl);
			confirmMov.addEventListener(ConfirmDialog.CLOSE_CONFIRM_DIALOG, onDialogConfirmHdl);
			confirmMov.addEventListener(ConfirmDialog.CONFIRM_SELECTED, onDialogConfirmHdl);
			confirmMov.addEventListener(ConfirmDialog.CONFIRM_TIME_OUT, onDialogConfirmHdl);
			refreshBtn.addEventListener(MouseEvent.CLICK, onRefreshClickHdl);
			refreshBtn.addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			refreshBtn.addEventListener(MouseEvent.ROLL_OUT, onRollOut);
			
			_maxBasicQuestCompletedInDay = Game.database.gamedata.getConfigData(GameConfigID.QUEST_TRANSPORT_MAX_QUEST_PER_DAY) as int;
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
						dispatchEvent(new EventEx(TooltipEvent.SHOW_TOOLTIP, {type: TooltipID.SIMPLE, value: "Tìm nhiệm vụ mới."}, true));
					break;
				default: 
			}
		
		}
		
		private function onUnitClickHdl(e:EventEx):void 
		{
			if (checkUnitSlotEmpty((e.data as MovieClip).name == unit_1.name ? 0 : 1)) {
				onUnitDClickHdl(e);
			}
		}
		
		private function onUnitDClickHdl(e:EventEx):void 
		{
			var mission:MissionInfo = _quests[_missionSelected];
			if (mission && mission.state == QuestState.STATE_RECEIVED) {
				var avatar:BitmapEx;
				//switch(e.target) {
				switch(e.data) {
					case unit_1:
						avatar = unit_1.getChildAt(1)as BitmapEx;
						if (avatar.url != "" && avatar.url != ImageURL.BAO_TIEU_AVATAR) {
							//remove character unit from slot
							dispatchEvent(new EventEx(REMOVE_UNIT_SLOT, _infoUnit_1 ? _infoUnit_1 : null));
							updateCharacterSlot(0, null);
						}else 	
							dispatchEvent(new EventEx(QuestTransportEventName.RENT_MISSION, { info: _quests[_missionSelected], slotIndex: 0 }, true));
						break;
					case unit_2:
						avatar = unit_2.getChildAt(1)as BitmapEx;
						if (avatar.url != "" && avatar.url != ImageURL.BAO_TIEU_AVATAR) {
							//remove character unit from slot
							dispatchEvent(new EventEx(REMOVE_UNIT_SLOT, _infoUnit_2 ? _infoUnit_2 : null));
							updateCharacterSlot(1, null);
						}else 	
							dispatchEvent(new EventEx(QuestTransportEventName.RENT_MISSION, { info: _quests[_missionSelected], slotIndex: 1 }, true));
						break;	
				}
			}
		}
		
		private function onMouseDownHdl(e:MouseEvent):void 
		{
			if (!checkUnitSlotEmpty((e.target as MovieClip).name == unit_1.name ? 0 : 1)) {				
				addEventListener(MouseEvent.MOUSE_UP, onMouseUpHdl);
				addEventListener(MouseEvent.MOUSE_OUT, onMouseOutHdl);
				_isMouseDown = true;
			}
		}
		
		private function onMouseOutHdl(e:MouseEvent):void 
		{
			removeEventListener(MouseEvent.MOUSE_OUT, onMouseOutHdl);
			removeEventListener(MouseEvent.MOUSE_UP, onMouseUpHdl);
			if (_isMouseDown) {				
				//reset flag
				_isMouseDown = false;
				
				//this is a drag
				/*if (getStatus() == OCCUPIED && isEnabled()) {					
					var objDrag:BitmapEx = new BitmapEx();
					objDrag.load(_data.xmlData.largeAvatarURLs[_data.sex]);
					objDrag.name = "mov_drag";
					dispatchEvent(new EventEx(CHARACTER_SLOT_DRAG, {target: objDrag, data: _data, x:e.stageX, y:e.stageY,
								from: DragDropEvent.FROM_INVENTORY }, true));				
				}*/
			}
		}
		
		private function onMouseUpHdl(e:MouseEvent):void 
		{			
			removeEventListener(MouseEvent.MOUSE_OUT, onMouseOutHdl);
			removeEventListener(MouseEvent.MOUSE_UP, onMouseUpHdl);
			_isMouseDown = false;			
		}
		
		private function onRefreshClickHdl(e:MouseEvent):void 
		{
			var refreshCode:int = checkRefreshValid();
			switch(refreshCode) {
				case 0:
					//send request to server
					dispatchEvent(new Event(CLEAR_QUEST));
					break;
				case 1:
					//show message info --> need waiting quest finish before action refresh
					Manager.display.showMessageID(MessageID.QUEST_TRANSPORT_FINISH_QUEST_BEFORE_REFRESH);
					break;
				case 2:
					//show message info --> need close finish quest before action refresh
					Manager.display.showMessageID(MessageID.QUEST_TRANSPORT_RECEIVE_REWARD_BEFORE_REFRESH);
					break;
				/*case 3:
					//show message info --> need close finish quest before action refresh
					Manager.display.showMessageID(MessageID.QUEST_DAILY_REACH_MAX_COMPLETED);
					break;*/
			}
		}
		
		private function checkRefreshValid():int {
			var result:int = 0;			
			for (var i:int = 0; i < _quests.length; i++) {
				var mission:MissionInfo = _quests[i];
				result = mission.state == QuestState.STATE_ACTIVED ? 1 : 
						mission.state == QuestState.STATE_FINISHED_SUCCESS ? 2 : 0;
						//_numQuestCompleted == _maxQuestCompletedInDay ? 3 :	0;	
				if (result > 0)
					break;
			}
			return result;
		}
		
		private function onDialogConfirmHdl(e:EventEx):void 
		{
			_questContainer.mouseEnabled = true;
			_questContainer.mouseChildren = true;	
			
			//save info to update slot rented for mission completed if success
			/*var type:int = e.data ? e.data.type as int : 0;
			var index:int = e.data ? e.data.index as int : 0;
			var slotIndex:int = e.data ? e.data.slotIndex as int : 0;*/			
		}
		
		private function onConfirmCloseHdl(e:MouseEvent):void 
		{
			/*if (_numQuestCompleted < _maxQuestCompletedInDay) {				
				dispatchEvent(new EventEx(QuestTransportEventName.CONFIRM_CLOSE, {index: _missionSelected}));
			}else {
				Manager.display.showMessageID(MessageID.QUEST_DAILY_REACH_MAX_COMPLETED);
			}*/
			var currentVip:int = Game.database.userdata.vip;
			var currentVipInfo:VIPConfigXML = Game.database.gamedata.getData(DataType.VIP, currentVip) as VIPConfigXML;
			var numQuestAddCurr:int = currentVipInfo ? currentVipInfo.transporterQuestAddCount : 0;
			/*if (_numQuestCompleted > (_maxBasicQuestCompletedInDay + numQuestAddCurr)) 
			{
				Manager.display.showMessage("Không thể nhận thưởng, bạn đã hết số lần nhận thưởng trong ngày.");
				return;
			}*/
			dispatchEvent(new EventEx(QuestTransportEventName.CONFIRM_CLOSE, {index: _missionSelected}));
			Game.stage.dispatchEvent(new EventEx(TutorialEvent.EVENT, {type: TutorialEvent.RECEIVE_REWARD_TRANSPORT_QUEST}, true));
		}
		
		private function onActionClickHdl(e:MouseEvent):void 
		{
			var mission:MissionInfo = _quests[_missionSelected];
			if (mission)
				dispatchEvent(new EventEx(QuestTransportEventName.START_MISSION, mission, true));
		}
		
		private function onMouseClickHdl(e:MouseEvent):void 
		{
			
			if (_clickStarted && (getTimer() - _clickStarted < DragDropEvent.MAX_TIME_FOR_CLICK)) {
				//this is a double click
				clearTimeout(_mouseTimeOut);
				_clickStarted = -1;				
				dispatchEvent(new EventEx(UNIT_SLOT_DCLICK, e.target, true));
				//onUnitDClick(e.target as MovieClip);
			}else {
				_clickStarted = getTimer();
				_mouseTimeOut = setTimeout(checkIsDoubleClick, DragDropEvent.MAX_TIME_FOR_CLICK, e.target);	
			}
		}
		
		private function checkIsDoubleClick(target: MovieClip):void 
		{
			_clickStarted = -1;
			dispatchEvent(new EventEx(UNIT_SLOT_CLICK, target, true));
		}
		
		private function onBackClickHdl(e:MouseEvent):void 
		{
			dispatchEvent(new Event(Event.CLOSE));
		}
		
		public function updateCharacterSlot(index:int, info:Character, reset:Boolean = false): void {			
			var avatar:BitmapEx;
			var mission:MissionInfo;
			switch(index) {
				case 0:
					avatar = unit_1.getChildAt(1) as BitmapEx;
					var avatarURL:String = avatar ? (reset ? "" : avatar.url) : "";
					//if (avatar.url != ImageURL.BAO_TIEU_AVATAR) {						
					if (avatarURL != ImageURL.BAO_TIEU_AVATAR) {						
						_infoUnit_1 = info;
						avatar.load(info ? info.xmlData.largeAvatarURLs[info.sex] : "");
						unit_1.getChildAt(0).visible = !(avatar.url != "");					
						
						//update mission unit attend
						mission = _quests[_missionSelected];
						mission.updateUnitIDAtIndex(0, info ? info.ID : -1);
					}
					break;
				case 1:
					avatar = unit_2.getChildAt(1) as BitmapEx;
					avatarURL = avatarURL ? (avatar.url = reset ? "" : avatar.url) : "";
					//if (avatar.url != ImageURL.BAO_TIEU_AVATAR) {						
					if (avatarURL != ImageURL.BAO_TIEU_AVATAR) {						
						_infoUnit_2 = info;
						avatar.load(info ? info.xmlData.largeAvatarURLs[info.sex] : "");
						unit_2.getChildAt(0).visible = !(avatar.url != "");
						
						//update mission unit attend
						mission = _quests[_missionSelected];
						mission.updateUnitIDAtIndex(1, info ? info.ID : -1);
					}
					break;
			}
		}
		
		private function onLoadCompletedHdl(e:Event):void 
		{
			var avatar:BitmapEx;
			switch(e.currentTarget) {
				case unit_1:
					avatar = unit_1.getChildAt(1)as BitmapEx;
					avatar.x = avatar.url != ImageURL.BAO_TIEU_AVATAR ? - avatar.width / 4 :  0;
					avatar.y = avatar.url != ImageURL.BAO_TIEU_AVATAR ? - avatar.width / 8 :  avatar.width / 4;
					break;
				case unit_2:
					avatar = unit_2.getChildAt(1)as BitmapEx;
					avatar.x = avatar.url != ImageURL.BAO_TIEU_AVATAR ? - avatar.width / 4 :  0;
					avatar.y = avatar.url != ImageURL.BAO_TIEU_AVATAR ? - avatar.width / 8 :  avatar.width / 4;
					break;	
			}
		}
		
		public function updateQuestInfo(packet:ResponseQuestTransportInfo): void {
			var prices: Array = Game.database.gamedata.getConfigData(GameConfigID.QUEST_TRANSPORT_PRICE_REFRESH) as Array; 
			var freeTimeNum:int = 0;
			for (var i:int = 1; i < prices.length; i++) 
			{
				if (prices[i] == 0) freeTimeNum++;
			}
			
			var refreshTime:int = Game.database.userdata.nTransportRefresh;
			var remain:int =  refreshTime > freeTimeNum ? 0 : freeTimeNum - refreshTime;
			freeTimeTf.text = remain.toString();
			
			//_quests = packet.filterQuestsByState(new Array(QuestTransportEventName.QUEST_STATE_RECEIVED,QuestTransportEventName.QUEST_STATE_ACTIVED));
			_quests = packet.quests;
			_numQuestCompleted = packet.numQuestCompletedInDay;			
			
			//update vip info to display
			var currentVip:int = Game.database.userdata.vip;
			var currentVipInfo:VIPConfigXML = Game.database.gamedata.getData(DataType.VIP, currentVip) as VIPConfigXML;
			var numQuestAddCurr:int = currentVipInfo ? currentVipInfo.transporterQuestAddCount : 0;
			
			var vipInfoDic:Dictionary = Game.database.gamedata.getTable(DataType.VIP);
			for each(var vipXML:VIPConfigXML in vipInfoDic) {
				/*if (currentVipInfo && vipXML.ID <= currentVipInfo.ID)
					numQuestAddCurr = vipXML.transporterQuestAddCount;*/
				if (vipXML.ID > currentVip && vipXML.transporterQuestAddCount > numQuestAddCurr)
					break;				
			}
			
			vipTf.text = vipXML.ID.toString();
			moreTf.text = (vipXML.transporterQuestAddCount - numQuestAddCurr).toString();
			finishTf.text = _numQuestCompleted.toString() + "/" + (_maxBasicQuestCompletedInDay + numQuestAddCurr).toString();
			
			//stop all timer
			var missionUI:MissionInfoUI;
			for (i = 0; i < _questContainer.numChildren; i++) {
				missionUI = _questContainer.getChildAt(i) as MissionInfoUI;
				missionUI.stopCountDown();
			}
			//remove all child
			MovieClipUtils.removeAllChildren(_questContainer);
			if (_quests) {
				for (i = 0; i < _quests.length; i++) {
					missionUI = new MissionInfoUI();				
					_questContainer.addChild(missionUI);
					missionUI.x = 5;
					missionUI.y = (DISTANCE_PER_MISSION + missionUI.height) * i;
					missionUI.update(_quests[i] as MissionInfo);
				}
				questScroll.init(_questContainer, questMaskMov, "vertical", true, false, true);
				
				//set quest auto selected
				//var info:MissionInfo;
				//var missionUI:MissionInfoUI;
				if (_quests.length > 0) {
					if (_missionSelected < 0 || _missionSelected >= _quests.length) {
						//info = _quests[0];
						missionUI = _questContainer.getChildAt(0) as MissionInfoUI;
					}else {
						//info = _quests[_missionSelected];
						missionUI = _questContainer.getChildAt(_missionSelected) as MissionInfoUI;
					}					
					missionUI.onSelectedHdl();
					//updateMissionSelected(info);
				}
				
			}
		}
		
		public function showConfirmDialog(info:Object): void {	
			
			addChild(confirmMov);			
			confirmMov.visible = info ? true : false;
			_questContainer.mouseEnabled = confirmMov.visible ? false : true;
			_questContainer.mouseChildren = confirmMov.visible ? false : true;
			
			confirmMov.update(info);
			
			//clear UI if dialog is waiting for new quests
			if (info && (info.type == ConfirmDialog.CONFIRM_FOR_ALL_COMPLETED
						|| info.type == ConfirmDialog.CONFIRM_FOR_REFRESH)) {
				//clear rewards
				MovieClipUtils.removeAllChildren(_rewardContainer);				
				//clear unit slot 
				unit_1.visible = false;
				unit_2.visible = false;
				//clear desc
				descTf.text = "";
				//clear quest
				MovieClipUtils.removeAllChildren(_questContainer);
			}

			Game.stage.dispatchEvent(new EventEx(TutorialEvent.EVENT, {type: TutorialEvent.SKIP_TRANSPORT_QUEST_SHOWED}, true));
		}
		
		public function updateMissionSelected(mission:MissionInfo): void {
			//Utility.log( "updateMissionSelected : " + mission.index );
			var index:int = _quests.indexOf(mission);
			if (index >= 0) {
				var missionUI:MissionInfoUI;
				//reset current mission selected
				if (_missionSelected >= 0 && _missionSelected < _questContainer.numChildren) {
					missionUI = _questContainer.getChildAt(_missionSelected) as MissionInfoUI;
					missionUI.setSelected(false);
				}
				//update mission selected and UI
				_missionSelected = index;
				missionUI = _questContainer.getChildAt(index) as MissionInfoUI;
				missionUI.setSelected(true);
				
				//update desc
				descTf.text = mission && mission.xmlData ? mission.xmlData.desc : "";				
				
				//update state
				actionBtn.visible = mission && mission.state == QuestState.STATE_RECEIVED ? true : false;
				//confirmBtn.visible = mission && mission.state == QuestState.QUEST_STATE_FINISHED_FAILED ? true : false;
				receiveBtn.visible = mission && mission.state == QuestState.STATE_FINISHED_SUCCESS ? true : false;
				resultMov.visible = mission && mission.state == QuestState.STATE_FINISHED_SUCCESS ? true : false;
				switch(mission.state) {
					case QuestState.STATE_FINISHED_SUCCESS:
						resultMov.gotoAndStop("success");
						break;
					/*case QuestState.QUEST_STATE_FINISHED_FAILED:
						resultMov.gotoAndStop("fail");
						break;*/
				}
				
				//update reward
				// init reward container	
				
				var i:int;
				var item:Reward;
				if (!_rewardContainer.numChildren)
				{
					for (i = 0; i < 3 ; i++) {
						item = new Reward();
						item.changeType(Reward.QUEST);
						_rewardContainer.addChild(item);
						_rewardContainer["item_" + i] = item;
						item.x = DISTANCE_X_PER_REWARD * (int) (i % 2);
						item.y = DISTANCE_X_PER_REWARD * (int) (i / 2);
					}
					rewardScroll.init(_rewardContainer, rewardMaskMov, "vertical", true, false, false); 
				}
				
				var itemConfig:IItemConfig;
				var quantity:int;
				var level:int = Game.database.userdata.level;
				var baseValue:int;
				var rate:Number;
				
				// reward gold
				
				itemConfig = ItemFactory.buildItemConfig(ItemType.GOLD, 0) as IItemConfig;
				item = _rewardContainer["item_0"] as Reward;
				
				baseValue = Game.database.gamedata.getConfigData(GameConfigID.QUEST_TRANSPORT_REWARD_GOLD_BASE) as int;
				rate = (Game.database.gamedata.getConfigData(GameConfigID.QUEST_TRANSPORT_REWARD_RATE_ON_TYPE_ARR) as Array)[mission.difficulty] / 100;
				
				quantity = level * baseValue * rate;
				item.updateInfo(itemConfig, quantity);
				
				// reward exp
				itemConfig = ItemFactory.buildItemConfig(ItemType.EXP, 0) as IItemConfig;
				item = _rewardContainer["item_1"] as Reward;
				
				baseValue = Game.database.gamedata.getConfigData(GameConfigID.QUEST_TRANSPORT_REWARD_EXP_BASE) as int;
				rate = (Game.database.gamedata.getConfigData(GameConfigID.QUEST_TRANSPORT_REWARD_RATE_ON_TYPE_ARR) as Array)[mission.difficulty] / 100;
				
				quantity = level * baseValue * rate;
				item.updateInfo(itemConfig, quantity);
				// reward skill scroll
				itemConfig = ItemFactory.buildItemConfig(ItemType.BROKEN_SCROLL, 2) as IItemConfig;
				item = _rewardContainer["item_2"] as Reward;
				quantity = (Game.database.gamedata.getConfigData(GameConfigID.QUEST_TRANSPORT_REWARD_SKILL_BOOK_NUM_ARR) as Array)[mission.difficulty];
				item.updateInfo(itemConfig, quantity);
				
				//update unit slot
				if(mission.state == QuestState.STATE_FINISHED_SUCCESS) {
					unit_1.visible = false;
					unit_2.visible = false;
				}else {
					var avatar:BitmapEx;				
					if (mission && mission.unitAttend.length > 0 && mission.unitAttend[0] && mission.unitAttend[0] == -2) {
						unit_1.mouseEnabled = false;
						unit_1.mouseChildren = false;
						avatar = unit_1.getChildAt(1)as BitmapEx;
						avatar.load(ImageURL.BAO_TIEU_AVATAR);
						unit_1.getChildAt(0).visible = !(avatar.url != "");
					}else {
						unit_1.mouseEnabled = true;
						unit_1.mouseChildren = true;
						updateCharacterSlot(0, mission.getUnitInfoByIndex(0), true);
					}
						
					if (mission && mission.unitAttend.length > 1 && mission.unitAttend[1] && mission.unitAttend[1] == -2) {
						unit_2.mouseEnabled = false;
						unit_2.mouseChildren = false;
						avatar = unit_2.getChildAt(1)as BitmapEx;
						avatar.load(ImageURL.BAO_TIEU_AVATAR);
						unit_2.getChildAt(0).visible = !(avatar.url != "");
					}else { 					
						unit_2.mouseEnabled = true;
						unit_2.mouseChildren = true;
						updateCharacterSlot(1, mission.getUnitInfoByIndex(1), true);
					}
						
					checkUnitShow(mission);
				}
			}
		}
		
		private function checkUnitShow(mission:MissionInfo):void 
		{
			switch(mission.xmlData.maxUnit) {
				case 1:
					unit_2.visible = false;
					unit_2.mouseEnabled = false;
					unit_2.mouseChildren = false;
					unit_1.x = (UNIT_SLOT_1_START_FROM_X + UNIT_SLOT_2_START_FROM_X) / 2;
					unit_1.visible = true;
					break;
				case 2:
					unit_1.x = UNIT_SLOT_1_START_FROM_X;
					unit_1.visible = true;
					unit_2.x = UNIT_SLOT_2_START_FROM_X;
					unit_2.visible = true;
					unit_2.mouseEnabled = true;
					unit_2.mouseChildren = true;
					break;
			}
		}
		
		public function changeUnitSelected(bound:Rectangle, data:Character): void {
			//check valid unit before check hit
			if (data && !data.isInMainFormation && !data.isInQuestTransport) {
				var unit_1Point:Point = localToGlobal(new Point(unit_1.x, unit_1.y));
				var unit_1Rect:Rectangle = new Rectangle(unit_1Point.x, unit_1Point.y, UNIT_SLOT_WIDTH, UNIT_SLOT_HEIGHT);
				
				var unit_2Point:Point = localToGlobal(new Point(unit_2.x, unit_2.y));
				var unit_2Rect:Rectangle = new Rectangle(unit_2Point.x, unit_2Point.y, UNIT_SLOT_WIDTH, UNIT_SLOT_HEIGHT);
				
				var indexSelected:int = Utility.math.checkOverlap(bound, unit_1Rect) ? 0 : (Utility.math.checkOverlap(bound, unit_2Rect) ? 1 : -1);
				updateCharacterSlot(indexSelected, data);				
			}else {
				Manager.display.showMessageID(MessageID.QUEST_TRANSPORT_CAN_NOT_USE_UNIT);
			}
		}
		
		public function autoInsertUnit(data:Character):Boolean {			
			var index:int = checkUnitSlotEmpty(0) ? 0 : checkUnitSlotEmpty(1) ? 1 : -1;			
			Utility.log("auto insert unit slot at index :" + index + " with id " + data.ID);
			updateCharacterSlot(index, data);
			return index != -1;
		}
		
		private function checkUnitSlotEmpty(index:int): Boolean {
			var result:Boolean = false;
			
			switch(index) {
				case 0:
					var avatar:BitmapEx = unit_1.getChildAt(1) as BitmapEx;
					break;
				case 1:
					avatar = unit_2.getChildAt(1) as BitmapEx;
					break;
			}
			result = avatar ? avatar.url == "" : false;
			return result;
		}
		
		public function getMissionInfoSelected():MissionInfo {
			return _missionSelected >= 0 && _missionSelected < _quests.length ? _quests[_missionSelected] : null;
		}
		
		override public function transitionIn():void 
		{
			super.transitionIn();
			
			//visible button		
			actionBtn.visible = false;
			confirmBtn.visible = false;
			receiveBtn.visible = false;		
			resultMov.visible = false;
		}
		
		public function showEffectCompleted(): void {
			var child:Reward;
			var childPos:Point;
			//var childType:ItemType;
			
			for (var i:int = 0; i < _rewardContainer.numChildren; i++) {
				child = _rewardContainer.getChildAt(i) as Reward;
				//childType = child.getRewardXML().type;
				childPos = child.getGlobalPos();
				var itemSlot:ItemSlot = Manager.pool.pop(ItemSlot) as ItemSlot;
				if (/*childType && */itemSlot) {					
					itemSlot.x = childPos.x;
					itemSlot.y = childPos.y;
					//itemSlot.setConfigInfo(ItemFactory.buildItemConfig(childType, child.getRewardXML().ID), TooltipID.ITEM_COMMON, childType);
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
			dispatchEvent(new Event(SHOW_QUEST_TRANSPORT_EFFECT_COMPLETED));
		}

		//TUTORIAL
		public function showHintQuest(questIndex:int, content:String =""):void
		{
			if(confirmMov.visible)
			{
				showHintConfirmDlg();
			}
			else
			{
				var missionUI:MissionInfoUI = _questContainer.getChildAt(questIndex) as MissionInfoUI;
				Game.hint.showHint(missionUI, Direction.RIGHT, missionUI.x, missionUI.y + missionUI.height / 2, content);
			}
		}

		public function showHintButton(content:String):void
		{
			if(confirmMov.visible)
			{
				showHintConfirmDlg();
			}
			else
			{
				switch (selectedQuest.state)
				{
					case QuestState.STATE_RECEIVED:
						Game.hint.showHint(actionBtn, Direction.RIGHT, actionBtn.x, actionBtn.y + actionBtn.height/2, "Click chuột");
						break;
					case QuestState.STATE_ACTIVED:
						var item:MissionInfoUI = _questContainer.getChildAt(_missionSelected) as MissionInfoUI;
						var skipBtn:SimpleButton = item.skipBtn;
						Game.hint.showHint(skipBtn, Direction.UP, skipBtn.x + skipBtn.width/2, skipBtn.y + skipBtn.height, "Bỏ thời gian chờ");
						break;
					case QuestState.STATE_FINISHED_SUCCESS:
						Game.hint.showHint(receiveBtn, Direction.UP, receiveBtn.x + receiveBtn.width/2, receiveBtn.y + receiveBtn.height, "Nhận thưởng");
						break;
				}
			}
		}

		public function showHintConfirmDlg():void
		{
			var btn:SimpleButton = confirmMov.confirmBtn;
			Game.hint.showHint(btn, Direction.RIGHT, btn.x, btn.y + btn.height/2, "Click Chuột");
		}

		public function get selectedQuest():MissionInfo
		{
			return _quests[_missionSelected] as MissionInfo;
		}
	}
}