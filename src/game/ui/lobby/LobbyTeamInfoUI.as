package game.ui.lobby 
{
	import core.event.EventEx;
	import core.util.Utility;
	import flash.display.MovieClip;
	import flash.events.Event;
	//import game.data.enum.pvp.ModePVPEnum;
	import game.data.vo.lobby.LobbyPlayerInfo;
	import game.enum.GameMode;
	import game.enum.LobbyEvent;
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class LobbyTeamInfoUI extends MovieClip
	{	
		public static const MAX_PLAYER_PER_TEAM:int = 3;
		
		private static const DISTANCE_Y_PER_PLAYER_FREE:int = -45;
		private static const PLAYER_FREE_START_FROM_X:int = 0;
		private static const PLAYER_FREE_START_FROM_Y:int = 0;
		
		private static const DISTANCE_X_PER_PLAYER_MM:int = 100;
		private static const DISTANCE_Y_PER_PLAYER_MM:int = -100;
		private static const PLAYER_MM_START_FROM_X:int = 300;
		private static const PLAYER_MM_START_FROM_Y:int = 45;
		
		private var _playerUIs:Array = [];
		private var _playersInfo:Array = [];
		
		private var _teamID:int;
		private var _mode:GameMode;
		
		public function LobbyTeamInfoUI(/*mode:int, */teamID:int) 
		{
			//_mode = mode;
			_teamID = teamID;
			
			//prepare player UI
			for (var i:int = 0; i < MAX_PLAYER_PER_TEAM; i ++) {
				var player:LobbyPlayerInfoUI = new LobbyPlayerInfoUI();			
				player.x = PLAYER_FREE_START_FROM_X;
				player.y = PLAYER_FREE_START_FROM_Y + (player.height + DISTANCE_Y_PER_PLAYER_FREE) * i;
				player.visible = false;		
				//Utility.log("player info ui pos is " + player.x + " // " + player.y);
				_playerUIs.push(player);	
				_playersInfo.push(null);
				addChild(player);
			}
			
			//initUI();
			initEvent();
		}
		
		private function initEvent():void 
		{			
			addEventListener(LobbyEvent.VIEW_PLAYER, onPlayerRequestHdl);
			addEventListener(LobbyEvent.SWAP_PLAYER, onPlayerRequestHdl);
			addEventListener(LobbyEvent.KICK_PLAYER, onPlayerRequestHdl);
		}
		
		public function initUIByMode(mode:GameMode):void {
			_mode = mode;
			//Utility.log("lobby team UI init with mode: " + _mode);
			switch(_mode) {
				case GameMode.PVP_1vs1_MM:
				case GameMode.PVP_1vs1_FREE:
				case GameMode.PVP_3vs3_FREE:
					for (var i:int = 0; i < MAX_PLAYER_PER_TEAM; i ++) {
						var player:LobbyPlayerInfoUI = _playerUIs[i] as LobbyPlayerInfoUI;							
						player.setType(LobbyPlayerInfoUI.TYPE_FREE);
						player.x = PLAYER_FREE_START_FROM_X;
						player.y = PLAYER_FREE_START_FROM_Y + (player.height + DISTANCE_Y_PER_PLAYER_FREE) * i;
						//Utility.log("player info ui pos is " + player.x + " // " + player.y);
					}
					break;
				case GameMode.PVP_3vs3_MM:
					for (i = 0; i < MAX_PLAYER_PER_TEAM; i ++) {
						player = _playerUIs[i] as LobbyPlayerInfoUI;
						player.setType(LobbyPlayerInfoUI.TYPE_MATCHING);
						player.x = PLAYER_MM_START_FROM_X + DISTANCE_X_PER_PLAYER_MM * i;
						player.y = PLAYER_MM_START_FROM_Y + (player.height + DISTANCE_Y_PER_PLAYER_MM) * i;
						//Utility.log("player info ui pos is " + player.x + " // " + player.y);
					}
					break;
			}
		}
		
		private function onPlayerRequestHdl(e:Event):void 
		{
			switch(e.type) {
				case LobbyEvent.VIEW_PLAYER:				
				case LobbyEvent.SWAP_PLAYER:
				case LobbyEvent.KICK_PLAYER:
					var slotIndex:int = _playerUIs.indexOf(e.target);
					var id:int = slotIndex >= 0 ? (_playersInfo[slotIndex] as LobbyPlayerInfo).id : -1;
					dispatchEvent(new EventEx(LobbyEvent.PLAYER_REQUEST, { type:e.type, teamID: _teamID , slotIndex: slotIndex, playerID: id }, true ));
					break;
			}
		}
		
		public function updatePlayerInfo(index: int, data:LobbyPlayerInfo, showFromRight:Boolean = false):void {			
			if (index < 0 || index > MAX_PLAYER_PER_TEAM) {
				Utility.log(" can not update index out of range ");
			}else {
				var player:LobbyPlayerInfoUI = _playerUIs[index];
				//Utility.log("update info of team // " + _teamID + " // ");
				player.updateInfo(data ? data: null, showFromRight);			
				_playersInfo[index] = data;
				player.visible = data != null;				
			}
		}
		
		public function clear():void {
			for (var i:int = 0; i < _playerUIs.length; i++) {
				updatePlayerInfo(i, null);
			}
		}
		
		public function showAllPlayers(show:Boolean, showFromRight:Boolean ):void {
			for (var i:int = 0; i < MAX_PLAYER_PER_TEAM; i++) {				
				updatePlayerInfo(i, show ? new LobbyPlayerInfo() : null, showFromRight);
			}
		}
		
		public function showPlayerAtIndex(index: int, showFromRight:Boolean): void {
			if (index >= 0 && index < MAX_PLAYER_PER_TEAM) {				
				updatePlayerInfo(index, new LobbyPlayerInfo(), showFromRight);
			}
		}
		
		public function enableKick(enable:Boolean):void {
			var player:LobbyPlayerInfoUI;
			for (var i:int = 0; i < MAX_PLAYER_PER_TEAM; i++) {				
				player = _playerUIs[i] as LobbyPlayerInfoUI;
				player.enableKick(enable);
			}
		}
	}

}