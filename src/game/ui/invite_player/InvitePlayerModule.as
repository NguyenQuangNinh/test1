package game.ui.invite_player 
{
	import core.util.Enum;
	import flash.events.Event;
	import game.enum.PlayerType;
	
	import core.Manager;
	import core.display.ModuleBase;
	import core.event.EventEx;
	import core.util.Utility;
	
	import game.Game;
	import game.data.vo.lobby.LobbyPlayerInfo;
	import game.enum.ErrorCode;
	import game.enum.LobbyEvent;
	import game.net.IntRequestPacket;
	import game.net.IntResponsePacket;
	import game.net.ResponsePacket;
	import game.net.Server;
	import game.net.lobby.LobbyRequestType;
	import game.net.lobby.LobbyResponseType;
	import game.net.lobby.request.RequestListPlayerFree;
	import game.net.lobby.response.ResponseListPlayersFree;
	import game.ui.ModuleID;
	import game.ui.components.PagingMov;
	import game.ui.components.tab.Tab;

	/**
	 * ...
	 * @author TrungLNM
	 */
	public class InvitePlayerModule extends ModuleBase
	{		
		private var _data:Array;
		private var _currentPage:int;
		
		//0: stand by
		//1: toward
		//-1: backward
		private var _direction:int;
		//0: get all server
		//1: get friend
		//2: get guide
		private var _currentTabIndex:int = -1;
		private var invitedPlayer:LobbyPlayerInfo;
		
		public function InvitePlayerModule() 
		{
			
		}
		
		override protected function createView():void 
		{
			super.createView();
			baseView = new InvitePlayerView();
			
			Game.network.lobby.addEventListener(Server.SERVER_DATA, onLobbyServerResponeHdl);
			baseView.addEventListener(PagingMov.GO_TO_NEXT, onGoToNextHdl);
			baseView.addEventListener(PagingMov.GO_TO_PREV, onGoToPrevHdl);
			baseView.addEventListener(LobbyEvent.PLAYER_INVITE_CLICK, onPlayerClickHdl);
			baseView.addEventListener(Event.CLOSE, onCloseHdl);
			baseView.addEventListener(Tab.CHANGE_TAB, onChangeTabHdl);
		}
		
		private function onChangeTabHdl(e:EventEx):void 
		{
			var tabIndex:int = e.data as int;
			if (tabIndex != _currentTabIndex) {
				//chang tab
				_direction = 0;
				_currentPage = 0;
				_currentTabIndex = tabIndex;
				//_type = tabIndex + 1;
				//clear content before get new one
				//(view as InvitePlayerView).updatePlayers([]);
				var playerType:int = Enum.getEnum(PlayerType, _currentTabIndex) ? (Enum.getEnum(PlayerType, _currentTabIndex) as PlayerType).type : -1;
				Utility.log("get friend on tab type " + playerType);
				requestListPlayers(_currentPage * InvitePlayerView.MAX_PLAYER_SHOW_IN_LIST,
							(_currentPage + 1) * InvitePlayerView.MAX_PLAYER_SHOW_IN_LIST /*- 1*/, 1, playerType);	
			}			
		}
		
		private function onCloseHdl(e:Event):void 
		{
			Manager.display.hideModule(ModuleID.INVITE_PLAYER);
		}
		
		private function onLobbyServerResponeHdl(e:EventEx):void 
		{
			var packet:ResponsePacket = e.data as ResponsePacket;
			switch(packet.type) {
				case LobbyResponseType.LIST_PLAYERS_FREE:
					var packetListPlayersFree:ResponseListPlayersFree = packet as ResponseListPlayersFree;			
					Utility.log(" response --> success for request list players " + packetListPlayersFree.players.length);
					_currentPage += _direction;						
					update(packetListPlayersFree.players);
					_direction = 0;
					break;
				case LobbyResponseType.INVITE_TO_PLAY_GAME:
				case LobbyResponseType.HEROIC_INVITE_PLAYER:
					//hot check level 20 and more can see invite dialog
					//var currentLevel:int = Game.database.userdata.level;
					//if(currentLevel  > 20)
						onInvitePlayerResult(IntResponsePacket(packet).value);
					break;
			}
		}
		
		private function onInvitePlayerResult(errorCode:int):void
		{
			//Utility.log("invite friend result: " + errorCode);
			switch(errorCode)
			{
				case ErrorCode.SUCCESS:
					(baseView as InvitePlayerView).updatePlayerSelected(_data.indexOf(invitedPlayer));
					break;
				case ErrorCode.INVITE_PLAYER_LEVEL_REQUIREMENT:
					Manager.display.showMessage("Bằng hữu này chưa đủ cấp độ yêu cầu");
					break;
				case ErrorCode.INVITE_PLAYER_OUT_OF_TURN:
					Manager.display.showMessage("Bằng hữu này đã hết lượt chơi");
					break;
			}
		}
		
		private function onPlayerClickHdl(e:EventEx):void 
		{
			//Game.flow.action(FlowActionID.INVITE_PLAYER, e.data);
			var data:LobbyPlayerInfo = e.data as LobbyPlayerInfo;
			if (data) {
				invitedPlayer = data;
				Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.INVITE_TO_PLAY_GAME, data.id));
				/*switch(extraInfo.moduleID) {
					case ModuleID.HEROIC_NODE:
						Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.HEROIC_INVITE_PLAYER, data.id));
						break;
						
					default:
						Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.INVITE_TO_PLAY_GAME, data.id));
						break;
				}*/
			}
		} 
		
		private function onGoToPrevHdl(e:Event):void 		
		{
			var playerType:int = Enum.getEnum(PlayerType, _currentTabIndex) ? (Enum.getEnum(PlayerType, _currentTabIndex) as PlayerType).type : -1
			requestListPlayers((_currentPage - 2) * InvitePlayerView.MAX_PLAYER_SHOW_IN_LIST,
						(_currentPage - 1) * InvitePlayerView.MAX_PLAYER_SHOW_IN_LIST /*- 1*/, -1, playerType);	
		}
		
		private function onGoToNextHdl(e:Event):void 
		{
			var playerType:int = Enum.getEnum(PlayerType, _currentTabIndex) ? (Enum.getEnum(PlayerType, _currentTabIndex) as PlayerType).type : -1
			requestListPlayers(_currentPage * InvitePlayerView.MAX_PLAYER_SHOW_IN_LIST,
						(_currentPage + 1) * InvitePlayerView.MAX_PLAYER_SHOW_IN_LIST /*- 1*/, 1, playerType);	
		}
		
		private function requestListPlayers(from:int, to:int, direction:int, type:int):void {
			_direction = direction;
			//_currentTabIndex = type;
			//call server to get data
			Game.network.lobby.sendPacket(new RequestListPlayerFree(
						from, to, type));
		}			
		
		public function update(data:Array):void {
			_data = data;				
			/*data = data.concat(data);
			data = data.concat(data);
			data = data.concat(data);
			data = data.concat(data);*/
			(baseView as InvitePlayerView).updatePlayers(_data);
			(baseView as InvitePlayerView).updatePaging(_currentPage, data.length > InvitePlayerView.MAX_PLAYER_SHOW_IN_LIST ? 0 : -1);
		}
		
		override protected function onTransitionOutComplete():void 
		{
			super.onTransitionOutComplete();
			_currentTabIndex = -1;
		}
	}	

}