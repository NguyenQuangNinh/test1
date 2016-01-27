package game.flow
{

	import core.Manager;
	import core.display.layer.Layer;
	import core.display.layer.LayerManager;
	import core.event.EventEx;
	import core.util.Enum;
	import core.util.Utility;
	import flash.utils.setTimeout;
	import game.enum.GameConfigID;

	import game.net.lobby.response.ResponseChangeRoomHost;
	import game.ui.ingame.replay.GameReplayManager;

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Point;

	import game.Game;
	import game.data.gamemode.ModeData;
	import game.data.gamemode.ModeDataHeroicTower;
	import game.data.gamemode.ModeDataPVEHeroic;
	import game.data.gamemode.ModeDataPvE;
	import game.data.gamemode.ModeDataPvP;
	import game.data.model.Character;
	import game.data.model.item.ItemFactory;
	import game.data.vo.chat.ChatType;
	import game.data.vo.item.ItemInfo;
	import game.data.vo.lobby.LobbyInfo;
	import game.data.vo.lobby.LobbyPlayerInfo;
	import game.data.xml.item.ItemXML;
	import game.enum.DialogEventType;
	import game.enum.ErrorCode;
	import game.enum.FlowActionEnum;
	import game.enum.GameMode;
	import game.enum.TeamID;
	import game.net.BooleanResponsePacket;
	import game.net.IntRequestPacket;
	import game.net.IntResponsePacket;
	import game.net.RequestPacket;
	import game.net.ResponsePacket;
	import game.net.Server;
	import game.net.lobby.LobbyRequestType;
	import game.net.lobby.LobbyResponseType;
	import game.net.lobby.request.RequestCreateBasicRoom;
	import game.net.lobby.request.RequestJoinRoomPvP;
	import game.net.lobby.request.RequestQuickJoinBasicRoom;
	import game.net.lobby.response.ResponseCreateRoom;
	import game.net.lobby.response.ResponseEndGameRewardResult;
	import game.net.lobby.response.ResponseGameServerAddress;
	import game.net.lobby.response.ResponseHeroicRoomFormation;
	import game.net.lobby.response.ResponseJoinRoomPvP;
	import game.net.lobby.response.ResponseRequestToPlayGame;
	import game.net.lobby.response.ResponseUpdateRoomPvP;
	import game.ui.ModuleID;
	import game.ui.arena.ArenaView;
	import game.ui.challenge.ChallengeModule;
	import game.ui.chat.ChatView;
	import game.ui.dialog.DialogID;
	import game.ui.dialog.dialogs.YesNo;
	import game.ui.global_boss.GlobalBossModule;
	import game.ui.global_boss.GlobalBossView;
	import game.ui.heroic.lobby.HeroicLobbyModule;
	import game.ui.heroic.lobby.HeroicLobbyView;
	import game.ui.heroic.world_map.CampaignData;
	import game.ui.lobby.LobbyModule;
	import game.ui.lobby.LobbyView;
	import game.ui.message.MessageID;

	/**
	 * ...
	 * @author TrungLNM
	 */
	public class GameFlow extends EventDispatcher
	{

		public function GameFlow()
		{
			Game.network.lobby.addEventListener(Server.SERVER_DATA, onLobbyServerResponeHdl);
		}

		public function lock():void
		{
			Game.network.lobby.removeEventListener(Server.SERVER_DATA, onLobbyServerResponeHdl);
		}
		
		public function unlock():void
		{
			Game.network.lobby.removeEventListener(Server.SERVER_DATA, onLobbyServerResponeHdl);
			Game.network.lobby.addEventListener(Server.SERVER_DATA, onLobbyServerResponeHdl);
		}
		
		private var _tempLobbyInfo:LobbyInfo = new LobbyInfo();

		public function continuePlayGame():void
		{
			switch (_tempLobbyInfo.mode)
			{
				case GameMode.PVE_HEROIC:
					Manager.display.to(ModuleID.HEROIC_LOBBY, true, _tempLobbyInfo);
					break;
				case GameMode.PVP_1vs1_FREE:
				case GameMode.PVP_3vs3_FREE:
				case GameMode.PVP_3vs3_MM:
					Manager.display.to(ModuleID.LOBBY, true, _tempLobbyInfo);
					break;
			}
		}

		public function createBasicLobby(info:LobbyInfo):void
		{
			Utility.log("createBasicLobby : " + ((info && info.mode) ? info.mode.name : " null info"));
			
			checkAndSaveTempInfo(info);
			
			// not send to server LobbyRequestType.CREATE_BASIC_LOBBY incase replaying game
			
			if (GameReplayManager.getInstance().isReplaying) 
			{
				saveInfoToUserData();
				return;
			}
			
			//Gui packet tao room dua vao Lobby Info truyen vao
			var lobbyCreate:RequestCreateBasicRoom = new RequestCreateBasicRoom();
			lobbyCreate.strRoomName = _tempLobbyInfo.name;
			lobbyCreate.nGameMode = _tempLobbyInfo.mode.ID;
			lobbyCreate.bIsPrivate = _tempLobbyInfo.privateLobby;
			lobbyCreate.nPlayerAIID = _tempLobbyInfo.challengeID;
			lobbyCreate.nTowerID = _tempLobbyInfo.towerID;
			lobbyCreate.nMissionID = _tempLobbyInfo.missionID;
			lobbyCreate.nCampaignID = _tempLobbyInfo.campaignID;
			lobbyCreate.nDifficultyLevel = _tempLobbyInfo.difficultyLevel;
			lobbyCreate.bOccupied = _tempLobbyInfo.bOccupied;
			
			Game.network.lobby.sendPacket(lobbyCreate);
		}

		public function notifyJoinRoomReady():void
		{
			Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.NOTIFY_JOIN_ROOM_READY));
		}

		public function startLobby():void
		{
			switch (_tempLobbyInfo.mode)
			{
				case GameMode.PVP_1vs1_MM:
				case GameMode.PVP_2vs2_MM:
				case GameMode.PVP_3vs3_MM:
					Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.REQUEST_MATCHING));
					break;
				default:
					Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.START_GAME));
					break;
			}
		}

		public function leaveGame():void
		{
			Utility.log("GameFlow.leaveGame: ");
			Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.LEAVE_GAME));
		}

		public function joinLobbyByID(info:Object):void
		{
			Utility.log("GameFlow.joinLobbyByID : " + info.id + " with mode " + info.mode);
			checkAndSaveTempInfo(info);
			Game.network.lobby.sendPacket(new RequestJoinRoomPvP(_tempLobbyInfo.id, true));
		}

		public function quickJoinLobby(info:LobbyInfo):void
		{
			Utility.log("GameFlow.quickJoinLobby : " + info.id + " with mode " + info.mode);
			checkAndSaveTempInfo(info);
			//Gui packet quick join room dua vao Lobby Info truyen vao
			var packet:RequestQuickJoinBasicRoom = new RequestQuickJoinBasicRoom();
			packet.nModeID = _tempLobbyInfo.mode.ID;
			packet.nCampaignID = _tempLobbyInfo.campaignID;
			packet.nDifficultyLevel = _tempLobbyInfo.difficultyLevel;
			Game.network.lobby.sendPacket(packet);
		}

		public function getCurrentGameMode():GameMode
		{
			if (_tempLobbyInfo) return _tempLobbyInfo.mode;
			else return null;
		}
		
		private function onQuickJoinResult(packet:ResponsePacket):void
		{
			var packetJoin:ResponseJoinRoomPvP = packet as ResponseJoinRoomPvP;
			if (packetJoin)
			{
				Utility.log(" respone --> quick join room result " + packetJoin.errorCode);
				switch (packetJoin.errorCode)
				{
					case 0:
						saveInfoToUserData();
						_tempLobbyInfo.mode = Enum.getEnum(GameMode, packetJoin.mode) as GameMode;
						switch (_tempLobbyInfo.mode)
						{
							case GameMode.PVP_3vs3_MM:
								Manager.display.to(ModuleID.LOBBY, true, _tempLobbyInfo);
								Manager.display.closeAllPopup();

								break;
							case GameMode.PVP_1vs1_MM:
							case GameMode.PVP_2vs2_MM:
								var arenaView:ArenaView = (Manager.module.getModuleByID(ModuleID.ARENA).baseView as ArenaView)
								if (arenaView)
								{
									arenaView.registerSuccessHdl();
								}
								break;
							case GameMode.PVE_HEROIC:
								Manager.display.closeAllPopup();
								Manager.display.to(ModuleID.HEROIC_LOBBY, true, _tempLobbyInfo);
								resetHeroicLobbyFormation();
								break;
						}
						break;
					default:
						//incase quick join fail --> create room instead
						var infoCopy:LobbyInfo = _tempLobbyInfo.clone();
						createBasicLobby(infoCopy);
						break;
				}
			}
		}

		private function onStartRoomResult(packet:ResponsePacket):void
		{
			var packetStart:IntResponsePacket = packet as IntResponsePacket;
			Utility.log(" respone start game errorCode: " + packetStart.value);

			switch (packetStart.value)
			{
				case 0:
					break;
				default:
					displayPlayGameError(packetStart.value)
					break;
			}
		}

		private function onMatchingResult(packet:ResponsePacket):void
		{
			switch (_tempLobbyInfo.mode)
			{
				case GameMode.PVP_1vs1_MM:
					var arenaView:ArenaView = (Manager.module.getModuleByID(ModuleID.ARENA).baseView as ArenaView)
					if (arenaView)
					{
						arenaView.stopMatching();
					}
				case GameMode.PVP_3vs3_MM:
					var lobbyView:LobbyView = (Manager.module.getModuleByID(ModuleID.LOBBY).baseView as LobbyView)
					if (lobbyView)
					{
						lobbyView.stopMatching();
					}
					Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.START_GAME));
					break;
				case GameMode.PVP_2vs2_MM:
					Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.START_GAME));
					break;
			}
		}

		private function onUpdateRoomResult(packet:ResponsePacket):void
		{
			var packetInfo:ResponseUpdateRoomPvP = packet as ResponseUpdateRoomPvP;
			Utility.log(" response --> update info room pvp with num players " + packetInfo.numPlayers);
			var currentMode:GameMode = Game.database.userdata.getGameMode();
			var currentModeData:ModeData = Game.database.userdata.getCurrentModeData();
			switch (currentMode)
			{
				case GameMode.PVE_HEROIC:
					var heroicModeData:ModeDataPVEHeroic = currentModeData as ModeDataPVEHeroic;
					if (heroicModeData)
					{
						heroicModeData.setPlayers(packetInfo.players);
						heroicModeData.campaignStep = packetInfo.heroicCampaignStep;
						heroicModeData.caveID = packetInfo.heroicCampaignID;
						heroicModeData.difficulty = packetInfo.heroicCampaignDifficultyLevel;
						var campaignData:CampaignData = Game.database.gamedata.getHeroicConfig(heroicModeData.caveID);
						if (campaignData && campaignData.missionIDs[heroicModeData.difficulty])
						{
							var missionIDs:Array = campaignData.missionIDs[heroicModeData.difficulty];
							if (missionIDs && missionIDs[heroicModeData.campaignStep])
							{
								heroicModeData.missionID = missionIDs[heroicModeData.campaignStep];
							}
						}
					}
					break;
				//for arena
				case GameMode.PVP_1vs1_MM:
				//for lobby
				case GameMode.PVP_3vs3_MM:
				case GameMode.PVP_2vs2_MM:
				case GameMode.PVP_1vs1_FREE:
				case GameMode.PVP_3vs3_FREE:
				//for tuu lau chien
				case GameMode.PVP_RESOURCE_WAR_PVP:
				case GameMode.PVE_EXPRESS_WAR_PVP:
					Game.database.userdata.lobbyPlayers = packetInfo.players;
					var myID:int = Game.database.userdata.userID;
					var playerObj:LobbyPlayerInfo;
					for (var i:int = 0; i < packetInfo.players.length; i++)
					{
						playerObj = packetInfo.players[i] as LobbyPlayerInfo;
						if (myID == playerObj.id)
						{
							currentModeData.teamID = playerObj.teamIndex;
							currentModeData.roomName = packetInfo.roomName;
							//insert skill for self
							for (var j:int = 0; j < playerObj.characters.length; j++)
							{
								var char:Character = playerObj.characters[j] as Character;
								if (char)
								{
									char.skills = Game.database.userdata.getCharacter(char.ID).skills;
								}
							}
						}
					}

					//update lobby UI
					var lobbyView:LobbyView = Manager.module.getModuleByID(ModuleID.LOBBY).baseView as LobbyView;
					if (lobbyView)
					{
						lobbyView.initUIByMode(Game.database.userdata.getGameMode());
						lobbyView.initRoomName(Game.database.userdata.getCurrentModeData().roomName);
						lobbyView.updateLobby(Game.database.userdata.lobbyPlayers);
					}
					break;
			}
		}

		private function onCreateRoomResult(packet:ResponsePacket):void
		{
			var packetCreate:ResponseCreateRoom = packet as ResponseCreateRoom;
			Utility.log("create room result: " + packetCreate.errorCode);
			switch (packetCreate.errorCode)
			{
				case 0:	//create room success
					saveInfoToUserData();
					_tempLobbyInfo.id = packetCreate.roomID;
					//here save info to global lobby info and do action
					switch (_tempLobbyInfo.mode)
					{
						case GameMode.PVE_WORLD_CAMPAIGN:
						case GameMode.PVE_SHOP_WARRIOR:
						case GameMode.PVP_1vs1_AI:
						case GameMode.PVE_TUTORIAL:
						case GameMode.PVE_GLOBAL_BOSS:
						case GameMode.HEROIC_TOWER:
						case GameMode.PVE_RESOURCE_WAR_NPC:
						case GameMode.PVP_RESOURCE_WAR_PVP:
						case GameMode.PVE_EXPRESS_WAR_PVP:
							Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.START_GAME));
							break;
						case GameMode.PVP_1vs1_FREE:
						case GameMode.PVP_3vs3_FREE:
						case GameMode.PVP_3vs3_MM:
							Manager.display.closeAllPopup();
							Manager.display.closeAllDialog();
							Manager.display.to(ModuleID.LOBBY, true, _tempLobbyInfo);
							break;
						case GameMode.PVE_HEROIC:
							Manager.display.closeAllPopup();
							Manager.display.closeAllDialog();
							Manager.display.to(ModuleID.HEROIC_LOBBY, true, _tempLobbyInfo);
							resetHeroicLobbyFormation();
							break;
						case GameMode.PVP_1vs1_MM:
						case GameMode.PVP_2vs2_MM:
							var view:ArenaView = (Manager.module.getModuleByID(ModuleID.ARENA).baseView as ArenaView)
							if (view)
							{
								view.registerSuccessHdl();
							}
							break;
					}
					break;
				default:
					displayPlayGameError(packetCreate.errorCode);
					break;
			}
		}

		private function displayPlayGameError(errorCode:int):void
		{  			
			/*PLAY_GAME_SUCCESS             	= 0,
			 PLAY_GAME_FAIL                      = 1,
			 PLAY_GAME_WRONG_PLAYERAI_ID         = 2,    //Sai ID cua player muon dau (hoa son luan kiem)
			 PLAY_GAME_WRONG_TIME                = 3,    //Chua toi gio duoc choi mode
			 PLAY_GAME_NOT_ENOUGH_LEVEL          = 4,    //Chua du level
			 PLAY_GAME_LIMIT_FREE_PLAY           = 5,    //Da choi het so lan mien phi (hoa son luan kiem, heroic, pvp3mm)
			 PLAY_GAME_NOT_COOL_DOWN             = 6,    //Chua het thoi gian cool down giua 2 lan choi (hoa son luan kiem)
			 PLAY_GAME_CAN_NOT_CHANGE_ROOM       = 7,    //Khong the vao room (kiem tra ham ChangeRoom trong VPlayer)
			 PLAY_GAME_NO_EMPTY_SLOT             = 8,    //Khong the vao room vi room da full
			 PLAY_GAME_LIMIT_PAY_PLAY            = 9,    //Da het so lan mua game co the (hoa son luan kiem)
			 PLAY_GAME_TOWER_ALREADY_DEAD        = 10,   //Da chet, phai hoi sinh de choi tiep hoac doi qua ngay (Thap Cao Thu, Tower)
			 PLAY_GAME_TOWER_HIGHEST_FLOOR       = 11,   //Da di den tang cao nhat cua Thap (Thap Cao Thu, Tower)
			 PLAY_GAME_TOWER_WRONG_TOWER_ID      = 12,   //Tower ID gui len khong hop le hoac DB cua player khong ton tai Tower ID nay
			 PLAY_GAME_WRONG_MISSION_ID          = 13,   //Mission ID gui len khong hop le(PVE, Heroic)
			 PLAY_GAME_NOT_COMPLETE_PREV_MIS     = 14,   //Chua hoan thanh mission truoc do (PVE)
			 PLAY_GAME_NOT_ENOUGH_LEVEL_MIS      = 15,   //Chua du level de choi mission(PVE)
			 PLAY_GAME_NOT_ENOUGH_AP             = 16,   //Chua du AP de choi mission(PVE)
			 PLAY_GAME_NOT_FIND_ROOM             = 17,   //Khong the tim duoc room thoa man dieu kien cua player muon choi
			 PLAY_GAME_ROOM_IS_PRIVATE           = 18,   //Room khoa, khong the vao vi khong duoc moi
			 PLAY_GAME_START_NOT_HOST            = 19,   //Player start game khong phai host
			 PLAY_GAME_NOT_ENOUGH_PLAYER         = 20,   //Khong the start vi chua du player trong room
			 PLAY_GAME_NOT_FIND_GAME_SERVER      = 21,   //Khong the tim duoc game server
			 PLAY_GAME_BOSS_RESPAWN_COOL_DOWN    = 22,   //Chua het thoi gian cho hoi sinh cua che do BOSS
			 PLAY_GAME_CAN_NOT_MATCH_MAKING      = 23,   //Khong the add room vao danh sach match making (room khong hop le)
			 PLAY_GAME_OUT_OF_TIME_GLOBAL_BOSS	 = 24,	//het gio choi boss the gioi
			 
			 //here interrupt config --> need redefine for all of next errorCode
			 
			 PLAY_GAME_TOWER_IS_AUTO_PLAY        = 25,   //Dang auto play che do tower
			 PLAY_GAME_TRAIN_KUNGFU_OVER_TIMES_TRAIN = 26, // qua so lan train kungfu
			 PLAY_GAME_TRAIN_KUNGFU_OVER_TIMES_TRAINED = 27, // qua so lan dc train kungfu
			 PLAY_GAME_TRAIN_KUNGFU_LEVEL_INVALID = 28, // level cua 2 nguoi tham gian ko hop le
			 PLAY_GAME_LOCKED 					 = 29, // bi khoa (do dang co nguoi chien dau trong mo)
			 PLAY_GAME_SM_OCCUPIED_ANOTHER 		 = 30, // da chiem 1 mo khac
			 PLAY_GAME_SM_PROTECTED				 = 31, // mo duoc bao ve
			 PLAY_GAME_SM_NOT_ROB_OCCUPY_YET 	 = 32, // mo chua the bi chiem hoac cuop
			 PLAY_GAME_SM_NO_ONE_OCCUPY 		 = 33, //  chua ai chiem mo
			 PLAY_GAME_OVER_ROB_TIMES_IN_DAY 	 = 34, // qua so lan cuop trong ngay
			 PLAY_GAME_OVER_ROBBED_TIMES 		 = 35, //  qua so lan bi cuop
			 PLAY_GAME_NOT_ROB_YET 				 = 36, // chua the bi cuop tiep
			 PLAY_GAME_SM_INVALID_GAMEMODE		 = 37, // sai game mode
			 PLAY_GAME_SM_OVER_MAX_LEVEL		 = 38, // qua max level
			 PLAY_GAME_SM_CANT_ROB_OCCUPY_YOURSELF = 39, // ko the tu cuop/chiem cua chinh minh
												 = 40	// tieu xa chua the cuop ???	
			 PLAY_GAME_SM_NOT_ROB_OCCUPY_YET 	 = 41, // chua het thoi gian cho co the chiem mo lan nua
			 */
			switch (errorCode)
			{
				case 5:
					//over limit daily time play
					switch (_tempLobbyInfo.mode)
					{
						case GameMode.HEROIC_TOWER:
							break;
						case GameMode.PVP_1vs1_AI:
							var challenge:ChallengeModule = Manager.module.getModuleByID(ModuleID.CHALLENGE) as ChallengeModule;
							if (challenge)
							{
								challenge.skipLimitPlayDailyHdl();
							}
							break;
						case GameMode.PVP_3vs3_MM:
							break;
					}
					break;
				case 6:
					//not complete time count down
					challenge = Manager.module.getModuleByID(ModuleID.CHALLENGE) as ChallengeModule;
					if (challenge)
					{
						challenge.skipCountDownHdl();
					}
					break;
				case 24:
					var globalModule:GlobalBossModule = Manager.module.getModuleByID(ModuleID.GLOBAL_BOSS) as GlobalBossModule;
					if (globalModule && globalModule.baseView)
					{
						GlobalBossView(globalModule.baseView).showDialogTimesUp();
					}
					break;
				/*default:
				 dialogData.title = "Thông báo";
				 dialogData.message = "Lỗi hệ thống! Mã lỗi: " + e.data.error;
				 dialogData.option = YesNo.YES | YesNo.CLOSE;
				 Manager.display.showDialog(DialogID.YES_NO, null, null, dialogData, Layer.BLOCK_BLACK);
				 break;*/
			}
			Manager.display.showMessageID(MessageID.PLAY_GAME_ERROR_CODE + errorCode - 1);
		}
		
		private function onJoinRoomByIDResult(packet:IntResponsePacket):void
		{
			Utility.log("onResponseJoinRoomByID : " + packet.value);
			switch (packet.value)
			{
				case ErrorCode.SUCCESS:
					saveInfoToUserData();
					switch (_tempLobbyInfo.mode)
					{
						case GameMode.PVE_HEROIC:
							Manager.display.closeAllPopup();
							Manager.display.closeAllDialog();
							Manager.display.to(ModuleID.HEROIC_LOBBY, true, _tempLobbyInfo);
							resetHeroicLobbyFormation();
							break;
						case GameMode.PVP_1vs1_FREE:
						case GameMode.PVP_3vs3_FREE:
						case GameMode.PVP_3vs3_MM:
							Manager.display.closeAllPopup();
							Manager.display.closeAllDialog();
							Manager.display.to(ModuleID.LOBBY, true, _tempLobbyInfo);
							break;
						default:
							break;
					}
					break;
				case 4: // Chua du level
				case 15: // Chua du level
					//Manager.display.showMessageID(111);
					displayPlayGameError(packet.value);
					break;
				case 5: // Da choi het so lan mien phi (hoa son luan kiem, heroic, pvp3mm)
					switch (_tempLobbyInfo.mode)
					{
						case GameMode.PVE_HEROIC:
							var campaignData:CampaignData = Game.database.gamedata.getHeroicConfig(_tempLobbyInfo.campaignID);

							Manager.display.showDialog(DialogID.YES_NO,
									function(data:Object):void
									{
										Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.HEROIC_BUY_PLAYING_TIMES, data.id));
									}
									, null,
									{
										title: "Thông báo",
										message: "Bạn đã hết lượt tham gia. Mua thêm với giá " + campaignData.playingCost + " vàng?", option:YesNo.YES|YesNo.CLOSE|YesNo.NO, id:campaignData.campaignID
									},
									Layer.BLOCK_BLACK);
							break;
						default:
							break;
					}
					break;
				case 8: // Full room
					//Manager.display.showMessageID(104);
					displayPlayGameError(packet.value);
					break;
				case 9: // Het luot choi
					//Manager.display.showMessageID(105);
					displayPlayGameError(packet.value);
					break;
				case 16: // Khong du AP
					//Manager.display.showMessageID(112);
					displayPlayGameError(packet.value);
					break;
				default:
					displayPlayGameError(packet.value);
					break;
			}
		}

		private function onAcceptHdl(data:Object):void
		{
			var packet:ResponseRequestToPlayGame = data.packet as ResponseRequestToPlayGame;
			if (packet)
			{
				var lobbyInfo:LobbyInfo = new LobbyInfo();
				lobbyInfo.mode = packet.mode;
				lobbyInfo.id = packet.roomID;
				switch (lobbyInfo.mode)
				{
					case GameMode.PVE_HEROIC:
						lobbyInfo.backModule = ModuleID.HEROIC_MAP;
						break;
					case GameMode.PVP_1vs1_FREE:
					case GameMode.PVP_3vs3_FREE:
					case GameMode.PVP_3vs3_MM:
						lobbyInfo.backModule = ModuleID.HOME;
						break;
				}
				joinLobbyByID(lobbyInfo);
			}
		}

		//Sau khi tao room, join room thanh cong thi save lobbyInfo local vao userdata

		public function onLeaveGameResult(errorCode:int = 0):void
		{
			Utility.log("leave lobby response code result is: " + errorCode);

			switch (errorCode)
			{
				case 0:
					var currentModeData:ModeData = (Game.database.userdata.getCurrentModeData());
					var backModuleID:ModuleID = currentModeData ? currentModeData.backModuleID : null;
					if (backModuleID)
					{
						switch (backModuleID)
						{
							case ModuleID.WORLD_MAP:
								Manager.display.to(ModuleID.WORLD_MAP, false, true);
								break;
							case ModuleID.SHOP:
								Manager.display.to(ModuleID.HOME, false, {module: ModuleID.SHOP});
								break;
							case ModuleID.GLOBAL_BOSS:
								if (Game.database.userdata.getCurrentModeData().result)
								{
									Manager.display.to(ModuleID.HOME);
									Manager.display.showModule(ModuleID.SELECT_GLOBAL_BOSS, new Point(0, 0), LayerManager.LAYER_POPUP, "top_left", Layer.BLOCK_BLACK);
								}
								else
								{
									Game.database.userdata.globalBossData.setReviveCountDown(Game.database.gamedata.getGlobalBossConfig().defaultReviveTime);
									Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.GLOBAL_BOSS_START_REVIVE_COUNT_DOWN, (ModeDataPvE)(Game.database.userdata.getCurrentModeData()).missionID));
							
									Manager.display.to(ModuleID.GLOBAL_BOSS, false, {missionID: ModeDataPvE(Game.database.userdata.getCurrentModeData()).missionID});
								}
								break;
							case ModuleID.CHALLENGE:
								Manager.display.to(ModuleID.HOME);
								setTimeout(Manager.display.showModule, 600, ModuleID.CHALLENGE, new Point(0, 0), LayerManager.LAYER_POPUP, "top_left", Layer.BLOCK_BLACK);
								break;
							case ModuleID.ARENA:
								Manager.display.to(ModuleID.HOME);
								Manager.display.showModule(ModuleID.ARENA, new Point(0, 0), LayerManager.LAYER_POPUP);
								break;
							case ModuleID.HEROIC_MAP:
								Manager.display.to(ModuleID.HEROIC_MAP);
								break;
							case ModuleID.HEROIC_TOWER:
								Manager.display.to(ModuleID.HEROIC_TOWER);
								break;
							case ModuleID.TUULAUCHIEN:
								Manager.display.to(ModuleID.TUULAUCHIEN);
								break;
							case ModuleID.EXPRESS:
								Manager.display.to(ModuleID.EXPRESS);
								break;
							case ModuleID.HOME:
							default:
								Manager.display.to(ModuleID.HOME);
								break;
						}
					}
					else
					{
						Manager.display.to(ModuleID.HOME);
					}
					break;
				default:
					//leave lobby fall khi nao xay ra
					Utility.log("leave lobby fail with errorcode: " + errorCode);
					break;
			}
		}

		private function onEndGameResult(gameResult:Boolean):void
		{
			Utility.log("game end, result=" + gameResult);
			Game.database.userdata.getCurrentModeData().setResult(gameResult);
			dispatchEvent(new EventEx(Event.COMPLETE, { type: FlowActionEnum.END_GAME_RESULT, result : gameResult,
						autoReturn: _tempLobbyInfo.mode == GameMode.PVP_3vs3_MM
									|| _tempLobbyInfo.mode == GameMode.PVP_2vs2_MM
									|| _tempLobbyInfo.mode == GameMode.PVP_1vs1_FREE
									|| _tempLobbyInfo.mode == GameMode.PVP_3vs3_FREE }));

			if (_tempLobbyInfo && ((_tempLobbyInfo.mode) == GameMode.PVE_GLOBAL_BOSS))
			{
				Game.database.userdata.globalBossData.setIsReviveCountDown(!gameResult);
			}
			
			if (_tempLobbyInfo && _tempLobbyInfo.mode == GameMode.PVP_RESOURCE_WAR_PVP && !_tempLobbyInfo.bOccupied && gameResult)
			{
				Game.database.userdata.timeRemainAttackResourceInfo = Game.database.gamedata.getConfigData(GameConfigID.TIME_FROZEN_FOR_EACH_ACTION_ATTACK_RESOURCE) as int;
			}
		}

		private function onEndGameRewardResult(packet:ResponseEndGameRewardResult):void
		{
			switch (packet.mode)
			{
				case GameMode.PVE_WORLD_CAMPAIGN:
				case GameMode.PVE_SHOP_WARRIOR:
				case GameMode.PVE_RESOURCE_WAR_NPC:
					Utility.log("end game PVE reward result: " + packet.result);
					var modeDataPvE:ModeDataPvE = Game.database.userdata.getCurrentModeData() as ModeDataPvE;
					modeDataPvE.numStars = packet.numStars;
					modeDataPvE.fixReward = packet.fixReward;
					modeDataPvE.randomReward = packet.randomReward;
					break;
				case GameMode.HEROIC_TOWER:
					var modeData:ModeDataHeroicTower = Game.database.userdata.getCurrentModeData() as ModeDataHeroicTower;
					if (modeData != null)
					{
						modeData.fixReward = packet.fixReward;
						modeData.randomReward = packet.randomReward;
					}
					break;
				case GameMode.PVE_GLOBAL_BOSS:
					Utility.log("end game PVE reward result: " + packet.result);
					modeDataPvE = Game.database.userdata.getCurrentModeData() as ModeDataPvE;
					modeDataPvE.numStars = packet.numStars;
					modeDataPvE.fixReward = packet.fixReward;
					modeDataPvE.randomReward = packet.randomReward;
					//Game.database.userdata.globalBossData.rewards = modeDataPvE.fixReward;
					if (Game.database.userdata.globalBossData.rewards != null)
					{
						Game.database.userdata.globalBossData.rewards.concat(modeDataPvE.randomReward);
					}
					break;
				case GameMode.PVP_1vs1_AI:
				case GameMode.PVP_1vs1_MM:
				case GameMode.PVP_3vs3_MM:
				case GameMode.PVP_2vs2_MM:
				case GameMode.PVP_1vs1_FREE:
				case GameMode.PVP_3vs3_FREE:
				case GameMode.PVP_RESOURCE_WAR_PVP:
				case GameMode.PVE_EXPRESS_WAR_PVP:
					Utility.log("end game PVP reward result: " + packet.result);
					var modeDataPvP:ModeDataPvP = Game.database.userdata.getModeData(packet.mode) as ModeDataPvP;

					//modeDataPvP.result = packet.result;
					modeDataPvP.fixReward = packet.fixReward;
					modeDataPvP.randomReward = packet.randomReward;

					modeDataPvP.oldRank = packet.oldRank;
					modeDataPvP.newRank = packet.newRank;

					modeDataPvP.eloScore = packet.eloScore;
					modeDataPvP.honorScore = packet.honorScore;

					if (packet.fixReward.length > 0)
					{
						var chat:ChatView = Manager.module.getModuleByID(ModuleID.CHAT).baseView as ChatView;
						if (chat != null)
						{
							var chatMessage:String = "Bạn nhận được: ";
							for (var i:int = 0; i < packet.fixReward.length; ++i)
							{
								var itemData:ItemInfo = packet.fixReward[i];
								if (itemData != null)
								{
									var itemXML:ItemXML = ItemFactory.buildItemConfig(itemData.type, itemData.id) as ItemXML;
									if (itemXML != null)
									{
										chatMessage += (i == 0 ? "" : ", ") + itemData.quantity + " " + itemXML.name;
									}
								}
							}
							chat.updateChatBox(ChatType.CHAT_ERROR, 0, "", chatMessage);
						}
					}
					break;
			}
		}
		/**
		 * 
		 * @param	packet: packet is null in replaying mode
		 */
		public function onStartLoadingResult(packet:ResponsePacket = null):void
		{
			if (packet)
			{
				var packetServerAddress:ResponseGameServerAddress = packet as ResponseGameServerAddress;
				Game.database.userdata.gameServerAddress.reset(packetServerAddress.IP, packetServerAddress.port);
			}
			switch (Game.database.userdata.getGameMode())
			{
				case GameMode.PVE_WORLD_CAMPAIGN:
				case GameMode.PVE_SHOP_WARRIOR:
				case GameMode.PVE_GLOBAL_BOSS:
				case GameMode.PVE_HEROIC:
				case GameMode.HEROIC_TOWER:
				case GameMode.PVE_RESOURCE_WAR_NPC:		
					if (!GameReplayManager.getInstance().isReplaying)
					{
						Game.database.userdata.getCurrentModeData().teamID = TeamID.LEFT;
					}
					else
					{
						Game.database.userdata.getCurrentModeData().teamID = GameReplayManager.getInstance().getTeamID();
					}
					
					if (_tempLobbyInfo.missionID > 0)
					{
						(ModeDataPvE)(Game.database.userdata.getCurrentModeData()).missionID = _tempLobbyInfo.missionID;
					}
					break;
				case GameMode.PVP_1vs1_AI:
				case GameMode.PVP_RESOURCE_WAR_PVP:
				case GameMode.PVE_EXPRESS_WAR_PVP:
					if (!GameReplayManager.getInstance().isReplaying)
					{
						Game.database.userdata.getCurrentModeData().teamID = TeamID.LEFT;
					}
					else
					{
						Game.database.userdata.getCurrentModeData().teamID = GameReplayManager.getInstance().getTeamID();
					}
					
					/*if (_tempLobbyInfo.missionID > 0)
					{
						(ModeDataPvE)(Game.database.userdata.getCurrentModeData()).missionID = _tempLobbyInfo.missionID;
					}*/
					break;
				case GameMode.PVP_1vs1_MM:
				case GameMode.PVP_2vs2_MM:
					var view:ArenaView = (Manager.module.getModuleByID(ModuleID.ARENA).baseView as ArenaView)
					if (view)
					{
						view.registerMov.startSuccess(true);
					}
					break;
			}
			Game.database.userdata.getCurrentModeData().backModuleID = _tempLobbyInfo.backModule;

			Manager.display.closeAllPopup();
			Manager.display.closeAllDialog();
			Manager.display.to(ModuleID.LOADING, true, _tempLobbyInfo);
		}

		private function checkAndSaveTempInfo(info:Object):void
		{
			//reset before used again
			_tempLobbyInfo.reset();

			_tempLobbyInfo.mode = (info.mode && info.mode is GameMode) ? info.mode : null;
			_tempLobbyInfo.id = (info.id && info.id is int) ? info.id : -1;
			_tempLobbyInfo.name = (info.name && info.name is String) ? info.name : "";
			_tempLobbyInfo.privateLobby = (info.privateLobby && info.privateLobby is Boolean) ? info.privateLobby : false;
			_tempLobbyInfo.missionID = (info.missionID && info.missionID is int) ? info.missionID : -1;
			_tempLobbyInfo.backModule = (info.backModule && info.backModule is ModuleID) ? info.backModule : null;
			_tempLobbyInfo.challengeID = (info.challengeID && info.challengeID is int) ? info.challengeID : -1;
			_tempLobbyInfo.towerID = (info.towerID && info.towerID is int) ? info.towerID : -1;
			_tempLobbyInfo.campaignID = (info.campaignID && info.campaignID is int) ? info.campaignID : -1;
			_tempLobbyInfo.difficultyLevel = (info.difficultyLevel is int) ? info.difficultyLevel : -1;
			_tempLobbyInfo.bOccupied = (info.bOccupied && info.bOccupied is Boolean) ? info.bOccupied : false;
		}

		private function saveInfoToUserData():void
		{
			Game.database.userdata.setGameMode(_tempLobbyInfo.mode);
		}

		private function resetHeroicLobbyFormation():void
		{
			var heroicLobbyModule:HeroicLobbyModule = Manager.module.getModuleByID(ModuleID.HEROIC_LOBBY) as HeroicLobbyModule;
			if (heroicLobbyModule)
			{
				heroicLobbyModule.resetFormation();
			}
		}

		private function onLobbyServerResponeHdl(e:EventEx):void
		{
			var packet:ResponsePacket = e.data as ResponsePacket;
			switch (packet.type)
			{
				case LobbyResponseType.CREATE_ROOM:
					onCreateRoomResult(packet);
					break;
				case LobbyResponseType.LOBBY_CHANGE_HOST_RS:
					onChangeHostResult(packet as ResponseChangeRoomHost);
					break;
				case LobbyResponseType.UPDATE_INFO_ROOM_PVP:
					onUpdateRoomResult(packet);
					break;
				case LobbyResponseType.START_GAME_RESULT:
					onStartRoomResult(packet);
					break;
				case LobbyResponseType.MATCHING_RESULT:
					onMatchingResult(packet);
					break;
				case LobbyResponseType.COUNT_MATCHING:
					onCountMatching(packet as IntResponsePacket);
					break;
				case LobbyResponseType.START_RESOURCE_LOADING:
					onStartLoadingResult(packet as ResponseGameServerAddress);
					break;
				case LobbyResponseType.END_GAME_REWARD_RESULT:
					onEndGameRewardResult(packet as ResponseEndGameRewardResult);
					break;
				case LobbyResponseType.END_GAME_RESULT:
					var winTeam:int = (packet as IntResponsePacket).value;
					var result:Boolean = winTeam == Game.database.userdata.getCurrentModeData().teamID;
					onEndGameResult(result);
					break;
				case LobbyResponseType.LEAVE_GAME_RESULT:
					onLeaveGameResult((packet as IntResponsePacket).value);
					break;
				case LobbyResponseType.QUICK_JOIN_ROOM_RESULT:
					onQuickJoinResult(packet);
					break;
				case LobbyResponseType.JOIN_ROOM_BY_ID_RESULT:
					onJoinRoomByIDResult(packet as IntResponsePacket);
					break;
				case LobbyResponseType.RESPONSE_END_GAME_CONTINUE:
					continuePlayGame();
					break;
				case LobbyResponseType.HEROIC_LOBBY_FORMATION:
					var modeData:ModeDataPVEHeroic = Game.database.userdata.getModeData(GameMode.PVE_HEROIC) as ModeDataPVEHeroic;
					modeData.formationIndex = ResponseHeroicRoomFormation(packet).formationIndex;
					modeData.formationTypeID = ResponseHeroicRoomFormation(packet).formationTypeID;
					modeData.formationTypeLevel = ResponseHeroicRoomFormation(packet).formationTypeLevel;
					modeData.autoStart = ResponseHeroicRoomFormation(packet).autoStart;

					var heroicLobbyView:HeroicLobbyView = Manager.module.getModuleByID(ModuleID.HEROIC_LOBBY).baseView as HeroicLobbyView;
					if (heroicLobbyView)
					{
						heroicLobbyView.update();
					}
					break;
				case LobbyResponseType.HEROIC_BROADCAST_AUTO_START:
					var data:BooleanResponsePacket = packet as BooleanResponsePacket;

					Utility.log("Received Heroic BroadCast Auto Start: " + data.result);

					heroicLobbyView = Manager.module.getModuleByID(ModuleID.HEROIC_LOBBY).baseView as HeroicLobbyView;
					if (heroicLobbyView)
					{
						heroicLobbyView.setAutoStart(data.result);
					}
					break;
				case LobbyResponseType.WRONG_LOBBY_STATE_BACK:
					//move out to home module
					Utility.log(">>> Lobby server response: wrong lobby state must back");
					Manager.display.closeAllPopup();
					Manager.display.closeAllDialog();
					Manager.display.to(ModuleID.HOME);
					break;
				case LobbyResponseType.WRONG_LOBBY_STATE_LOG:
					Utility.log(">>> Lobby server response: wrong lobby state log print");
					break;
				case LobbyResponseType.REQUEST_TO_PLAY_GAME:
					//Module nao co the nghe su kien moi thi them vao day
					// not process for GameMode.PVP_TRAINING, incase gamemode == GameMode.PVP_TRAINING, the process is put in onLobbyServerData() of UserData class
					if ((Manager.display.getCurrentModule() == ModuleID.HOME
							|| Manager.display.getCurrentModule() == ModuleID.WORLD_MAP
							|| Manager.display.getCurrentModule() == ModuleID.HEROIC_MAP) &&  ResponseRequestToPlayGame(packet).mode != GameMode.PVP_TRAINING
							)
					{
						if(Game.database.gamedata.enableReceiveInvitation)
						{
							var packetRequestToPlay:ResponseRequestToPlayGame = packet as ResponseRequestToPlayGame;
							//show dialog invite to play game
							var currentLevel:int = Game.database.userdata.level;
							if (packetRequestToPlay && currentLevel > 20)
							{
								Manager.display.showDialog(DialogID.YES_NO, onAcceptHdl, null,
										{type     : DialogEventType.INVITE_TO_PLAY_GAME_YN,
											packet: packetRequestToPlay,
											option: YesNo.YES | YesNo.NO | YesNo.CLOSE});
							}
						}
					}
					break;
			}
		}

		private function onCountMatching(packet:IntResponsePacket):void
		{
			Utility.log("onCountMatching:" + packet.value);
			switch (packet.value)
			{
				case 0://success
					break;
				case 1://fail
					break;
				case 42://PVP 2vs2 tổng số lượng người tham gia bắt cặp bị lẻ => dư ra 1 người;
					Manager.display.showMessageID(162);
					break;
			}
		}

		private function onChangeHostResult(packet:ResponseChangeRoomHost):void
		{
			Logger.log("onChangeHostResult > " + packet.errorCode + " , new host: " + packet.name);

			var lobby:LobbyModule = Manager.module.getModuleByID(ModuleID.LOBBY) as LobbyModule;

			switch (packet.errorCode)
			{
				case 0://success
					Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.NOTIFY_JOIN_ROOM_READY));
					Manager.display.showMessage("Chủ phòng đã được chuyển cho: " + packet.name);
					break;
				case 1:// fail
				case 2://
					Manager.display.showMessage("Chuyển chủ phòng thất bại.");
					lobby.leaveGame();
					break;
				case 3: //CHANGE_HOST_FAIL_WRONG_MODE
					Manager.display.showMessage("Chuyển chủ phòng thất bại do sai chế độ chơi.");
					lobby.leaveGame();
					break;
				case 4: //CHANGE_HOST_FAIL_NOT_FULL_ROOM
					lobby.leaveGame();
					break;
				case 5: //CHANGE_HOST_FAIL_NOT_HOST
					Manager.display.showMessage("Chuyển chủ phòng thất bại.Không phải chủ phòng.");
					lobby.leaveGame();
					break;
				default:
					Manager.display.showMessage("Lỗi không xác định.");
					lobby.leaveGame();
					break;
			}
		}
	}
}