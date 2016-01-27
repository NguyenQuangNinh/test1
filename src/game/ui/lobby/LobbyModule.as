package game.ui.lobby 
{
	import core.display.layer.Layer;
	import core.display.layer.LayerManager;
	import core.display.ModuleBase;
	import core.event.EventEx;
	import core.Manager;
	import core.util.Utility;
	import flash.events.Event;
	import flash.geom.Point;
	import game.data.model.UIData;
	import game.enum.FlowActionEnum;
	import game.flow.FlowManager;
	import game.ui.arena.MatchingCount;
	//import game.data.enum.pvp.ModePVPEnum;
	import game.data.model.Character;
	import game.data.model.ServerAddress;
	import game.data.vo.lobby.LobbyInfo;
	import game.data.vo.lobby.LobbyPlayerInfo;
	import game.enum.DialogEventType;
	import game.net.StringResponsePacket;
	import game.ui.arena.ArenaEventName;
	import game.enum.GameMode;
	import game.enum.LobbyEvent;
	import game.enum.LobbyStatus;
	import game.Game;
	import game.net.IntRequestPacket;
	import game.net.IntResponsePacket;
	import game.net.lobby.LobbyRequestType;
	import game.net.lobby.LobbyResponseType;
	import game.net.lobby.request.RequestChangeLobbySlot;
	import game.net.lobby.response.ResponseChangeLobbySlot;
	import game.net.lobby.response.ResponseGameServerAddress;
	import game.net.lobby.response.ResponseUpdateRoomPvP;
	import game.net.RequestPacket;
	import game.net.ResponsePacket;
	import game.net.Server;
	import game.ui.dialog.DialogID;
	import game.ui.loading.LoadingView;
	import game.ui.ModuleID;
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class LobbyModule extends ModuleBase
	{		
		public function LobbyModule() 
		{
			
		}		
		
		override protected function createView():void {
			super.createView();
			
			baseView = new LobbyView();
			//Game.network.lobby.addEventListener(Server.SERVER_DATA, onLobbyServerResponse);
			
			baseView.addEventListener(LobbyEvent.BACK_TO_HOME, onViewRequestHdl);
			baseView.addEventListener(LobbyEvent.START_PVP_GAME, onViewRequestHdl);
			baseView.addEventListener(LobbyEvent.GET_PLAYER_LIST, onViewRequestHdl);
			baseView.addEventListener(MatchingCount.CANCEL_MATCHING_COUNT, onCancelMatchingHdl);
			baseView.addEventListener(LobbyEvent.PLAYER_REQUEST, onPlayerSlotRequestHdl);
		}
		
		private function onCancelMatchingHdl(e:Event):void 
		{
			Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.REQUEST_CANCEL_MATCHING));
		}
		
		/*private function onLobbyServerResponse(e:EventEx):void 
		{
			var packet: ResponsePacket = e.data as ResponsePacket;
			switch(packet.type) {
				case LobbyResponseType.START_GAME_RESULT:
					Utility.log(" respone --> success for request start game pvp --> start loading before trans to IN GAME ");
					break;
				/*case LobbyResponseType.LIST_PVP_RANKING:
					var packetListPvPRanking:ResponseListPvPRanking = packet as ResponseListPvPRanking;
					var pvpRankingModule:PvPRankingModule = Manager.module.getModuleByID(ModuleID.PVP_RANKING) as PvPRankingModule;
					pvpRankingModule.updateListPvPRanking(packetListPvPRanking.arrName);
					Utility.log(" respone --> success for request get list pvp ranking");
					break;
			}
		}*/
		
		private function onViewRequestHdl(e:Event):void 
		{
			switch(e.type) {
				case LobbyEvent.START_PVP_GAME:
					//Game.flow.action(FlowActionID.START_GAME_PVP, {mode:_lobby.mode});
					Utility.log("request start lobby pvp");
					//Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.START_GAME_NORMAL));
					/*switch(_lobby.mode) {
						//case ArenaEventName.PVP_1vs1_FREE:
						//case ArenaEventName.PVP_3vs3_FREE:
						case Gamemode.PVP_1vs1_FREE:
						case Gamemode.PVP_3vs3_FREE:
							Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.START_GAME));
							break;
						//case ArenaEventName.PvP_1vs1_MATCHING:	
						//case ArenaEventName.PvP_3vs3_MATCHING:
						case Gamemode.PVP_1vs1_MM:	
						case Gamemode.PVP_3vs3_MM:
							//Manager.display.showLoadingSync("waiting respone from server ...", false, -1);
							Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.REQUEST_MATCHING));
							break;
					}*/
					Game.flow.doAction(FlowActionEnum.START_LOBBY);
					break;
				//case LobbyEvent.CANCEL_MATCHING:
					//Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.REQUEST_CANCEL_MATCHING));
					//break;	
				case LobbyEvent.GET_PLAYER_LIST:
					Manager.display.showModule(ModuleID.INVITE_PLAYER, new Point(0, 0), LayerManager.LAYER_POPUP,
							"top_left",Layer.BLOCK_ALPHA, {moduleID:ModuleID.LOBBY});
					break;				
				case LobbyEvent.BACK_TO_HOME:
					leaveGame();
					break;
			}
		}

		public function leaveGame():void
		{
			Game.database.userdata.getCurrentModeData().backModuleID = ModuleID.HOME;
			Game.flow.doAction(FlowActionEnum.LEAVE_GAME);
		}

		private function onPlayerSlotRequestHdl(e:EventEx):void 
		{
			var info:Object = e.data != null ? e.data : { };
			
			switch(info.type) {
				case LobbyEvent.VIEW_PLAYER:
					Utility.log("request to view player slot detail " + info.type + " team  " + info.teamID + " index " + info.slotIndex);
					Manager.display.showPopup(ModuleID.PLAYER_PROFILE,  Layer.BLOCK_BLACK, info.playerID);
					break;
				case LobbyEvent.SWAP_PLAYER:
					/*//reset player want to swap
					var player:LobbyPlayerInfo = new LobbyPlayerInfo();
					player.teamIndex = info.teamID;
					player.index = info.slotIndex;
					(view as LobbyView).updateTeamInfo(player);
					//reset player swap
					for (var i:int = 0; i < Game.database.userdata.lobbyPlayers.length; i++) {
						player = Game.database.userdata.lobbyPlayers[i] as LobbyPlayerInfo;
						if (player.name == Game.database.userdata.playerName) {
							player.characters = [];
							(view as LobbyView).updateTeamInfo(player);
							break;
						}
					}*/
					//(view as LobbyView).initUIByMode(_lobby.mode, checkIsOwner());
					Utility.log("request to swap player slot detail " + info.type + " team  " + info.teamID + " index " + info.slotIndex);
					Game.network.lobby.sendPacket(new RequestChangeLobbySlot(info.teamID, info.slotIndex));					
					break;
				case LobbyEvent.KICK_PLAYER:
					//(view as LobbyView).initUIByMode(_lobby.mode, checkIsOwner());
										Utility.log("request to kick player slot detail " + info.type + " team  " + info.teamID + " index " + info.slotIndex);
					Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.KICK_LOBBY_PLAYER_SLOT, info.playerID));
					break;
			}			
		}
		
		override protected function preTransitionIn():void 
		{
			Utility.log( "LobbyModule.preTransitionIn" );
			super.preTransitionIn();
			
			Game.network.lobby.addEventListener(Server.SERVER_DATA, onLobbyResponseHdl);
			//hide top bar
			Manager.display.hideModule(ModuleID.TOP_BAR);
		}
		
		override protected function transitionIn():void 
		{
			Utility.log( "LobbyModule.transitionIn" );
			super.transitionIn();
			//Game.flow.addEventListener(FlowManager.ACTION_COMPLETED, onFlowActionCompletedHdl);
			Game.database.userdata.addEventListener(UIData.DATA_CHANGED, changeDataHdl);
			
			//call update room to show owner info
			Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.NOTIFY_JOIN_ROOM_READY));	
			Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.GET_SERVER_TIME));						
		}
		
		private function changeDataHdl(e:Event):void 
		{
			// check lobbyplayers
			Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.NOTIFY_JOIN_ROOM_READY));	
		}
		
		/*private function onFlowActionCompletedHdl(e:EventEx):void 
		{
			switch(e.data.type) {
				case FlowActionEnum.START_LOBBY_SUCCESS:						
					(view as LobbyView).endCount();
					Game.flow.doAction(FlowActionEnum.START_LOADING_RESOURCE);
					break;
				case FlowActionEnum.LEAVE_LOBBY_SUCCESS: 
					Manager.display.to(ModuleID.HOME);
					break;
				case FlowActionEnum.UPDATE_LOBBY_INFO_SUCCESS:
					Utility.log( "LobbyModule.UPDATE_LOBBY_INFO_SUCCESS: ");
					(view as LobbyView).initUIByMode(Game.database.userdata.getGameMode());
					(view as LobbyView).initRoomName(Game.database.userdata.getCurrentModeData().roomName);
					updateLobby(Game.database.userdata.lobbyPlayers);
					break;
			}
		}*/
		
		override protected function onTransitionOutComplete():void 
		{
			Utility.log( "LobbyModule.onTransitionOutComplete" );
			super.onTransitionOutComplete();
			
			Game.database.userdata.removeEventListener(UIData.DATA_CHANGED, changeDataHdl);
			Game.network.lobby.removeEventListener(Server.SERVER_DATA, onLobbyResponseHdl);
			//Game.flow.removeEventListener(FlowManager.ACTION_COMPLETED, onFlowActionCompletedHdl);
			(baseView as LobbyView).stopMatching();
		}
		
		private function onLobbyResponseHdl(e:EventEx):void 
		{
			var packet: ResponsePacket = e.data as ResponsePacket;			
			switch(packet.type) {
				case LobbyResponseType.COUNT_MATCHING:
					var packetResultMatching:IntResponsePacket = packet as IntResponsePacket;
					Utility.log(" response --> result matching " + packetResultMatching.value);

					switch (packetResultMatching.value)
					{
						case 0://success
							(baseView as LobbyView).startMatching();
							break;
						case 1://fail

							break;
					}
					break;
				case LobbyResponseType.CANCEL_MATCHING:
					var packetResultCancelMatching:IntResponsePacket = packet as IntResponsePacket;
					Utility.log(" response --> result cancel matching " + packetResultCancelMatching.value);
					if (packetResultCancelMatching.value == 0) {
						Utility.log("receive request cancel match matching by server");
						(baseView as LobbyView).stopMatching();
						Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.NOTIFY_JOIN_ROOM_READY));
					}else {
						
					}
					break;
				case LobbyResponseType.CHANGE_LOBBY_PLAYER_SLOT:
					var packetRequestChangeSlot:ResponseChangeLobbySlot = packet as ResponseChangeLobbySlot;
					if (packetRequestChangeSlot) {
						//_data = { name:packetRequestToPlay.nameInvite, room: packetRequestToPlay.roomID };
						Manager.display.showDialog(DialogID.YES_NO, onAcceptHdl, null,
								{type:DialogEventType.REQUEST_CHANGE_LOBBY_SLOT_YN, id:packetRequestChangeSlot.playerID, name: packetRequestChangeSlot.playerName} );								
					}
					break;	
				case LobbyResponseType.KICK_FROM_LOBBY:
					Manager.display.back();	
					break;
				case LobbyResponseType.RECEIVE_SERVER_TIME:
					var packetTime:StringResponsePacket = packet as StringResponsePacket;
					if (packetTime)
						Utility.log("receive server time " + packetTime.value);
					break;
			}			
			
		}
		
		/*private function checkIsOwner():Boolean
		{
			var result:Boolean = false;
			var info:LobbyPlayerInfo;
			for (var i:int = 0; i < Game.database.userdata.lobbyPlayers.length; i++) {
				info = Game.database.userdata.lobbyPlayers[i];
				if (info.owner && info.name == Game.database.userdata.playerName) {
					result = true;
					break;
				}
			}
			return result;
		}*/
		
		private function onAcceptHdl(data:Object):void 
		{
			if (data) {
				Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.CONFIRM_CHANGE_LOBBY_SLOT, data.id));
			}else {
				Utility.error("can not confirm change lobby slot with NULL info");
			}
		}
		
		/*private function updateLobby(info: Array):void {
			//here prepare lobby info
			if (info) {
				(view as LobbyView).updateLobby(info);				
			}else {
				Utility.error("can not init lobby by none info error");
			}
		}*/		
		
		/*public function getLobbyInfo():LobbyInfo {
			return _lobby;
		}*/
		
	}
}