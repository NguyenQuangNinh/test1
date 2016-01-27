package game.ui.leader_board 
{
	import core.display.ModuleBase;
	import core.event.EventEx;
	import core.Manager;
	import core.util.Enum;
	import core.util.Utility;
	import flash.events.Event;
	import game.data.model.Character;
	import game.data.model.UserData;
	import game.data.vo.lobby.LobbyPlayerInfo;
	import game.enum.LeaderBoardTypeEnum;
	import game.Game;
	import game.net.IntRequestPacket;
	import game.net.lobby.LobbyRequestType;
	import game.net.lobby.LobbyResponseType;
	import game.net.lobby.request.RequestLeaderBoard;
	import game.net.lobby.response.ResponseLeaderBoard;
	import game.net.lobby.response.ResponseTopLeaderBoard;
	import game.net.ResponsePacket;
	import game.net.Server;
	import game.ui.components.PagingMov;
	import game.ui.components.tab.Tab;
	import game.ui.hud.HUDModule;
	import game.ui.ModuleID;
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class LeaderBoardModule extends ModuleBase
	{
		
		private var _data:Array;
		private var _currentPage:int;		
		//0: stand by
		//1: toward
		//-1: backward
		private var _direction:int;
		//1: get by 1vs1
		//2: get by level
		//3: get by damage
		private var _type:int = -1;
		
		private var _playerSelected:LobbyPlayerInfo;
		
		public function LeaderBoardModule() 
		{
			
		}
		
		override protected function createView():void 
		{
			super.createView();
			
			baseView = new LeaderBoardView();
			
			Game.network.lobby.addEventListener(Server.SERVER_DATA, onLobbyServerResponeHdl);
			//Game.database.userdata.addEventListener(UserData.UPDATE_CHARACTER_INFO
			baseView.addEventListener(PagingMov.GO_TO_NEXT, onGoToNextHdl);
			baseView.addEventListener(PagingMov.GO_TO_PREV, onGoToPrevHdl);
			baseView.addEventListener(LeaderBoardPlayer.PLAYER_LEADER_BOARD_CLICK, onPlayerClickHdl);
			baseView.addEventListener(Event.CLOSE, onCloseHdl);
			baseView.addEventListener(Tab.CHANGE_TAB, onChangeTabHdl);
		}
		
		private function onPlayerClickHdl(e:EventEx):void 
		{		
			_playerSelected = e.data as LobbyPlayerInfo;
			(baseView as LeaderBoardView).setPlayerSelected(_playerSelected);
			//get player formation info to display tool tip
			//Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType., _playerSelected.id));
		}
		
		private function onCloseHdl(e:Event):void 
		{
			Manager.display.hideModule(ModuleID.LEADER_BOARD);
			//var hudModule : HUDModule = Manager.module.getModuleByID(ModuleID.HUD) as HUDModule;
			//if (hudModule != null) {
				//hudModule.onSelectModule(ModuleID.ARENA);
			//}
			
			//Manager.display.hideModule(ModuleID.LEADER_BOARD);
		}
		
		private function onChangeTabHdl(e:EventEx):void 
		{
			var tabIndex:int = e.data as int;
			//if (tabIndex != _type) {
				//chang tab
				_direction = 0;
				_currentPage = 0;
				//_type = tabIndex;
				var leaderType:LeaderBoardTypeEnum = (Enum.getEnum(LeaderBoardTypeEnum, tabIndex) as LeaderBoardTypeEnum)
				_type = leaderType.type;
				//_type = tabIndex + 1;
				//clear content before get new one
				//(view as InvitePlayerView).updatePlayers([]);
				
				if(_type != 0) {
					Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.TOP_LEADER_BOARD, _type));
						
					//cheat call 1 more if exist --> enable navigator // if not --> disable
					requestListPlayers(_currentPage * LeaderBoardView.MAX_PLAYER_SHOW_IN_LIST,
							(_currentPage + 1) * LeaderBoardView.MAX_PLAYER_SHOW_IN_LIST /*- 1*/, 1, _type);											
				}
			//}			
		}
		
		private function onLobbyServerResponeHdl(e:EventEx):void 
		{
			var packet:ResponsePacket = e.data as ResponsePacket;
			switch(packet.type) {
				case LobbyResponseType.LEADER_BOARD:
					//Utility.log(" response --> success for request leader board");					
					var packetLeaderBoard:ResponseLeaderBoard = packet as ResponseLeaderBoard;				
					_currentPage += _direction;	
					if (packetLeaderBoard.typeRequest == LeaderBoardTypeEnum.HEROIC_TOWER.type)
						update(packetLeaderBoard.rankingRecords);
					else 
						update(packetLeaderBoard.players);
					_direction = 0;
					break;
				case LobbyResponseType.TOP_LEADER_BOARD:
					//Utility.log(" response --> success for request top leader board");
					var packetTopLeaderBoard:ResponseTopLeaderBoard = packet as ResponseTopLeaderBoard;
					(baseView as LeaderBoardView).updatePlayersTop(packetTopLeaderBoard.players);
					break;
				//case LobbyResponseType.:
					
					//break;
			}
		}
		
		/*private function onPlayerClickHdl(e:EventEx):void 
		{
			//Game.flow.action(FlowActionID.INVITE_PLAYER, e.data);
			var data:LobbyPlayerInfo = e.data as LobbyPlayerInfo;
			if (data) {
				Utility.log("invite player " + data.id + " to pvp game");
				Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.INVITE_TO_PLAY_GAME, data.id));				
			}
		}*/
		
		private function onGoToPrevHdl(e:Event):void 		
		{
			//var type:int = e.data as int;
			requestListPlayers((_currentPage - 2) * LeaderBoardView.MAX_PLAYER_SHOW_IN_LIST,
						(_currentPage - 1) * LeaderBoardView.MAX_PLAYER_SHOW_IN_LIST /*- 1*/, -1, _type);	
		}
		
		private function onGoToNextHdl(e:Event):void 
		{
			//var type:int = e.data as int;
			requestListPlayers(_currentPage * LeaderBoardView.MAX_PLAYER_SHOW_IN_LIST,
						(_currentPage + 1) * LeaderBoardView.MAX_PLAYER_SHOW_IN_LIST /*- 1*/, 1, _type);	
		}
		
		private function requestListPlayers(from:int, to:int, direction:int, type:int):void {
			_direction = direction;
			_type = type;
			//call server to get data
			//Utility.log("call server to get data from " + from + " // " + to + " with request type " + type);
			Game.network.lobby.sendPacket(new RequestLeaderBoard(_type,
						from, to));
		}			
		
		public function update(data:Array):void {
			_data = data;				
			if (data) {				
				(baseView as LeaderBoardView).updatePlayers(_currentPage - 1, data);
				(baseView as LeaderBoardView).updatePaging(_currentPage, data.length > LeaderBoardView.MAX_PLAYER_SHOW_IN_LIST ? 0 : -1);
				//(view as LeaderBoardView).setPlayerSelected(data.length > 0 ? data[0] : null);
			}
		}		
		
	}

}