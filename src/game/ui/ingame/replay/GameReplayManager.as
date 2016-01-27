package game.ui.ingame.replay {
	import core.display.layer.Layer;
	import core.display.layer.LayerManager;
	import core.event.EventEx;
	import core.Manager;
	import core.util.Enum;
	import core.util.Utility;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.utils.ByteArray;
	import flash.utils.clearTimeout;
	import flash.utils.Endian;
	import flash.utils.setTimeout;
	import game.data.vo.challenge.HistoryInfo;
	import game.data.vo.lobby.LobbyInfo;
	import game.data.vo.lobby.LobbyPlayerInfo;
	import game.enum.FlowActionEnum;
	import game.enum.FormationType;
	import game.enum.GameMode;
	import game.enum.TeamID;
	import game.Game;
	import game.net.ExGameServer;
	import game.net.ExLobbyServer;
	import game.net.ExServer;
	import game.net.game.GameResponseType;
	import game.net.game.GameServer;
	import game.net.game.ingame.IngamePacket;
	import game.net.game.response.ResponseIngame;
	import game.net.IntRequestPacket;
	import game.net.lobby.LobbyRequestType;
	import game.net.lobby.LobbyResponseType;
	import game.net.lobby.LobbyServer;
	import game.net.lobby.request.RequestBasePacket;
	import game.net.lobby.request.RequestFormation;
	import game.net.lobby.response.ResponseChallengeReplayInfo;
	import game.net.lobby.response.ResponseFormation;
	import game.net.ResponsePacket;
	import game.net.Server;
	import game.ui.chat.ChatModule;
	import game.ui.chat.ChatView;
	import game.ui.ingame.replay.data.ReplayInfo;
	import game.ui.ModuleID;
	/**
	 * ...
	 * @author vu anh
	 */
	public class GameReplayManager 
	{
		private static var LOBBY_RESPONSE:int = 0;
		private static var GAME_RESPONSE:int = 1;
		private static var INSTANCE:GameReplayManager;
		private var startTime:Number; // minisecond
		
		private var responseQueue:Array;
		private var timeoutIds:Array;
		public var isReplaying:Boolean;
		public var gameTime:int = -1;
		
		private var gameServer:ExGameServer;
		private var lobbyServer:ExLobbyServer;
		private var gameMode:GameMode;
		private var lobbyPlayerInfos:Array;
		private var backModule:ModuleID;
		private var teamId:int;
		private var replayInfoBA:ByteArray;
		
		public function GameReplayManager() 
		{
			if (INSTANCE) 
			{
				throw new Error("PVPReplayManager singleton error!");
				return;
			}
			responseQueue = [];
			timeoutIds = [];
			lobbyServer = new ExLobbyServer();
			gameServer = new ExGameServer();
			
			// test ---------------
			//Game.network.game.addEventListener(Server.SERVER_DATA, onGameResponseTest);
			//Game.network.lobby.addEventListener(Server.SERVER_DATA, onLobbyResponseTest);
			// --------------------
		}
		
		// for testing only, will not use in real mode ======================================================================
		
		private function onLobbyResponseTest(e:EventEx):void 
		{
			var packet:ResponsePacket = e.data as ResponsePacket;
			if (packet.type == LobbyResponseType.END_GAME_REWARD_RESULT ||
				packet.type == LobbyResponseType.END_GAME_RESULT) pushPacket(LOBBY_RESPONSE, packet);
		}
		
		private function onGameResponseTest(e:EventEx):void 
		{
			var packet:ResponsePacket = e.data as ResponsePacket;
			if (packet.type == GameResponseType.IN_GAME || 
			    packet.type == GameResponseType.INIT_PLAYER ||
				packet.type == GameResponseType.PREPARE_NEXT_WAVE ||
				packet.type == GameResponseType.NEXT_WAVE_READY) pushPacket(GAME_RESPONSE, packet);
		}
		
		// ==================================================================================================================
		
		// FLOW: 
		// 1. getGameReplayInfo()
		// 2. get formation of all players
		// 3. createBasicLobby()
		// 4. load resource Game.flow.doAction(FlowActionEnum.START_LOADING_RESOURCE_REPLAY);
		// 5. after resource loading completed, call startPlay() 
		// 6. startSimulation()
		
		public function endReplaying():void
		{
			Game.network.lobby.removeEventListener(Server.SERVER_DATA, onLobbyResponse);
			while (timeoutIds.length) clearTimeout(timeoutIds.pop() as uint);
			isReplaying = false;
			responseQueue = [];
			gameTime = -1;
		}
		
		public static function getInstance():GameReplayManager
		{
			if (!INSTANCE) INSTANCE = new GameReplayManager();
			return INSTANCE;
		}
		
		public function pushPacket(responseType:int, packet:ResponsePacket):void
		{
			if (responseQueue.length == 0) 
			{
				startTime = new Date().getTime();
			}
			var delay:uint = new Date().getTime() - startTime;
			trace("pushPacket responseType: " + responseType + " delay: " + delay);
			responseQueue.push(new ReplayInfo(delay, responseType, packet));
		}
		
		// call this method after finishing loading resources
		public function startPlay():void
		{
			// progress packet here
			if (responseQueue.length == 0) decodeReplayInfo(replayInfoBA);
			startSimulation();
		}
		
		/**
		 * 
		 * @param	gameMode
		 * @param	gameTime
		 * @param	lobbyPlayerInfos	lobbyPlayerInfos[0]: active	lobbyPlayerInfos[1]: challenged
 		 * @param	backModule
		 * @param	teamId: the cuurent player (main user) is on the left or right side of the battle
		 */
		public function beginReplaying(gameMode:GameMode, gameTime:int, lobbyPlayerInfos:Array, backModule:ModuleID = null, teamId:int = - 1):void
		{
			this.teamId = teamId;
			this.backModule = backModule;
			this.lobbyPlayerInfos = lobbyPlayerInfos;
			this.gameMode = gameMode;
			this.gameTime = gameTime;
			
			Game.network.lobby.removeEventListener(Server.SERVER_DATA, onLobbyResponse);
			Game.network.lobby.addEventListener(Server.SERVER_DATA, onLobbyResponse);
			if (responseQueue.length == 0) getGameReplayInfo();
			else startReplaying();
	
		}
		
		private function startReplaying():void
		{
			isReplaying = true;
			
			// start load formation
			Game.database.userdata.lobbyPlayers = [];
			
			for (var i:int = 0; i < lobbyPlayerInfos.length; i++) 
			{
				LobbyPlayerInfo(lobbyPlayerInfos[i]).teamIndex = (i + 1);
			}
			getFomationInfo(this.lobbyPlayerInfos[0]);
		}
		
		public function startSimulation():void
		{
			Game.network.game.removeEventListener(Server.SERVER_DATA, onGameResponseTest);
			Game.network.lobby.removeEventListener(Server.SERVER_DATA, onLobbyResponseTest);
			while (timeoutIds.length) clearTimeout(timeoutIds.pop() as uint);
			var server:Server;
			var timeoutId:uint;
			while (responseQueue.length)
			{
				var rInfo:ReplayInfo = responseQueue.shift();
				server = rInfo.responseType == LOBBY_RESPONSE ? Game.network.lobby : Game.network.game;
				
				timeoutId = setTimeout(onTimeout, rInfo.delay, server, rInfo.packet);
				timeoutIds.push(timeoutId);
			}
		}
		
		// return true if the player is main player
		public function getFomationInfo(playerInfo:LobbyPlayerInfo):void
		{
			switch (gameMode)
			{
				//pvp resource war
				case GameMode.PVP_RESOURCE_WAR_PVP:
				case GameMode.PVE_EXPRESS_WAR_PVP:
				// challenge
				case GameMode.PVP_1vs1_AI:
					// already loaded for main player
					var playerIndx:int = Game.database.userdata.lobbyPlayers.length;
					if (Game.database.userdata.userID == playerInfo.id)
					{
						Game.database.userdata.lobbyPlayers[playerIndx] = playerInfo;
						playerInfo.characters = Game.database.userdata.formationChallenge;
						if (Game.database.userdata.lobbyPlayers.length == 2)
						{
							createBasicLobby();
							// start playing mechanism now ------------------------------
							// start loading ingame resource
							Game.flow.doAction(FlowActionEnum.START_LOADING_RESOURCE_REPLAY);
						}
						else getFomationInfo(this.lobbyPlayerInfos[Game.database.userdata.lobbyPlayers.length]);
					}
					else 
					{
						Game.network.lobby.sendPacket(new RequestFormation(FormationType.FORMATION_CHALLENGE.ID, playerInfo.id));
					}
					break;
			}
		}
		
		public function getGameReplayInfo():void
		{
			if (gameTime < 0) throw new Error("gameIndex is not initialized yet!");
			var packet:RequestBasePacket = new RequestBasePacket(LobbyRequestType.CHALLENGE_REPLAY_INFO);
			if (LobbyPlayerInfo(lobbyPlayerInfos[0]).owner) packet.ba.writeInt(LobbyPlayerInfo(lobbyPlayerInfos[0]).id);
			else packet.ba.writeInt(LobbyPlayerInfo(lobbyPlayerInfos[1]).id);
			packet.ba.writeUnsignedInt(gameTime);
			//packet.ba.writeInt(GameMode.PVP_1vs1_AI.ID);
			packet.ba.writeInt(this.gameMode.ID);
			Game.network.lobby.sendPacket(packet);
		}
		
		private function onLobbyResponse(e:EventEx):void 
		{
			Utility.log("game play manager --> receive replay info");
			var packet:ResponsePacket = e.data as ResponsePacket;
			switch (packet.type)
			{
				case LobbyResponseType.FORMATION:
					var packetFormation:ResponseFormation = packet as ResponseFormation;
					switch(packetFormation.formationType) 
					{
						case FormationType.FORMATION_CHALLENGE:	
							var playerIndx:int = Game.database.userdata.lobbyPlayers.length;
							var player:LobbyPlayerInfo = lobbyPlayerInfos[playerIndx];
	
							player.characters = packetFormation.formation;
							
							Game.database.userdata.lobbyPlayers[playerIndx] = player;
							if (Game.database.userdata.lobbyPlayers.length == 2)
							{
								Game.network.lobby.removeEventListener(Server.SERVER_DATA, onLobbyResponse);
								createBasicLobby();
								// start playing mechanism now ------------------------------
								// start loading ingame resource
								Game.flow.doAction(FlowActionEnum.START_LOADING_RESOURCE_REPLAY);
							}
							else
							{
								getFomationInfo(this.lobbyPlayerInfos[Game.database.userdata.lobbyPlayers.length]);
							}
							break;
					}
					break;
				case LobbyResponseType.CHALLENGE_REPLAY_INFO:
					
					replayInfoBA = ResponseChallengeReplayInfo(packet).ba;
					var chatModule:ChatModule = Manager.module.getModuleByID(ModuleID.CHAT) as ChatModule;
					if (replayInfoBA.length)
					{
						startReplaying();
						ChatView(chatModule.baseView).chatVisible(false);
					} else 
					{
						endReplaying();
						Manager.display.showMessage("Dữ liệu lỗi, không thể xem lại.");
					}
					break;
			}
		}
		
		private function createBasicLobby():void 
		{
			var lobbyInfo:LobbyInfo = new LobbyInfo();
			lobbyInfo.backModule = this.backModule;
			lobbyInfo.mode = GameMode.PVP_1vs1_AI;
			lobbyInfo.challengeID = LobbyPlayerInfo(lobbyPlayerInfos[1]).id;
			Game.flow.doAction(FlowActionEnum.CREATE_BASIC_LOBBY, lobbyInfo);
		}
		
		private function onTimeout(server:Server, packet:ResponsePacket):void 
		{
			server.fireServerDataEvent(packet);
		}
		
		private function decodeReplayInfo(ba:ByteArray):void
		{
			responseQueue = [];
			var rInfo:ReplayInfo = new ReplayInfo();
			var server:ExServer;
			ba.position = 0;
			var startWaveTime:int = 0;
			// INIT_PLAYER 0 - PREPARE_NEXT_WAVE 2333 - IN_GAME 2333 - NEXT_WAVE_READY 7136 - IN_GAME ... IN_GAME - END_GAME_REWARD_RESULT - END_GAME_RESULT
			while (ba.bytesAvailable)
			{
				rInfo = new ReplayInfo();
				
				rInfo.delay = ba.readUnsignedInt() + startWaveTime;
				rInfo.responseType = ba.readByte();
				server = rInfo.responseType == LOBBY_RESPONSE ? lobbyServer : gameServer;
				rInfo.packet = server.readPacket(ba);
				
				if (rInfo.responseType == GAME_RESPONSE && rInfo.packet.type == GameResponseType.PREPARE_NEXT_WAVE)
				{
					rInfo.delay = 2000;
					startWaveTime = rInfo.delay;
				}
				if (rInfo.responseType == GAME_RESPONSE && rInfo.packet.type == GameResponseType.NEXT_WAVE_READY)
				{
					startWaveTime = 7000;
				}
				trace("rInfo.delay ==== " + rInfo.delay);
				responseQueue.push(rInfo);
			}
			
			if (responseQueue.length > 3)
			{
				// set delay of END_GAME_REWARD_RESULT and END_GAME_RESULT to the delay of latest ingame packet
				ReplayInfo(responseQueue[responseQueue.length - 1]).delay = ReplayInfo(responseQueue[responseQueue.length - 3]).delay;
				ReplayInfo(responseQueue[responseQueue.length - 2]).delay = ReplayInfo(responseQueue[responseQueue.length - 3]).delay;
			}
		}
		
		// call this to determine which team will be showed formation
		// check Game.database.userdata.getCurrentModeData().teamID
		public function getTeamID():int
		{
			if (teamId >= 0) return teamId;
			if (Game.database.userdata.userID == lobbyPlayerInfos[0].id) return TeamID.LEFT;
			else return TeamID.RIGHT;
		}
		
		public function serializeReplayMsg(teamId:int, time:uint, player1:LobbyPlayerInfo, player2: LobbyPlayerInfo):String
		{
			var msg:String = "[challenge-replay]";
			msg += teamId + ',';
			msg += time + ',';
			
			msg += player1.id + ',';
			msg += (player1.owner ? 1 : 0) + ',';
			msg += player1.level + ',';
			msg += player1.name + ',';
			
			msg += player2.id + ',';
			msg += (player2.owner ? 1 : 0) + ',';
			msg += player2.level + ',';
			msg += player2.name;
			return msg;
		}
		
	}

}