package game.ui.challenge 
{
	import components.event.BaseEvent;
	import core.display.DisplayManager;
	import core.display.layer.Layer;
	import core.display.layer.LayerManager;
	import core.display.ModuleBase;
	import core.event.EventEx;
	import core.Manager;
	import core.util.Utility;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.utils.setTimeout;
	import game.data.vo.challenge.HistoryInfo;
	import game.data.vo.chat.ChatInfo;
	import game.data.vo.chat.ChatType;
	import game.data.vo.lobby.LobbyInfo;
	import game.enum.FlowActionEnum;
	import game.enum.InventoryMode;
	import game.enum.PaymentType;
	import game.flow.FlowManager;
	import game.data.vo.lobby.LobbyPlayerInfo;
	import game.data.xml.DataType;
	import game.data.xml.ModeConfigXML;
	import game.enum.DialogEventType;
	import game.enum.FormationType;
	import game.enum.GameConfigID;
	import game.enum.GameMode;
	import game.enum.LeaderBoardTypeEnum;
	import game.enum.TeamID;
	import game.flow.GameFlow;
	import game.net.IntRequestPacket;
	import game.net.IntResponsePacket;
	import game.net.lobby.LobbyRequestType;
	import game.net.lobby.LobbyResponseType;
	import game.net.lobby.request.RequestFormation;
	import game.net.lobby.request.RequestPvPReceivedReward;
	import game.net.lobby.response.ResponseChallengeHistory;
	import game.net.lobby.response.ResponseFormation;
	import game.net.lobby.response.ResponseGameServerAddress;
	import game.net.lobby.response.ResponseListChallengeRanking;
	import game.net.lobby.response.ResponsePVP1vs1AIState;
	import game.net.lobby.response.ResponseTopReceivedReward;
	import game.net.RequestPacket;
	import game.net.ResponsePacket;
	import game.net.Server;
	import game.ui.arena.ArenaEventName;
	import game.ui.chat.ChatEvent;
	import game.ui.chat.ChatModule;
	import game.ui.components.FormationSlot;
	import game.ui.components.ReceiveButton;
	import game.ui.dialog.DialogID;
	import game.ui.dialog.dialogs.YesNo;
	import game.ui.formation.FormationModule;
	import game.ui.formation.FormationView;
	import game.ui.ingame.replay.GameReplayManager;
	import game.ui.message.MessageID;
	import game.ui.ModuleID;
	import flash.events.MouseEvent;
	import game.Game;
	import game.utility.GameUtil;
	
	/**
	 * ...
	 * @author ...
	 */
	public class ChallengeModule extends ModuleBase 
	{
		private var _players:Array = [];
		private var _playerChallenge:LobbyPlayerInfo;
		
		private static const FORMATION_START_FROM_X:int = 155;
		private static const FORMATION_START_FROM_Y:int = 477;
		public var view:ChallengeView;
		
		public function ChallengeModule() 
		{
			relatedModuleIDs = [ModuleID.FORMATION];
		}
		
		override protected function createView():void 
		{
			super.createView();
			baseView = new ChallengeView();
			this.view = baseView as ChallengeView;
			
			baseView.addEventListener(ArenaEventName.PLAYER_CHALLENGE_CLICK, onPlayerChallengeClickHdl);
			baseView.addEventListener(History.VIEW_HISTORY_CLICK, viewHistoryClickHdl);
			baseView.addEventListener(History.SHARE_HISTORY_CLICK, shareHistoryClickHdl);
			baseView.addEventListener(Event.CLOSE, onCloseHdl);
			baseView.addEventListener(ChallengeView.SHOW_LEADER_BOARD, onViewRequestHdl);
			baseView.addEventListener(ChallengeView.SHOW_CHANGE_FORMATION_CHALLENGE, onViewRequestHdl);
			baseView.addEventListener(ChallengeView.REFRESH_TIME_COUNT_DOWN, onViewRequestHdl);
			baseView.addEventListener(ChallengeView.COMPLETED_TIME_COUNT_DOWN, onViewRequestHdl);
			baseView.addEventListener(ReceiveButton.ON_RECEIVE, onReceivedRewardHdl);
		}
		
		private function onCloseHdl(e:Event):void 
		{
			Manager.display.hideModule(ModuleID.CHALLENGE);
		}
		
		private function onReceivedRewardHdl(e:EventEx):void 
		{
			Game.network.lobby.sendPacket(new RequestPvPReceivedReward(
						LeaderBoardTypeEnum.TOP_1vs1_AI.type, e.data as int));
		}
		
		private function onViewRequestHdl(e:Event):void 
		{
			
			switch(e.type) {
				case ChallengeView.REFRESH_TIME_COUNT_DOWN:
					//reset player selected
					_playerChallenge = null;
					//var value: int = Game.database.gamedata.getConfigData(GameConfigID.COST_REFRESH_TIME_PER_PVP1vs1_AI) as int;
					var modeXML:ModeConfigXML = Game.database.gamedata.getData(DataType.MODE_CONFIG, GameMode.PVP_1vs1_AI.ID) as ModeConfigXML;
					Manager.display.showDialog(DialogID.YES_NO, onAcceptSkipRefreshHdl, null,
								{type:DialogEventType.CONFIRM_SKIP_COUNT_DOWN_PVP1vs1_AI, cost: modeXML ? modeXML.getCostSkipCoolDown() : 0} );						
					break;
				case ChallengeView.SHOW_LEADER_BOARD:
					Manager.display.hideModule(ModuleID.CHALLENGE);
					//Manager.display.showPopup(ModuleID.LEADER_BOARD, Layer.BLOCK_BLACK);
					Manager.display.showModule(ModuleID.LEADER_BOARD, new Point(0, 0), LayerManager.LAYER_POPUP,
										"top_left",Layer.BLOCK_BLACK);
					break;
				case ChallengeView.SHOW_CHANGE_FORMATION_CHALLENGE:
					//Manager.display.hideModule(ModuleID.LEADER_BOARD);
					//Manager.display.showPopup(ModuleID.CHANGE_FORMATION_CHALLENGE, Layer.BLOCK_BLACK);	
					var formationModule:FormationModule = (FormationModule)(modulesManager.getModuleByID(ModuleID.FORMATION));
					formationModule.mode = InventoryMode.CHANGE_FORMATION_CHALLENGE;
					Manager.display.showModule(ModuleID.CHANGE_FORMATION_CHALLENGE, new Point(0, 0), LayerManager.LAYER_POPUP,
										"top_left", Layer.BLOCK_BLACK);
					Manager.display.hideModule(ModuleID.CHALLENGE);					
					break;	
				case ChallengeView.COMPLETED_TIME_COUNT_DOWN:
					//reset player selected
					_playerChallenge = null;
					sendPacketInfo();
					break;
			}
		}
		
		private function onAcceptSkipRefreshHdl(data:Object):void 
		{
			//refresh time remain count down		
			Game.network.lobby.sendPacket(new RequestPacket(
						LobbyRequestType.PVP1vs1AI_REFRESH_TIME));
		}
		
		private function onAcceptSkipLimitHdl(data:Object):void 
		{
			//skip limit daily play time		
			Game.network.lobby.sendPacket(new RequestPacket(
						LobbyRequestType.PVP1vs1AI_SKIP_LIMIT));
		}
		
		private function onLobbyServerResponeHdl(e:EventEx):void 
		{
			var packet:ResponsePacket = e.data as ResponsePacket;
			switch(packet.type) {
				case LobbyResponseType.LIST_CHALLENGE_RANKING:
					Utility.log(" response --> success for request list challenge ranking");					
					var packetChallenges:ResponseListChallengeRanking = packet as ResponseListChallengeRanking;	
					_players = packetChallenges.players;
					(baseView as ChallengeView).updatePlayers(packetChallenges.players);
					break;
				case LobbyResponseType.CHALLENGE_HISTORY:
					Utility.log(" response --> success for request challenge history");
					var packetHistorys:ResponseChallengeHistory = packet as ResponseChallengeHistory;
					(baseView as ChallengeView).updateHistorys(packetHistorys.historys);
					break;
				case LobbyResponseType.PVP1vs1_AI_SKIP_LIMIT:
					var packetSkipLimit:IntResponsePacket = packet as IntResponsePacket;
					switch(packetSkipLimit.value) {
						case 0:
							//succecc skip limit --> call to start game again
							if (_playerChallenge) {
								sendPacketCreateBasicLobby();								
							}
							break;
						case 1:
							//fail by normal error
							
							break;
						case 2:
							//fail by not enough money
							//Manager.display.showMessageID(MessageID.PVP1vs1AI_NOT_ENOUGH_XU_SKIP_LIMIT);
							Game.flow.doAction(FlowActionEnum.PURCHASE_RESOURCE, PaymentType.XU_NORMAL.ID);
							break;
						case 3:
							//fail by reach limit pay game
							Manager.display.showMessageID(MessageID.PVP1vs1AI_REACH_LIMIT_PAY_GAME);
							break;
					}
					
					break;
				
				case LobbyResponseType.PVP1vs1_AI_STATE:
					var modeXML:ModeConfigXML = Game.database.gamedata.getData(DataType.MODE_CONFIG, GameMode.PVP_1vs1_AI.ID) as ModeConfigXML;
					if (packet) 
					{						
						var packetState:ResponsePVP1vs1AIState = packet as ResponsePVP1vs1AIState;
						packetState.maxMatchFreePlay = modeXML ? modeXML.getMaxFreeGame() + packetState.numMatchPaid : 0;
						(baseView as ChallengeView).updateState(packetState);
					}
					break;
				case LobbyResponseType.TOP_RECEIVED_REWARD:
					var packetReceived:ResponseTopReceivedReward = packet as ResponseTopReceivedReward;
					Utility.log(" response --> success for request received reward " + packetReceived.result);
					switch(packetReceived.result) {
						case 0:
							Manager.display.showMessageID(MessageID.PVP1vs1AI_RECEIVED_REWARD_SUCCESS);
							break;
						case 1:
							//full kho
							Manager.display.showMessageID(MessageID.PVP1vs1AI_RECEIVED_REWARD_FAIL);
							break;
					}
					//get state and rewards can get and had received
					Game.network.lobby.sendPacket(new RequestPacket(
								LobbyRequestType.PVP1vs1AI_STATE));
					break;
				case LobbyResponseType.PVP1vs1_AI_REFRESH_TIME:
					var packetRefresh:IntResponsePacket = packet as IntResponsePacket;
					Utility.log(" response --> success for refresh time count down " + packetRefresh.value);
					switch(packetRefresh.value) {
						case 0:
							//success
							sendPacketInfo();
							if(_playerChallenge) {
								sendPacketCreateBasicLobby();
							}
							break;
						case 1:
							//fail by normal error
							
							break;
						case 2:
							//fail by not enough money
							Manager.display.showMessageID(MessageID.PVP1vs1AI_NOT_ENOUGH_XU_REFRESH_TIME);
							break;	
					}
					break;
				case LobbyResponseType.FORMATION:
					if (GameReplayManager.getInstance().isReplaying) break;
					var packetFormation:ResponseFormation = packet as ResponseFormation;
					switch(packetFormation.formationType) {
						case FormationType.FORMATION_CHALLENGE:
							if (_playerChallenge) {				
								if (_playerChallenge.id == packetFormation.userID) {									
									Game.database.userdata.lobbyPlayers = [];
									//here was change by remove the last info ~ myself
									var self:LobbyPlayerInfo = new LobbyPlayerInfo();
									self.id = Game.database.userdata.userID;
									//self.characters = Game.database.userdata.getFormationChallenge();
									self.characters = Game.database.userdata.formationChallenge;
									self.teamIndex = 1;
									self.owner = true;
									self.level = Game.database.userdata.level;
									self.name = Game.database.userdata.playerName;
									Game.database.userdata.lobbyPlayers[0] = self;
									
									_playerChallenge.teamIndex = 2;
									_playerChallenge.characters = packetFormation.formation;
									Game.database.userdata.lobbyPlayers[1] = _playerChallenge;
									sendPacketCreateBasicLobby();
								}
							}else {
								Utility.error("can not go to loading by error NULL player challenge pvp ai");
							}
							break;
					}
					break;
					
			}
		}
		
		private function viewHistoryClickHdl(e:BaseEvent):void 
		{
			var info:HistoryInfo = e.data as HistoryInfo;
			var players:Array;
			
			var mainPlayer:LobbyPlayerInfo = new LobbyPlayerInfo();
			mainPlayer.id = Game.database.userdata.userID;
			mainPlayer.owner = true;
			mainPlayer.level = Game.database.userdata.level;
			mainPlayer.name = Game.database.userdata.playerName;
			
			var player:LobbyPlayerInfo = new LobbyPlayerInfo();
			player.id = info.playerID;
			player.name = info.name;
			player.level = 1;
			player.owner = false;
			
			if (info.activeAttack) players = [mainPlayer, player];
			else players = [player, mainPlayer];
			
			GameReplayManager.getInstance().beginReplaying(GameMode.PVP_1vs1_AI, info.nTimeCreate, players, ModuleID.CHALLENGE);
			
			view.historyMov.lock();
			setTimeout(view.historyMov.unlock, 2000); 
		}
		
		private function shareHistoryClickHdl(e:BaseEvent):void 
		{
			var msg:String = "";
			var info:HistoryInfo = e.data as HistoryInfo;
			
			var mainPlayer:LobbyPlayerInfo = new LobbyPlayerInfo();
			mainPlayer.id = Game.database.userdata.userID;
			mainPlayer.owner = true;
			mainPlayer.level = Game.database.userdata.level;
			mainPlayer.name = Game.database.userdata.playerName;
			
			var player:LobbyPlayerInfo = new LobbyPlayerInfo();
			player.id = info.playerID;
			player.owner = false;
			player.level = 1;
			player.name = info.name;
			
			var player1:LobbyPlayerInfo;
			var player2:LobbyPlayerInfo;
			
			if (info.activeAttack)
			{
				player1 = mainPlayer;
				player2 = player;
			}
			else 
			{
				player1 = player;
				player2 = mainPlayer;
			}
			
			var teanmId:int = info.activeAttack ? TeamID.LEFT : TeamID.RIGHT;
			msg = GameReplayManager.getInstance().serializeReplayMsg(teanmId, info.nTimeCreate, player1, player2);
			
			var chatInfo:ChatInfo = new ChatInfo();
			chatInfo.type = ChatType.CHAT_TYPE_SERVER;
			chatInfo.mes = msg;
			
			ChatModule(Manager.module.getModuleByID(ModuleID.CHAT)).onSendChat(new EventEx(ChatEvent.SEND_CHAT_GLOBAL, chatInfo));
		}
		
		private function onPlayerChallengeClickHdl(e:EventEx):void 
		{
			_playerChallenge = e.data as LobbyPlayerInfo;						
			Manager.display.showDialog(DialogID.YES_NO, onAcceptChallengeHdl, null,
								{type:DialogEventType.CONFIRM_CHALLENGE_PLAYER_PVP1vs1_AI, name:_playerChallenge.name,
								id: _playerChallenge.id} );	
		}				
		
		private function onAcceptChallengeHdl(data:Object):void 
		{
			if (data) {
				Game.network.lobby.sendPacket(new RequestFormation(FormationType.FORMATION_CHALLENGE.ID, data.id));
			}
		}			
		
		override protected function preTransitionIn():void {
			GameReplayManager.getInstance();
			addFormationView();
			super.preTransitionIn();
		}
		
		public function addFormationView():void {
			var formationModule:FormationModule = (FormationModule)(modulesManager.getModuleByID(ModuleID.FORMATION));
			formationModule.mode = InventoryMode.FORMATION_CHALLENGE;
			//formationModule.enableChange = false;
			//formationModule.enableAddCharacter = true;
			formationModule.baseView.x = FORMATION_START_FROM_X;
			formationModule.baseView.y = FORMATION_START_FROM_Y;
			formationModule.baseView.scaleX = 0.85;
			formationModule.baseView.scaleY = 0.85;
			(baseView as ChallengeView).addFormationView(formationModule.baseView as FormationView);
		}
		
		override protected function transitionIn():void 
		{
			super.transitionIn();
			
			_players = [];
			_playerChallenge = null;
			
			Game.network.lobby.addEventListener(Server.SERVER_DATA, onLobbyServerResponeHdl);			
			sendPacketInfo();
		}
		
		override protected function transitionOut():void 
		{
			super.transitionOut();
			Game.network.lobby.removeEventListener(Server.SERVER_DATA, onLobbyServerResponeHdl);
		}


		override protected function onTransitionOutComplete():void
		{
			super.onTransitionOutComplete();
			var formationModule:FormationModule = (FormationModule)(modulesManager.getModuleByID(ModuleID.FORMATION));
			formationModule.baseView.scaleX = 1;
			formationModule.baseView.scaleY = 1;
		}

		private function sendPacketInfo():void {
			//get list challenge ranking			
			Game.network.lobby.sendPacket(new RequestPacket(
						LobbyRequestType.LIST_CHALLENGE_RANKING));
			//get list history			
			Game.network.lobby.sendPacket(new RequestPacket(
						LobbyRequestType.CHALLENGE_HISTORY));	
			//get state and rewards can get and had received
			Game.network.lobby.sendPacket(new RequestPacket(
						LobbyRequestType.PVP1vs1AI_STATE));	
		}
		
		//Gui len server tao basic lobby
		/**
		 * 
		 * @param	isReplay: set to true when create basic lobby for challenge replaying
		 * @param	challengeID
		 */
		private function sendPacketCreateBasicLobby():void 
		{
			var lobbyInfo:LobbyInfo = new LobbyInfo();
			lobbyInfo.backModule = ModuleID.CHALLENGE;
			lobbyInfo.mode = GameMode.PVP_1vs1_AI;
			lobbyInfo.challengeID = _playerChallenge.id;
			Game.flow.doAction(FlowActionEnum.CREATE_BASIC_LOBBY, lobbyInfo);
		}
				
		public function skipLimitPlayDailyHdl():void {
			//over limit daily time play
			var modeXML:ModeConfigXML = Game.database.gamedata.getData(DataType.MODE_CONFIG, GameMode.PVP_1vs1_AI.ID) as ModeConfigXML;
			
			Manager.display.showDialog(DialogID.YES_NO, onAcceptSkipLimitHdl, null,
				{type:DialogEventType.CONFIRM_SKIP_LIMIT_PLAY_DAILY_PVP1vs1_AI,
				cost: modeXML ? modeXML.getCostPlayGame() : 0,
				exist: modeXML ? modeXML.getMaxPayGame() + modeXML.getMaxFreeGame() - (baseView as ChallengeView).getMaxMatchPlay() : 0} );
		}
		
		public function skipCountDownHdl():void {
			//not complete time count down
			var modeXML:ModeConfigXML = Game.database.gamedata.getData(DataType.MODE_CONFIG, GameMode.PVP_1vs1_AI.ID) as ModeConfigXML;
			
			Manager.display.showDialog(DialogID.YES_NO, onAcceptSkipRefreshHdl, null,
						{type:DialogEventType.CONFIRM_SKIP_COUNT_DOWN_PVP1vs1_AI, cost: modeXML ? modeXML.getCostSkipCoolDown() : 0} );
		}
	}

}