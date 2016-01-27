package game.ui.arena 
{
	import core.display.layer.Layer;
	import core.display.layer.LayerManager;
	import core.display.ModuleBase;
	import core.event.EventEx;
	import core.Manager;
	import core.util.Utility;
	import flash.events.Event;
	import flash.geom.Point;
	import game.data.model.Character;
	import game.enum.FlowActionEnum;
	import game.flow.FlowManager;
	import game.net.lobby.request.RequestPvPReceivedReward;
	import game.net.lobby.response.ResponseCreateRoom;
	import game.net.lobby.response.ResponsePVP2vs2MMState;
	import game.net.lobby.response.ResponseTopReceivedReward;
	import game.ui.components.ReceiveButton;
	import game.ui.dialog.dialogs.YesNo;
	//import game.data.enum.pvp.ModePVPEnum;
	//import game.data.enum.topleader.LeaderBoardTypeEnum;
	import game.data.vo.lobby.LobbyInfo;
	import game.data.vo.lobby.LobbyPlayerInfo;
	import game.enum.DialogEventType;
	//import game.enum.FlowActionID;
	import game.enum.GameMode;
	import game.enum.LeaderBoardTypeEnum;
	import game.enum.TeamID;
	import game.Game;
	import game.net.IntRequestPacket;
	import game.net.IntResponsePacket;
	import game.net.lobby.LobbyRequestType;
	import game.net.lobby.LobbyResponseType;
	//import game.net.lobby.request.RequestCreateRoomPvP;
	import game.net.lobby.request.RequestHistoryLeaderBoard;
	import game.net.lobby.request.RequestJoinRoomPvP;
	import game.net.lobby.request.RequestLeaderBoard;
	import game.net.lobby.request.RequestRoomListPvP;
	//import game.net.lobby.response.ResponseCreateRoomPvP;
	import game.net.lobby.response.ResponseGameServerAddress;
	import game.net.lobby.response.ResponseHistoryLeaderBoard;
	import game.net.lobby.response.ResponseJoinRoomPvP;
	import game.net.lobby.response.ResponseLeaderBoard;
	import game.net.lobby.response.ResponsePVP1vs1MMState;
	import game.net.lobby.response.ResponsePVP3vs3MMState;
	import game.net.lobby.response.ResponseRoomListPvP;
	import game.net.lobby.response.ResponseUpdateRoomPvP;
	import game.net.RequestPacket;
	import game.net.ResponsePacket;
	import game.net.Server;
	import game.net.StringResponsePacket;
	import game.ui.components.PagingMov;
	import game.ui.dialog.DialogID;
	import game.ui.home.scene.CharacterManager;
	import game.ui.hud.HUDModule;
	import game.ui.message.MessageID;
	import game.ui.ModuleID;
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class ArenaModule extends ModuleBase
	{
		
		private static const MAX_TOP_CHAMPION_IN_PAGE:int = 10;
		
		//0: stand by
		//1: toward
		//-1: backward
		private var _direction:int = 0;
		private var _data:Array = [];
		private var _topIndex:int = 0;
		private var _pagingIndex:int = 0;
		private var _mode:GameMode;
		
		private var _lobbyInfo:LobbyInfo = new LobbyInfo();
		
		public function ArenaModule() 
		{
			
		}
			
		override protected function createView():void {
			super.createView();
			baseView = new ArenaView();
			
			baseView.addEventListener(ArenaEventName.CLOSE, onCloseHdl);
			baseView.addEventListener(ArenaEventName.ROOM_CREATED, onRoomCreatedHdl);
			baseView.addEventListener(RoomList.REQUEST_ROOM_LIST, onRequestRoomListHdl);
			
			baseView.addEventListener(TopLeaderBoardMov.TOP_LEADER_BOARD_REQUEST, onRequestTopLeaderBoardHdl);
			baseView.addEventListener(PagingMov.GO_TO_NEXT, onPagingChangeHdl);
			baseView.addEventListener(PagingMov.GO_TO_PREV, onPagingChangeHdl);
			
			baseView.addEventListener(ArenaEventName.QUICK_JOIN_GAME, onQuickJoinGameHdl);
			
			baseView.addEventListener(ArenaEventName.JOIN_ROOM, onJoinRoomHdl);
			baseView.addEventListener(ArenaEventName.REQUEST_MODE_INFO_STATE, onRequestModeInfoStateHdl);
			baseView.addEventListener(ArenaEventName.REQUEST_MODE_INFO_LEADER_BOARD, onRequestModeInfoLeaderBoardHdl);
			baseView.addEventListener(MatchingCount.CANCEL_MATCHING_COUNT, onMatchingCancelHdl);
			baseView.addEventListener(ReceiveButton.ON_RECEIVE, onReceivedRewardHdl);
		}
		
		private function onRequestTopLeaderBoardHdl(e:EventEx):void 
		{
			if (e.data) {
				var request:int = e.data as int;
				
				var type:int = -1;
				switch(_mode) {
					case GameMode.PVP_1vs1_MM:
						type = LeaderBoardTypeEnum.TOP_1VS1_MM.type;
						break;
					case GameMode.PVP_3vs3_MM:
						type = LeaderBoardTypeEnum.TOP_3VS3_MM.type;
						break;
					case GameMode.PVP_2vs2_MM:
						type = LeaderBoardTypeEnum.TOP_2VS2_MM.type;
						break;
				}
				
				switch(request) {
					case TopLeaderBoardMov.TOP_LEADER_BOARD_NEXT:
						_pagingIndex = 0;
						_topIndex++;
						//request top champion by top index && paging index
						requestListPlayers(type, _pagingIndex * TopLeaderBoardMov.MAX_TOP_SHOW_IN_LIST,
						(_pagingIndex + 1) * TopLeaderBoardMov.MAX_TOP_SHOW_IN_LIST - 1, 1, _topIndex * -1);
						break;
					case TopLeaderBoardMov.TOP_LEADER_BOARD_PREVIOUS:
						_pagingIndex = 0;
						_topIndex--;
						//request top champion by top index && paging index
						requestListPlayers(type, _pagingIndex * TopLeaderBoardMov.MAX_TOP_SHOW_IN_LIST,
						(_pagingIndex + 1) * TopLeaderBoardMov.MAX_TOP_SHOW_IN_LIST - 1, 1, _topIndex * -1);
						break;				
				}
			}
		}
		
		private function onRequestModeInfoStateHdl(e:EventEx):void 
		{
			_mode = e.data as GameMode;
			
			switch(_mode) {
				case GameMode.PVP_1vs1_MM:
					Game.network.lobby.sendPacket(new RequestPacket(
						LobbyRequestType.PVP1vs1_MM_STATE));
					break;
				case GameMode.PVP_3vs3_MM:
					Game.network.lobby.sendPacket(new RequestPacket(
						LobbyRequestType.PVP3vs3_MM_STATE));
					break;
				case GameMode.PVP_2vs2_MM:
					Game.network.lobby.sendPacket(new RequestPacket(
						LobbyRequestType.PVP2vs2_MM_STATE));
					break;
			}
		}
		
		private function onRequestModeInfoLeaderBoardHdl(e:EventEx):void 
		{
			_mode = e.data as GameMode;
			
			_topIndex = 0;
			_pagingIndex = 0;
			
			var type:int = -1;
			switch(_mode) {
				case GameMode.PVP_1vs1_MM:
					type = LeaderBoardTypeEnum.TOP_1VS1_MM.type;
					break;
				case GameMode.PVP_3vs3_MM:
					type = LeaderBoardTypeEnum.TOP_3VS3_MM.type;
					break;
				case GameMode.PVP_2vs2_MM:
					type = LeaderBoardTypeEnum.TOP_2VS2_MM.type;
					break;
			}
			
			// get list top championship
			requestListPlayers(type, _pagingIndex * TopLeaderBoardMov.MAX_TOP_SHOW_IN_LIST,
							(_pagingIndex + 1) * TopLeaderBoardMov.MAX_TOP_SHOW_IN_LIST - 1, 1, _topIndex * -1);
		}
		
		private function requestListPlayers(type:int, from:int, to:int, direction:int, index:int = 0):void {
			_direction = direction;
			//call server to get data
			Utility.log("call server to get data for mode " + type + " from " + from + " // " + to + " by index " + index);
			if(index == 0)
				Game.network.lobby.sendPacket(new RequestLeaderBoard(type,
						from, to));
			else {
				//get top leader board history
				Game.network.lobby.sendPacket(new RequestHistoryLeaderBoard(type, index,
						from, to));
			}					
		}
		
		private function onMatchingCancelHdl(e:Event):void 
		{
			(baseView as ArenaView).stopMatching();
			Game.flow.doAction(FlowActionEnum.LEAVE_GAME);
		}
		
		private function onPagingChangeHdl(e:Event):void 
		{
			//request top champion by top index && paging index
			var type:int = -1;
			switch(_mode) {
				case GameMode.PVP_1vs1_MM:
					type = LeaderBoardTypeEnum.TOP_1VS1_MM.type;
					break;
				case GameMode.PVP_3vs3_MM:
					type = LeaderBoardTypeEnum.TOP_3VS3_MM.type;
					break;
				case GameMode.PVP_2vs2_MM:
					type = LeaderBoardTypeEnum.TOP_2VS2_MM.type;
					break;
			}
			
			switch(e.type) {
				case PagingMov.GO_TO_NEXT:
					//onGoToNextHdl();
					requestListPlayers(type, _pagingIndex * TopLeaderBoardMov.MAX_TOP_SHOW_IN_LIST,
						(_pagingIndex + 1) * TopLeaderBoardMov.MAX_TOP_SHOW_IN_LIST - 1, 1, _topIndex * -1);
					break;
				case PagingMov.GO_TO_PREV:
					//onGoToPrevHdl();
					requestListPlayers(type, (_pagingIndex - 2) * TopLeaderBoardMov.MAX_TOP_SHOW_IN_LIST,
						(_pagingIndex - 1) * TopLeaderBoardMov.MAX_TOP_SHOW_IN_LIST - 1, -1, _topIndex * -1);
					break;
			}
		}
		
		private function onRewardCompletedCountDownHdl(e:EventEx):void 
		{
			//update general info to change state of reward received
			
		}
		
		private function onReceivedRewardHdl(e:EventEx):void 
		{
			//index = 0 ~ reward daily // 1 ~ reward weekly
			var mode:int = e.data ? e.data.mode as int : -1;
			var index:int = e.data ? e.data.index as int : -1;
			var leaderBoardType:int = -1;

			switch (mode)
			{
				case GameMode.PVP_3vs3_MM.ID:
					leaderBoardType = LeaderBoardTypeEnum.TOP_3VS3_MM.type;
					break;
				case GameMode.PVP_1vs1_MM.ID:
					leaderBoardType = LeaderBoardTypeEnum.TOP_1VS1_MM.type;
					break;
				case GameMode.PVP_2vs2_MM.ID:
					leaderBoardType = LeaderBoardTypeEnum.TOP_2VS2_MM.type;
					break;
				default :
					leaderBoardType = -1;
			}

			Game.network.lobby.sendPacket(new RequestPvPReceivedReward(leaderBoardType	, index));
		}
		
		private function onJoinRoomHdl(e:EventEx):void 
		{			
			var data:LobbyInfo = e.data as LobbyInfo;
			if (data) {			
				var roomID:int = data.id;
				Game.flow.doAction(FlowActionEnum.JOIN_LOBBY_BY_ID, { mode: data.mode, id: data.id, pass:false } );
			}
		}
		
		private function onQuickJoinGameHdl(e:EventEx):void 
		{
			var gameMode:GameMode = e.data as GameMode;
			var lobbyInfo:LobbyInfo = new LobbyInfo();
			lobbyInfo.backModule = ModuleID.LOBBY;
			lobbyInfo.mode = gameMode;
			Game.flow.doAction(FlowActionEnum.QUICK_JOIN, lobbyInfo);
		}
		
		private function onLobbyServerResponseHdl(e:EventEx):void 
		{
			var packet:ResponsePacket = e.data as ResponsePacket;
			switch(packet.type) {
				case LobbyResponseType.ROOM_LIST_PVP:
					var packetRoomList:ResponseRoomListPvP = packet as ResponseRoomListPvP;
					(baseView as ArenaView).updateRoomList(packetRoomList.rooms);
					break;
				case LobbyResponseType.PVP1vs1_MM_STATE:
					var packetState1vs1MM:ResponsePVP1vs1MMState = packet as ResponsePVP1vs1MMState;
					(baseView as ArenaView).updateState(_mode, packetState1vs1MM.numMatchPlayed, packetState1vs1MM.rank, packetState1vs1MM.honorPoint, packetState1vs1MM.eloPoint);
					(baseView as ArenaView).updateReward(packetState1vs1MM.rewardDaily, packetState1vs1MM.receivedRewardDaily,
										packetState1vs1MM.rewardWeekly, packetState1vs1MM.receivedRewardWeekly,
										packetState1vs1MM.timeRemainRewardDaily, packetState1vs1MM.timeRemainRewardWeekly);
					break;
				case LobbyResponseType.PVP2vs2_MM_STATE:
					var packetState2vs2MM:ResponsePVP2vs2MMState = packet as ResponsePVP2vs2MMState;
					(baseView as ArenaView).updateState(_mode, packetState2vs2MM.numMatchPlayed, packetState2vs2MM.rank, packetState2vs2MM.honorPoint, packetState2vs2MM.eloPoint);
					(baseView as ArenaView).updateReward(packetState2vs2MM.rewardDaily, packetState2vs2MM.receivedRewardDaily,
							packetState2vs2MM.rewardWeekly, packetState2vs2MM.receivedRewardWeekly,
							packetState2vs2MM.timeRemainRewardDaily, packetState2vs2MM.timeRemainRewardWeekly);
					break;
				case LobbyResponseType.PVP3vs3_MM_STATE:
					var packetState3vs3MM:ResponsePVP3vs3MMState = packet as ResponsePVP3vs3MMState;
					(baseView as ArenaView).updateState(_mode, packetState3vs3MM.numMatchPlayed, packetState3vs3MM.rank, packetState3vs3MM.honorPoint, packetState3vs3MM.eloPoint);
					(baseView as ArenaView).updateReward(packetState3vs3MM.rewardDaily, packetState3vs3MM.receivedRewardDaily,
										packetState3vs3MM.rewardWeekly, packetState3vs3MM.receivedRewardWeekly,
										packetState3vs3MM.timeRemainRewardDaily, packetState3vs3MM.timeRemainRewardWeekly);
					break;
				case LobbyResponseType.PVP1vs1_MM_HISTORY_TOP_LEADER_BOARD:
				case LobbyResponseType.PVP3vs3_MM_HISTORY_TOP_LEADER_BOARD:
					Utility.log(" response --> success for request history top championship");					
					var packetHistoryLeaderBoard:ResponseHistoryLeaderBoard = packet as ResponseHistoryLeaderBoard;				
					_pagingIndex += _direction;						
					updateTopLeaderBoard(packetHistoryLeaderBoard.players, packetHistoryLeaderBoard.isLastTop);
					_direction = 0;
					break;	
				case LobbyResponseType.LEADER_BOARD:
					Utility.log(" response --> success for request current top championship");					
					var packetLeaderBoard:ResponseLeaderBoard = packet as ResponseLeaderBoard;				
					_pagingIndex += _direction;						
					updateTopLeaderBoard(packetLeaderBoard.players);
					_direction = 0;
					break;	
				case LobbyResponseType.PVP1vs1_MM_SKIP_LIMIT:
					var packetSkipLimit:IntResponsePacket = packet as IntResponsePacket;
					switch(packetSkipLimit.value) {
						case 0:
							//succecc skip limit --> call to start game again
							break;
						case 1:
							//fail by normal error							
							break;
						case 2:
							//fail by not enough money
							Manager.display.showMessageID(MessageID.PVP1vs1MM_NOT_ENOUGH_XU_SKIP_LIMIT);
							break;
					}
					break;
				case LobbyResponseType.TOP_RECEIVED_REWARD:
					var packetReceived:ResponseTopReceivedReward = packet as ResponseTopReceivedReward;
					Utility.log(" response --> success for request received reward " + packetReceived.result);
					switch(packetReceived.topType) {
						case LeaderBoardTypeEnum.TOP_3VS3_MM.type:
							if(packetReceived.result)
								Manager.display.showMessageID(15);
							else 	
								Manager.display.showMessageID(MessageID.PVP3vs3MM_RECEIVED_REWARD_SUCCESS);
							//get state and rewards can get and had received
							Game.network.lobby.sendPacket(new RequestPacket(
											LobbyRequestType.PVP3vs3_MM_STATE));	
							break;
						case LeaderBoardTypeEnum.TOP_2VS2_MM.type:
							if(packetReceived.result)
								Manager.display.showMessageID(15);
							else
								Manager.display.showMessageID(12);
							//get state and rewards can get and had received
							Game.network.lobby.sendPacket(new RequestPacket(
											LobbyRequestType.PVP2vs2_MM_STATE));
							break;
						case LeaderBoardTypeEnum.TOP_1VS1_MM.type:
							if(packetReceived.result)
								Manager.display.showMessageID(15);
							else 	
								Manager.display.showMessageID(MessageID.PVP1vs1MM_RECEIVED_REWARD_SUCCESS);
							//get state and rewards can get and had received
							Game.network.lobby.sendPacket(new RequestPacket(
											LobbyRequestType.PVP1vs1_MM_STATE));
							break;
					}
					break;	
			}	
		}
		
		private function onAcceptSkipLimitHdl(data:Object):void 
		{
			//skip limit daily play time		
			Game.network.lobby.sendPacket(new RequestPacket(
						LobbyRequestType.PVP1vs1AI_SKIP_LIMIT));
		}
		
		private function updateTopLeaderBoard(data:Array, isLastBack:Boolean = false ):void {
			_data = data;				
			if (data) {				
				(baseView as ArenaView).updateTopChampion(_topIndex, _pagingIndex - 1, data, isLastBack, _topIndex == 0);
				(baseView as ArenaView).updatePaging(_pagingIndex, 0);
				//(view as LeaderBoardView).setPlayerSelected(data.length > 0 ? data[0] : null);
			}
		}
		
		private function onRequestRoomListHdl(e:EventEx):void 
		{
			var data:Object = e.data;
			if (data) {
				//call server to get room list
				if (data.mode as GameMode) Game.network.lobby.sendPacket(new RequestRoomListPvP(
						data.from, data.to, (data.mode as GameMode).ID == GameMode.PVP_FREE.ID ? -1 : (data.mode as GameMode).ID));
						//data.from, data.to, data.mode == ArenaEventName.PVP_FREE ? -1 : data.mode));
			}
		}
		
		private function onRoomCreatedHdl(e:EventEx):void 
		{
			var info:Object = e.data;
			if(info) {				
				var backModule:ModuleID;				
				if (info.mode == GameMode.PVP_FREE) {
					_lobbyInfo.mode = info.modeSelect;
				}else {
					_lobbyInfo.mode = info.mode;
				}
				_lobbyInfo.privateLobby = info.privateLobby;
				_lobbyInfo.name = info.name;
				if (info.mode == GameMode.PVP_1vs1_MM) {
					_lobbyInfo.backModule = ModuleID.ARENA;
				}else {
					_lobbyInfo.backModule = ModuleID.LOBBY;
				}
				
				Game.flow.doAction(FlowActionEnum.CREATE_BASIC_LOBBY, _lobbyInfo);
				Utility.log("request create room with name " + _lobbyInfo.name + " and mode " + _lobbyInfo.mode + " , private: " + _lobbyInfo.privateLobby);									
			}else {
				Utility.error("can not create room with NULL info");
			}
		}
		
		private function onCloseHdl(e:Event):void 
		{		
			Manager.display.hideModule(ModuleID.ARENA);
			//var hudModule : HUDModule = Manager.module.getModuleByID(ModuleID.HUD) as HUDModule;
			//if (hudModule != null) {
				//hudModule.onSelectModule(ModuleID.ARENA);
			//}
		}
		
		override protected function transitionIn():void 
		{
			super.transitionIn();
			(baseView as ArenaView).resetView();
			(baseView as ArenaView).enableButtonView(true);
			
			_lobbyInfo.reset();
			Game.network.lobby.addEventListener(Server.SERVER_DATA, onLobbyServerResponseHdl);
			//Game.flow.addEventListener(FlowManager.ACTION_COMPLETED, onFlowActionCompletedHdl);
		}
		
		override protected function onTransitionInComplete():void 
		{
			super.onTransitionInComplete();
			CharacterManager.instance.hideCharacters();
		}
		
		override protected function onTransitionOutComplete():void 
		{
			super.onTransitionOutComplete();			
			CharacterManager.instance.displayCharacters();
			Game.network.lobby.removeEventListener(Server.SERVER_DATA, onLobbyServerResponseHdl);
			ArenaView(baseView).registerMov.unregisterMatchMaking();
			//Game.flow.removeEventListener(FlowManager.ACTION_COMPLETED, onFlowActionCompletedHdl);
		}
		
		/*private function onFlowActionCompletedHdl(e:EventEx):void 
		{
			switch(e.data.type) {
				case FlowActionEnum.CREATE_LOBBY_SUCCESS:
					Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.NOTIFY_JOIN_ROOM_READY));
					break;
				case FlowActionEnum.UPDATE_LOBBY_INFO_SUCCESS:
					if (_lobbyInfo.mode == GameMode.PVP_1vs1_MM) {
						(view as ArenaView).startMatching();
						Game.flow.doAction(FlowActionEnum.START_LOBBY);						
					}else 						
						Manager.display.to(ModuleID.LOBBY, true, e.data.info);
					break;
				case FlowActionEnum.CREATE_LOBBY_FAIL:
					var dialogData:Object = {};
					switch(e.data.error) {
						case 3:
							//Wrong time							
							dialogData.title = "Thông báo";
							dialogData.message = "Đã quá thời gian tham gia chế độ, hãy quay lại sau nhé";
							dialogData.option = YesNo.YES | YesNo.CLOSE;
							Manager.display.showDialog(DialogID.YES_NO, null, null, dialogData, Layer.BLOCK_BLACK);
							break;
						case 4:
							//not enough level
							dialogData.title = "Thông báo";
							dialogData.message = "Bạn chưa đủ đẳng cấp để tham gia chế độ, hãy luyện tập thêm nhé";
							dialogData.option = YesNo.YES | YesNo.CLOSE;
							Manager.display.showDialog(DialogID.YES_NO, null, null, dialogData, Layer.BLOCK_BLACK);
							break;	
						case 5:
							//da choi toi da so tran mien phi trong ngay
							dialogData.title = "Thông báo";
							dialogData.message = "Đã hết số lần chơi trong ngày, hãy quay lại vào ngày mai nhé";
							dialogData.option = YesNo.YES | YesNo.CLOSE;
							Manager.display.showDialog(DialogID.YES_NO, null, null, dialogData, Layer.BLOCK_BLACK);
							break;	
						default:
							break;
					}
					break;
				case FlowActionEnum.START_LOBBY_SUCCESS:	
					(view as ArenaView).stopMatching();
					Game.flow.doAction(FlowActionEnum.START_LOADING_RESOURCE);
					break;
				case FlowActionEnum.QUICK_JOIN_SUCCESS:
					Manager.display.to(ModuleID.LOBBY, true, e.data.info);					
					break;
				case FlowActionEnum.QUICK_JOIN_FAIL:
					//Xy ly quick join room fail
					break;
			}
		}*/
	}

}