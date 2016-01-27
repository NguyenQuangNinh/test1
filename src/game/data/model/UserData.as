package game.data.model
{

	import core.Manager;
	import core.display.layer.Layer;
	import core.display.layer.LayerManager;
	import core.event.EventEx;
	import core.util.Enum;
	import core.util.Utility;

	import game.data.xml.RewardXML;
	import game.enum.ItemType;
	import game.net.lobby.request.RequestBasePacket;
	import game.net.lobby.request.RequestJoinRoomPvP;
	import game.net.lobby.response.ResponseGuOwnGuildInfo;
	import game.net.lobby.response.ResponseRequestToPlayGame;
	import game.net.RequestPacket;
	import game.ui.dialog.dialogs.YesNo;

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	import flash.utils.Dictionary;

	import game.Game;
	import game.data.gamemode.ModeData;
	import game.data.vo.formation.FormationStat;
	import game.data.xml.DataType;
	import game.data.xml.TutorialXML;
	import game.enum.FormationType;
	import game.enum.GameConfigID;
	import game.enum.GameMode;
	import game.enum.PlayerAttributeID;
	import game.net.IntRequestPacket;
	import game.net.IntResponsePacket;
	import game.net.ResponsePacket;
	import game.net.Server;
	import game.net.StringResponsePacket;
	import game.net.lobby.LobbyRequestType;
	import game.net.lobby.LobbyResponseType;
	import game.net.lobby.response.ResponseCharacterInfo;
	import game.net.lobby.response.ResponseCharacterInfoByID;
	import game.net.lobby.response.ResponseCharacterInfoList;
	import game.net.lobby.response.ResponseDailyTaskInfo;
	import game.net.lobby.response.ResponseFormation;
	import game.net.lobby.response.ResponseGameLevelUp;
	import game.net.lobby.response.ResponseGlobalBossMissionInfo;
	import game.net.lobby.response.ResponseGlobalBossReward;
	import game.net.lobby.response.ResponseGuInvite;
	import game.net.lobby.response.ResponseInboxMailRequest;
	import game.net.lobby.response.ResponseInventoryInfo;
	import game.net.lobby.response.ResponseItemInventory;
	import game.net.lobby.response.ResponseListFormationType;
	import game.net.lobby.response.ResponseLobbyNotifyClient;
	import game.net.lobby.response.ResponsePlayerInfo;
	import game.net.lobby.response.ResponsePlayerInfoAttribute;
	import game.net.lobby.response.ResponseRequestFriendList;
	import game.net.lobby.response.ResponseTutorialFinishedSteps;
	import game.ui.ModuleID;
	import game.ui.dialog.DialogID;
	import game.ui.hud.HUDButtonID;
	import game.ui.hud.HUDModule;
	import game.utility.GameUtil;
	import game.utility.TimerEx;

	public class UserData extends EventDispatcher
	{
		/*
		 * Khai báo biến static const
		 */
		public static const INFO_CHANGE:String = "infoChange";
		public static const UPDATE_PLAYER_INFO:String = "updatePlayerInfo";
		public static const GAME_LEVEL_UP:String = "gameLevelUp";
		public static const UPDATE_CHARACTER_LIST:String = "update_character_list";
		public static const UPDATE_FORMATION:String = "update_formation";
		static public const UPDATE_CHARACTER_INFO:String = "GameDataUpdateCharacterInfo";
		static public const GOLD_CHANGED:String = "gold_changed";
		static public const INVENTORY_INFO:String = "inventory_info";
		static public const GET_MAIL_BOX:String = "get_mail_box";
		static public const REQUEST_FRIEND_LIST:String = "request_friend_list";
		static public const LOBBY_NOTIFY_CLIENT:String = "lobby_notify_client";
		public static const BATTLE_POINT_CHANGED:String = "battlePointChanged";
		public static const XU_CHANGED:String = "xuChanged";
		static public const UPDATE_DAILY_TASK:String = "updateDailyTask";
		static public const GLOBAL_BOSS_BUFF_CHANGED:String = "globalBossBuffChanged";

		/*
		 * Khai báo các thuộc tính của UserData
		 */

		public function UserData():void
		{
			var gameModes:Array = Enum.getAll(GameMode);
			for each (var gameMode:GameMode in gameModes)
			{
				if (gameMode != null)
				{
					gameModeDatas[gameMode.ID] = new gameMode.dataClass();
				}
			}
			Game.network.lobby.addEventListener(Server.SERVER_DATA, onLobbyServerData);
		}
		public var userID:int;
		public var accountName:String = "";
		public var playerName:String = "";
		public var level:int;
		public var guildLevel:int;
		public var lastLevel:int;
		public var maxLevel:int;
		public var currentExp:int;
		public var expToNextLevel:int;
		public var xu:int;
		public var honor:int;
		public var actionPoint:int;
		public var maxActionPoint:int;
		public var fomationHP:int;
		public var maxFomationHP:int;
		public var selectedCharacter:Character;
		public var characterMaxSlot:int; // NOTE : co the chua phan tu null
		public var formation:Array = [];
		public var loginTime:Number = -1;
		public var serverTimeDifference:Number = 0;
		public var secretMerchantEventID:int = -1;
		public var arrFormationType:Array = [];
		public var characters:Array = [];
		public var gameServerAddress:ServerAddress = new ServerAddress();
		public var lobbyPlayers:Array = [];
		public var globalBossData:GlobalBossData = new GlobalBossData();
		public var formationStat:FormationStat = new FormationStat();
		public var numNormalFormationSlot:int;
		public var numLegendFormationSlot:int;
		public var nAlchemyInDay:int;
		public var isWaitingLevelUpEffect:Boolean;
		public var vip:int;
		public var healedAP:int;
		public var luckyGiftXu:int;
		public var luckyGiftTime:int;
		public var soulExchangePoint:int;
		public var consumeXuInMonth:int; //Mail data
		public var arrMailData:Array = new Array();
		public var finishedMissions:Dictionary;
		public var isEXPTransfer:Boolean = false;
		public var attendanceChecked:Boolean;
		public var attendanceTime:int;
		public var remainTimeWaitAlchemy:int;
		public var elapsedTimeWaitAP:int;
		public var sweepingMissionID:int; // Thoi gian can quet da troi qua
		public var elapsedSweepingTime:int; // Tong so lan can quet ma user da chon

		//public var numAttackResourcePerDay:int;	//so lan cuop mo da thuc hien trong ngay	
		
		//array id of filter character for quest transporter		
		public var giveAPCount:int;
		public var receiveAPCount:int;
		public var maxSweepTimes:int;
		public var questTransportFilterID:Array = []; // NOTE : co the chua phan tu null
		public var formationChallengeTemp:Array = []; // NOTE : co the chua phan tu null
		public var formationChallenge:Array = [];
		public var nStatusGiftOnline:int;
		public var nEventCurrentPaymentEventID:int;
		public var nEventCurrentConsumeEventID:int;
		public var nFirstChargeState:int;
		public var nAttendanceState:int;
		public var isFirstTutorial:Boolean = false;
		public var responseNotify:Dictionary = new Dictionary();
		public var quests:Array = [];
		public var worldBossEnable:Boolean = false;
		public var dailyTasks:Array = [];
		public var nDailyQuestRefresh:int;
		public var nTransportRefresh:int;
		public var guildId:int;
		public var guildMemberType:int;
		public var currDigTreasure:int;
		public var nKungfuTrainHostRemainTime:int;
		public var nKungfuTrainPartnerRemainTime:int;
		public var numOfRespawnBoss:int;
		public var numUseMysticBoxes:Array;
		public var enableTreasure:Boolean;
		public var enableMysticBox:Boolean;
		public var enableDice:Boolean;
		public var enableShopDiscount:Boolean;
		public var enableVIPPromotion:Boolean;
		public var mysticLuckPoint:int = 0;
		public var numBuyUseMysticBox:int = 0;

		private var gameMode:GameMode;
		private var gameModeDatas:Array = [];
		private var gold:int;
		private var finishTutorialIDs:Array = [];
		
		public var timeRemainAttackResourceInfo: int = 0;
		
		private var formations:Dictionary = new Dictionary();

		public var guildInfo:ResponseGuOwnGuildInfo;

		/*
		 * Khai báo các hàm public
		 */
		//Lay danh sach mang formation challenge ko co phan tu null
		private var APTimerID:int = -1;

		//Lay danh sach mang formation challenge ko co phan tu null

		public function get mainCharacter():Character
		{
			for each (var character:Character in characters)
			{
				if (character && character.isMainCharacter)
				{
					return character;
				}
			}
			return null;
		}
		
		public function leaveGuild():void
		{
			guildId = -1;
			guildInfo = null;
		}
		
		public function get timeNow():Number
		{
			return new Date().getTime() + serverTimeDifference;
		}

		public function getFormationChallenge():Array
		{
			var result:Array = [];
			for (var i:int = 0; i < formationChallenge.length; i++)
			{
				if (formationChallenge[i] != null)
				{
					result.push(formationChallenge[i]);
				}
			}
			return result;
		}

		public function getFormationChallengeTemp():Array
		{
			var result:Array = [];
			for (var i:int = 0; i < formationChallengeTemp.length; i++)
			{
				if (formationChallengeTemp[i] != null)
				{
					result.push(formationChallengeTemp[i]);
				}
			}
			return result;
		}

		public function getGameMode():GameMode
		{
			return gameMode;
		}

		public function setGameMode(mode:GameMode):void
		{
			gameMode = mode;
		}

		public function getCurrentModeData():ModeData
		{
			return getModeData(gameMode);
		}

		public function getModeData(mode:GameMode):ModeData
		{
			if (mode != null)
			{
				return gameModeDatas[mode.ID];
			}
			return null;
		}

		public function getGold():int
		{
			return gold;
		}

		public function setGold(value:int):void
		{
			if (gold != value)
			{
				gold = value;
				dispatchEvent(new Event(GOLD_CHANGED, true));
			}
		}

		public function haveCharacterWithXMLID(ID:int):Boolean
		{
			var result:Character;
			for each (var character:Character in characters)
			{
				if (character != null && character.xmlID == ID)
				{
					result = character;
					break;
				}
			}

			return result != null;
		}

		public function haveCharacter(ID:int):Boolean
		{
			return getCharacter(ID) != null;
		}

		public function getCharacter(ID:int):Character
		{
			var result:Character;
			for each (var character:Character in characters)
			{
				if (character != null && character.ID == ID)
				{
					result = character;
					break;
				}
			}

			return result;
		}

		public function removeCharacter(ID:int):void
		{
			var character:Character = getCharacter(ID);
			if (character != null)
			{
				var index:int = characters.indexOf(character);
				if (index > -1)
				{
					characters.splice(index, 1);
				}
				else
				{
					index = formation.indexOf(character);
					if (index > -1)
					{
						formation.splice(index, 1);
					}
				}
			}
		}

		public function getNumFreeSlots():int
		{
			return characterMaxSlot - characters.length;
		}

		public function checkIsInFormationChallengeTemp(id:int):Boolean
		{
			for each (var character:Character in formationChallengeTemp)
			{
				if (character && character.ID == id)
				{
					return true;
				}
			}

			return false;
		}

		public function getFormationTypeByID(formationTypeID:int):Object
		{
			if (arrFormationType == null)
			{
				return null;
			}
			for each (var obj:Object in arrFormationType)
			{
				if (obj.id == formationTypeID)
				{
					return obj;
				}
			}
			return null;
		}

		public function updateFinishTutorialID(value:int):void
		{
			if (Utilities.getElementIndex(finishTutorialIDs, value) == -1)
			{
				finishTutorialIDs.push(value);
			}
		}

		public function getFinishTutorialIDs():Array
		{
			return finishTutorialIDs;
		}

		public function getFinishTutorialScenes():Array
		{
			var finishTutorialScenes:Array = [];
			var tutorialXML:TutorialXML;
			for each (var id:int in finishTutorialIDs)
			{
				tutorialXML = Game.database.gamedata.getData(DataType.TUTORIAL, id) as TutorialXML;
				if (tutorialXML)
				{
					finishTutorialScenes.push(tutorialXML.sceneID);
				}
			}

			finishTutorialScenes.sort(Array.NUMERIC);

			return finishTutorialScenes;
		}

		/*
		 * Khai báo các hàm private
		 */

		public function dismissNotify(type:int):void
		{
			if (responseNotify[type] != null)
			{
				delete responseNotify[type];
			}

		}

		public function checkNotify(type:int):Object
		{
			return responseNotify[type];
		}

		public function setFormation(type:FormationType, formation:Array):void
		{
			formations[type] = formation;
		}

		public function getFormation(type:FormationType):Array
		{
			return formations[type];
		}

		public function getRemainTimeRegainAP():int
		{
			return TimerEx.getRemainTime(APTimerID);
		}

		private function inviteToGuildCancelHdl(data:Object):void
		{
			Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.GU_INVITE_REJECT, data.sender));
		}

		private function inviteToGuildOkHdl(data:Object):void
		{
			var packet:RequestBasePacket = new RequestBasePacket(LobbyRequestType.GU_INVITE_ACCEPT);
			packet.ba.writeInt(data.guildId);
			packet.ba.writeInt(data.sender);
			Game.network.lobby.sendPacket(packet);
		}

		private function onResponseGlobalBossMissionInfo(packet:ResponseGlobalBossMissionInfo):void
		{
			globalBossData.currentGoldBuff = packet.currentGoldBuff;
			globalBossData.maxGoldBuff = packet.maxGoldBuff;
			globalBossData.currentXuBuff = packet.currentXuBuff;
			globalBossData.maxXuBuff = packet.maxXuBuff;
			dispatchEvent(new Event(GLOBAL_BOSS_BUFF_CHANGED));
		}

		private function onResponseGlobalBossReward(packet:ResponseGlobalBossReward):void
		{
			if (Game.database.userdata.globalBossData)
			{
				var missionId:int = Game.database.userdata.globalBossData.currentMissionID;
				Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.GLOBAL_BOSS_TOP_DMG, missionId as int));
			}
			
			var rewardItems:Array = [];
			var ids:Array = [];
			for (var i:int = 0; i < packet.rewards.length; i++)
			{
				ids.push(packet.rewards[i].id);
			}
			globalBossData.rewards = GameUtil.getItemRewardsByIDs(ids);

			var rewardXML:RewardXML = new RewardXML();
			rewardXML.itemID = 0;
			rewardXML.quantity = packet.bonusGold;
			rewardXML.type = ItemType.GOLD;
			rewardXML.type = ItemType.GOLD;
			rewardXML.rate = 0;
			rewardXML.requirement = 0;
			globalBossData.rewards.push(rewardXML);

			showRewardPopup();
		}

		private function showRewardPopup():void
		{
			//if ((Game.database.userdata.globalBossData.rewards && Game.database.userdata.globalBossData.rewards.length > 0) || (Game.database.userdata.globalBossData.timeUp == true))
			//{
			var obj:Object = { };
			obj.content = "<font size = '20' color = '#ffff00'>Bạn nhận được các phần thưởng BOSS Mật Đạo sau: ";
			obj.rewards = Game.database.userdata.globalBossData.rewards;
			Game.database.userdata.globalBossData.rewards = [];
			Manager.display.showDialog(DialogID.GLOBAL_BOSS_CONFIRM, null, null, obj, Layer.BLOCK_BLACK);
			//}
		}

		private function onReceiveServerTime(packet:StringResponsePacket):void
		{
			if (loginTime == -1)
			{
				var timeStr:String = packet.value;
				var year:int = parseInt(timeStr.substr(0, 4));
				var month:int = parseInt(timeStr.substr(4, 2));
				var day:int = parseInt(timeStr.substr(6, 2));
				var hour:int = parseInt(timeStr.substr(9, 2));
				var minute:int = parseInt(timeStr.substr(11, 2));
				var second:int = parseInt(timeStr.substr(13, 2));
				loginTime = new Date(year, month - 1, day, hour, minute, second).getTime();

				serverTimeDifference = loginTime - new Date().getTime();
			}
		}

		private function onReceiveListFormationType(responseListFormationType:ResponseListFormationType):void
		{
			if (responseListFormationType)
			{
				this.arrFormationType = responseListFormationType.formationTypes;
			}
		}

		private function onUpdateItemResponse(responseItemInventory:ResponseItemInventory):void
		{
			if (responseItemInventory)
			{
				Game.database.inventory.updateItems(responseItemInventory.items);
			}
		}

		private function onReceivePlayerInfoAttribute(packet:ResponsePlayerInfoAttribute):void
		{
			Utility.log("receive update player info attribute, attributeID=" + packet.attributeID + " value=" + packet.value);
			var attributeID:PlayerAttributeID = Enum.getEnum(PlayerAttributeID, packet.attributeID) as PlayerAttributeID;
			switch (attributeID)
			{
				case PlayerAttributeID.BATTLE_POINT:
					if (formationStat.damage != packet.value)
					{
						formationStat.damage = packet.value;
						dispatchEvent(new Event(BATTLE_POINT_CHANGED));
					}
					break;
				case PlayerAttributeID.GOLD:
					if (gold != packet.value)
					{
						gold = packet.value;
						dispatchEvent(new Event(GOLD_CHANGED));
					}
					break;
				case PlayerAttributeID.XU:
				{
					if (xu != packet.value)
					{
						xu = packet.value;
						dispatchEvent(new Event(XU_CHANGED));
					}
					break;
				}
			}
		}

		private function onLobbyNotifyClient(packet:ResponseLobbyNotifyClient):void
		{
			if (packet)
			{
				responseNotify[packet.notifyType] = packet;
				dispatchEvent(new EventEx(LOBBY_NOTIFY_CLIENT, packet, true));
			}
		}

		private function onRequestFriendList(packet:ResponseRequestFriendList):void
		{
			if (packet != null)
			{
				dispatchEvent(new EventEx(REQUEST_FRIEND_LIST, packet, true));
			}
		}

		private function onGetMailBox(packet:ResponseInboxMailRequest):void
		{
			if (packet != null)
			{
				arrMailData = packet.arrMailBox;
				dispatchEvent(new Event(GET_MAIL_BOX));
			}
		}

		private function onInventorySlotInfo(packet:ResponseInventoryInfo):void
		{
			characterMaxSlot = packet.characterMaxSlot;
			dispatchEvent(new Event(INVENTORY_INFO));
		}

		private function onGameLevelUp(responseGameLevelUp:ResponseGameLevelUp):void
		{
			Utility.log("################ Server response : GameLevelUp current - " + responseGameLevelUp.currentLevel);
			Utility.log("################ Server response : GameLevelUp last - " + responseGameLevelUp.lastLevel);
			this.level = responseGameLevelUp.currentLevel;
			this.lastLevel = responseGameLevelUp.lastLevel;

			this.dispatchEvent(new Event(GAME_LEVEL_UP));

			if (Manager.module.moduleIsVisible(ModuleID.INGAME_PVE) || Manager.module.moduleIsVisible(ModuleID.INGAME_PVP) || Manager.module.moduleIsVisible(ModuleID.LUCKY_GIFT))
			{
				this.isWaitingLevelUpEffect = true;
			}
			else
			{
				Manager.display.showModule(ModuleID.GAME_LEVEL_UP, new Point(0, 0), LayerManager.LAYER_TOP);
				if (Manager.module.moduleIsVisible(ModuleID.WORLD_MAP))
				{
					//trong module worldmap khi level up ko hien thi button chien dich
					var moduleHUD:HUDModule = Manager.module.getModuleByID(ModuleID.HUD) as HUDModule;
					if (moduleHUD)
					{
						moduleHUD.setVisibleButtonHUD([HUDButtonID.WORLD_MAP.name], false);
					}
				}
			}
		}

		private function updateCharacterInfoByID(packet:ResponseCharacterInfoByID):void
		{
			if (selectedCharacter)
			{
				//selectedCharacter.updateInfo(packet);
			}
			dispatchEvent(new EventEx(UPDATE_CHARACTER_INFO, packet.character, true));
		}

		private function updateCharacterInfo(packet:ResponseCharacterInfo):void
		{
			//Utility.log("update character info");
			if (characters != null)
			{
				var character:Character;
				for (var i:int = 0, length:int = characters.length; i < length; ++i)
				{
					character = characters[i];
					if (character != null && character.ID == packet.character.ID)
					{
						character.cloneInfo(packet.character);
						dispatchEvent(new EventEx(UPDATE_CHARACTER_INFO, character, true));
						Manager.tutorial.onTriggerCondition();
						break;
					}
				}
			}
		}

		private function updatePlayerInfo(responsePlayerInfo:ResponsePlayerInfo):void
		{
			playerName = responsePlayerInfo.playerName;
			level = responsePlayerInfo.level;
			maxLevel = responsePlayerInfo.maxLevel;
			currentExp = responsePlayerInfo.currentExp;
			expToNextLevel = responsePlayerInfo.expToNextLevel;
			gold = responsePlayerInfo.gold;
			xu = responsePlayerInfo.xu;
			honor = responsePlayerInfo.honor;
			actionPoint = responsePlayerInfo.actionPoint;
			maxActionPoint = responsePlayerInfo.maxActionPoint;
			fomationHP = responsePlayerInfo.fomationHP;
			maxFomationHP = responsePlayerInfo.maxFomationHP;

			formationStat.damage = responsePlayerInfo.f_damage;
			formationStat.ID = responsePlayerInfo.f_typeID;
			formationStat.level = responsePlayerInfo.f_level;
			formationStat.hp = responsePlayerInfo.f_hp;
			formationStat.physicalDamage = responsePlayerInfo.f_physicalDamage;
			formationStat.physicalArmor = responsePlayerInfo.f_physicalArmor;
			formationStat.magicalDamage = responsePlayerInfo.f_magicalDamage;
			formationStat.magicalArmor = responsePlayerInfo.f_magicalArmor;

			numNormalFormationSlot = responsePlayerInfo.numNormalFormationSlot;
			numLegendFormationSlot = responsePlayerInfo.numLegendFormationSlot;
			nAlchemyInDay = responsePlayerInfo.nAlchemyInDay;
			vip = responsePlayerInfo.vip;
			healedAP = responsePlayerInfo.healedAP;
			luckyGiftXu = responsePlayerInfo.luckyGiftXu;
			luckyGiftTime = responsePlayerInfo.luckyGiftTime;
			soulExchangePoint = responsePlayerInfo.soulExchangePoint;
			consumeXuInMonth = responsePlayerInfo.consumeXuInMonth;
			nStatusGiftOnline = responsePlayerInfo.nStatusGiftOnline;
			nEventCurrentPaymentEventID = responsePlayerInfo.nEventCurrentPaymentEventID;
			nEventCurrentConsumeEventID = responsePlayerInfo.nEventCurrentConsumeEventID;
			nFirstChargeState = responsePlayerInfo.nFirstCharge;
			attendanceChecked = responsePlayerInfo.nAttendanceChecked;
			attendanceTime = responsePlayerInfo.nAttendanceTime;
			var arrInt:Array = Game.database.gamedata.getConfigData(GameConfigID.ATTENDANCE_REWARDS) as Array;
			nAttendanceState = attendanceTime < arrInt.length - 1 ? 1 : 0;
			remainTimeWaitAlchemy = responsePlayerInfo.nRemainTimeWaitAlchemy;
			elapsedTimeWaitAP = responsePlayerInfo.nElapsedTimeWaitAP;
			sweepingMissionID = responsePlayerInfo.nSweepingMissionID;
			elapsedSweepingTime = responsePlayerInfo.nElapsedSweepingTime;
			maxSweepTimes = responsePlayerInfo.nMaxSweepTimes;

			nTransportRefresh = responsePlayerInfo.nTransportRefresh;
			nDailyQuestRefresh = responsePlayerInfo.nDailyQuestRefresh;
			
			nKungfuTrainHostRemainTime = responsePlayerInfo.nKungfuTrainHostRemainTime;
			nKungfuTrainPartnerRemainTime = responsePlayerInfo.nKungfuTrainPartnerRemainTime;

			guildId = responsePlayerInfo.guildId;
			guildMemberType = responsePlayerInfo.guildMemberType;
			giveAPCount = responsePlayerInfo.giveAPCount;
			receiveAPCount = responsePlayerInfo.receiveAPCount;
			currDigTreasure = responsePlayerInfo.currDigTreasure;
			enableTreasure = responsePlayerInfo.enableTreasure;
			//numAttackResourcePerDay = responsePlayerInfo.numAttackResourcePerDay;
			numOfRespawnBoss = responsePlayerInfo.numOfRespawnBoss;
			enableTreasure = responsePlayerInfo.enableTreasure;
			enableMysticBox = responsePlayerInfo.enableMysticBox;
			enableDice = responsePlayerInfo.enableDice;
			enableShopDiscount = responsePlayerInfo.enableShopDiscount;
			enableVIPPromotion = responsePlayerInfo.enableVIPPromotion;
			numUseMysticBoxes = responsePlayerInfo.numUseMysticBoxes;
			mysticLuckPoint = responsePlayerInfo.mysticLuckPoint;
			numBuyUseMysticBox = responsePlayerInfo.numBuyUseMysticBox;
			
			timeRemainAttackResourceInfo = responsePlayerInfo.timeRemainAttackResourceInfo;

			if (guildId >= 0 && !guildInfo) Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.GU_GET_OWN_GUILD_INFO));
			
			this.dispatchEvent(new Event(UPDATE_PLAYER_INFO, true));
			Manager.tutorial.onTriggerCondition();
			Game.database.gamedata.eventsData.init();

			var timePerAP:int = Game.database.gamedata.getConfigData(GameConfigID.TIME_PER_AP) as int;
			TimerEx.stopTimer(APTimerID);
			APTimerID = TimerEx.startTimer((timePerAP - elapsedTimeWaitAP) * 1000, 0, autoRegainAP);
		}

		private function autoRegainAP():void
		{
			actionPoint = (actionPoint < maxActionPoint) ? ++actionPoint : maxActionPoint;

			var timePerAP:int = Game.database.gamedata.getConfigData(GameConfigID.TIME_PER_AP) as int;
			TimerEx.stopTimer(APTimerID);
			APTimerID = TimerEx.startTimer(timePerAP * 1000, 0, autoRegainAP);

			dispatchEvent(new Event(UPDATE_PLAYER_INFO, true));
		}

		private function updateCharacterList(packet:ResponseCharacterInfoList):void
		{
			if (characters != null)
			{
				for each (var character:Character in characters)
				{
					if (character != null)
					{
						character.reset();
						Manager.pool.push(character, Character);
					}
				}
				characters.splice(0);
				Manager.pool.push(characters);
			}
			characters = packet.characters;

			for (var i:int = 0; i < formation.length; i++)
			{
				character = formation[i];
				if (character)
				{
					formation[i] = getCharacter(character.ID);
				}
			}

			for (i = 0; i < formationChallenge.length; i++)
			{
				character = formationChallenge[i];
				if (character)
				{
					formationChallenge[i] = getCharacter(character.ID);
				}
			}

			for (i = 0; i < formationChallengeTemp.length; i++)
			{
				character = formationChallengeTemp[i];
				if (character)
				{
					formationChallengeTemp[i] = getCharacter(character.ID);
				}
			}

			dispatchEvent(new Event(UPDATE_CHARACTER_LIST));
		}

		private function updateFormation(packet:ResponseFormation):void
		{
			if (packet.userID == userID)
			{
				formations[packet.formationType] = packet.formationCharacterIDs;
				trace(packet.formationType.name + ": " + formations[packet.formationType]);
				switch (packet.formationType)
				{
					case FormationType.FORMATION_MAIN:
						formation = packet.formation;
						break;
					case FormationType.FORMATION_CHALLENGE:
						formationChallenge = packet.formation;
						break;
					case FormationType.FORMATION_TEMP:
						formationChallengeTemp = packet.formation;
				}
				dispatchEvent(new EventEx(UPDATE_FORMATION, {formationType: packet.formationType}, true));
			}
		}

		private function onLobbyServerData(e:EventEx):void
		{
			var packet:ResponsePacket = e.data as ResponsePacket;
			switch (packet.type)
			{
				case LobbyResponseType.CHARACTER_INFO_LIST:
					updateCharacterList(packet as ResponseCharacterInfoList);
					break;
				case LobbyResponseType.FORMATION:
					updateFormation(packet as ResponseFormation);
					break;
				case LobbyResponseType.PLAYER_INFO:
					updatePlayerInfo(packet as ResponsePlayerInfo);
					break;
				case LobbyResponseType.CHARACTER_INFO:
					updateCharacterInfo(packet as ResponseCharacterInfo);
					break;
				case LobbyResponseType.CHARACTER_INFO_BY_ID:
					updateCharacterInfoByID(packet as ResponseCharacterInfoByID);
					break;
				case LobbyResponseType.GAME_LEVEL_UP:
					onGameLevelUp(packet as ResponseGameLevelUp);
					break;
				case LobbyResponseType.INVENTORY_SLOT_INFO:
					onInventorySlotInfo(packet as ResponseInventoryInfo);
					break;
				case LobbyResponseType.MAIL_GET_MAIL_RESULT:
					onGetMailBox(packet as ResponseInboxMailRequest);
					break;
				case LobbyResponseType.REQUEST_FRIEND_LIST_RESULT:
					onRequestFriendList(packet as ResponseRequestFriendList);
					break;
				case LobbyResponseType.LOBBY_NOTIFY_CLIENT:
					onLobbyNotifyClient(packet as ResponseLobbyNotifyClient);
					break;
				case LobbyResponseType.PLAYER_INFO_ATTRIBUTE:
					onReceivePlayerInfoAttribute(packet as ResponsePlayerInfoAttribute);
					break;
				case LobbyResponseType.ITEM_INVENTORY:
					onUpdateItemResponse(packet as ResponseItemInventory);
					break;
				case LobbyResponseType.LIST_FORMATION_TYPE:
					onReceiveListFormationType(packet as ResponseListFormationType);
					break;
				case LobbyResponseType.RECEIVE_SERVER_TIME:
					onReceiveServerTime(packet as StringResponsePacket);
					break;
				case LobbyResponseType.SECRET_MERCHANT_EVENT_ID:
					secretMerchantEventID = IntResponsePacket(packet).value;
					break;
				case LobbyResponseType.TUTORIAL_FINISHED_STEPS:
					finishTutorialIDs = ResponseTutorialFinishedSteps(packet).finishedScenes;
					Utility.log("server response finished steps: " + finishTutorialIDs);
					Manager.tutorial.updateFinishIDs();
					break;
				case LobbyResponseType.DAILY_TASK_INFO:
					dailyTasks = ResponseDailyTaskInfo(packet).result;
					dispatchEvent(new Event(UPDATE_DAILY_TASK));
					break;
				case LobbyResponseType.GLOBAL_BOSS_REWARD:
					onResponseGlobalBossReward(packet as ResponseGlobalBossReward);
					break;
				case LobbyResponseType.GLOBAL_BOSS_MISSION_INFO:
					onResponseGlobalBossMissionInfo(packet as ResponseGlobalBossMissionInfo);
					break;
				case LobbyResponseType.GU_INVITE_SEND:
					var invitePacket:ResponseGuInvite = ResponseGuInvite(packet);
					Manager.display.showDialog(DialogID.GUILD_MESSAGE, inviteToGuildOkHdl, inviteToGuildCancelHdl, {message: invitePacket.nPlayerNameInvite + " muốn mời bạn vào bang " + invitePacket.strName + ". Bạn có đồng ý không?", guildId: invitePacket.nGuildID});
					break;
				case LobbyResponseType.GU_INVITE_ACCEPT:
					Manager.display.showMessage("Lời mời vào bang đã được chấp nhận.");
					break;
				case LobbyResponseType.GU_INVITE_REJECT:
					Manager.display.showMessage("Lời mời vào bang đã bị từ chối.");
					break;
				case LobbyResponseType.GU_GET_OWN_GUILD_INFO:
					guildInfo = packet as ResponseGuOwnGuildInfo;
					break;
				case LobbyResponseType.REQUEST_TO_PLAY_GAME:
					var packetRequestToPlay:ResponseRequestToPlayGame = packet as ResponseRequestToPlayGame;
					if (packetRequestToPlay.mode != GameMode.PVP_TRAINING) break;
					Manager.display.showDialog(DialogID.YES_NO, onAcceptKungfuTrainHdl, null, {title: "THÔNG BÁO", message: packetRequestToPlay.nameInvite + " mời bạn cùng chỉ điểm võ công. Bạn có muốn tham gia?", option: YesNo.YES | YesNo.NO, roomId: packetRequestToPlay.roomID});
					break;
			}
		}
		
		private function onAcceptKungfuTrainHdl(data:Object):void 
		{
			Manager.display.showModule(ModuleID.KUNGFU_TRAIN, new Point(0, 0), LayerManager.LAYER_POPUP, "top_left", Layer.BLOCK_BLACK, {roomId: data.roomId});
		}
	}
}