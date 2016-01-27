package game.net.lobby
{
	import game.enum.ServerResponseType;
	import game.net.BooleanResponsePacket;
	import game.net.ByteResponsePacket;
	import game.net.IntResponsePacket;
	import game.net.IntResponsePacket;
	import game.net.lobby.response.ResponseBuyItemShopVipResult;
	import game.net.lobby.response.ResponseCampaignInfo;
	import game.net.lobby.response.ResponseChallengeHistory;
	import game.net.lobby.response.ResponseChallengeReplayInfo;
	import game.net.lobby.response.ResponseChangeLobbySlot;
	import game.net.lobby.response.ResponseChangeRecipe;
	import game.net.lobby.response.ResponseChangeRoomHost;
	import game.net.lobby.response.ResponseChangeSkillResult;
	import game.net.lobby.response.ResponseCharacterInfo;
	import game.net.lobby.response.ResponseCharacterInfoByID;
	import game.net.lobby.response.ResponseCharacterInfoList;
	import game.net.lobby.response.ResponseChatNotify;
	import game.net.lobby.response.ResponseChatResult;
	import game.net.lobby.response.ResponseConsumeItem;
	import game.net.lobby.response.ResponseConvertEventItem;
	import game.net.lobby.response.ResponseCreateRoom;
	import game.net.lobby.response.ResponseDailyTaskInfo;
	import game.net.lobby.response.ResponseDiceBetResult;
	import game.net.lobby.response.ResponseDiceLog;
	import game.net.lobby.response.ResponseDicePlayerInfo;
	import game.net.lobby.response.ResponseDiceRollResult;
	import game.net.lobby.response.ResponseDiscountShopItems;
import game.net.lobby.response.ResponseDivineWeaponInventory;
import game.net.lobby.response.ResponseEndGamePVP1vs1MM;
	import game.net.lobby.response.ResponseEndGamePvP1x1;
	import game.net.lobby.response.ResponseEndGamePvpReward;
	import game.net.lobby.response.ResponseEndGameRewardResult;
	import game.net.lobby.response.ResponseErrorCode;
	import game.net.lobby.response.ResponseEventInfo;
	import game.net.lobby.response.ResponseEventRewards;
	import game.net.lobby.response.ResponseExchangeInvitation;
	import game.net.lobby.response.ResponseExchangeMysticBoxResult;
	import game.net.lobby.response.ResponseExpressRefresh;
	import game.net.lobby.response.ResponseFormation;
	import game.net.lobby.response.ResponseGameLevelUp;
	import game.net.lobby.response.ResponseGameServerAddress;
	import game.net.lobby.response.ResponseGetActivityInfo;
	import game.net.lobby.response.ResponseGetAvailableEvents;
	import game.net.lobby.response.ResponseGetConsumeEventInfo;
	import game.net.lobby.response.ResponseGetGiftOnlineInfo;
	import game.net.lobby.response.ResponseGetPaymentEventInfo;
	import game.net.lobby.response.ResponseGetRewardGiftCode;
	import game.net.lobby.response.ResponseGetRewardRequireLevelInfo;
	import game.net.lobby.response.ResponseGetShopVipInfo;
	import game.net.lobby.response.ResponseGetSweepingCampaignReward;
	import game.net.lobby.response.ResponseGetTopLevelInPresent;
	import game.net.lobby.response.ResponseListResourceOccupied;
	import game.net.lobby.response.ResponseMysticBoxLog;
	import game.net.lobby.response.ResponseOwnerResourceInfo;
	import game.net.lobby.response.ResponsePVP2vs2MMState;
	import game.net.lobby.response.ResponsePorterInfo;
	import game.net.lobby.response.ResponsePorterList;
	import game.net.lobby.response.ResponsePorterPlayerInfo;
	import game.net.lobby.response.ResponseResourceInfo;
	import game.net.lobby.response.ResponseLockResult;
	import game.net.lobby.response.ResponseGiveAPResult;
	import game.net.lobby.response.ResponseGlobalAnnouncement;
	import game.net.lobby.response.ResponseGlobalBossEndgame;
	import game.net.lobby.response.ResponseGlobalBossHP;
	import game.net.lobby.response.ResponseGlobalBossListPlayers;
	import game.net.lobby.response.ResponseGlobalBossMissionInfo;
	import game.net.lobby.response.ResponseGlobalBossReward;
	import game.net.lobby.response.ResponseGlobalBossTopDmg;
	import game.net.lobby.response.ResponseGuActionLog;
	import game.net.lobby.response.ResponseGuChatMessage;
	import game.net.lobby.response.ResponseGuDedicatedList;
	import game.net.lobby.response.ResponseGuGetElderList;
	import game.net.lobby.response.ResponseGuGetFriendList;
	import game.net.lobby.response.ResponseGuGetMemberList;
	import game.net.lobby.response.ResponseGuGuildInfo;
	import game.net.lobby.response.ResponseGuGuildLevelUp;
	import game.net.lobby.response.ResponseGuGuildSearch;
	import game.net.lobby.response.ResponseGuInvite;
	import game.net.lobby.response.ResponseGuJoinRequestList;
	import game.net.lobby.response.ResponseGuOwnGuildInfo;
	import game.net.lobby.response.ResponseGuProfile;
	import game.net.lobby.response.ResponseGuTopLadder;
	import game.net.lobby.response.ResponseGuUpdateMemberRole;
	import game.net.lobby.response.ResponseHeroicFinishMissions;
	import game.net.lobby.response.ResponseHeroicInfo;
	import game.net.lobby.response.ResponseHeroicInvitePlayer;
	import game.net.lobby.response.ResponseHeroicJoinRoom;
	import game.net.lobby.response.ResponseHeroicJoinRoomInfo;
	import game.net.lobby.response.ResponseHeroicRoomFormation;
	import game.net.lobby.response.ResponseHeroicStartGameResult;
	import game.net.lobby.response.ResponseHeroicTowerList;
	import game.net.lobby.response.ResponseHistoryLeaderBoard;
	import game.net.lobby.response.ResponseInboxMailRequest;
	import game.net.lobby.response.ResponseInventoryInfo;
	import game.net.lobby.response.ResponseItemInventory;
	import game.net.lobby.response.ResponseJoinRoomPvP;
	import game.net.lobby.response.ResponseLeaderBoard;
	import game.net.lobby.response.ResponseLeaderBoardPlayerFormationInfo;
	import game.net.lobby.response.ResponseListChallengeRanking;
	import game.net.lobby.response.ResponseListFormationType;
	import game.net.lobby.response.ResponseListItemShopDaily;
	import game.net.lobby.response.ResponseListPlayersFree;
	import game.net.lobby.response.ResponseLobbyNotifyClient;
	import game.net.lobby.response.ResponseLogin;
	import game.net.lobby.response.ResponseMetalFurnaceResult;
	import game.net.lobby.response.ResponseNotifyAddFriend;
	import game.net.lobby.response.ResponseNotifyReceiveAP;
	import game.net.lobby.response.ResponsePlayerInfo;
	import game.net.lobby.response.ResponsePlayerInfoAttribute;
	import game.net.lobby.response.ResponsePlayerList;
	import game.net.lobby.response.ResponsePlayerProfile;
	import game.net.lobby.response.ResponsePVP1vs1AIState;
	import game.net.lobby.response.ResponsePVP1vs1MMState;
	import game.net.lobby.response.ResponsePVP3vs3MMState;
	import game.net.lobby.response.ResponseQuestDailyAccumulateReward;
	import game.net.lobby.response.ResponseQuestDailyInfo;
	import game.net.lobby.response.ResponseQuestDailyState;
	import game.net.lobby.response.ResponseQuestMainInfo;
	import game.net.lobby.response.ResponseQuestTransportInfo;
	import game.net.lobby.response.ResponseQuestTransportListSastified;
	import game.net.lobby.response.ResponseQuestTransportState;
	import game.net.lobby.response.ResponseReceiveAPResult;
	import game.net.lobby.response.ResponseReputePoint;
	import game.net.lobby.response.ResponseRequestATMPayment;
	import game.net.lobby.response.ResponseRequestFriendList;
	import game.net.lobby.response.ResponseRequestLuckyGift;
	import game.net.lobby.response.ResponseRequestToPlayGame;
	import game.net.lobby.response.ResponseRewardPacket;
	import game.net.lobby.response.ResponseRoomListPvP;
	import game.net.lobby.response.ResponseSaveFormation;
	import game.net.lobby.response.ResponseSecretMerchantInfo;
	import game.net.lobby.response.ResponseSecretMerchantList;
	import game.net.lobby.response.ResponseSelectGlobalBoss;
	import game.net.lobby.response.ResponseShopHeroes;
	import game.net.lobby.response.ResponseSoulCraft;
	import game.net.lobby.response.ResponseSoulCraftAuto;
	import game.net.lobby.response.ResponseSoulInfo;
	import game.net.lobby.response.ResponseSoulInventory;
	import game.net.lobby.response.ResponseTopLeaderBoard;
	import game.net.lobby.response.ResponseTopReceivedReward;
	import game.net.lobby.response.ResponseTreasureLog;
	import game.net.lobby.response.ResponseTreasureRewards;
	import game.net.lobby.response.ResponseTutorialFinishedSteps;
	import game.net.lobby.response.ResponseTuuLauChienHistory;
	import game.net.lobby.response.ResponseUpdateLoadingPercent;
	import game.net.lobby.response.ResponseUpdateRoomPvP;
	import game.net.lobby.response.ResponseUpStarAdditionRate;
	import game.net.ResponsePacket;
	import game.net.StringResponsePacket;
	import game.net.lobby.response.ResponseVIPPromotionPlayerInfo;


	public class LobbyResponseType extends ServerResponseType
	{
		public static const LOGIN							:LobbyResponseType = new LobbyResponseType(0, ResponseLogin);
		public static const CHECK_NEW_USER_RESULT			:LobbyResponseType = new LobbyResponseType(1, BooleanResponsePacket);
		public static const CHECK_ROLE_NAME					:LobbyResponseType = new LobbyResponseType(2, IntResponsePacket);
		public static const PLAYER_LIST						:LobbyResponseType = new LobbyResponseType(3, ResponsePlayerList);
		public static const FORMATION						:LobbyResponseType = new LobbyResponseType(4, ResponseFormation);
		public static const SAVE_FORMATION					:LobbyResponseType = new LobbyResponseType(5, ResponseSaveFormation);
		public static const CHARACTER_INFO_LIST				:LobbyResponseType = new LobbyResponseType(6, ResponseCharacterInfoList);	//dup
		public static const CHARACTER_INFO					:LobbyResponseType = new LobbyResponseType(7, ResponseCharacterInfo);
		public static const LEVEL_UP_ENHANCEMENT			:LobbyResponseType = new LobbyResponseType(9, IntResponsePacket);
		//public static const LEVEL_UP_STAR					:LobbyResponseType = new LobbyResponseType(10, IntResponsePacket);
		public static const LEVEL_UP_CLASS					:LobbyResponseType = new LobbyResponseType(11, IntResponsePacket);
		public static const PLAYER_INFO						:LobbyResponseType = new LobbyResponseType(12, ResponsePlayerInfo);
		public static const CAMPAIGN_INFO					:LobbyResponseType = new LobbyResponseType(13, ResponseCampaignInfo);
		public static const CAMPAIGN_REWARD					:LobbyResponseType = new LobbyResponseType(14, IntResponsePacket);
		public static const UP_STAR_ADDITION_RATE			:LobbyResponseType = new LobbyResponseType(16, ResponseUpStarAdditionRate);
		public static const ITEM_INVENTORY					:LobbyResponseType = new LobbyResponseType(17, ResponseItemInventory);
		public static const UPGRADE_SKILL					:LobbyResponseType = new LobbyResponseType(18, IntResponsePacket);
		public static const PLAYER_INFO_ATTRIBUTE			:LobbyResponseType = new LobbyResponseType(19, ResponsePlayerInfoAttribute);
		public static const LEADER_BOARD					:LobbyResponseType = new LobbyResponseType(20, ResponseLeaderBoard);
		public static const LIST_CHALLENGE_RANKING			:LobbyResponseType = new LobbyResponseType(21, ResponseListChallengeRanking);
		public static const LIST_FORMATION_TYPE				:LobbyResponseType = new LobbyResponseType(22, ResponseListFormationType);
		public static const UPGRADE_FORMATION_TYPE			:LobbyResponseType = new LobbyResponseType(23, IntResponsePacket);
		public static const CONSUME_ITEM					:LobbyResponseType = new LobbyResponseType(25, ResponseConsumeItem);
		public static const SHOP_HEROES_RESPONSE			:LobbyResponseType = new LobbyResponseType(26, ResponseShopHeroes);
		public static const ACTIVE_FORMATION_TYPE			:LobbyResponseType = new LobbyResponseType(27, IntResponsePacket);
		public static const GET_SOUL_INFO					:LobbyResponseType = new LobbyResponseType(31, ResponseSoulInfo);
		public static const SELL_SOUL						:LobbyResponseType = new LobbyResponseType(32, IntResponsePacket);
		public static const SELL_FAST_SOUL					:LobbyResponseType = new LobbyResponseType(33, IntResponsePacket);
		public static const COLLECT_SOUL					:LobbyResponseType = new LobbyResponseType(34, IntResponsePacket);
		public static const COLLECT_FAST_SOUL				:LobbyResponseType = new LobbyResponseType(35, IntResponsePacket);
		public static const UPGRADE_SOUL 					:LobbyResponseType = new LobbyResponseType(36, IntResponsePacket);
		public static const TOP_LEADER_BOARD				:LobbyResponseType = new LobbyResponseType(28, ResponseTopLeaderBoard);
		public static const SOUL_CRAFT						:LobbyResponseType = new LobbyResponseType(29, ResponseSoulCraft);
		public static const AUTO_SOUL_CRAFT					:LobbyResponseType = new LobbyResponseType(30, ResponseSoulCraftAuto);
		
		public static const EQUIP_SOUL 						:LobbyResponseType = new LobbyResponseType(38, IntResponsePacket);
		public static const CHALLENGE_HISTORY				:LobbyResponseType = new LobbyResponseType(39, ResponseChallengeHistory);
		public static const SOUL_INVENTORY					:LobbyResponseType = new LobbyResponseType(40, ResponseSoulInventory);
		public static const SELL_ITEM_INVENTORY				:LobbyResponseType = new LobbyResponseType(42, IntResponsePacket);
		public static const	RECEIVE_SERVER_TIME				:LobbyResponseType = new LobbyResponseType(43, StringResponsePacket);
		public static const SWAP_SOUL_INV					:LobbyResponseType = new LobbyResponseType(44, IntResponsePacket);
		public static const SWAP_SOUL_INV_EQUIP				:LobbyResponseType = new LobbyResponseType(45, IntResponsePacket);
		
		//for quest transport module
		public static const QUEST_TRANSPORT_INFO			:LobbyResponseType = new LobbyResponseType(46, ResponseQuestTransportInfo);
		public static const QUEST_TRANSPORT_ACTIVE			:LobbyResponseType = new LobbyResponseType(47, IntResponsePacket);
		public static const QUEST_TRANSPORT_RENT			:LobbyResponseType = new LobbyResponseType(48, IntResponsePacket);
		public static const QUEST_TRANSPORT_REFRESH			:LobbyResponseType = new LobbyResponseType(49, IntResponsePacket);
		public static const QUEST_TRANSPORT_SKIP			:LobbyResponseType = new LobbyResponseType(50, IntResponsePacket);
		public static const QUEST_TRANSPORT_CLOSE			:LobbyResponseType = new LobbyResponseType(51, IntResponsePacket);
		public static const CHARACTER_INFO_BY_ID			:LobbyResponseType = new LobbyResponseType(52, ResponseCharacterInfoByID);
		public static const LOGIN_CONFLICT_ACC				:LobbyResponseType = new LobbyResponseType(53, ByteResponsePacket);
		public static const QUEST_TRANSPORT_REPUTE_POINT	:LobbyResponseType = new LobbyResponseType(54, ResponseReputePoint);
		public static const GAME_LEVEL_UP					:LobbyResponseType = new LobbyResponseType(55, ResponseGameLevelUp);
		public static const QUEST_TRANSPORT_STATE			:LobbyResponseType = new LobbyResponseType(56, ResponseQuestTransportState);
		public static const QUEST_TRANSPORT_LIST_SASTIFIED	:LobbyResponseType = new LobbyResponseType(57, ResponseQuestTransportListSastified);
		public static const	UNIT_CHANGE_SKILL				:LobbyResponseType = new LobbyResponseType(58, IntResponsePacket);		
		public static const LEADER_BOARD_PLAYER_FORMATION_INFO:LobbyResponseType = new LobbyResponseType(59, ResponseLeaderBoardPlayerFormationInfo);
		public static const METAL_FURNACE					:LobbyResponseType = new LobbyResponseType(60, ResponseMetalFurnaceResult);
		
		//for quest main module
		public static const QUEST_MAIN_STATE				:LobbyResponseType = new LobbyResponseType(61, IntResponsePacket);
		public static const QUEST_MAIN_INFO					:LobbyResponseType = new LobbyResponseType(62, ResponseQuestMainInfo);
		public static const QUEST_MAIN_CLOSE				:LobbyResponseType = new LobbyResponseType(63, IntResponsePacket);
		public static const UNLOCK_SLOT						:LobbyResponseType = new LobbyResponseType(64, IntResponsePacket);
		public static const HEAL_AP							:LobbyResponseType = new LobbyResponseType(65, IntResponsePacket);
		public static const HEAL_HP							:LobbyResponseType = new LobbyResponseType(66, IntResponsePacket);
		
		//for quest daily module
		public static const QUEST_DAILY_STATE				:LobbyResponseType = new LobbyResponseType(67, ResponseQuestDailyState);
		public static const QUEST_DAILY_INFO				:LobbyResponseType = new LobbyResponseType(68, ResponseQuestDailyInfo);
		public static const QUEST_DAILY_CLOSE				:LobbyResponseType = new LobbyResponseType(69, IntResponsePacket);
		public static const QUEST_DAILY_QUICK_FINISH		:LobbyResponseType = new LobbyResponseType(70, IntResponsePacket);
		public static const QUEST_DAILY_REFRESH				:LobbyResponseType = new LobbyResponseType(71, IntResponsePacket);
		//public static const QUEST_DAILY_ACCUMULATE_INFO:LobbyResponseType = new LobbyResponseType(72, );
		//public static const QUEST_DAILY_ACCUMULATE_CLOSE:LobbyResponseType = new LobbyResponseType(73, );
		public static const	QUEST_DAILY_ACCUMULATE_REWARD	:LobbyResponseType = new LobbyResponseType(76, ResponseQuestDailyAccumulateReward);
		
		
		//for pvp 1vs1 AI ~ Hoa Son Luan Kiem
		public static const PVP1vs1_AI_STATE				:LobbyResponseType = new LobbyResponseType(74, ResponsePVP1vs1AIState);
		public static const TOP_RECEIVED_REWARD				:LobbyResponseType = new LobbyResponseType(77, ResponseTopReceivedReward);
		public static const PVP1vs1_AI_REFRESH_TIME			:LobbyResponseType = new LobbyResponseType(79, IntResponsePacket);
		public static const PVP1vs1_AI_SKIP_LIMIT			:LobbyResponseType = new LobbyResponseType(80, IntResponsePacket);
		public static const EXTEND_RECRUITMENT				:LobbyResponseType = new LobbyResponseType(81, IntResponsePacket);
		
		//for pvp 1vs1 MM ~ Vo Lam Minh Chu
		public static const PVP1vs1_MM_STATE				:LobbyResponseType = new LobbyResponseType(83, ResponsePVP1vs1MMState);
		public static const LUCKY_GIFT_RESULT				:LobbyResponseType = new LobbyResponseType(84, ResponseRequestLuckyGift);
		public static const PVP1vs1_MM_HISTORY_TOP_LEADER_BOARD:LobbyResponseType = new LobbyResponseType(85, ResponseHistoryLeaderBoard);
		public static const PVP1vs1_MM_SKIP_LIMIT			:LobbyResponseType = new LobbyResponseType(86, null);
		
		public static const INVENTORY_SLOT_INFO				:LobbyResponseType = new LobbyResponseType(87, ResponseInventoryInfo);	//dup
		
		//for pvp 3vs3 MM ~ Tam Hung Ki Hiep
		public static const PVP3vs3_MM_STATE				:LobbyResponseType = new LobbyResponseType(88, ResponsePVP3vs3MMState);
		public static const PVP3vs3_MM_HISTORY_TOP_LEADER_BOARD:LobbyResponseType = new LobbyResponseType(89, ResponseHistoryLeaderBoard);
		
		public static const GLOBAL_BOSS_LEAVE_GAME			:LobbyResponseType = new LobbyResponseType(90, IntResponsePacket);
		public static const SELECT_GLOBAL_BOSS_INFO			:LobbyResponseType = new LobbyResponseType(91, ResponseSelectGlobalBoss);
		public static const GET_REWARD_GIFT_CODE_RESULT		:LobbyResponseType = new LobbyResponseType(92, ResponseGetRewardGiftCode);
		public static const GLOBAL_BOSS_BUFF_GOLD			:LobbyResponseType = new LobbyResponseType(93, IntResponsePacket);
		public static const GLOBAL_BOSS_BUFF_XU				:LobbyResponseType = new LobbyResponseType(94, IntResponsePacket);
		public static const GLOBAL_BOSS_REVIVE				:LobbyResponseType = new LobbyResponseType(95, IntResponsePacket);
		public static const GLOBAL_BOSS_AUTO_PLAY			:LobbyResponseType = new LobbyResponseType(96, IntResponsePacket);
		public static const GLOBAL_BOSS_MY_DMG				:LobbyResponseType = new LobbyResponseType(97, IntResponsePacket);
		public static const GLOBAL_BOSS_TOP_DMG				:LobbyResponseType = new LobbyResponseType(98, ResponseGlobalBossTopDmg);
		public static const GLOBAL_BOSS_AUTO_REVIVE			:LobbyResponseType = new LobbyResponseType(99, IntResponsePacket);
		public static const GLOBAL_BOSS_HP					:LobbyResponseType = new LobbyResponseType(100, ResponseGlobalBossHP);
		public static const GLOBAL_BOSS_MISSION_INFO		:LobbyResponseType = new LobbyResponseType(101, ResponseGlobalBossMissionInfo);
		public static const GLOBAL_BOSS_LIST_PLAYERS		:LobbyResponseType = new LobbyResponseType(102, ResponseGlobalBossListPlayers);
		public static const GET_TOP_LEVEL_IN_PRESENT		:LobbyResponseType = new LobbyResponseType(104, ResponseGetTopLevelInPresent);
		public static const GLOBAL_BOSS_REWARD				:LobbyResponseType = new LobbyResponseType(105, ResponseGlobalBossReward);
		public static const HEROIC_TOWER_LIST				:LobbyResponseType = new LobbyResponseType(106, ResponseHeroicTowerList);
		public static const HEROIC_TOWER_START_AUTOPLAY		:LobbyResponseType = new LobbyResponseType(107, IntResponsePacket);
		public static const HEROIC_TOWER_STOP_AUTOPLAY		:LobbyResponseType = new LobbyResponseType(108, IntResponsePacket);
		public static const HEROIC_TOWER_AUTOPLAY_REWARD	:LobbyResponseType = new LobbyResponseType(109, ResponseRewardPacket);
		public static const HEROIC_INFO						:LobbyResponseType = new LobbyResponseType(110, ResponseHeroicInfo);
		public static const GET_REWARD_REQUIRE_LEVEL_INFO	:LobbyResponseType = new LobbyResponseType(111, ResponseGetRewardRequireLevelInfo);
		public static const RECEIVE_REWARD_REQUIRE_LEVEL	:LobbyResponseType = new LobbyResponseType(112, IntResponsePacket);
		public static const QUEST_TRANSPORT_CLEAR_QUEST		:LobbyResponseType = new LobbyResponseType(113, IntResponsePacket);
		public static const HEROIC_TOWER_INSTANT_FINISH		:LobbyResponseType = new LobbyResponseType(114, IntResponsePacket);
		public static const HEROIC_BUY_PLAYING_TIMES		:LobbyResponseType = new LobbyResponseType(115, IntResponsePacket);
		public static const LOBBY_NOTIFY_CLIENT				:LobbyResponseType = new LobbyResponseType(117, ResponseLobbyNotifyClient);
		public static const HEROIC_FINISH_MISSIONS			:LobbyResponseType = new LobbyResponseType(118, ResponseHeroicFinishMissions);
		public static const CHANGE_SKILL_BOOK				:LobbyResponseType = new LobbyResponseType(119, ResponseChangeRecipe);
		public static const CHANGE_FORMATION_TYPE_BOOK		:LobbyResponseType = new LobbyResponseType(120, ResponseChangeRecipe);
		
		public static const ERROR_CODE						:LobbyResponseType = new LobbyResponseType(122, ResponseErrorCode);
		
		//event
		public static const GET_PAYMENT_EVENT_INFO			:LobbyResponseType = new LobbyResponseType(123, ResponseGetPaymentEventInfo);
		public static const RECEIVE_PAYMENT_EVENT_REWARD	:LobbyResponseType = new LobbyResponseType(124, IntResponsePacket);
		public static const GET_CONSUME_EVENT_INFO			:LobbyResponseType = new LobbyResponseType(125, ResponseGetConsumeEventInfo);
		public static const RECEIVE_CONSUME_EVENT_REWARD	:LobbyResponseType = new LobbyResponseType(126, IntResponsePacket);
		public static const GET_GIFT_ONLINE_INFO			:LobbyResponseType = new LobbyResponseType(127, ResponseGetGiftOnlineInfo);
		public static const RECEIVE_GIFT_ONLINE_REWARD		:LobbyResponseType = new LobbyResponseType(128, IntResponsePacket);
		public static const RECEIVE_LIST_ITEM_BOUGHT_SHOP_DAILY	:LobbyResponseType = new LobbyResponseType(129, ResponseListItemShopDaily);
		public static const RECEIVE_PLAYER_PROFILE:			LobbyResponseType = new LobbyResponseType(130, ResponsePlayerProfile);
		public static const RECEIVE_PLAYER_CHARACTER_INFO	:LobbyResponseType = new LobbyResponseType(131, ResponseCharacterInfo);
		public static const SECRET_MERCHANT_INFO			:LobbyResponseType = new LobbyResponseType(132, ResponseSecretMerchantInfo);
		public static const SECRET_MERCHANT_PLAYERS_LIST	:LobbyResponseType = new LobbyResponseType(133, ResponseSecretMerchantList);
		public static const SECRET_MERCHANT_EVENT_ID		:LobbyResponseType = new LobbyResponseType(134, IntResponsePacket);
		public static const TUTORIAL_FINISHED_STEPS			:LobbyResponseType = new LobbyResponseType(135, ResponseTutorialFinishedSteps);
		public static const GET_SHOP_VIP_INFO				:LobbyResponseType = new LobbyResponseType(138, ResponseGetShopVipInfo);
		public static const FIRST_CHARGE_REWARD_RESULT		:LobbyResponseType = new LobbyResponseType(139, IntResponsePacket);
		public static const GLOBAL_ANNOUCEMENT				:LobbyResponseType = new LobbyResponseType(140, ResponseGlobalAnnouncement);
		public static const DAILY_TASK_INFO					:LobbyResponseType = new LobbyResponseType(141, ResponseDailyTaskInfo);
		public static const ALCHEMY_SKIP_TIMEWAIT				:LobbyResponseType = new LobbyResponseType(145, IntResponsePacket);
		public static const CAMPAIGN_SWEEP				:LobbyResponseType = new LobbyResponseType(146, IntResponsePacket);
		public static const CAMPAIGN_CANCEL_SWEEP				:LobbyResponseType = new LobbyResponseType(147, IntResponsePacket);
		public static const CAMPAIGN_QUICK_SWEEP				:LobbyResponseType = new LobbyResponseType(148, ResponseGetSweepingCampaignReward);
		public static const GET_SWEEP_CAMPAIGN_REWARD				:LobbyResponseType = new LobbyResponseType(149, ResponseGetSweepingCampaignReward);
		public static const EVENT_GET_INFO				:LobbyResponseType = new LobbyResponseType(150, ResponseEventInfo);
		public static const EVENT_RECEIVE_REWARD				:LobbyResponseType = new LobbyResponseType(151, ResponseEventRewards);
		public static const EVENT_BUY_ITEM_ACTIVE				:LobbyResponseType = new LobbyResponseType(152, IntResponsePacket);
		public static const EVENT_CONVERT_ITEM				:LobbyResponseType = new LobbyResponseType(153, ResponseConvertEventItem);
		public static const GET_AVAILABLE_EVENTS				:LobbyResponseType = new LobbyResponseType(154, ResponseGetAvailableEvents);
		public static const FRIEND_GIVE_AP_RESULT				:LobbyResponseType = new LobbyResponseType(162, ResponseGiveAPResult);
		public static const FRIEND_NOTIFY_RECEIVE_AP				:LobbyResponseType = new LobbyResponseType(163, ResponseNotifyReceiveAP);
		public static const FRIEND_RECEIVE_AP_RESULT				:LobbyResponseType = new LobbyResponseType(164, ResponseReceiveAPResult);
		public static const RESPONSE_EXPRESS_PORTER_LIST				:LobbyResponseType = new LobbyResponseType(165, ResponsePorterList);
		public static const RESPONSE_EXPRESS_PORTER_INFO				:LobbyResponseType = new LobbyResponseType(166, ResponsePorterInfo);
		public static const RESPONSE_EXPRESS_PLAYER_INFO				:LobbyResponseType = new LobbyResponseType(167, ResponsePorterPlayerInfo);
		public static const RESPONSE_EXPRESS_REFRESH_RESULT				:LobbyResponseType = new LobbyResponseType(168, ResponseExpressRefresh);
		public static const RESPONSE_EXPRESS_HIRE_RED_PORTER_RESULT				:LobbyResponseType = new LobbyResponseType(169, IntResponsePacket);
		public static const RESPONSE_EXPRESS_START_RESULT				:LobbyResponseType = new LobbyResponseType(170, IntResponsePacket);

		public static const TREASURE_REWARD_RESULT				:LobbyResponseType = new LobbyResponseType(173, ResponseTreasureRewards);
		public static const TREASURE_LOG_RESULT     				:LobbyResponseType = new LobbyResponseType(174, ResponseTreasureLog);
		public static const KEEP_LUCK_RESULT 				:LobbyResponseType = new LobbyResponseType(177, IntResponsePacket);
		public static const CHECK_BOSS_PAYMENT_RESULT 				:LobbyResponseType = new LobbyResponseType(179, BooleanResponsePacket);
		public static const EXCHANGE_INVITATION_RESULT 				:LobbyResponseType = new LobbyResponseType(180, ResponseExchangeInvitation);
		public static const EXCHANGE_MYSTIC_BOX_RESULT 				:LobbyResponseType = new LobbyResponseType(181, ResponseExchangeMysticBoxResult);
		public static const MYSTIC_BOX_LOG_RESULT 				:LobbyResponseType = new LobbyResponseType(182, ResponseMysticBoxLog);
		public static const MYSTIC_BOX_BUY_RESULT 				:LobbyResponseType = new LobbyResponseType(183, IntResponsePacket);

		public static const DICE_GET_PLAYER_INFO_RESULT 				:LobbyResponseType = new LobbyResponseType(184, ResponseDicePlayerInfo);
		public static const DICE_GET_REWARD_RESULT 				:LobbyResponseType = new LobbyResponseType(185, IntResponsePacket);
		public static const DICE_ROLL_RESULT 				:LobbyResponseType = new LobbyResponseType(186, ResponseDiceRollResult);
		public static const DICE_BET_RESULT 				:LobbyResponseType = new LobbyResponseType(187, ResponseDiceBetResult);
		public static const DICE_LOG_RESULT 				:LobbyResponseType = new LobbyResponseType(188, ResponseDiceLog);

		public static const SHOP_DISCOUNT_ITEMS_RESULT 				:LobbyResponseType = new LobbyResponseType(190, ResponseDiscountShopItems);
		public static const SHOP_DISCOUNT_BUY_ITEM_RESULT 				:LobbyResponseType = new LobbyResponseType(191, IntResponsePacket);

		public static const VIP_PROMOTION_PLAYER_INFO_RESULT 				:LobbyResponseType = new LobbyResponseType(192, ResponseVIPPromotionPlayerInfo);
		public static const VIP_PROMOTION_BUY_RESULT 				:LobbyResponseType = new LobbyResponseType(193, IntResponsePacket);

		public static const CHANGE_SKILL_RESULT 				:LobbyResponseType = new LobbyResponseType(194, ResponseChangeSkillResult);

		public static const PVP2vs2_MM_STATE				:LobbyResponseType = new LobbyResponseType(206, ResponsePVP2vs2MMState);

		public static const START_RESOURCE_LOADING			:LobbyResponseType = new LobbyResponseType(1001, ResponseGameServerAddress);
		public static const READY_TRANS_TO_IN_GAME			:LobbyResponseType = new LobbyResponseType(1002, ResponsePacket);
		
		public static const CREATE_ROOM						:LobbyResponseType = new LobbyResponseType(1005, ResponseCreateRoom);		//create room common
		public static const START_GAME_RESULT				:LobbyResponseType = new LobbyResponseType(1004, IntResponsePacket);		//start game common
		public static const END_GAME_RESULT					:LobbyResponseType = new LobbyResponseType(1023, IntResponsePacket);		//end game common
		public static const END_GAME_REWARD_RESULT			:LobbyResponseType = new LobbyResponseType(1024, ResponseEndGameRewardResult);		//end game reward common
		public static const LEAVE_GAME_RESULT				:LobbyResponseType = new LobbyResponseType(1011, IntResponsePacket);		//leave room common
		public static const MATCHING_RESULT					:LobbyResponseType = new LobbyResponseType(1025, ResponsePacket);		//result matching request	
		public static const UPDATE_LOADING_PERCENT			:LobbyResponseType = new LobbyResponseType(1026, ResponseUpdateLoadingPercent);	//result update loading percent for lobby		
		
		public static const LIST_PLAYERS_FREE				:LobbyResponseType = new LobbyResponseType(1009, ResponseListPlayersFree);
		public static const END_GAME_PVP_3x3				:LobbyResponseType = new LobbyResponseType(1012, ResponseEndGamePvpReward);
		
		public static const JOIN_ROOM_BY_ID_RESULT			:LobbyResponseType = new LobbyResponseType(1003, IntResponsePacket);
		public static const QUICK_JOIN_ROOM_RESULT			:LobbyResponseType = new LobbyResponseType(1006, ResponseJoinRoomPvP);
		public static const WRONG_LOBBY_STATE_LOG			:LobbyResponseType = new LobbyResponseType(1007, ResponsePacket);
		public static const UPDATE_INFO_ROOM_PVP			:LobbyResponseType = new LobbyResponseType(1008, ResponseUpdateRoomPvP);
		
		public static const ROOM_LIST_PVP					:LobbyResponseType = new LobbyResponseType(1013, ResponseRoomListPvP);
		public static const REQUEST_TO_PLAY_GAME			:LobbyResponseType = new LobbyResponseType(1014, ResponseRequestToPlayGame);
		public static const INVITE_TO_PLAY_GAME				:LobbyResponseType = new LobbyResponseType(1015, IntResponsePacket);
		public static const COUNT_MATCHING					:LobbyResponseType = new LobbyResponseType(1016, IntResponsePacket);		//result adap matching condition to start count
		public static const CANCEL_MATCHING					:LobbyResponseType = new LobbyResponseType(1017, IntResponsePacket);		//result cancel matching request
		
		public static const CHANGE_LOBBY_PLAYER_SLOT		:LobbyResponseType = new LobbyResponseType(1018, ResponseChangeLobbySlot);
		public static const END_GAME_PVP_1x1				:LobbyResponseType = new LobbyResponseType(1019, ResponseEndGamePvP1x1);
		public static const KICK_FROM_LOBBY					:LobbyResponseType = new LobbyResponseType(1020, ResponsePacket);
		public static const END_GAME_PVP_1VS1_MM			:LobbyResponseType = new LobbyResponseType(1021, ResponseEndGamePVP1vs1MM);
		public static const END_GAME_GLOBAL_BOSS			:LobbyResponseType = new LobbyResponseType(1022, ResponseGlobalBossEndgame);
		public static const HEROIC_LOBBY_FORMATION			:LobbyResponseType = new LobbyResponseType(1027, ResponseHeroicRoomFormation);
		public static const ENTER_PVE_HEROIC				:LobbyResponseType = new LobbyResponseType(1028, IntResponsePacket);
		public static const WRONG_LOBBY_STATE_BACK			:LobbyResponseType = new LobbyResponseType(1029, ResponsePacket);	//
		public static const RESPONSE_END_GAME_CONTINUE		:LobbyResponseType = new LobbyResponseType(1030, IntResponsePacket);	//for all common continue play game
		public static const START_HEROIC_RESULT				:LobbyResponseType = new LobbyResponseType(1031, ResponseHeroicStartGameResult);
		public static const HEROIC_GET_CAVE_ID				:LobbyResponseType = new LobbyResponseType(1032, ResponseHeroicJoinRoomInfo);
		public static const HEROIC_RECEIVE_INVITE_MESS		:LobbyResponseType = new LobbyResponseType(1033, ResponseHeroicInvitePlayer);
		public static const HEROIC_INVITE_PLAYER			:LobbyResponseType = new LobbyResponseType(1034, IntResponsePacket);
		public static const HEROIC_ACCEPT_JOIN_ROOM			:LobbyResponseType = new LobbyResponseType(1035, ResponseHeroicJoinRoom);
		//public static const LEAVE_GAME_RESULT				:LobbyResponseType = new LobbyResponseType(1036, IntResponsePacket);
		public static const HEROIC_KICK						:LobbyResponseType = new LobbyResponseType(1037, IntResponsePacket);
		public static const HEROIC_BROADCAST_AUTO_START		:LobbyResponseType = new LobbyResponseType(1039, BooleanResponsePacket);
		
		// kungfu train ---------------------
		public static const KUNGFU_TRAIN_READY				:LobbyResponseType = new LobbyResponseType(1040, IntResponsePacket);
		public static const KUNGFU_TRAIN_START				:LobbyResponseType = new LobbyResponseType(1041, IntResponsePacket);
		public static const KUNGFU_TRAIN_REWARD				:LobbyResponseType = new LobbyResponseType(1042, IntResponsePacket);
		public static const KUNGFU_TRAIN_STOP				:LobbyResponseType = new LobbyResponseType(1043, IntResponsePacket);
		public static const KUNGFU_ROOM_DESTROY				:LobbyResponseType = new LobbyResponseType(1044, ResponsePacket);
		// ----------------------------------

		public static const LOBBY_CHANGE_HOST_RS				:LobbyResponseType = new LobbyResponseType(1045, ResponseChangeRoomHost);
		public static const CHAT_NOTIFY						:LobbyResponseType = new LobbyResponseType(2000, ResponseChatNotify);
		public static const CHAT_RESPONSE					:LobbyResponseType = new LobbyResponseType(2001, ResponseChatResult);
		
		public static const ADD_FRIEND_RESULT				:LobbyResponseType = new LobbyResponseType(2003, IntResponsePacket);
		public static const DELETE_FRIEND_RESULT			:LobbyResponseType = new LobbyResponseType(2004, IntResponsePacket);
		public static const REQUEST_FRIEND_LIST_RESULT		:LobbyResponseType = new LobbyResponseType(2005, ResponseRequestFriendList);
		
		
		public static const MAIL_GET_MAIL_RESULT			:LobbyResponseType = new LobbyResponseType(2007, ResponseInboxMailRequest);
		public static const MAIL_DELETE_MAIL_RESULT			:LobbyResponseType = new LobbyResponseType(2010, IntResponsePacket);
		//public static const MAIL_READ_MAIL_RESULT:LobbyResponseType 		   = new LobbyResponseType(2036, );
		public static const MAIL_RECEIVE_ATTACHMENT_RESULT	:LobbyResponseType = new LobbyResponseType(2037, IntResponsePacket);
		
		public static const BUY_ITEM_RESULT					:LobbyResponseType = new LobbyResponseType(3002, IntResponsePacket);
		public static const BUY_ITEM_SHOP_VIP_RESULT		:LobbyResponseType = new LobbyResponseType(3004, ResponseBuyItemShopVipResult);
		public static const REQUEST_ATM_PAYMENT_RESULT		:LobbyResponseType = new LobbyResponseType(3006, ResponseRequestATMPayment);

		// guild ----------------------
	
		public static const GU_CREATE     					:LobbyResponseType = new LobbyResponseType(2012, IntResponsePacket);
		public static const GU_GET_OWN_GUILD_INFO     		:LobbyResponseType = new LobbyResponseType(2013, ResponseGuOwnGuildInfo);
		public static const GU_INVITE_SEND     				:LobbyResponseType = new LobbyResponseType(2014, ResponseGuInvite);
		public static const GU_INVITE_ACCEPT     			:LobbyResponseType = new LobbyResponseType(2015, IntResponsePacket);
		public static const GU_INVITE_REJECT     			:LobbyResponseType = new LobbyResponseType(2016, IntResponsePacket);
		public static const GU_KICK     					:LobbyResponseType = new LobbyResponseType(2017, IntResponsePacket);
		public static const GU_JOIN_REQUEST_SEND     		:LobbyResponseType = new LobbyResponseType(2018, IntResponsePacket);
		public static const GU_JOIN_REQUEST_ACCEPT     		:LobbyResponseType = new LobbyResponseType(2019, IntResponsePacket);
		public static const GU_JOIN_REQUEST_REJECT     		:LobbyResponseType = new LobbyResponseType(2020, IntResponsePacket);
		public static const GU_LEAVE     					:LobbyResponseType = new LobbyResponseType(2021, IntResponsePacket);
		public static const GU_CHANGE_MEMBER_ROLE      		:LobbyResponseType = new LobbyResponseType(2022, IntResponsePacket);
		public static const GU_GET_GUILD_INFO     			:LobbyResponseType = new LobbyResponseType(2023, ResponseGuGuildInfo);
		public static const GU_PROMOTE_TO_PRESIDENT     	:LobbyResponseType = new LobbyResponseType(2024, IntResponsePacket);
		public static const GU_GET_PROFILE_INFO     		:LobbyResponseType = new LobbyResponseType(2025, ResponseGuProfile);
		public static const GU_GET_ACTION_LOG     			:LobbyResponseType = new LobbyResponseType(2026, ResponseGuActionLog);
		public static const GU_UPDATE_ANNOUCE     			:LobbyResponseType = new LobbyResponseType(2027, IntResponsePacket);
		public static const GU_GET_TOTAL_MEMBER     		:LobbyResponseType = new LobbyResponseType(2028, IntResponsePacket);
		public static const GU_GET_TOTAL_JOIN_REQUEST     	:LobbyResponseType = new LobbyResponseType(2029, IntResponsePacket);
		public static const GU_GET_JOIN_REQUEST_LIST   		:LobbyResponseType = new LobbyResponseType(2030, ResponseGuJoinRequestList);
		public static const GU_GET_MEMBER_LIST      		:LobbyResponseType = new LobbyResponseType(2031, ResponseGuGetMemberList);
		public static const GU_DEDICATED      				:LobbyResponseType = new LobbyResponseType(2032, IntResponsePacket);
		public static const GU_UPDATE_MEMBER_ROLE      		:LobbyResponseType = new LobbyResponseType(2033, ResponseGuUpdateMemberRole);
		public static const GU_KICKED				    	:LobbyResponseType = new LobbyResponseType(2034, ResponsePacket);
		public static const GU_GET_ELDER_LIST				:LobbyResponseType = new LobbyResponseType(2035, ResponseGuGetElderList);
		
		public static const GET_ACTIVITY_INFO		    	:LobbyResponseType = new LobbyResponseType(171, ResponseGetActivityInfo);
		public static const GU_GET_ACTIVITY_REWARD		    :LobbyResponseType = new LobbyResponseType(172, IntResponsePacket);
		
		public static const GU_CHAT_SEND_MESSAGE		    :LobbyResponseType = new LobbyResponseType(2039, ResponseGuChatMessage);
		public static const GU_GET_FRIEND_LIST		      	:LobbyResponseType = new LobbyResponseType(2040, ResponseGuGetFriendList);
		public static const GU_UPGRATE_GUILD		    	:LobbyResponseType = new LobbyResponseType(2041, IntResponsePacket);
		public static const GU_SEARCH_GUILD_NAME		    :LobbyResponseType = new LobbyResponseType(2042, ResponseGuGuildSearch);
		
		public static const GU_GET_LEADER_BOARD		    	:LobbyResponseType = new LobbyResponseType(2043, ResponseGuTopLadder);
		public static const GU_GUILD_LEVEL_UP		    	:LobbyResponseType = new LobbyResponseType(2044, ResponseGuGuildLevelUp);
	
		public static const GU_DEDICATED_SKILL		    	:LobbyResponseType = new LobbyResponseType(2045, IntResponsePacket);
		public static const FRIEND_NOTIFY_ADD		    	:LobbyResponseType = new LobbyResponseType(2046, ResponseNotifyAddFriend);

		// --------------------
		
		public static const CHALLENGE_REPLAY_INFO		    :LobbyResponseType = new LobbyResponseType(155, ResponseChallengeReplayInfo);
		public static const LOCK_CHAR:LobbyResponseType = new LobbyResponseType(175, ResponseLockResult);
		public static const UNLOCK_CHAR:LobbyResponseType = new LobbyResponseType(176, ResponseLockResult);
		public static const TUTORIAL_RESPONSE_TRANSPORT_INDEX:LobbyResponseType = new LobbyResponseType(178, IntResponsePacket);

		
		//tuu lau chien
		public static const LIST_RESOURCES_OCCUPIED			:LobbyResponseType = new LobbyResponseType(156, ResponseListResourceOccupied);
		public static const RESOURCE_INFO					:LobbyResponseType = new LobbyResponseType(157, ResponseResourceInfo);
		public static const OWNER_RESOURCE_INFO				:LobbyResponseType = new LobbyResponseType(158, ResponseOwnerResourceInfo);
		public static const ACTIVE_RESOURCE_BUFF			:LobbyResponseType = new LobbyResponseType(159, IntResponsePacket);
		public static const ACTIVE_RESOURCE_PROTECT			:LobbyResponseType = new LobbyResponseType(160, IntResponsePacket);
		public static const CANCEL_RESOURCE_OCCUPIED		:LobbyResponseType = new LobbyResponseType(161, IntResponsePacket);
		public static const RECEIVE_TUU_LAU_CHIEN_HISTORY	:LobbyResponseType = new LobbyResponseType(189, ResponseTuuLauChienHistory);

        //than binh
        public static const DIVINE_WEAPON_INVENTORY         :LobbyResponseType = new LobbyResponseType(195, ResponseDivineWeaponInventory);
        public static const DIVINE_WEAPON_LOCK_ITEM         :LobbyResponseType = new LobbyResponseType(196, IntResponsePacket);
        public static const DIVINE_WEAPON_LOCK_LUCKY_POINT         :LobbyResponseType = new LobbyResponseType(197, IntResponsePacket);
        public static const DIVINE_WEAPON_DESTROY_ITEM         :LobbyResponseType = new LobbyResponseType(198, IntResponsePacket);
        public static const DIVINE_WEAPON_EQUIP_ITEM         :LobbyResponseType = new LobbyResponseType(199, IntResponsePacket);
        public static const DIVINE_WEAPON_UNEQUIP_ITEM         :LobbyResponseType = new LobbyResponseType(200, IntResponsePacket);
        public static const DIVINE_WEAPON_UPGRADE_STAR         :LobbyResponseType = new LobbyResponseType(201, IntResponsePacket);
        public static const DIVINE_WEAPON_UPGRADE_ATTRIB         :LobbyResponseType = new LobbyResponseType(202, IntResponsePacket);

		public function LobbyResponseType(ID:int, packetClass:Class, name:String=""):void
		{
			super(ID, packetClass, name);
		}
	}
}