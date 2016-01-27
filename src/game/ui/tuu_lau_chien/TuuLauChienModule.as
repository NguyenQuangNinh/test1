package game.ui.tuu_lau_chien 
{
	import core.display.layer.Layer;
	import core.display.layer.LayerManager;
	import core.display.ModuleBase;
	import core.event.EventEx;
	import core.Manager;
	import core.util.Utility;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.utils.setTimeout;
	import game.data.model.UserData;
	import game.data.vo.challenge.HistoryInfo;
	import game.data.vo.lobby.LobbyInfo;
	import game.data.vo.lobby.LobbyPlayerInfo;
	import game.data.vo.tuu_lau_chien.ResourceInfo;
	import game.enum.FlowActionEnum;
	import game.enum.FormationType;
	import game.enum.GameConfigID;
	import game.enum.GameMode;
	import game.enum.NotifyType;
	import game.Game;
	import game.net.IntRequestPacket;
	import game.net.IntResponsePacket;
	import game.net.lobby.LobbyRequestType;
	import game.net.lobby.LobbyResponseType;
	import game.net.lobby.request.RequestFormation;
	import game.net.lobby.response.ResponseFormation;
	import game.net.lobby.response.ResponseListResourceOccupied;
	import game.net.lobby.response.ResponseLobbyNotifyClient;
	import game.net.lobby.response.ResponseOwnerResourceInfo;
	import game.net.lobby.response.ResponseResourceInfo;
	import game.net.lobby.response.ResponseTuuLauChienHistory;
	import game.net.RequestPacket;
	import game.net.ResponsePacket;
	import game.net.Server;
	import game.ui.dialog.DialogID;
	import game.ui.dialog.dialogs.TuuLauChienDialog;
	import game.ui.dialog.dialogs.TuuLauChienHistoryDialog;
	import game.ui.dialog.dialogs.YesNo;
	import game.ui.hud.HUDModule;
	import game.ui.ingame.replay.GameReplayManager;
	import game.ui.message.MessageID;
	import game.ui.ModuleID;
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class TuuLauChienModule extends ModuleBase
	{
		private var _needShowDialog:Boolean = false;
		
		private var _resourceDialog:TuuLauChienDialog;
		private var _historyDialog:TuuLauChienHistoryDialog;
		
		private var _ownerInfo:ResourceInfo;
		private var _playerTarget:LobbyPlayerInfo;
		
		public function TuuLauChienModule() 
		{
			_playerTarget = new LobbyPlayerInfo();
		}
		
		override protected function createView():void 
		{
			super.createView();
			baseView = new TuuLauChienView();
			_resourceDialog = new TuuLauChienDialog();
			_historyDialog = new TuuLauChienHistoryDialog();
			
			//add view events
			baseView.addEventListener(Event.CLOSE, onCloseHdl);
			baseView.addEventListener(TuuLauChienIconMov.ON_REQUEST_RESOURCE_INFO, onRequestResourceInfoHdl);
			baseView.addEventListener(TuuLauChienInfoMov.OCCUPY_RESOURCE_COMPLETED, onOccupyCompletedHdl);
			baseView.addEventListener(TuuLauChienView.ON_REQUEST_HISTORY, onHistoryRequestHdl);
			
			baseView.addEventListener(TuuLauChienHistoryDialog.ON_REQUEST_VIEW_HISTORY_RESOURCE_MATCH, onActionRequestHdl);
			
			baseView.addEventListener(TuuLauChienDialog.ON_REQUEST_ACTIVE_PROTECT_RESOURCE, onActionRequestHdl);
			baseView.addEventListener(TuuLauChienDialog.ON_REQUEST_ACTIVE_BUFF_RESOURCE, onActionRequestHdl);
			baseView.addEventListener(TuuLauChienDialog.ON_REQUEST_CANCEL_OCCUPY_RESOURCE, onActionRequestHdl);
			baseView.addEventListener(TuuLauChienDialog.ON_REQUEST_ATTACK_RESOURCE, onActionRequestHdl);
			baseView.addEventListener(TuuLauChienDialog.ON_REQUEST_OCCUPY_RESOURCE, onActionRequestHdl);
			baseView.addEventListener(TuuLauChienDialog.OCCUPY_RESOURCE_COMPLETED_DIALOG, onOccupyCompletedHdl);
		}
		
		private function onHistoryRequestHdl(e:Event):void 
		{
			Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.REQUEST_TUU_LAU_CHIEN_HISTORY));	
		}
		
		private function onOccupyCompletedHdl(e:EventEx):void 
		{
			var info:ResourceInfo = e.data as ResourceInfo;
			if (info)
			{
				_resourceDialog.visible = false;
				//request server to get info
				Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.LIST_RESOURCES_OCCUPIED));
				Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.OWNER_RESOURCE_INFO));
			}
		}
		
		private function onAcceptActiveProtectHdl(data:Object):void 
		{
			Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.ACTIVE_RESOURCE_PROTECT));
		}
		
		private function onAcceptActiveBuffHdl(data:Object):void 
		{
			Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.ACTIVE_RESOURCE_BUFF));
		}
		
		private function onActionRequestHdl(e:EventEx):void 
		{
			var info:ResourceInfo = e.data as ResourceInfo;
			switch(e.type)
			{
				case TuuLauChienDialog.ON_REQUEST_ACTIVE_PROTECT_RESOURCE:
					if (info)
					{
						_needShowDialog = true;
						//Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.ACTIVE_RESOURCE_PROTECT));
						var dialogProtect:Object = {};
						dialogProtect.title = "Kích hoạt bảo vệ";
						var timeProtect:int = Game.database.gamedata.getConfigData(GameConfigID.MAX_TIME_ROB_ENABLE) as int;
						var priceProtect:int = Game.database.gamedata.getConfigData(GameConfigID.PRICE_ACTIVE_PROTECT_PER_DAY) as int;
						dialogProtect.message = "Kích hoạt bảo vệ giúp Tửu lâu của bạn không bị người chơi khác đánh chiếm và cướp đoạt."
								+ "Kích hoạt bảo vệ tiêu tốn <font color='#00FF00'>" + priceProtect + "</font> vàng, bạn xác nhận kích hoạt ?";
						dialogProtect.option = YesNo.YES | YesNo.CLOSE | YesNo.NO;
						Manager.display.showDialog(DialogID.YES_NO, onAcceptActiveProtectHdl, null, dialogProtect, Layer.BLOCK_BLACK);
					}
					break;
				case TuuLauChienDialog.ON_REQUEST_ACTIVE_BUFF_RESOURCE:
					if (info)
					{
						_needShowDialog = true;
						//Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.ACTIVE_RESOURCE_BUFF));
						var timeBuff:int = Game.database.gamedata.getConfigData(GameConfigID.MAX_TIME_BUFF_ENABLE) as int;
						var priceBuff:int = Game.database.gamedata.getConfigData(GameConfigID.PRICE_ACTIVE_BUFF_PER_DAY) as int;
						var dialogBuff:Object = {};
						dialogBuff.title = "Tăng cường mua bán";
						dialogBuff.message = "Tăng cường mua bán Tửu Lâu sẽ nhận được gấp đôi số bạc nhận được,"
								+ "nhưng khi bi cướp đoạt sẽ mất gấp đôi số bạc. Chỉ có thể tăng cường trong " + timeBuff + " phút đầu tiên chiếm Tửu Lâu."
								+ "Tăng cường tiêu tốn <font color='#00FF00'>" + priceBuff + "</font> vàng, bạn xác nhận tăng cường ?";
						dialogBuff.option = YesNo.YES | YesNo.CLOSE | YesNo.NO;
						Manager.display.showDialog(DialogID.YES_NO, onAcceptActiveBuffHdl, null, dialogBuff, Layer.BLOCK_BLACK);
					}
					break;
				case TuuLauChienDialog.ON_REQUEST_CANCEL_OCCUPY_RESOURCE:
					if (info)
					{
						Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.CANCEL_RESOURCE_OCCUPIED));
					}
					break;
				case TuuLauChienDialog.ON_REQUEST_ATTACK_RESOURCE:
					if (info)
					{								
						//first all need to request target formation
						if (info.ownerID > 0)
						{							
							info.requestAction = false;
							_playerTarget.reset();
							_playerTarget.id = info.ownerID;
							Game.network.lobby.sendPacket(new RequestFormation(FormationType.FORMATION_CHALLENGE.ID, info.ownerID));
						}
						else 
						{
							//requestCreateRoom();
							Utility.log("can not attack resource of NPC control");
						}
					}
					break;
				case TuuLauChienDialog.ON_REQUEST_OCCUPY_RESOURCE:
					if (info)
					{
						//first all need to request target formation
						if (info.ownerID > 0)
						{
							info.requestAction = true;
							_playerTarget.reset();
							_playerTarget.id = info.ownerID;
							Game.network.lobby.sendPacket(new RequestFormation(FormationType.FORMATION_CHALLENGE.ID, info.ownerID));							
						}
						else 
						{
							requestCreateRoom();
						}
					}
					break;				
				case TuuLauChienHistoryDialog.ON_REQUEST_VIEW_HISTORY_RESOURCE_MATCH:
					var historyInfo:HistoryInfo = e.data as HistoryInfo
					if (historyInfo) 
					{
						//replay history resource match
						var mainPlayer:LobbyPlayerInfo = new LobbyPlayerInfo();
						mainPlayer.id = Game.database.userdata.userID;
						mainPlayer.owner = true;
						mainPlayer.level = Game.database.userdata.level;
						mainPlayer.name = Game.database.userdata.playerName;
						
						var player:LobbyPlayerInfo = new LobbyPlayerInfo();
						player.id = historyInfo.playerID;
						player.name = historyInfo.name;
						player.level = 1;
						player.owner = false;
						
						var players:Array = [player, mainPlayer];
						Utility.log("start replay tuu lau chien");
						Game.network.lobby.removeEventListener(Server.SERVER_DATA, onLobbyServerData);
						GameReplayManager.getInstance().beginReplaying(GameMode.PVP_RESOURCE_WAR_PVP, historyInfo.nTimeCreate, players, ModuleID.TUULAUCHIEN);
						
						_historyDialog.lock();
						setTimeout(_historyDialog.unlock, 2000);
						setTimeout(function():void
						{
							Game.network.lobby.addEventListener(Server.SERVER_DATA, onLobbyServerData);
						}, 2000);
					}
					break;
			}
		}
		
		private function onRequestResourceInfoHdl(e:EventEx):void 
		{
			var resourceID:int = e.data as int;
			//request server to get resource info
			if (_ownerInfo && _ownerInfo.id == resourceID)
			{
				_needShowDialog = true;
				Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.OWNER_RESOURCE_INFO));
			}
			else 
			{				
				Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.RESOURCE_INFO, resourceID));
			}
		}
		
		private function onCloseHdl(e:Event):void 
		{
			var hudModule: HUDModule = Manager.module.getModuleByID(ModuleID.HUD) as HUDModule;
			if (hudModule != null) {
				hudModule.updateHUDButtonStatus(ModuleID.TUULAUCHIEN, false);
			}
			
			Manager.display.to(ModuleID.HOME);
		}
		
		override protected function transitionIn():void 
		{
			super.transitionIn();
			//(baseView as TuuLauChienView).resetDisplay();
			(baseView as TuuLauChienView).initUI();
			(baseView as TuuLauChienView).resetResourceSelected();
			(baseView as TuuLauChienView).infoMov.checkTimeAttack();
			Manager.display.showModule(ModuleID.HUD, new Point(0,0), LayerManager.LAYER_HUD, "top_left", Layer.NONE);
			Manager.display.showModule(ModuleID.TOP_BAR, new Point(0,0), LayerManager.LAYER_TOP);
			Manager.display.showModule(ModuleID.CHAT, new Point(0,0), LayerManager.LAYER_SCREEN_TOP, "top_left");
			
			Utility.log("TuuLauChienModule --> TuuLauChienModule.transitionIn");
			Game.network.lobby.addEventListener(Server.SERVER_DATA, onLobbyServerData);	
			
			//request server to get info
			Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.LIST_RESOURCES_OCCUPIED));
			Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.OWNER_RESOURCE_INFO));
			Game.database.userdata.addEventListener(UserData.LOBBY_NOTIFY_CLIENT, onLobbyNotifyClient);
		}
		
		private function onLobbyNotifyClient(e:EventEx):void 
		{
			var packet:ResponseLobbyNotifyClient = e.data as ResponseLobbyNotifyClient;
			if (packet)
			{
				switch (packet.notifyType)
				{
					case NotifyType.NOTIFY_TUU_LAU_CHIEN.ID:
					{
						(baseView as TuuLauChienView).notify.visible = true;
						break;
					}
				}
			}
		}
		
		override protected function onTransitionOutComplete():void 
		{
			super.onTransitionOutComplete();
			
			Game.network.lobby.removeEventListener(Server.SERVER_DATA, onLobbyServerData);	
			Game.database.userdata.removeEventListener(UserData.LOBBY_NOTIFY_CLIENT, onLobbyNotifyClient);
			_resourceDialog.visible = false;
			_historyDialog.visible = false;
		}
		
		private function onLobbyServerData(e:EventEx):void 
		{
			Utility.log("TuuLauChienModule --> TuuLauChienModule.onLobbyServerData");
			
			var packet:ResponsePacket = e.data as ResponsePacket;
			switch(packet.type) 
			{
				case LobbyResponseType.LIST_RESOURCES_OCCUPIED:
					var listPackets:ResponseListResourceOccupied = packet as ResponseListResourceOccupied;
					(baseView as TuuLauChienView).updateNodesInfo(listPackets.info);
					
					break;
				case LobbyResponseType.OWNER_RESOURCE_INFO:
					var ownerInfo:ResponseOwnerResourceInfo = packet as ResponseOwnerResourceInfo;
					_ownerInfo = ownerInfo.info;
					(baseView as TuuLauChienView).updateSelfInfo(ownerInfo.info);					
					if (_needShowDialog)
					{
						_needShowDialog = false;
						//(baseView as TuuLauChienView).updateInfoCache(ownerInfo.info);
						(baseView as TuuLauChienView).updateResourceInfo(ownerInfo.info);
						_resourceDialog.data = { data:ownerInfo.info };					
						_resourceDialog.visible = true;
						baseView.addChild(_resourceDialog);
					}
					break;
				case LobbyResponseType.RECEIVE_TUU_LAU_CHIEN_HISTORY:
					var history:ResponseTuuLauChienHistory = packet as ResponseTuuLauChienHistory;
					_historyDialog.data = { data:history.historyInfo };					
					_historyDialog.visible = true;
					baseView.addChild(_historyDialog);
					break;
				case LobbyResponseType.RESOURCE_INFO:
					var resourceInfo:ResponseResourceInfo = packet as ResponseResourceInfo;
					//(baseView as TuuLauChienView).updateInfoCache(resourceInfo.info);
					(baseView as TuuLauChienView).updateResourceInfo(resourceInfo.info);
					_resourceDialog.data = { data:resourceInfo.info };					
					_resourceDialog.visible = true;
					baseView.addChild(_resourceDialog);
					break;					
				case LobbyResponseType.ACTIVE_RESOURCE_BUFF:
					var buffPacket:IntResponsePacket = packet as IntResponsePacket;
					switch(buffPacket.value)
					{
						case 0:
							//buff success
							Manager.display.showMessageID(MessageID.SUCCESS_ACTIVE_BUFF_RESOURCE_INFO);
							Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.OWNER_RESOURCE_INFO));
							Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.LIST_RESOURCES_OCCUPIED));
							Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.GET_PLAYER_INFO));
							break;
						case 1:
							//buff fail 
							Manager.display.showMessageID(MessageID.FAIL_ACTIVE_BUFF_RESOURCE_INFO);
							break;
						case 2:
							//can not buff by over expire time
							Manager.display.showMessageID(MessageID.FAIL_ACTIVE_BUFF_BY_OVER_TIME_EXPIRE);
							break;
						case 3:
							//can not buff by not enough gold							
							Manager.display.showMessageID(MessageID.FAIL_ACTIVE_BUFF_BY_NOT_ENOUGH_GOLD);
							break;
						case 4:
							//has already active buffed before
							Manager.display.showMessageID(MessageID.FAIL_BY_ALREADY_BUFFED_BEFORE);
							break;
							
					}					
					break;
				case LobbyResponseType.ACTIVE_RESOURCE_PROTECT:
					var protectPacket:IntResponsePacket = packet as IntResponsePacket;
					switch(protectPacket.value)
					{
						case 0:
							//protect success
							Manager.display.showMessageID(MessageID.SUCCESS_ACTIVE_PROTECT_RESOURCE_INFO);
							Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.OWNER_RESOURCE_INFO));
							Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.LIST_RESOURCES_OCCUPIED));
							Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.GET_PLAYER_INFO));
							break;
						case 1:
							//protect fail
							Manager.display.showMessageID(MessageID.FAIL_ACTIVE_PROTECT_RESOURCE_INFO);
							break;
						case 2:
							//can not protect by not enough money
							Manager.display.showMessageID(MessageID.FAIL_ACTIVE_PROTECT_BY_NOT_ENOUGH_GOLD);
							break;	
						case 3:
							//can not protect by over num protect per day
							Manager.display.showMessageID(MessageID.FAIL_ACTIVE_PROTECT_BY_OVER_NUM_PER_DAY);
							break;
						case 4:
							//has already active protected before
							Manager.display.showMessageID(MessageID.FAIL_BY_ALREADY_PROTECTED_BEFORE);
							break;
					}
					
					break;
				case LobbyResponseType.CANCEL_RESOURCE_OCCUPIED:
					var cancelPacket:IntResponsePacket = packet as IntResponsePacket;
					switch(cancelPacket.value)
					{
						case 0:
							//success cancel
							_resourceDialog.visible = false;
							Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.OWNER_RESOURCE_INFO));
							Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.LIST_RESOURCES_OCCUPIED));
							Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.GET_PLAYER_INFO));
							break;
						case 1:
							//fail cancel
							
							break;
					}
					break;
				case LobbyResponseType.FORMATION:
					if (GameReplayManager.getInstance().isReplaying) break;
					var packetFormation:ResponseFormation = packet as ResponseFormation;
					switch(packetFormation.formationType) {
						case FormationType.FORMATION_CHALLENGE:
							if (_playerTarget) {				
								if (_playerTarget.id == packetFormation.userID) {									
									Game.database.userdata.lobbyPlayers = [];
									//here was change by remove the last info ~ myself
									var self:LobbyPlayerInfo = new LobbyPlayerInfo();
									self.id = Game.database.userdata.userID;
									//self.characters = Game.database.userdata.getFormationChallenge();
									self.characters = Game.database.userdata.formation;
									self.teamIndex = 1;
									self.owner = true;
									self.level = Game.database.userdata.level;
									self.name = Game.database.userdata.playerName;
									Game.database.userdata.lobbyPlayers[0] = self;
									
									_playerTarget.teamIndex = 2;
									_playerTarget.characters = packetFormation.formation;
									Game.database.userdata.lobbyPlayers[1] = _playerTarget;
									
									requestCreateRoom();
								}
							}else {
								Utility.error("can not go to loading by error NULL player challenge pvp ai");
							}
							break;
					}
					break;
			}
		}
		
		private function requestCreateRoom():void 
		{
			var info:ResourceInfo = _resourceDialog.data as ResourceInfo;
			if (info)
			{				
				var occupyInfo:LobbyInfo = new LobbyInfo();
				occupyInfo.challengeID = info.ownerID;
				occupyInfo.bOccupied = info.requestAction;	//flag to notice depend on user action request --> here mean want to occupy
				occupyInfo.mode = info.ownerID == 0 ? GameMode.PVE_RESOURCE_WAR_NPC : GameMode.PVP_RESOURCE_WAR_PVP;
				occupyInfo.missionID = info.id;
				occupyInfo.backModule = ModuleID.TUULAUCHIEN;
				Game.flow.doAction(FlowActionEnum.CREATE_BASIC_LOBBY, occupyInfo);				
			}
		}
	}

}