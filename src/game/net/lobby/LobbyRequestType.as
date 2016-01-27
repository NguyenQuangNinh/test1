package game.net.lobby
{
	

	public class LobbyRequestType
	{
		public static const LOGIN:int 						= 0;
		public static const CHECK_NEW_USER:int				= 1;
		public static const CHECK_ROLE_NAME:int				= 2;
		public static const GET_PLAYERS:int 				= 3;
		public static const GET_FORMATION:int 				= 4;
		public static const SAVE_FORMATION:int 				= 5;
		public static const GET_CHARACTERS:int 				= 6;	//dup
		public static const GET_CHARACTER_INFO:int 			= 7;
		public static const REMOVE_CHARACTER:int			= 8;
		public static const LEVEL_UP_ENHANCEMENT:int		= 9;
		public static const LEVEL_UP_CLASS:int 				= 10;
		public static const GET_PLAYER_INFO:int 			= 11;
		public static const GET_CAMPAIGN_INFO:int 			= 12;
		public static const GET_CAMPAIGN_REWARD:int			= 13;
		public static const LEVEL_UP_STAR:int 				= 14;
		public static const GET_UP_STAR_ADDITION_RATE:int 	= 15;
		public static const GET_ITEM_INVENTORY:int 			= 16;
		public static const UPGRADE_SKILL:int				= 17;
		public static const GET_PLAYER_INFO_ATTRIBUTE:int	= 18;
		public static const LEADER_BOARD:int				= 19;
		public static const LIST_CHALLENGE_RANKING:int		= 20;
		public static const LIST_FORMATION_TYPE:int			= 21;
		public static const UPGRADE_FORMATION_TYPE:int		= 22;
		public static const CONSUME_ITEM:int 				= 24;
		public static const GET_SHOP_HEROES:int 			= 25;
		public static const ACTIVE_FORMATION_TYPE:int 		= 26;
		public static const TOP_LEADER_BOARD:int			= 27;
		public static const SOUL_CRAFT:int					= 28;
		public static const AUTO_SOUL_CRAFT:int				= 29;
		public static const GET_SOUL_INFO:int 				= 30;
		public static const SELL_SOUL:int 					= 31;
		public static const SELL_FAST_SOUL:int 				= 32;
		public static const COLLECT_SOUL:int 				= 33;
		public static const COLLECT_FAST_SOUL:int 			= 34;
		public static const UPGRADE_SOUL :int 				= 35;
		public static const MERGE_SOUL :int					= 36;
		public static const EQUIP_SOUL :int					= 37;
		public static const CHARACTER_INFO_BY_UNIT_ID:int	= 38;
		
		public static const CHALLENGE_HISTORY:int 			= 39;
		public static const SOUL_INVENTORY:int 				= 40;
		public static const INVENTORY_SELL_ITEM:int 		= 42;
		public static const GET_SERVER_TIME:int				= 43;
		public static const SWAP_SOUL_INV:int 				= 44;
		public static const SWAP_SOUL_INV_EQUIP:int 		= 45;
		
		//for quest transport module
		public static const QUEST_TRANSPORT_INFO:int 			= 46;
		public static const QUEST_TRANSPORT_ACTIVE:int 			= 47;
		public static const QUEST_TRANSPORT_RENT:int 			= 48;
		public static const QUEST_TRANSPORT_REFRESH:int			= 49;
		public static const QUEST_TRANSPORT_SKIP:int 			= 50;
		public static const QUEST_TRANSPORT_CLOSE:int 			= 51;
		public static const QUEST_TRANSPORT_REPUTE_POINT:int	= 52;
		public static const QUEST_TRANSPORT_STATE:int 			= 53;
		public static const QUEST_TRANSPORT_LIST_SASTIFIED:int	= 54;
		
		public static const	UNIT_CHANGE_SKILL:int 					= 55;
		public static const LEADER_BOARD_PLAYER_FORMATION_INFO:int	= 56;
		public static const METAL_FURNACE:int 						= 57;
		
		//for quest main module
		public static const QUEST_MAIN_STATE:int 			= 58;
		public static const QUEST_MAIN_INFO:int 			= 59;
		public static const QUEST_MAIN_CLOSE:int 			= 60;		
		public static const UNLOCK_SLOT:int 				= 61;		
		public static const HEAL_AP:int 					= 62;		
		public static const HEAL_HP:int 					= 63;		
		public static const QUEST_MAIN_NEW_INFO:int			= 137;
		
		//for quest daily module
		public static const QUEST_DAILY_STATE:int			= 64;
		public static const QUEST_DAILY_INFO:int			= 65;
		public static const QUEST_DAILY_CLOSE:int			= 66;
		public static const QUEST_DAILY_QUICK_COMPLETE:int	= 67;
		public static const QUEST_DAILY_REFRESH:int			= 68;
		public static const QUEST_DAILY_NEW_INFO:int		= 138;
		//public static const QUEST_DAILY_ACCUMULATE_INFO:int	= 69;
		//public static const QUEST_DAILY_ACCUMULATE_CLOSE:int= 70;
		
		//for pvp 1vs1 AI ~ Hoa Son Luan Kiem
		public static const PVP1vs1AI_STATE:int				= 71;
		public static const PVP_RECEIVED_REWARD:int 		= 73;
		
		public static const PVP1vs1AI_REFRESH_TIME:int		= 75;
		public static const PVP1vs1AI_SKIP_LIMIT:int 		= 76;
		
		public static const EXTEND_RECRUITMENT_SHOP_HEROES:int 		= 78;
		//for pvp 1vs1 MM ~ Vo Lam Minh Chu
		public static const PVP1vs1_MM_STATE:int					= 79;
		public static const PVP1vs1_MM_HISTORY_TOP_LEADER_BOARD:int = 81;
		
		//for pvp 3vs3 MM ~ Tam Hung Ki Hiep
		public static const PVP3vs3_MM_STATE:int					= 84;
		public static const PVP3vs3_MM_HISTORY_TOP_LEADER_BOARD:int = 85;
		public static const GLOBAL_BOSS_LEAVE_GAME:int 		= 86;
		public static const SELECT_GLOBAL_BOSS_INFO:int		= 87;
		public static const GLOBAL_BOSS_BUFF_GOLD:int 		= 89;
		public static const GLOBAL_BOSS_BUFF_XU:int 		= 90;
		public static const GLOBAL_BOSS_REVIVE:int 			= 91;
		public static const GLOBAL_BOSS_AUTO_PLAY:int 		= 92;
		public static const GLOBAL_BOSS_MY_DMG:int			= 93;
		public static const GLOBAL_BOSS_TOP_DMG:int			= 94;
		public static const GLOBAL_BOSS_AUTO_REVIVE:int		= 95;
		public static const GLOBAL_BOSS_HP:int				= 96;
		public static const GLOBAL_BOSS_MISSION_INFO:int	= 97;
		public static const GLOBAL_BOSS_LIST_PLAYERS:int 	= 98;
		public static const GET_TOP_LEVEL_IN_PRESENT:int	= 100;
		public static const GLOBAL_BOSS_START_REVIVE_COUNT_DOWN:int	= 101;
		public static const GET_HEROIC_TOWER_LIST:int		= 102;
		public static const HEROIC_TOWER_START_AUTOPLAY:int			= 103;
		public static const HEROIC_TOWER_STOP_AUTOPLAY:int			= 104;
		public static const HEROIC_TOWER_GET_AUTOPLAY_REWARD:int	= 105;
		public static const GET_HEROIC_INFO:int				= 106;
		
		public static const EXTEND_RECRUITMENT:int			= 77;
		public static const REQUEST_LUCKY_GIFT:int			= 80;
		public static const PVP1vs1MATCHING_SKIP_LIMIT:int 	= 82;
		public static const GET_INVENTORY_SLOT_INFO:int		= 83;		//dup
		
		public static const GET_REWARD_GIFT_CODE:int		= 88;
		
		public static const GET_REWARD_REQUIRE_LEVEL_INFO:int	= 107;
		public static const RECEIVE_REWARD_REQUIRE_LEVEL:int	= 108;
		public static const QUEST_TRANSPORT_CLEAR_QUEST:int		= 109;
		public static const HEROIC_TOWER_INSTANT_FINISH:int		= 110;
		public static const HEROIC_BUY_PLAYING_TIMES:int 		= 111;
		public static const HEROIC_TOWER_BUY_EXTRA_TURN:int 	= 112;
		public static const HEROIC_FINISH_MISSIONS:int 			= 113;
		public static const CHANGE_SKILL_BOOK:int 				= 114;
		public static const CHANGE_FORMATION_TYPE_BOOK:int 		= 115;
		
		public static const HEROIC_TOWER_USE_ITEM:int = 117;
		
		//event
		public static const GET_PAYMENT_EVENT_INFO:int 			= 118;
		public static const RECEIVE_PAYMENT_EVENT_REWARD:int 	= 119;
		public static const GET_CONSUME_EVENT_INFO:int 			= 120;
		public static const RECEIVE_CONSUME_EVENT_REWARD:int 	= 121;
		public static const GLOBAL_BOSS_NOTIFY_JOIN:int			= 122;
		public static const GET_GIFT_ONLINE_INFO:int 			= 123;
		public static const RECEIVE_GIFT_ONLINE_REWARD:int 		= 124;
		public static const GET_LIST_ITEM_BOUGHT_SHOP_DAILY:int	= 125;	
		public static const GET_PLAYER_PROFILE:int 				= 126;
		public static const GET_PLAYER_CHARACTER_INFO:int 		= 127;
		public static const SECRET_MERCHANT_INFO:int 			= 128;
		public static const SECRET_MERCHANT_LIST_PLAYERS:int 	= 129;
		public static const SECRET_MERCHANT_EVENT_ID:int 		= 130;
		public static const SWAP_ITEM_INVENTORY:int 			= 131;
		public static const SORT_ITEM_INVENTORY:int 			= 132;
		public static const TUTORIAL_FINISHED_SCENE:int			= 134;
		public static const LOCK_SOUL_INVENTORY:int				= 135;		
		public static const GET_TUTORIAL_FINISHED_SCENE:int		= 136;
		public static const GET_SHOP_VIP_INFO:int				= 139;
		public static const LOG_TUTORIAL:int					= 140;
		public static const FIRST_CHARGE_REWARD:int				= 142;
		public static const DAILY_TASK_INFO:int					= 143;
		public static const USE_SPEAKER:int						= 144;
		public static const LOGIC_CHECK_IN :int					= 145;
		public static const ALCHEMY_SKIP_TIMEWAIT :int			= 146;
		public static const SWEEP_CAMPAIGN :int					= 147;
		public static const CAMPAIGN_CANCEL_SWEEP	 :int		= 148;
		public static const CAMPAIGN_QUICK_SWEEP	 :int		= 149;
		public static const GET_CAMPAIGN_SWEEP_REWARD :int		= 150;
		public static const EVENT_GET_INFO :int					= 151;
		public static const EVENT_RECEIVE_REWARD :int			= 152;
		public static const EVENT_BUY_ITEM_ACTIVE :int			= 153;
		public static const EVENT_CONVERT_ITEM :int				= 154;
		public static const EVENT_GET_AVAILABLE_EVENTS :int		= 155;
		
		//tuu lau chien
		public static const LIST_RESOURCES_OCCUPIED:int			= 157;
		public static const RESOURCE_INFO:int					= 158;
		public static const OWNER_RESOURCE_INFO:int				= 159;
		public static const ACTIVE_RESOURCE_BUFF:int			= 160;
		public static const ACTIVE_RESOURCE_PROTECT:int 		= 161;
		public static const CANCEL_RESOURCE_OCCUPIED:int		= 162;		
		
		public static const FRIEND_GIVE_AP :int					= 163;
		public static const FRIEND_RECEIVE_AP :int				= 164;

		public static const EXPRESS_GET_LIST :int				= 165;
		public static const EXPRESS_GET_PORTER_INFO :int				= 166;
		public static const EXPRESS_GET_PLAYER_INFO :int				= 167;
		public static const EXPRESS_REFRESH :int				= 168;
		public static const EXPRESS_HIRE_RED_PORTER :int		= 169;
		public static const EXPRESS_START :int				= 170;

		public static const TREASURE_REQUEST_REWARD :int		= 173;
		public static const TREASURE_REQUEST_LOG :int			= 174;
		public static const INVENTORY_LOCK_CHARACTER :int			= 175;
		public static const INVENTORY_UNLOCK_CHARACTER :int			= 176;
		public static const CHAR_EVOLUTION_KEEP_LUCK :int			= 177;
		public static const CHECK_BOSS_PAYMENT :int					= 179;
		public static const EXCHANGE_MASTER_INVITATION :int			= 180;
		public static const EXCHANGE_MYSTIC_BOX :int				= 181;
		public static const REQUEST_MYSTIC_BOX_LOG :int				= 182;
		public static const REQUEST_BUY_EXTRA_USE_MYSTIC_BOX:int	= 183;
		
		public static const REQUEST_TUU_LAU_CHIEN_HISTORY:int		= 189;
		public static const DICE_GET_PLAYER_INFO:int				= 184;
		public static const DICE_RECEIVE_REWARD:int					= 185;
		public static const REQUEST_ROLL_DICE:int					= 186;
		public static const REQUEST_BET_DICE:int					= 187;
		public static const REQUEST_DICE_LOG:int					= 188;

		public static const REQUEST_DISCOUNT_SHOP_ITEMS:int					= 190;
		public static const REQUEST_BUY_DISCOUNT_SHOP_ITEM:int					= 191;

		public static const REQUEST_VIP_PROMOTION_PLAYER_INFO:int					= 192;
		public static const REQUEST_BUY_VIP_PROMOTION:int					= 193;

		public static const REQUEST_CHANGE_SKILL:int					= 194;

		public static const PVP2vs2_MM_STATE:int					= 206;

		public static const LOADING_TIME_OUT:int				= 1001;		//time out loading after xxx second (config in gameconfig)
		public static const START_GAME:int 						= 1010;		//start game use common
		public static const LEAVE_GAME:int						= 1003;		//leave room common
		
		public static const ROOM_LIST_PVP:int	 			= 1004;
		public static const GAME_READY:int 					= 1006;		//loading status finish
		public static const UPDATE_LOADING_PERCENT:int		= 1007;		//send request update loading percent of self
		
		public static const JOIN_ROOM_PVP:int 				= 1011;
		public static const GET_PLAYERS_FREE:int			= 1012;		
		public static const NOTIFY_JOIN_ROOM_READY:int		= 1013;	
		public static const REQUEST_MATCHING:int			= 1015;	
		public static const REQUEST_CANCEL_MATCHING:int		= 1016;			
		public static const INVITE_TO_PLAY_GAME:int			= 1017;
		public static const CHANGE_LOBBY_PLAYER_SLOT:int 	= 1018;		
		public static const CONFIRM_CHANGE_LOBBY_SLOT:int	= 1019;
		public static const KICK_LOBBY_PLAYER_SLOT:int		= 1020;
		public static const ENTER_PVE_HEROIC:int			= 1022;
		public static const CREATE_ROOM_HEROIC:int 			= 1023;
		public static const HEROIC_START_GAME:int			= 1024;
		public static const HEROIC_CHANGE_ROOM_FORMATION:int = 1025;
		public static const QUICK_JOIN_BASIC_ROOM:int 		= 1026;
		public static const END_GAME_CONTINUE:int 		 	= 1027;
		public static const HEROIC_GET_CAVE_ID:int 			= 1028;
		public static const HEROIC_INVITE_PLAYER:int 		= 1029;
		public static const HEROIC_ACCEPT_JOIN_ROOM:int 	= 1030;
		public static const HEROIC_KICK:int					= 1031;
		public static const CREATE_BASIC_LOBBY:int			= 1032;
		public static const HEROIC_AUTO_START:int			= 1033;
		
		// training
		public static const TRAIN_READY:int					= 1034;
		public static const TRAIN_START:int					= 1035;
		public static const TRAIN_REWARD:int				= 1036;
		public static const TRAIN_STOP:int					= 1037;
		public static const CHANGE_ROOM_HOST:int					= 1038;

		public static const LOG_LOADING_ACTION:int			= 141;
		
		public static const CHAT_ROOM:int					= 2001;
		public static const CHAT_GLOBAL:int					= 2002;
		public static const CHAT_PRIVATE:int				= 2003;
		public static const CHAT_TEAM:int					= 2013;
		
		public static const MAIL_GET_MAIL:int				= 2008;
		public static const MAIL_DELETE_MAIL:int			= 2011;
		public static const MAIL_READ_MAIL:int				= 2034;
		public static const MAIL_RECEIVE_ATTACHMENT:int		= 2035;
		
		
		public static const ADD_FRIEND_BY_ID:int			= 2004;
		public static const DELETE_FRIEND:int				= 2005;
		public static const REQUEST_FRIEND_LIST:int			= 2006;
		public static const ADD_FRIEND_BY_ROLE_NAME:int		= 2036;
		
		// guild ----------------------
		
		public static const GU_CREATE:int					= 2014;
		public static const GU_GET_OWN_GUILD_INFO:int		= 2015;
		public static const GU_INVITE_SEND:int				= 2016;
		public static const GU_INVITE_ACCEPT:int			= 2017;
		public static const GU_INVITE_REJECT:int			= 2018;
		public static const GU_KICK:int						= 2019;
		public static const GU_JOIN_REQUEST_SEND:int		= 2020;
		public static const GU_JOIN_REQUEST_ACCEPT:int		= 2021;
		public static const GU_JOIN_REQUEST_REJECT:int		= 2022;
		public static const GU_LEAVE:int					= 2023;
		public static const GU_CHANGE_MEMBER_ROLE:int 		= 2024;
		public static const GU_GET_GUILD_INFO:int			= 2025;
		public static const GU_PROMOTE_TO_PRESIDENT:int		= 2026;
		public static const GU_GET_PROFILE_INFO:int			= 2027;
		public static const GU_GET_ACTION_LOG:int			= 2028;
		public static const GU_UPDATE_ANNOUCE:int			= 2029;
		public static const GU_GET_TOTAL_MEMBER:int			= 2030;
		public static const GU_GET_TOTAL_JOIN_REQUEST:int	= 2031;
		public static const GU_GET_JOIN_REQUEST_LIST:int	= 2032;
		public static const GU_GET_MEMBER_LIST:int 			= 2033;
		
		public static const GU_CHAT_SEND_MESSAGE:int 		= 2037;
		public static const GU_GET_FRIEND_LIST:int 		    = 2038;
		public static const GU_UPGRATE_GUILD:int 			= 2039;
		public static const GU_SEARCH_GUILD_NAME:int 		= 2040;
		public static const GU_GET_LEADER_BOARD:int 		= 2041;
		public static const GU_DEDICATED:int 				= 2042;
		public static const GU_GET_ELDER_LIST:int 			= 2043;
		
		public static const AC_GET_ACTIVITY_INFO:int 		= 171;
		public static const AC_GET_ACTIVITY_REWARD:int 		= 172;

		public static const TUTORIAL_GET_TRANSPORT_INDEX:int 		= 178;


		public static const GU_DEDICATED_SKILL:int 			= 2045;
		
		// --------------------
		public static const CHALLENGE_REPLAY_INFO:int 		= 156;
		
		
		//billing
		public static const SHOP_BUY_SINGLE_ITEM:int 		= 3003;
		public static const SHOP_BUY_ITEM_SHOP_VIP:int 		= 3004;

        //than binh
        public static const DIVINE_WEAPON_INVENTORY:int     = 195;
        public static const DIVINE_WEAPON_LOCK_ITEM:int     = 196;
        public static const DIVINE_WEAPON_LOCK_LUCKY_POINT:int     = 197;
        public static const DIVINE_WEAPON_DESTROY_ITEM:int     = 198;
        public static const DIVINE_WEAPON_EQUIP_ITEM:int     = 199;
        public static const DIVINE_WEAPON_UNEQUIP_ITEM:int     = 200;
        public static const DIVINE_WEAPON_UPGRADE_STAR:int     = 201;
        public static const DIVINE_WEAPON_UPGRADE_ATTRIB:int     = 202;
	}
}