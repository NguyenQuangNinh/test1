package game.ui.global_boss 
{
	import core.display.layer.Layer;
	import core.display.layer.LayerManager;
	import core.display.ModuleBase;
	import core.event.EventEx;
	import core.Manager;
	import core.util.Utility;
	import flash.geom.Point;
	import flash.utils.setTimeout;
	import game.data.vo.lobby.LobbyInfo;
	import game.enum.ErrorCode;
	import game.enum.FlowActionEnum;
	import game.enum.GameMode;
	import game.enum.PlayerAttributeID;
	import game.Game;
	import game.net.IntRequestPacket;
	import game.net.IntResponsePacket;
	import game.net.lobby.LobbyRequestType;
	import game.net.lobby.LobbyResponseType;
	import game.net.lobby.request.RequestBossMissionInfo;
	import game.net.lobby.response.ResponseGlobalBossHP;
	import game.net.lobby.response.ResponseGlobalBossListPlayers;
	import game.net.lobby.response.ResponseGlobalBossTopDmg;
	import game.net.RequestPacket;
	import game.net.ResponsePacket;
	import game.net.Server;
	import game.ui.dialog.DialogID;
	import game.ui.ModuleID;
	
	/**
	 * ...
	 * @author MaiPTT
	 */
	public class GlobalBossModule extends ModuleBase 
	{
		
		public function GlobalBossModule() {
			
		}
	
		override protected function createView():void {
			super.createView();
			baseView = new GlobalBossView();
			baseView.addEventListener(GlobalBossEvent.EVENT, onUIEventHandler);
		}
		
		override protected function preTransitionIn():void {
			super.preTransitionIn();
			
			if (extraInfo) {
				var missionID:int = extraInfo.missionID;
				(GlobalBossView)(baseView).setMissionID(missionID);
			}
			
			(GlobalBossView)(baseView).setModeConfig(Game.database.gamedata.getGlobalBossConfig());
			Game.network.lobby.addEventListener(Server.SERVER_DATA, onServerDataResponseHandler);
			//Game.flow.addEventListener(FlowManager.ACTION_COMPLETED, onFlowActionCompletedHdl);
		}
		
		override protected function transitionIn():void {
			super.transitionIn();
			Manager.display.hideModule(ModuleID.HUD);
			Manager.display.hideModule(ModuleID.TOP_BAR);
			Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.GET_PLAYER_INFO_ATTRIBUTE, PlayerAttributeID.BATTLE_POINT.ID));
			Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.GET_PLAYER_INFO_ATTRIBUTE, PlayerAttributeID.XU.ID));
			//Manager.display.showModule(ModuleID.HUD, new Point(), LayerManager.LAYER_HUD);
			//Manager.display.showModule(ModuleID.TOP_BAR, new Point(), LayerManager.LAYER_TOP);
			
		}

		override protected function onTransitionInComplete():void {
			super.onTransitionInComplete();
			if (extraInfo) {
				var missionID:int = extraInfo.missionID;
				Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.GLOBAL_BOSS_LIST_PLAYERS,
														missionID));
			}			
		}
		
		override protected function preTransitionOut():void {
			super.preTransitionOut();
			Game.network.lobby.removeEventListener(Server.SERVER_DATA, onServerDataResponseHandler);
			//Game.flow.removeEventListener(FlowManager.ACTION_COMPLETED, onFlowActionCompletedHdl);
		}
		
		/*private function onFlowActionCompletedHdl(e:EventEx):void {
			switch(e.data.type) {
				case FlowActionEnum.CREATE_LOBBY_SUCCESS:
					Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.NOTIFY_JOIN_ROOM_READY));
					break;
				case FlowActionEnum.UPDATE_LOBBY_INFO_SUCCESS:
					Game.flow.doAction(FlowActionEnum.START_LOBBY);					
					break;
				case FlowActionEnum.START_LOBBY_SUCCESS:
					Game.database.userdata.globalBossData.firstPlay = false;
					Game.flow.doAction(FlowActionEnum.START_LOADING_RESOURCE);
					break;
				case FlowActionEnum.START_GAME_ERR_CODE:
					onResponseStartGameErrCode(e.data.value);
					break;
			}
		}*/
		
		/*private function onResponseStartGameErrCode(errorCode:int):void {
			switch(errorCode) {
				case 17:
					GlobalBossView(view).showDialogTimesUp();
					break;
					
				case 5:
					Manager.display.showDialog(DialogID.HEAL_AP);
					break;
			}
		}*/
		
		private function onServerDataResponseHandler(e:EventEx):void {
			var packet:ResponsePacket = e.data as ResponsePacket;
			switch(packet.type) {
				case LobbyResponseType.GLOBAL_BOSS_AUTO_PLAY:
					onResponseAutoPlayResult(packet as IntResponsePacket);
					break;
					
				case LobbyResponseType.GLOBAL_BOSS_AUTO_REVIVE:
					onResponseAutoReviveResult(packet as IntResponsePacket);
					break;
					
				case LobbyResponseType.GLOBAL_BOSS_BUFF_GOLD:
					onResponseBuffGoldResult(packet as IntResponsePacket);
					break;
					
				case LobbyResponseType.GLOBAL_BOSS_BUFF_XU:
					onResponseBuffXuResult(packet as IntResponsePacket);
					break;
					
				case LobbyResponseType.GLOBAL_BOSS_LEAVE_GAME:
					
					break;
					
				case LobbyResponseType.GLOBAL_BOSS_MY_DMG:
					onResponseMyDmg(packet as IntResponsePacket);
					break;
					
				case LobbyResponseType.GLOBAL_BOSS_REVIVE:
					onResponseUserRevive(packet as IntResponsePacket);
					break;
					
				case LobbyResponseType.GLOBAL_BOSS_LIST_PLAYERS:
					onResponseListPlayers(packet as ResponseGlobalBossListPlayers);
					break;
					
				case LobbyResponseType.GLOBAL_BOSS_HP:
					onResponseBossHP(packet as ResponseGlobalBossHP);
					break;
			}
		}
		
		private function onResponseMyDmg(packet:IntResponsePacket):void 
		{
			Game.database.userdata.globalBossData.currentDmg = packet.value;
			(GlobalBossView)(baseView).updateCurrentDmg();
		}
		
		private function onResponseUserRevive(packet:IntResponsePacket):void 
		{
			Utility.log( "Global Boss -> response revive xu result: " + packet.value);
			switch(packet.value) {
				case ErrorCode.SUCCESS:
					Manager.display.showMessage("Đã hồi sinh");
					Manager.display.hideDialog(DialogID.GLOBAL_BOSS_REVIVE);
					Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.GET_PLAYER_INFO_ATTRIBUTE, PlayerAttributeID.GOLD.ID));
					Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.GET_PLAYER_INFO_ATTRIBUTE, PlayerAttributeID.XU.ID));
					Game.database.userdata.globalBossData.setIsReviveCountDown(false);
					Game.database.userdata.numOfRespawnBoss++;
					break;
					
				case 3: //khong du xu
					Manager.display.showMessage("Bạn không có đủ Vàng");
					break;
			}
		}
		
		private function onResponseBuffXuResult(packet:IntResponsePacket):void {
			Utility.log( "Global Boss -> response buff xu result: " + packet.value);
			switch(packet.value) {
				case ErrorCode.SUCCESS:
					Manager.display.showMessage("Buff Vàng thành công");
					Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.GET_PLAYER_INFO_ATTRIBUTE, PlayerAttributeID.XU.ID));
					Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.GET_PLAYER_INFO_ATTRIBUTE, PlayerAttributeID.BATTLE_POINT.ID));
					Game.network.lobby.sendPacket(new RequestBossMissionInfo(LobbyRequestType.GLOBAL_BOSS_MISSION_INFO,
												Game.database.userdata.globalBossData.currentMissionID));
					break;
					
				case 2: //khong du xu
					Manager.display.showMessage("Bạn không có đủ Bạc");
					break;
					
				case 3: //max buff
					Manager.display.showMessage("Đã buff tối đa");
					break;
			}
		}
		
		private function onResponseBuffGoldResult(packet:IntResponsePacket):void {
			Utility.log( "Global Boss -> response buff vàng result: " + packet.value);
			switch(packet.value) {
				case ErrorCode.SUCCESS:
					Manager.display.showMessage("Buff Bạc thành công");
					Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.GET_PLAYER_INFO_ATTRIBUTE, PlayerAttributeID.GOLD.ID));
					Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.GET_PLAYER_INFO_ATTRIBUTE, PlayerAttributeID.BATTLE_POINT.ID));
					Game.network.lobby.sendPacket(new RequestBossMissionInfo(LobbyRequestType.GLOBAL_BOSS_MISSION_INFO,
												Game.database.userdata.globalBossData.currentMissionID));
					break;
					
				case 2: //khong du xu
					Manager.display.showMessage("Bạn không có đủ Vàng");
					break;
					
				case 3: //max buff
					Manager.display.showMessage("Đã buff tối đa");
					break;
			}
		}
		
		private function onResponseAutoReviveResult(packet:IntResponsePacket):void {
			Utility.log( "Global Boss -> response auto hồi sinh result: " + packet.value);
			switch(packet.value) {
				case ErrorCode.SUCCESS:
					Manager.display.showMessage("Tự động hồi sinh");
					Game.database.userdata.globalBossData.autoRevive = true;
					GlobalBossView(baseView).autoRevive(true);
					Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.GET_PLAYER_INFO_ATTRIBUTE, PlayerAttributeID.XU.ID));
					break;
					
				case 3:
					Manager.display.showMessage("Bạn không có đủ Vàng");
					break;
					
				case 4:
					Manager.display.showMessage("Đã kích hoạt tự động hồi sinh");
					break;
			}
		}
		
		private function onResponseAutoPlayResult(packet:IntResponsePacket):void {
			Utility.log( "Global Boss -> response auto play result: " + packet.value);
			switch(packet.value) {
				case ErrorCode.SUCCESS: 
					Manager.display.showMessage("Tự động chơi");
					Game.database.userdata.globalBossData.autoPlay = true;
					GlobalBossView(baseView).autoPlayEnable(true);
					if (!Game.database.userdata.globalBossData.getIsReviveCountDown()) {
						setTimeout(GlobalBossView(baseView).startGame, 1000);
					}
					Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.GET_PLAYER_INFO_ATTRIBUTE, PlayerAttributeID.XU.ID));
					break;
					
				case 3: //khong du xu
					Manager.display.showMessage("Bạn không có đủ Vàng");
					break;
					
				case 4: //da auto play roi
					Manager.display.showMessage("Đã kích hoạt tự động chơi");
					break;
			}
		}
		
		private function onResponseBossHP(packet:ResponseGlobalBossHP):void {
			(GlobalBossView)(baseView).updateBossHPBar(packet.currentHP, packet.maxHP);
		}
		
		private function onResponseListPlayers(packet:ResponseGlobalBossListPlayers):void {
			(GlobalBossView)(baseView).updatePlayersList(packet.players);
		}
		
		private function onUIEventHandler(e:EventEx):void {
			switch(e.data.type) {					
				case GlobalBossEvent.AUTO_PLAY:
					Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.GLOBAL_BOSS_AUTO_PLAY, e.data.missionID));
					break;
					
				case GlobalBossEvent.BUFF_GOLD:
					Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.GLOBAL_BOSS_BUFF_GOLD));
					break;
					
				case GlobalBossEvent.BUFF_XU:
					Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.GLOBAL_BOSS_BUFF_XU));
					break;
									
				case GlobalBossEvent.GET_MY_DMG:
					Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.GLOBAL_BOSS_MY_DMG, e.data.missionID));
					break;
					
				case GlobalBossEvent.GET_TOP_DMG:
					if (Manager.display.checkVisible(ModuleID.GLOBAL_BOSS_TOP)) Manager.display.hideModule(ModuleID.GLOBAL_BOSS_TOP);
					else Manager.display.showModule(ModuleID.GLOBAL_BOSS_TOP, new Point(90, 140), LayerManager.LAYER_POPUP, "top_left", Layer.NONE, {missionID: e.data.missionID});
					break;
					
				case GlobalBossEvent.LEAVE:
					Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.GLOBAL_BOSS_LEAVE_GAME, e.data.missionID));
					break;
					
				case GlobalBossEvent.REVIVE:
					Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.GLOBAL_BOSS_REVIVE, e.data.missionID));
					break;
					
				case GlobalBossEvent.AUTO_REVIVE:
					Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.GLOBAL_BOSS_AUTO_REVIVE, e.data.missionID));
					break;
					
				case GlobalBossEvent.START_GAME:
					var lobbyInfo:LobbyInfo = new LobbyInfo();
					lobbyInfo.mode = GameMode.PVE_GLOBAL_BOSS;
					lobbyInfo.missionID = e.data.missionID;
					lobbyInfo.backModule = ModuleID.GLOBAL_BOSS;
					Game.flow.doAction(FlowActionEnum.CREATE_BASIC_LOBBY, lobbyInfo);
					//Game.flow.doAction(FlowActionEnum.CREATE_LOBBY, {
										//mode: GameMode.PVE_GLOBAL_BOSS ,
										//missionID: e.data.missionID,
										//backModule: ModuleID.GLOBAL_BOSS } );
					
					break;
					
				case GlobalBossEvent.GET_BOSS_HP:
					Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.GLOBAL_BOSS_HP, e.data.missionID));
					break;
			}
		}
	}

}