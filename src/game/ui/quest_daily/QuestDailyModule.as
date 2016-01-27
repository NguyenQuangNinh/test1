package game.ui.quest_daily 
{
	import core.display.DisplayManager;
	import core.display.layer.Layer;
	import core.display.ModuleBase;
	import core.event.EventEx;
	import core.Manager;
	import core.util.Utility;
	import flash.events.Event;
	import flash.utils.Dictionary;
	import game.data.vo.quest_transport.ConditionInfo;
	import game.data.xml.DataType;
	import game.data.xml.LevelQuestDailyXML;
	import game.data.xml.VIPConfigXML;
	import game.enum.DialogEventType;
	import game.enum.FeatureEnumType;
	import game.enum.FlowActionEnum;
	import game.enum.GameConfigID;
	import game.enum.PaymentType;
	import game.flow.FlowManager;
	import game.Game;
	import game.net.IntRequestPacket;
	import game.net.IntResponsePacket;
	import game.net.lobby.LobbyRequestType;
	import game.net.lobby.LobbyResponseType;
	import game.net.lobby.response.ResponseQuestDailyAccumulateReward;
	import game.net.lobby.response.ResponseQuestDailyInfo;
	import game.net.lobby.response.ResponseQuestDailyState;
	import game.net.RequestPacket;
	import game.net.ResponsePacket;
	import game.net.Server;
	import game.ui.dialog.DialogID;
	import game.ui.dialog.dialogs.YesNo;
	import game.ui.home.scene.CharacterManager;
	import game.ui.hud.HUDModule;
	import game.ui.message.MessageID;
	import game.ui.ModuleID;
	import game.ui.tutorial.TutorialEvent;
	import game.utility.GameUtil;
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class QuestDailyModule extends ModuleBase
	{
		
		private var _rewardCache:Array = [];
		private var _stateCache:Object = {};
		private var _isCloseQuest:Boolean = false;
		
		public function QuestDailyModule() 
		{
			
		}
		
		override protected function createView():void 
		{
			super.createView();
			
			baseView  = new QuestDailyView();
			baseView.addEventListener(Event.CLOSE, onCloseHdl);
			baseView.addEventListener(QuestDailyUI.FINISH_DAILY_QUEST, onRequestHdl);
			baseView.addEventListener(QuestDailyUI.QUICK_COMPLETE_DAILY_QUEST, onRequestHdl);
			baseView.addEventListener(QuestDailyView.QUICK_REFRESH_DAILY_QUEST, onRequestHdl);
			baseView.addEventListener(QuestDailyView.COMPLETED_COUNT_DOWN, onRequestHdl);
			baseView.addEventListener(QuestDailyUI.GO_TO_DAILY_ACTION, onGoToActionHdl);
			baseView.addEventListener(QuestDailyUI.SHOW_QUEST_DAILY_EFFECT_COMPLETED, onEffectCompletedHdl);
		}
		
		private function onEffectCompletedHdl(e:Event):void 
		{
			//Utility.log( "QuestDailyModule.onEffectCompletedHdl > e : ");
			if (_stateCache.total != 0) {
				QuestDailyView(baseView).updateState(_stateCache.current, _stateCache.total, _stateCache.remain,
													_stateCache.accumulatePoint, _stateCache.indexAccumulated);
				_isCloseQuest = false;									
				Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.QUEST_DAILY_INFO));									
				_stateCache = { };
			}
		}
		
		private function onGoToActionHdl(e:EventEx):void 
		{		
			var con:ConditionInfo = e.data as ConditionInfo;
			Game.flow.doAction(FlowActionEnum.GO_TO_ACTION, con );
			/*//check vip condition
			var currentVip:int = Game.database.userdata.vip;
			var currentVipInfo:VIPConfigXML = Game.database.gamedata.getData(DataType.VIP, currentVip) as VIPConfigXML;
			var actionValid:Boolean = currentVipInfo ? currentVipInfo.dailyQuestGotoPlay : false;
			
			if (actionValid) {				
				var con:ConditionInfo = e.data as ConditionInfo;
				Game.flow.doAction(FlowActionEnum.GO_TO_ACTION, con );
			}else {
				var vipInfoDic:Dictionary = Game.database.gamedata.getTable(DataType.VIP);
				var nextValidExist:Boolean = false;
				for each(var vipXML:VIPConfigXML in vipInfoDic) {				
					if (vipXML.ID > currentVip && vipXML.dailyQuestGotoPlay) {
						nextValidExist = true;
						break;				
					}
				}				
				var actionValidNext:int = nextValidExist ? vipXML.ID : -1;
				var dialogData:Object = {};
				dialogData.title = "Thông báo";
				dialogData.message = "Lập tức di chuyển đến nơi làm nhiệm vụ. \n Vip" + actionValidNext.toString() 
										+ " mới được sử dụng chức năng này. Các hạ có muốn xem thông tin VIP không ?";
				dialogData.option = YesNo.YES | YesNo.CLOSE | YesNo.NO;
				Manager.display.showDialog(DialogID.YES_NO, onAcceptViewHdl, null, dialogData, Layer.BLOCK_BLACK);	
			}*/
		}

		public function showHintButton():void
		{
			if(baseView)
				(baseView as QuestDailyView).showHintButton();
		}

		public function showHintAccumulateBar():void
		{
			if(baseView)
				(baseView as QuestDailyView).showHintAccumulateBar();
		}

		private function onAcceptViewHdl(data:Object):void 
		{
			Manager.display.showPopup(ModuleID.DIALOG_VIP, Layer.BLOCK_BLACK);
		}
		
		private function onRequestHdl(e:EventEx):void 
		{
			switch(e.type) {
				case QuestDailyUI.QUICK_COMPLETE_DAILY_QUEST:
					//show message dialog confirm
					//Utility.log( "QuestDailyModule.onRequestHdl : " + QuestDailyView.QUICK_COMPLETE_DAILY_QUEST.toString() );
					_isCloseQuest = true;
					var value:int = Game.database.gamedata.getConfigData(GameConfigID.QUEST_DAILY_PRICE_FINISH) as int;
					(baseView as QuestDailyView).selectQuest(e.data as int);
					Manager.display.showDialog(DialogID.YES_NO, onAcceptConfirmHdl, null,
								{type:DialogEventType.CONFIRM_FINISH_DAILY_QUEST, id: e.data as int, cost: value } );
					break;
				case QuestDailyView.QUICK_REFRESH_DAILY_QUEST:
					//show message dialog confirm
					var values: Array = Game.database.gamedata.getConfigData(GameConfigID.QUEST_DAILY_PRICE_REFRESH) as Array;
					value = Game.database.userdata.nDailyQuestRefresh < values.length ? values[Game.database.userdata.nDailyQuestRefresh] : values[values.length - 1];
					var data:Object = { type:DialogEventType.CONFIRM_REFRESH_TIME_DAILY_QUEST, cost: value };
					if (value > 0)
					{
						Manager.display.showDialog(DialogID.YES_NO, onAcceptConfirmHdl, null,
								data );
					}
					else 
					{
						data.type = DialogEventType.CONFIRM_REFRESH_TIME_DAILY_QUEST;
						onAcceptConfirmHdl(data);
					}
					break;
				case QuestDailyView.COMPLETED_COUNT_DOWN:
					Utility.log("count down complete --> request to get new quest");
					Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.QUEST_DAILY_INFO));		
					break;
				case QuestDailyUI.FINISH_DAILY_QUEST:	
					/*if (_stateCache.current >= _stateCache.total) 
					{
						Manager.display.showMessage("Không thể nhận thưởng, bạn đã hết số lần nhận thưởng trong ngày.");
						break;
					}*/
					//Utility.log( "QuestDailyModule.onRequestHdl : " + QuestDailyView.FINISH_DAILY_QUEST.toString() );
					_isCloseQuest = true;
					(baseView as QuestDailyView).selectQuest(e.data as int);
					Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.QUEST_DAILY_CLOSE, e.data as int));
					break;
			}
		}
		
		private function onAcceptConfirmHdl(data:Object):void 
		{
			if (data) {				
				switch(data.type) {
					case DialogEventType.CONFIRM_FINISH_DAILY_QUEST:
						_isCloseQuest = true;
						Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.QUEST_DAILY_QUICK_COMPLETE, data.id));
						break;
					case DialogEventType.CONFIRM_REFRESH_TIME_DAILY_QUEST:
						Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.QUEST_DAILY_REFRESH));
						break;
				}
			}
		}
		
		private function onCloseHdl(e:Event):void 
		{
			//Manager.display.hideModule(ModuleID.QUEST_DAILY);
			var hudModule:HUDModule = Manager.module.getModuleByID(ModuleID.HUD) as HUDModule;
			if (hudModule != null) {
				Manager.display.clearKeepedModule(ModuleID.QUEST_DAILY);
				hudModule.updateHUDButtonStatus(ModuleID.QUEST_DAILY, false);
			}
		}
		
		override protected function transitionIn():void 
		{
			super.transitionIn();
			
			var currentLevel:int = Game.database.userdata.level;
			(baseView as QuestDailyView).updateRewardAccumulate(currentLevel);
			
			Game.network.lobby.addEventListener(Server.SERVER_DATA, onLobbyServerData);	
			//Game.flow.addEventListener(FlowManager.ACTION_COMPLETED, onFlowActionCompletedHdl);
				
			Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.QUEST_DAILY_STATE));
			Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.QUEST_DAILY_INFO));			
		}
		
		private function onLobbyServerData(e:EventEx):void 
		{
			var packet:ResponsePacket = e.data as ResponsePacket;
			switch(packet.type) {
				case LobbyResponseType.QUEST_DAILY_INFO:
					var packetInfo:ResponseQuestDailyInfo = packet as ResponseQuestDailyInfo;
					Utility.log(" response --> quest daily info --> num quests is " + packetInfo.quests.length);					
					(baseView as QuestDailyView).updateQuests(packetInfo.quests);
					break;
				case LobbyResponseType.QUEST_DAILY_CLOSE:
					var packetClose:IntResponsePacket = packet as IntResponsePacket;
					Utility.log(" response --> quest daily close value " + packetClose.value);
					switch(packetClose.value) {
						case 0:	//success
							(baseView as QuestDailyView).showEffectCompleted();
							break;
						case 2:	//full inventory
							Manager.display.showMessageID(MessageID.QUEST_DAILY_FINISH_FAIL_BY_FULL_INVENTORY);
							break;	
					}
					break;
				case LobbyResponseType.QUEST_DAILY_QUICK_FINISH:
					var packetQuickFinish:IntResponsePacket = packet as IntResponsePacket;
					Utility.log(" response --> quest daily quick finish value " + packetQuickFinish.value);
					switch(packetQuickFinish.value) {
						case 0:	//success
							(baseView as QuestDailyView).showEffectCompleted(true);
							break;
						case 5:	//not enough xu
							Game.flow.doAction(FlowActionEnum.PURCHASE_RESOURCE, PaymentType.XU_NORMAL.ID);
							break;	
					}
					break;
				case LobbyResponseType.QUEST_DAILY_REFRESH:
					var packetRefresh:IntResponsePacket = packet as IntResponsePacket;
					Utility.log(" response --> quest daily refresh value " + packetRefresh.value);
					switch(packetRefresh.value) {
						case 0:	//success
							Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.QUEST_DAILY_INFO));
							break;
						case 2:	//not enough xu
							Game.flow.doAction(FlowActionEnum.PURCHASE_RESOURCE, PaymentType.XU_NORMAL.ID);
							break;	
					}
					break;
			}
		}		
		
		override protected function onTransitionOutComplete():void 
		{
			super.onTransitionOutComplete();
			Game.network.lobby.removeEventListener(Server.SERVER_DATA, onLobbyServerData);
			CharacterManager.instance.displayCharacters();
		}
		
		override protected function onTransitionInComplete():void 
		{
			super.onTransitionInComplete();
			CharacterManager.instance.hideCharacters();
		}
		
		public function updateState(current:int, total:int, remain:int, accumulatePoint:int, indexAccumulated:int):void {
			
			Utility.log( "QuestDailyModule.updateState > current : " + current + ", total : " + total + ", remain : " + remain + "s, accumulatePoint : " + accumulatePoint + ", indexAccumulated : " + indexAccumulated );
			if (baseView)
				if(_isCloseQuest) {
					//Utility.log( "QuestDailyModule.updateState: cache state reponse" );
					_stateCache.current = current;
					_stateCache.total = total;
					_stateCache.remain = remain;
					_stateCache.accumulatePoint = accumulatePoint;
					_stateCache.indexAccumulated = indexAccumulated;
				} else {	
					QuestDailyView(baseView).updateState(current, total, remain, accumulatePoint, indexAccumulated);
			}
		}
	}

}