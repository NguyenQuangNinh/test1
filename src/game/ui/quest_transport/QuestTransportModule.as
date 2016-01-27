package game.ui.quest_transport 
{
	import core.display.ModuleBase;
	import core.display.ViewBase;
	import core.event.EventEx;
	import core.Manager;
	import core.util.Utility;
	import flash.events.Event;
	import game.data.xml.LevelQuestTransportXML;
	import game.enum.FeatureEnumType;
	import game.enum.FlowActionEnum;
	import game.enum.PaymentType;
	import game.net.lobby.response.ResponseQuestTransportState;
	import game.utility.GameUtil;
	//import game.data.enum.quest.QuestState;
	import game.data.model.Character;
	import game.data.model.UIData;
	import game.data.vo.quest_transport.MissionInfo;
	import game.enum.DialogEventType;
	import game.enum.GameConfigID;
	import game.enum.InventoryMode;
	import game.enum.QuestState;
	import game.Game;
	import game.net.IntRequestPacket;
	import game.net.IntResponsePacket;
	import game.net.lobby.LobbyRequestType;
	import game.net.lobby.LobbyResponseType;
	import game.net.lobby.request.RequestActiveQuestTransport;
	import game.net.lobby.request.RequestRentQuestTransport;
	import game.net.lobby.response.ResponseQuestTransportInfo;
	import game.net.lobby.response.ResponseQuestTransportListSastified;
	import game.net.lobby.response.ResponseReputePoint;
	import game.net.RequestPacket;
	import game.net.ResponsePacket;
	import game.net.Server;
	import game.ui.components.CharacterSlot;
	import game.ui.dialog.DialogID;
	import game.ui.hud.HUDModule;
	import game.ui.hud.HUDView;
	import game.ui.inventory.InventoryModule;
	import game.ui.inventory.InventoryView;
	import game.ui.message.MessageID;
	import game.ui.ModuleID;
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class QuestTransportModule extends ModuleBase
	{
		
		private var arrMissionCompleted:Array = [];
		private var _unitUsedTemp:Array = [];
		private var _rentInfoTemp:Object = null;
		
		public function QuestTransportModule() 
		{
			relatedModuleIDs = [ModuleID.INVENTORY_UNIT];
		}
		
		override protected function createView():void 
		{
			super.createView();
			
			baseView = new QuestTransportView();
			baseView.addEventListener(QuestTransportEventName.MISSION_SELECTED, onQuestTransportRequestHdl);
			baseView.addEventListener(QuestTransportEventName.RENT_MISSION, onUnitRentRequestHdl);
			baseView.addEventListener(QuestTransportEventName.SKIP_MISSION, onQuestTransportRequestHdl);
			baseView.addEventListener(QuestTransportEventName.START_MISSION, onQuestTransportRequestHdl);
			baseView.addEventListener(Event.CLOSE, onCloseHdl);
			baseView.addEventListener(ConfirmDialog.CONFIRM_SELECTED, onConfirmSelectedHdl);
			baseView.addEventListener(ConfirmDialog.CONFIRM_TIME_OUT, onConfirmTimeOutHdl);
			baseView.addEventListener(MissionInfoUI.MISSION_COMPLETED, onMissionCompletedHdl);
			baseView.addEventListener(QuestTransportEventName.CONFIRM_CLOSE, onConfirmCloseHdl);
			baseView.addEventListener(QuestTransportView.REMOVE_UNIT_SLOT, onRemoveUnitSlotHdl);
			baseView.addEventListener(QuestTransportView.CLEAR_QUEST, onClearQuestHdl);
			baseView.addEventListener(QuestTransportView.SHOW_QUEST_TRANSPORT_EFFECT_COMPLETED, onShowEffectCompletedHdl);
		}
		
		private function onShowEffectCompletedHdl(e:Event = null):void 
		{
			//Utility.log( "onShowEffectCompletedHdl : " + onShowEffectCompletedHdl );
			Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.QUEST_TRANSPORT_INFO));
		}
		
		private function onClearQuestHdl(e:Event):void 
		{
			//confirm dialog
			Manager.display.showDialog(DialogID.YES_NO, onAcceptConfirmHdl, null,
								{type:DialogEventType.CONFIRM_CLEAR_QUEST_TRANSPORT} );
		}
		
		private function onAcceptConfirmHdl(data:Object):void 
		{
			Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.QUEST_TRANSPORT_CLEAR_QUEST));			
		}
		
		private function onRemoveUnitSlotHdl(e:EventEx):void 
		{
			var character:Character = e.data as Character;
			//var filter:Array = Game.database.userdata.questTransportFilterID;
			//var index:int = filter.indexOf(slotID);
			var index:int = _unitUsedTemp.indexOf(character);
			
			if (index > -1) {
				//filter.splice(index, 1);
				(_unitUsedTemp[index] as Character).isInQuestTransport = false;
				_unitUsedTemp.splice(index, 1);
				//Game.database.userdata.dispatchEvent(new Event(UIData.DATA_CHANGED, true));
				Game.uiData.dispatchEvent(new Event(UIData.DATA_CHANGED));		
			}					
		}
		
		private function onCharacterSelectedHdl(e:EventEx):void 
		{
			var character:Character = e.data as Character;
			var filter:Array = Game.database.userdata.questTransportFilterID;
			if (character) {			
				if (character.isInMainFormation || character.isInQuestTransport) {
					Manager.display.showMessageID(MessageID.QUEST_TRANSPORT_CAN_NOT_USE_UNIT);
				}else if (filter.indexOf(character.ID) != -1) {
					if ((baseView as QuestTransportView).autoInsertUnit(character)){
						//Game.database.userdata.questTransportFilterID.push(character.ID);
						character.isInQuestTransport = true;
						_unitUsedTemp.push(character);
						//Game.database.userdata.dispatchEvent(new Event(UIData.DATA_CHANGED, true));
						Game.uiData.dispatchEvent(new Event(UIData.DATA_CHANGED));
					}
				}
			}
		}
		
		private function onConfirmCloseHdl(e:EventEx):void 
		{
			if(e.data) {
				Utility.log("on confirm mission completed");
				//prepare quest transport state
				Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.QUEST_TRANSPORT_CLOSE, e.data.index as int));
			}
		}
		
		private function onConfirmTimeOutHdl(e:EventEx):void 
		{
			//call to update list mission again
			Utility.log("confirm dialog had time out --> request new quest");
			QuestTransportView(baseView).showConfirmDialog(null);
			Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.QUEST_TRANSPORT_INFO));
		}
		
		private function onUnitRentRequestHdl(e:EventEx):void 
		{
			//show dialog to confirm use xuxu than chuong for rent character join in mission
			if(e.data) {
				var info:MissionInfo = e.data.info;	
				if(info) {
					var obj:Object = { };
					obj.type = ConfirmDialog.CONFIRM_FOR_RENT;
					obj.index = info.index;
					//var levelXML:LevelXML = Utility.getCurrentLevelConfig(FeatureEnumType.QUEST_TRANSPORT, Game.database.userdata.level) as LevelXML;					
					var levelXML:LevelQuestTransportXML = GameUtil.getLevelInRange(FeatureEnumType.QUEST_TRANSPORT, Game.database.userdata.level) as LevelQuestTransportXML;					
					obj.price = levelXML ? levelXML.xuLease : -1;
					obj.slotIndex = e.data.slotIndex;
					(baseView as QuestTransportView).showConfirmDialog(obj);
				}
			}
		}
		
		private function onCloseHdl(e:Event):void 
		{
			var hudModule : HUDModule = Manager.module.getModuleByID(ModuleID.HUD) as HUDModule;
			if (hudModule != null) {
				hudModule.updateHUDButtonStatus(ModuleID.QUEST_TRANSPORT, false);
			}
			//Manager.display.hideModule(ModuleID.QUEST_TRANSPORT);
		}
		
		private function onMissionCompletedHdl(e:EventEx):void 
		{
			Utility.log( "QuestTransportModule.onMissionCompletedHdl : ");
			//prepare quest transport state
			//Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.QUEST_TRANSPORT_STATE));
			Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.QUEST_TRANSPORT_INFO));
		}
		
		private function onConfirmSelectedHdl(e:EventEx):void 
		{
			var obj:Object = e.data;
			if (obj) {				
				switch(obj.type) {
					case ConfirmDialog.CONFIRM_FOR_REFRESH:
						Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.QUEST_TRANSPORT_REFRESH));
						break;
					case ConfirmDialog.CONFIRM_FOR_RENT:
						_rentInfoTemp = obj;
						Game.network.lobby.sendPacket(new RequestRentQuestTransport(obj.index, obj.slotIndex));
						break;
					case ConfirmDialog.CONFIRM_FOR_SKIP:
						Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.QUEST_TRANSPORT_SKIP, obj.index));
						break;	
				}
			}
		}
		
		private function resetUnitUsedTemp():void {
			for each(var character:Character in _unitUsedTemp) {
				character.isInQuestTransport = false;
			}
			_unitUsedTemp = [];
		}
		
		private function onQuestTransportRequestHdl(e:EventEx):void 
		{			
			var info:MissionInfo = e.data as MissionInfo;
			var obj:Object = { };
			switch(e.type) {
				case QuestTransportEventName.MISSION_SELECTED:
					//get current character join in // reward
					//reset tempt state used in mission before					
					resetUnitUsedTemp();
					
					(baseView as QuestTransportView).updateMissionSelected(info);
					if(info.state != QuestState.STATE_FINISHED_SUCCESS)
						Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.QUEST_TRANSPORT_LIST_SASTIFIED, info.index));						
					break;
				case QuestTransportEventName.SKIP_MISSION:
					//show dialog to confirm use xuxu than chuong for skip current quest running
					obj.type = ConfirmDialog.CONFIRM_FOR_SKIP;
					obj.index = info.index;
					obj.total = info.timeTotal;
					obj.remain = info.timeCurrent;

					var priceBase:Array = Game.database.gamedata.getConfigData(GameConfigID.QUEST_TRANSPORT_PRICE_BASE) as Array;
					if(priceBase && priceBase[0] && priceBase[1])
						obj.price = Math.ceil((info.timeCurrent /*/ info.timeTotal*/) / priceBase[0] / 60) * priceBase[1] ;

					(baseView as QuestTransportView).showConfirmDialog(obj);
					break;
				case QuestTransportEventName.START_MISSION:
					//confirm to start mission 
					Game.network.lobby.sendPacket(new RequestActiveQuestTransport(info.index, info.unitAttend));
					break;	
			}
			//prepare quest transport state
			//Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.QUEST_TRANSPORT_STATE));
		}
		
		override protected function onTransitionOutComplete():void 
		{
			super.onTransitionOutComplete();
			Game.network.lobby.removeEventListener(Server.SERVER_DATA, onLobbyServerData);	
			//view.removeEventListener(CharacterSlot.CHARACTER_SLOT_CLICK, onCharacterSelectedHdl);
			baseView.removeEventListener(CharacterSlot.CHARACTER_SLOT_DCLICK, onCharacterSelectedHdl);
			resetUnitUsedTemp();
				
		}
		
		override protected function onTransitionInComplete():void 
		{
			super.onTransitionInComplete();
			baseView.addEventListener(CharacterSlot.CHARACTER_SLOT_DCLICK, onCharacterSelectedHdl);
		}
		
		override protected function transitionIn():void 
		{
			
			var inventoryModule:ModuleBase = Manager.module.getModuleByID(ModuleID.INVENTORY_UNIT);
			(baseView as QuestTransportView).addChild(inventoryModule.baseView);
			inventoryModule.baseView.x = 80;
			inventoryModule.baseView.y = 105;
			(InventoryView)(inventoryModule.baseView).setMode(InventoryMode.QUEST_TRANSPORT);
			(InventoryView)(inventoryModule.baseView).transitionIn();
			
			Game.network.lobby.addEventListener(Server.SERVER_DATA, onLobbyServerData);	
			//prepare quest transport state
			//Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.QUEST_TRANSPORT_STATE));			
			//prepare current quest user have --> active//inactive --> if active what esclapse time
			Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.QUEST_TRANSPORT_INFO));	
			
			super.transitionIn();
		}
		
		private function onLobbyServerData(e:EventEx):void 
		{
			var packet:ResponsePacket = e.data as ResponsePacket;
			switch(packet.type) {				
				/*case LobbyResponseType.QUEST_TRANSPORT_STATE:
					var packetState:ResponseQuestTransportState = packet as ResponseQuestTransportState;
					Utility.log(" response --> quest transport state: " + packetState.state);
					switch(packetState.state) {
						case 3://out of quests in day
							var obj:Object = { };
							obj.type = ConfirmDialog.CONFIRM_FOR_ALL_COMPLETED;
							obj.index = -1;
							(view as QuestTransportView).showConfirmDialog(obj);
							break;
						case 0://error 							
						case 1://has quest but has no completed
						case 4://has quest completed but not confirm
							break;
						case 2://waiting for the next random
							//show dialog to confirm use xuxu than chuong for skip time cout down to next missions
							obj = { };
							obj.type = ConfirmDialog.CONFIRM_FOR_REFRESH;
							obj.index = -1;
							var priceBase:Array = Game.database.gamedata.getConfigData(GameConfigID.QUEST_TRANSPORT_PRICE_BASE) as Array;
							//var timeRefreshBase:int = Game.database.gamedata.getConfigData(GameConfigID.QUEST_TRANSPORT_TIME_REFRESH) as int;
							if(priceBase && priceBase[0] && priceBase[1])
								obj.price = Math.ceil((packetState.elapseTimeToNextRandom / 60) / priceBase[0]) * priceBase[1] ;
							obj.remain = packetState.elapseTimeToNextRandom;
							Utility.log("price to refresh next random till " + obj.remain + " is " + obj.price);
							(view as QuestTransportView).showConfirmDialog(obj);
							break;
					}
					//update hud view btn state
					var hudView:HUDView = Manager.module.getModuleByID(ModuleID.HUD).view as HUDView;
					if (hudView) 
						hudView.updateQuestTransportState(packetState);
					break;*/
				case LobbyResponseType.QUEST_TRANSPORT_INFO:					
					var packetInfo:ResponseQuestTransportInfo = packet as ResponseQuestTransportInfo;
					Utility.log(" response --> quest transport info --> num quests is " + packetInfo.quests.length);					
					(baseView as QuestTransportView).updateQuestInfo(packetInfo);
					break;
				case LobbyResponseType.QUEST_TRANSPORT_LIST_SASTIFIED:
					var packetList:ResponseQuestTransportListSastified = packet as ResponseQuestTransportListSastified;
					Utility.log(" response --> quest transport list sastified " + packetList.value.length);
					Game.database.userdata.questTransportFilterID = packetList.value;
					Game.uiData.dispatchEvent(new Event(UIData.DATA_CHANGED));
					break;
				case LobbyResponseType.QUEST_TRANSPORT_ACTIVE:
					var packetActive:IntResponsePacket = packet as IntResponsePacket;
					Utility.log(" response --> quest transport active with errorcode " + packetActive.value);
					switch(packetActive.value) {
						case 0:	//success
							Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.QUEST_TRANSPORT_INFO));	
							break;
						case 3:	//unit fail condition							
							Manager.display.showMessageID(MessageID.QUEST_TRANSPORT_FAIL_UNIT_CONDITION);
							break;
						case 4:	//not enought xu
							Game.flow.doAction(FlowActionEnum.PURCHASE_RESOURCE, PaymentType.XU_NORMAL.ID);							
							break;
						case 5:	//reach max limit auest completed in day
							Manager.display.showMessageID(MessageID.QUEST_TRANSPORT_REACH_MAX_COMPLETED);
							break;		
					}
					break;
				case LobbyResponseType.QUEST_TRANSPORT_CLOSE:
					var packetClose:IntResponsePacket = packet as IntResponsePacket;
					Utility.log(" response --> quest transport close with errorcode " + packetClose.value);
					switch(packetClose.value) {
						case 0:							
							(baseView as QuestTransportView).showEffectCompleted();
							break;
						case 2:	//full inventory							
							Manager.display.showMessageID(MessageID.QUEST_TRANSPORT_FINISH_FAIL_BY_FULL_INVENTORY);
							break;
						case 5:	//not enough xu
							Game.flow.doAction(FlowActionEnum.PURCHASE_RESOURCE, PaymentType.XU_NORMAL.ID);
							break;						
					}
					break;
				case LobbyResponseType.QUEST_TRANSPORT_REFRESH:
					var packetRefresh:IntResponsePacket = packet as IntResponsePacket;
					Utility.log(" response --> quest transport refresh with errorcode " + packetRefresh.value);
					switch(packetRefresh.value) {
						case 0:
							Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.QUEST_TRANSPORT_INFO));	
							break;
						case 2:	//not enough xu
							Game.flow.doAction(FlowActionEnum.PURCHASE_RESOURCE, PaymentType.XU_NORMAL.ID);
							break;	
						case 3:	//reach max limit auest completed in day
							Manager.display.showMessageID(MessageID.QUEST_TRANSPORT_REACH_MAX_COMPLETED);
							break;
					}
					break;
				case LobbyResponseType.QUEST_TRANSPORT_RENT:
					var packetRent:IntResponsePacket = packet as IntResponsePacket;
					Utility.log(" response --> quest transport rent with errorcode " + packetRent.value);
					switch(packetRent.value) {
						case 0: //success --> refresh mission selected
							var info:MissionInfo = (baseView as QuestTransportView).getMissionInfoSelected();
							if (info && _rentInfoTemp) {
								info.updateUnitIDAtIndex(_rentInfoTemp.slotIndex, -2);
								(baseView as QuestTransportView).updateMissionSelected(info);
							}
							Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.QUEST_TRANSPORT_INFO));
							break;
						case 2:	//not enough xu
							Game.flow.doAction(FlowActionEnum.PURCHASE_RESOURCE, PaymentType.XU_NORMAL.ID);
							break;
						case 7: //reach max limit auest completed in day
							Manager.display.showMessageID(MessageID.QUEST_DAILY_REACH_MAX_COMPLETED);
							break;	
						default: //reset rent info for next use		
							_rentInfoTemp = null;
							break;
					}
					break;	
				case LobbyResponseType.QUEST_TRANSPORT_SKIP:
					var packetSkip:IntResponsePacket = packet as IntResponsePacket;
					Utility.log(" response --> quest transport skip with errorcode " + packetSkip.value);
					switch(packetSkip.value) {
						case 0:
							Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.QUEST_TRANSPORT_INFO));	
							break;
						case 2:	//not enought xu
							Game.flow.doAction(FlowActionEnum.PURCHASE_RESOURCE, PaymentType.XU_NORMAL.ID);
							break;
					}
					break;
				case LobbyResponseType.QUEST_TRANSPORT_CLEAR_QUEST:
					var packectClear:IntResponsePacket = packet as IntResponsePacket;
					switch(packectClear.value) {
						case 0:
							Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.QUEST_TRANSPORT_INFO));	
							break;
						case 3:	//reach max limit quest completed in day
							Manager.display.showMessageID(MessageID.QUEST_DAILY_REACH_MAX_COMPLETED);
							break;	
					}
					break;
			}
		}

		//TUTORIAL

		public function showHintQuest(questIndex:int, content:String =""):void
		{
			if(baseView)
				QuestTransportView(baseView).showHintQuest(questIndex, content);
		}

		public function showHintButton(content:String = ""):void
		{
			if(baseView)
				QuestTransportView(baseView).showHintButton(content);
		}

		public function get selectedQuest():MissionInfo
		{
			if(baseView)
				return QuestTransportView(baseView).selectedQuest;

			return null;
		}
	}
}