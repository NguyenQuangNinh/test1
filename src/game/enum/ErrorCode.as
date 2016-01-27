package game.enum 
{
	/**
	 * ...
	 * @author MaiPTT
	 */
	public class ErrorCode 
	{
		public static const SUCCESS		:int = 0;
		public static const FAIL		:int = 1;
		
		public static const UP_STAR_NOT_ENOUGH_GOLD		:int = 2;
		public static const UP_STAR_BAD_LUCK			:int = 3;
		public static const UP_STAR_NOT_ENOUGH_ITEMS	:int = 4;
		public static const UP_STAR_NOT_ENOUGH_XU		:int = 5;
		
		public static const EXP_TRANSFER_CURRENTLY_IN_FORMATION:int = 2;
		public static const EXP_TRANSFER_NOT_ENOUGH_GOLD:int = 5;
		public static const EXP_TRANSFER_OVERCOMING:int = 7;
		public static const EXP_TRANSFER_FULL:int = 8;
		
		public static const UNLOCK_SLOT_NOT_ENOUGH_GOLD:int = 2;
		
		public static const EXTEND_RECRUITMENT_NOT_ENOUGH_RESOURCE:int = 2;
		
		public static const HEROIC_TOWER_USE_ITEM_NOT_ENOUGH_XU:int = 2;
		public static const HEROIC_TOWER_BUY_EXTRA_TURN_NOT_ENOUGH_XU:int = 2;
		public static const CHALLENGE_CENTER_AUTO_NOT_VIP:int = 2;
		
		public static const INVITE_PLAYER_OUT_OF_TURN:int = 5;
		public static const INVITE_PLAYER_LEVEL_REQUIREMENT:int = 7;
		
		public static const ADD_FRIEND_EXISTED:int = 2;
		public static const ADD_FRIEND_NO_EXIST_FRIEND:int = 3;
		public static const ADD_FRIEND_MAX_FRIENDS:int = 4;
		
		public static const CAST_SKILL_GLOBAL_COOLDOWN:int = 0;
		public static const CAST_SKILL_STUNNED:int = 1;
		public static const CAST_SKILL_SILENCED:int = 2;
		public static const CAST_SKILL_NOT_ENOUGH_MANA:int = 3;
		public static const CAST_SKILL_KNOCKED_BACK:int = 4;
		
		public static const QUICK_JOIN_HEROIC_CAMPAIGN_NO_ROOM_AVAILABLE:int = 5;
		
		public static const MAIL_CLAIM_ITEM_MAIL_EXPIRED:int = 2;
		public static const MAIL_CLAIM_ITEM_INVENTORY_FULL:int = 3;

		public static const FULL_ITEM_INVENTORY:int = 100;
		public static const FULL_UNIT_INVENTORY:int = 101;
	}

}