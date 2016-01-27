package game.ui.tooltip 
{
	import core.display.ModuleBase;
	import core.event.EventEx;
	import flash.events.Event;
	import game.Game;
	import game.net.IntRequestPacket;
	import game.net.lobby.LobbyRequestType;
	import game.net.lobby.LobbyResponseType;
	import game.net.lobby.response.ResponseLeaderBoardPlayerFormationInfo;
	import game.net.ResponsePacket;
	import game.net.Server;
	
	/**
	 * ...
	 * @author MaiPTT
	 */
	public class TooltipModule extends ModuleBase 
	{
		private var _playerRequestInfo:Object;
		
		public function TooltipModule() {
			
		}
		
		override protected function createView():void 
		{
			super.createView();
			baseView = new TooltipView();
			
			(baseView as TooltipView).addEventListener(TooltipEvent.REQUEST_PLAYER_FORMATION_INFO, onRequestPlayerFormationInfoHdl);
		}
		
		private function onRequestPlayerFormationInfoHdl(e:EventEx):void 
		{
			if (e.data) {
				_playerRequestInfo = e.data;
				var playerID:int = _playerRequestInfo.id;
				Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.LEADER_BOARD_PLAYER_FORMATION_INFO, playerID));
			}
		}
		
		override protected function transitionIn():void 
		{
			super.transitionIn();
			Game.network.lobby.addEventListener(Server.SERVER_DATA, onLobbyServerDataHdl);
		}
		
		private function onLobbyServerDataHdl(e:EventEx):void 
		{
			var packet:ResponsePacket = e.data as ResponsePacket;
			switch(packet.type) {
				case LobbyResponseType.LEADER_BOARD_PLAYER_FORMATION_INFO:
					var packetFormation:ResponseLeaderBoardPlayerFormationInfo = packet as ResponseLeaderBoardPlayerFormationInfo;
					(baseView as TooltipView).updatePlayerFormationInfo(packetFormation.formationStat, packetFormation.getFormation(), _playerRequestInfo ? _playerRequestInfo.from : 1 );
					break;
			}
				
		}
		
		override protected function onTransitionOutComplete():void 
		{
			super.onTransitionOutComplete();
			Game.network.lobby.removeEventListener(Server.SERVER_DATA, onLobbyServerDataHdl);
		}
	}

}