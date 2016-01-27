package game.ui.quest_main 
{
	import core.display.layer.Layer;
	import core.display.ModuleBase;
	import core.event.EventEx;
	import core.Manager;
	import core.util.Utility;
	import flash.events.Event;
	import flash.utils.Dictionary;
	import game.data.model.ConversationModel;
	import game.data.vo.quest_transport.ConditionInfo;
	import game.data.xml.DataType;
	import game.data.xml.VIPConfigXML;
	import game.enum.FlowActionEnum;
	import game.flow.FlowManager;
	import game.Game;
	import game.net.IntResponsePacket;
	import game.net.lobby.LobbyRequestType;
	import game.net.lobby.LobbyResponseType;
	import game.net.lobby.request.RequestQuestMainClose;
	import game.net.lobby.response.ResponseQuestMainInfo;
	import game.net.RequestPacket;
	import game.net.ResponsePacket;
	import game.net.Server;
	import game.ui.components.CharacterDialogue;
	import game.ui.dialog.DialogID;
	import game.ui.dialog.dialogs.YesNo;
	import game.ui.home.scene.CharacterManager;
	import game.ui.hud.HUDModule;
	import game.ui.hud.HUDView;
	import game.ui.message.MessageID;
	import game.ui.ModuleID;
	import game.utility.GameUtil;
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class QuestMainModule extends ModuleBase
	{
		private var charDialogue:CharacterDialogue;
		private var hudModule:HUDModule;
		public function QuestMainModule() 
		{
			
		}
		
		override protected function createView():void 
		{
			super.createView();
			baseView = new QuestMainView();
			
			baseView.addEventListener(Event.CLOSE, onCloseHdl);
			baseView.addEventListener(QuestMainView.FINISH_MAIN_QUEST, onFinishQuestHdl);
			baseView.addEventListener(ConditionMainUI.GO_TO_MAIN_ACTION, onGoToActionHdl);
			baseView.addEventListener(QuestMainView.SHOW_QUEST_MAIN_EFFECT_COMPLETED, onShowEffectCompletedHdl);
			//view.addEventListener(QuestMainView.SHOW_QUEST_MAIN_FINISH_COMPLETED, onShowFinishCompletedHdl);
		}
		
		private function onShowEffectCompletedHdl(e:Event = null):void 
		{
			Utility.log("show effect completed --> request new quest");
			Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.QUEST_MAIN_INFO));
		}
		
		/*private function onFlowActionCompletedHdl(e:EventEx):void 
		{
			switch(e.data.type) {
				case FlowActionEnum.CREATE_LOBBY_SUCCESS:
					Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.NOTIFY_JOIN_ROOM_READY));
					break;
				case FlowActionEnum.UPDATE_LOBBY_INFO_SUCCESS:
					Game.flow.doAction(FlowActionEnum.START_LOBBY);					
					break;
				case FlowActionEnum.START_LOBBY_SUCCESS:	
					Game.flow.doAction(FlowActionEnum.START_LOADING_RESOURCE);
					break;
			}
		}*/
		
		private function onGoToActionHdl(e:EventEx):void 
		{	
			var con:ConditionInfo = e.data as ConditionInfo;
			Game.flow.doAction(FlowActionEnum.GO_TO_ACTION, con );
			/*//check vip condition
			var currentVip:int = Game.database.userdata.vip;
			var currentVipInfo:VIPConfigXML = Game.database.gamedata.getData(DataType.VIP, currentVip) as VIPConfigXML;
			var actionValid:Boolean = true;// currentVipInfo ? currentVipInfo.dailyQuestGotoPlay : false;
			
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
				dialogData.message = "Lập tức di chuyển đến nơi làm nhiệm vụ. \nVip" + actionValidNext.toString() 
										+ " mới được sử dụng chức năng này. Các hạ có muốn xem thông tin VIP không?";
				dialogData.option = YesNo.YES | YesNo.CLOSE | YesNo.NO;
				Manager.display.showDialog(DialogID.YES_NO, onAcceptViewHdl, null, dialogData, Layer.BLOCK_BLACK);	
			}*/
		}
		
		private function onAcceptViewHdl(data:Object):void 
		{
			Manager.display.showPopup(ModuleID.DIALOG_VIP, Layer.BLOCK_BLACK);
		}
		
		private function onFinishQuestHdl(e:EventEx):void 
		{
			if (e.data) {		
				var questIndex:int = e.data.questIndex;
				var optionIndex:int = e.data.optionIndex;
				/*if (_questSelectedIndex > -1) {
					var quest:QuestInfo = _quests[_questSelectedIndex] as QuestInfo;
					_optionalRewardSelectedIndex = quest && quest.xmlData && quest.xmlData.optionalRewardIDs.length > 0 ? 0 : -1;
					Utility.log("quest main optional reward sending :" + _optionalRewardSelectedIndex);
				}*/
				if(optionIndex == -1)
					Manager.display.showMessageID(MessageID.QUEST_MAIN_SELECT_OPTION_REWARD_TO_FINISH);
				else 
					Game.network.lobby.sendPacket(new RequestQuestMainClose(questIndex, optionIndex < 0 ? -1 : optionIndex));
			}
		}
		
		private function onCloseHdl(e:Event):void 
		{
			if (hudModule != null) {
				Manager.display.clearKeepedModule(ModuleID.QUEST_MAIN);
				hudModule.updateHUDButtonStatus(ModuleID.QUEST_MAIN, false);
			}
			
			//Manager.display.hideModule(ModuleID.QUEST_MAIN);
		}
		
		override protected function transitionIn():void 
		{
			super.transitionIn();
			
			hudModule = Manager.module.getModuleByID(ModuleID.HUD) as HUDModule;
			
			Game.network.lobby.addEventListener(Server.SERVER_DATA, onLobbyServerData);	
			//Game.flow.addEventListener(FlowManager.ACTION_COMPLETED, onFlowActionCompletedHdl);
			
			//prepare quest transport state
			//prepare current quest user have --> active//inactive --> if active what esclapse time
			onShowEffectCompletedHdl(null);
			//Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.QUEST_MAIN_STATE));			
			//Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.QUEST_MAIN_INFO));		
			
			//var test:int = GameUtil.getNextLevelActiveSkill(2);
			//Utility.log("next level get active skill is " + test);
		}

		private function onLobbyServerData(e:EventEx):void 
		{
			var packet:ResponsePacket = e.data as ResponsePacket;
			switch(packet.type) {
				/*case LobbyResponseType.QUEST_MAIN_STATE:
					var packetState:IntResponsePacket = packet as IntResponsePacket;
					Utility.log(" response --> quest main state: " + packetState.value);
					(Manager.module.getModuleByID(ModuleID.HUD).view as HUDView).updateQuestMainState(packetState.value);
					break;*/
				case LobbyResponseType.QUEST_MAIN_INFO:
					var packetInfo:ResponseQuestMainInfo = packet as ResponseQuestMainInfo;
					//Utility.log(" response --> quest main info --> num quests is " + packetInfo.quests.length);		
					Game.database.userdata.quests = ResponseQuestMainInfo(packet).quests;
					if(Game.database.userdata.quests.length>0)
					{
						(baseView as QuestMainView).updateQuests(packetInfo.quests);
						if(HUDModule) hudModule.updateHUDButton();
					}
					else
						showCharacterDialogEnndQuest();
					
					break;
				case LobbyResponseType.QUEST_MAIN_CLOSE:
					var packetClose:IntResponsePacket = packet as IntResponsePacket;
					Utility.log(" response --> quest close value " + packetClose.value);
					switch(packetClose.value) {
						case 0:
							//success --> show animation
							//(view as QuestMainView).showEffectCompleted();
							(baseView as QuestMainView).showComplete();
							//Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.QUEST_MAIN_STATE));
							//Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.QUEST_MAIN_INFO));	
							break;
						case 1:
							//normal fail
							
							break;
						case 2:
							//full inventory
							Manager.display.showMessageID(MessageID.QUEST_MAIN_FINISH_FAIL_BY_FULL_INVENTORY);
							break;	
					}
					break;
			}
		}
		
		private function showCharacterDialogEnndQuest():void 
		{
			var conversationModel:ConversationModel = new ConversationModel();
			conversationModel.animIndex = 0;
			conversationModel.animURL = "resource/tutorial/quach_tinh_tut.banim";
			conversationModel.direction = 1;
			conversationModel.ID = 1;
			conversationModel.layerMask = 1;
			conversationModel.texts = ["Đến đây thì chắc ngươi đã nắm rất rõ về tình hình giang hồ rồi..",
			"Ngươi đã hoàn thành hết các nhiệm vụ chính rất tốt, khi nào có nhiệm vụ quan trọng ta sẽ giao cho ngươi ^^"];
			charDialogue = new CharacterDialogue();
			charDialogue.setData(conversationModel);
			this.baseView.addChild(charDialogue);
			charDialogue.setCallbackFunc(function increaseIndex():void {
				this.parent.removeChild(this);
				charDialogue = null;
				
				if (hudModule != null) {
					hudModule.updateHUDButtonStatus(ModuleID.QUEST_MAIN, true);
					hudModule.updateHUDButton();
				}
			});
		}
		
		override protected function onTransitionOutComplete():void 
		{
			super.onTransitionOutComplete();
			Game.network.lobby.removeEventListener(Server.SERVER_DATA, onLobbyServerData);	
			//Game.flow.removeEventListener(FlowManager.ACTION_COMPLETED, onFlowActionCompletedHdl);
			
			CharacterManager.instance.displayCharacters();
		}
		
		override protected function onTransitionInComplete():void 
		{
			super.onTransitionInComplete();
			CharacterManager.instance.hideCharacters();
		}

		//TUTORIAL
		public function showHintButton():void
		{
			(baseView as QuestMainView).showHintButton();
		}
	}

}