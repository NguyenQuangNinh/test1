package game.enum 
{
	/**
	 * ...
	 * @author MaiPTT
	 */
	public class GameConfigID 
	{
		public static const EXP_TABLE									:int = 4;
		public static const AP_INIT_CAPACITY							:int = 5;
		public static const DEFAULT_NUM_CHARACTER_SLOTS					:int = 6;
		public static const TIME_PER_AP					                :int = 7;
		public static const COST_TRANSMISSION							:int = 22;
		public static const UP_CLASS_CONDITIONS							:int = 33;
		public static const COST_UP_CLASS								:int = 23;
		public static const TRANMISSION_GENERATING_PERCENT				:int = 8;
		public static const TRANMISSION_OVERCOMING_PERCENT				:int = 11;
		public static const UP_STAR_ITEMS_REQUIREMENT					:int = 16;
		public static const MAIN_CHARACTER_IDS							:int = 14;
		public static const INIT_ITEM_INVENTORY_SIZE					:int = 24;
		public static const COST_UPGRADE_SKILL							:int = 28;
		public static const ITEM_UPGRADE_SKILL							:int = 29;
		public static const PERCENT_UPGRADE_SKILL						:int = 31;
		public static const INIT_SOUL_INVENTORY_SIZE					:int = 34;
		
		public static const STAR_OPEN_SLOT_SOUL_UNIT					:int = 41;

		public static const TIME_OPEN_PVP_AI							:int = 45;
		public static const TIME_OPEN_PVP_MATCHING						:int = 46;
		
		public static const QUEST_TRANSPORT_MAX_QUEST_PER_DAY			:int = 44;
		public static const QUEST_TRANSPORT_NUM_QUEST_RAN				:int = 48;
		public static const QUEST_TRANSPORT_TIME_REFRESH				:int = 50;
		public static const QUEST_TRANSPORT_PRICE_BASE					:int = 51;
		
		
		public static const UP_STAR_ITEM_ID								:int = 47;
		public static const MAX_SAME_SOUL_EQUIP_PER_CHARACTER			:int = 49;
		
		public static const GLOBAL_SKILL_COOLDOWN						:int = 61;
		
		public static const MAX_ALCHEMY_IN_DAY							:int = 65;
		public static const UNLOCK_SLOT_UNIT_BLOCKS						:int = 66;
		public static const UNLOCK_SLOT_UNIT_COSTS						:int = 67;
		
		public static const UNLOCK_SLOT_ITEM_BLOCKS						:int = 68;
		public static const UNLOCK_SLOT_ITEM_COSTS						:int = 69;
			
		public static const AP_LIST_BY_VIP								:int = 72;
		public static const HEAL_HP_VIP_LIST							:int = 73;
		public static const HEAL_HP_XU_LIST								:int = 74;
		public static const HEAL_HP_TOTAL_ADDED_HP_LIST					:int = 75;
		
		public static const FIRST_CHARE_REWARDS							:int = 81;
		
		public static const ATTENDANCE_REWARDS							:int = 84;
		
		public static const QUEST_DAILY_PRICE_REFRESH					:int = 146;
		public static const QUEST_DAILY_PRICE_REFRESH_VIP				:int = 89;
		public static const QUEST_DAILY_PRICE_FINISH					:int = 90;
		
		public static const CHANGE_SKILL_PRICE							:int = 91;
		public static const CHANGE_FORMATION_TYPE_PRICE					:int = 92;
		
		public static const HEAL_AP_QUANTITY_LIST						:int = 93;
		public static const HEAL_AP_DISCOUNT_LIST						:int = 94;
		public static const COST_REFRESH_TIME_PER_PVP1vs1_AI			:int = 95;	
		public static const COST_SKIP_LIMIT_PLAY_TIME_DAILY_PVP1vs1_AI	:int = 105;
		public static const CONSUME_XU_NEED_CHANGE_LUCKY_GIFT_TIME		:int = 106;
		public static const ARR_HERO_SHOP_ID							:int = 107;
		 
		public static const ARR_ALCHEMY_GOLD_BY_LEVEL					:int = 109;
		public static const ARR_ALCHEMY_XU_NEED_BY_TIME					:int = 110;
		
		public static const ARR_ID_CHAMPION_REWARD						:int = 111;
		
		public static const REWARD_LUCKY_GIFT_LIST						:int = 112;
		
		public static const COST_SKIP_LIMIT_PLAY_TIME_DAILY_PVP1vs1_MM	:int = 114;
		public static const XU_NEED_RECEIVE_GIFT_ONLINE_FAST			:int = 115;
		public static const MAX_MAIL_INBOX								:int = 116;
		public static const MAX_ADD_FRIEND								:int = 117;
		
		public static const TIME_GIFT_ONLINE							:int = 123;
		public static const GIFT_ONLINE_REWARD_NORMAL					:int = 124;
		
		public static const DAY_RECEIVE_TOP_LEVEL						:int = 125;
		public static const MAX_LOADING_TIME_OUT						:int = 128;
		public static const TIME_WAIT_ALCHEMY						:int = 136;
		public static const COST_SKIP_TIME_WAIT_ALCHEMY						:int = 137;
        public static const CAMPAIGN_MAX_SWEEP:int = 143;
        public static const CAMPAIGN_SWEEP_TIME:int = 144;

        public static const CAMPAIGN_SWEEP_QUICK_FINISH_COST:int = 145;
        public static const QUEST_TRANSPORT_PRICE_REFRESH				:int = 147;
		
        public static const QUEST_TRANSPORT_REWARD_SKILL_BOOK_NUM_ARR	:int = 151;
        public static const QUEST_TRANSPORT_REWARD_GOLD_BASE			:int = 152;
        public static const QUEST_TRANSPORT_REWARD_EXP_BASE				:int = 153;
        public static const QUEST_TRANSPORT_REWARD_RATE_ON_TYPE_ARR		:int = 154;
		
		// guild config --
        public static const GUILD_CREATE_XU_PRICE:int = 96;
        public static const GUILD_REQUIRED_LEVEL:int = 148;
        public static const GUILD_MAX_INVITE_TIME:int = 97;
        public static const GUILD_MAX_MEMBER_BASE:int = 98;
        public static const GUILD_MAX_MEMBER_ADDED_ARR:int = 99;
        public static const GUILD_MAX_LOG_ACTION:int = 100;
        public static const GUILD_PROMOTE_PRESIDENT_DELAY:int = 101;
        public static const GUILD_DELAY_AFTER_LEAVE:int = 102;
        public static const GUILD_LEVEL_UP_DP_COST:int = 103;
		
        public static const GUILD_ACTIVITY_DAILY_QUEST_ARR:int = 155;
        public static const GUILD_ACTIVITY_TRANSPORT_QUEST_ARR:int = 156;
        public static const GUILD_ACTIVITY_CAMPAIN_ARR:int = 157;
        public static const GUILD_ACTIVITY_PVP1VS1_ARR:int = 158;
        public static const GUILD_ACTIVITY_PVP3VS3MM_ARR:int = 159;
        public static const GUILD_ACTIVITY_PVP1VS1MM_ARR:int = 160;
        public static const GUILD_ACTIVITY_HEROIC_ARR:int = 161;
        public static const GUILD_ACTIVITY_GLOBALL_BOSS_ARR:int = 162;
        public static const GUILD_ACTIVITY_TOWER_ARR:int = 163;
        public static const GUILD_ACTIVITY_AL_CHEMY_ARR:int = 164;
        public static const GUILD_ACTIVITY_SOUL_ARR:int = 165;
        public static const GUILD_ACTIVITY_SKILL_ARR:int = 166;
        public static const GUILD_ACTIVITY_DEDICATE_ARR:int = 167;
		
        public static const GUILD_ACTIVITY_REWARD_POINT_ARR:int = 168;
        public static const GUILD_ACTIVITY_REWARD_ITEM_ARR:int = 222;
		
		public static const GUILD_DEDICATED_XU_MAX_TIME:int = 170;
		public static const GUILD_DEDICATED_GOLD_COST_ARR:int = 171;
        public static const GUILD_DEDICATED_GOLD_RECEIVE_ARR:int = 172;
        public static const GUILD_DEDICATED_XU_COST_ARR:int = 173;
        public static const GUILD_DEDICATED_XU_RECEIVE_ARR:int = 174;
        public static const GUILD_DEDICATED_GOLD_MAX_TIME:int = 175;
		
		// kungfu traning ---
        public static const KUNGFU_TRAIN_DURATION_IN_MINUTE:int = 176;
        public static const KUNGFU_TRAIN_MASTER_MAX_TIME:int = 177;
        public static const KUNGFU_TRAIN_PARTNER_MAX_TIME:int = 178;
        public static const KUNGFU_TRAIN_REWARD_DELAY_IN_SECOND:int = 179;
        public static const KUNGFU_TRAIN_EXP_REWARD:int = 180;
        public static const KUNGFU_TRAIN_LEVEL_DIFF_MIN:int = 181;
        public static const KUNGFU_TRAIN_LEVEL_DIFF_MAX:int = 182;
		// ------------------------------------------
		
        public static const GUILD_SKILL_ADDITIONAL_VITALITY:int = 195;
        public static const GUILD_SKILL_ADDITIONAL_STRENGTH:int = 196;
        public static const GUILD_SKILL_ADDITIONAL_AGILITY:int = 197;
        public static const GUILD_SKILL_ADDITIONAL_INTELLIGENT:int = 198;
		
        public static const GUILD_SKILL_DP_LEVEL_REQUIRES:int = 199;
        public static const GUILD_SKILL_DEDICATED_POINT:int = 200;
		
		public static const AC_ACTIVITY_REWARD_ITEM_ARR:int = 169;

		public static const TREASURE_MAX_DIG:int = 223;
		public static const TREASURE_PRICES:int = 224;
		public static const TREASURE_REWARDS_ID:int = 226;
		public static const TREASURE_TIME_START:int = 227;
		public static const TREASURE_TIME_END:int = 228;
		
		//tuu lau chien
		public static const ARRAY_PERCENT_REWARD_PER_RESOURCE_TYPE:int = 183;
		public static const TIME_RECEIVE_REWARD_OCCUPIED_RESOURCE:int = 184;
		public static const MAX_TIME_OCCUPY_PER_RESOURCE:int = 185;
		public static const MAX_TIME_ROB_ENABLE:int = 186;
		public static const MAX_NUM_OCCUPY_IN_DAY_PER_PLAYER:int = 187;
		public static const MAX_NUM_OCCUPY_IN_DAY_PER_RESOURCE:int = 189;
		public static const MAX_TIME_BUFF_ENABLE:int = 190;
		public static const MAX_NUM_ACTIVE_PROTECTED_PER_DAY:int = 191;
		public static const PRICE_ACTIVE_BUFF_PER_DAY:int = 192;
		public static const PRICE_ACTIVE_PROTECT_PER_DAY:int = 193;
		public static const ARRAY_REWARD_PER_CAMPAIGN_TYPE:int = 242;
		public static const TIME_FROZEN_FOR_EACH_ACTION_ATTACK_RESOURCE: int = 271;

		//thần binh
        public static const DIVINE_WEAPON_MAX_LUCKY_POINT:int = 288;
        public static const DIVINE_WEAPON_MAX_ATTRIB_LEVEL:int = 290;
		// -----------------
		
	}

}