package game.ui.message 
{
	/**
	 * ...
	 * @author MaiPTT
	 */
	public class MessageID 
	{
		public static const TRANMISSION_SUCCESS		:int = 1;
		public static const TRANMISSION_FAIL		:int = 2;		
		public static const UP_STAR_SUCCESS			:int = 3;
		public static const UP_STAR_FAIL			:int = 4;
		public static const UP_CLASS_SUCCESS		:int = 5;
		public static const UP_CLASS_FAIL			:int = 6;
		public static const TRANMISSION_INVALID_IN_FORMATION		:int = 7;
		public static const TRANMISSION_INVALID_MAIN_CHAR			:int = 8;
		public static const TRANMISSION_INVALID_RECURSOR			:int = 9;
		public static const TRANMISSION_INVALID_LEGENDARY			:int = 10;
		public static const TRANMISSION_OVERCOMING_CHARACTER		:int = 11;
		public static const UP_STAR_NOT_ENOUGH_ITEMS				:int = 14;
		public static const SHOP_HEROES_BUY_SUCCESS					:int = 17;
		public static const SHOP_HEROES_BUY_FAIL					:int = 18;
		public static const LEVEL_UP_MAX_STARS						:int = 23;
		public static const UPGRADE_SOUL_FAIL_BY_MAX_LEVEL			:int = 32;
		public static const LOGIN_CONFLICT_ACC						:int = 33;
		public static const REGISTER_EXISTED_ROLE_NAME				:int = 34;
		public static const NOT_ENOUGH_GOLD							:int = 43;
		public static const NOT_ENOUGH_XU							:int = 49;
		
		public static const PVP1vs1AI_RECEIVED_REWARD_SUCCESS		:int = 50;
		public static const PVP1vs1AI_RECEIVED_REWARD_FAIL			:int = 51;
		public static const PVP1vs1AI_NOT_ENOUGH_XU_REFRESH_TIME	:int = 52;
		public static const PVP1vs1AI_NOT_ENOUGH_XU_SKIP_LIMIT		:int = 55;
		public static const PVP1vs1AI_REACH_LIMIT_PAY_GAME			:int = 93;
		
		
		public static const PVP1vs1MM_RECEIVED_REWARD_SUCCESS			:int = 57;
		public static const PVP1vs1MM_RECEIVED_REWARD_FAIL				:int = 58;
		public static const PVP1vs1MM_NOT_ENOUGH_XU_SKIP_LIMIT			:int = 59;
		
		public static const QUEST_MAIN_SELECT_OPTION_REWARD_TO_FINISH	:int = 60;
		public static const QUEST_MAIN_FINISH_FAIL_BY_FULL_INVENTORY	:int = 85;
		
		public static const QUEST_TRANSPORT_CAN_NOT_USE_UNIT				:int = 53;
		public static const QUEST_TRANSPORT_FAIL_UNIT_CONDITION				:int = 91;
		public static const QUEST_TRANSPORT_RECEIVE_REWARD_BEFORE_REFRESH	:int = 61;
		public static const QUEST_TRANSPORT_FINISH_QUEST_BEFORE_REFRESH		:int = 62;
		public static const QUEST_TRANSPORT_FINISH_FAIL_BY_FULL_INVENTORY	:int = 63;
		public static const QUEST_TRANSPORT_FINISH_FAIL_BY_NOT_ENOUGH_XU	:int = 64;
		public static const QUEST_TRANSPORT_REACH_MAX_COMPLETED				:int = 70;
		
		public static const QUEST_DAILY_FINISH_FAIL_BY_FULL_INVENTORY	:int = 65;
		public static const QUEST_DAILY_REFRESH_FAIL_BY_NOT_ENOUGH_XU	:int = 66;
		public static const QUEST_DAILY_FINISH_FAIL_BY_NOT_ENOUGH_XU	:int = 67;
		public static const QUEST_DAILY_REACH_MAX_COMPLETED				:int = 54;
		
		public static const UPGRADE_SKILL_SUCCESS						:int = 71;
		public static const UPGRADE_SKILL_FAIL_BY_NOT_ENOUGH_SCROLL		:int = 72;
		public static const UPGRADE_SKILL_FAIL							:int = 73;
		
		public static const PVP3vs3MM_RECEIVED_REWARD_SUCCESS		:int = 74;
		public static const PVP3vs3MM_RECEIVED_REWARD_FAIL			:int = 75;
		
		public static const SHOP_ITEM_BUY_FAIL_FULL_INVENTORY		:int = 86;
		public static const SHOP_ITEM_BUY_FAIL_NOT_ENOUGH_MONEY		:int = 87;
		public static const SHOP_ITEM_BUY_FAIL_REACH_MAX_QUANTITY	:int = 88;
		public static const SHOP_ITEM_BUY_FAIL_OUT_OF_TIME			:int = 89;
		public static const SHOP_ITEM_BUY_FAIL_NOT_ENOUGH_LEVEL		:int = 90;
		public static const SHOP_ITEM_BUY_FAIL						:int = 76;
		public static const SHOP_ITEM_BUY_SUCCESS					:int = 77;
		
		public static const FAIL_MERGE_BY_NO_ITEM_RECIPE			:int = 78;
		public static const SUCCESS_MERGE_SOUL						:int = 79;
		public static const SUCCESS_EQUIP_SOUL						:int = 95;
		public static const FAIL_EQUIP_SOUL_TYPE_BY_MAX_LIMIT		:int = 96;
		
		//for tuu lau chien
		public static const SUCCESS_ACTIVE_BUFF_RESOURCE_INFO		:int = 97;
		public static const FAIL_ACTIVE_BUFF_RESOURCE_INFO			:int = 98;
		public static const FAIL_ACTIVE_BUFF_BY_OVER_TIME_EXPIRE	:int = 99;
		public static const FAIL_ACTIVE_BUFF_BY_NOT_ENOUGH_GOLD		:int = 100;
		public static const FAIL_BY_ALREADY_BUFFED_BEFORE			:int = 101;
		public static const SUCCESS_ACTIVE_PROTECT_RESOURCE_INFO	:int = 102;
		public static const FAIL_ACTIVE_PROTECT_RESOURCE_INFO		:int = 103;
		public static const FAIL_ACTIVE_PROTECT_BY_NOT_ENOUGH_GOLD	:int = 104;
		public static const FAIL_ACTIVE_PROTECT_BY_OVER_NUM_PER_DAY	:int = 105;
		public static const FAIL_BY_ALREADY_PROTECTED_BEFORE		:int = 106;		
		public static const TUU_LAU_CHIEN_GUIDE						:int = 155;
		
		public static const CHANGE_FORMATION_ERROR_ID				:int = 80;
		public static const CHANGE_FORMATION_ERROR_DUP				:int = 81;
		public static const CHANGE_FORMATION_ERROR_FULL				:int = 82;
		public static const CHANGE_FORMATION_ERROR_MAIN_PLAYER		:int = 83;
		public static const UPGRADE_SKILL_FAIL_BY_REACH_CHARACTER_LEVEL	:int = 84;
		
		public static const OUT_OF_AUTO_DIVINE_IN_DAY				:int = 92;
		public static const ARENA_JOIN_FAILED_BY_NOT_SELECT_ROOM	:int = 94;
		
		public static const ATTACH_SOUL_FAIL_BY_RECIPE				:int = 120;
		public static const MERGE_SOUL_FAIL_BY_RECIPE				:int = 121;
		public static const METAL_FURNACE_WAITNG				:int = 122;
		public static const METAL_FURNACE_OUT_OF_TURN				:int = 123;
		
		public static const PLAY_GAME_ERROR_CODE					:int = 1000;
		
	}
}