package game.enum 
{
	import core.util.Enum;
	/**
	 * ...
	 * @author MaiPTT
	 */
	public class NotifyType extends Enum
	{
		public static const NOTIFY_REWARD_LEVEL			:NotifyType = new NotifyType(0, "level_notify");	
		public static const NOTIFY_NEW_MAIL				:NotifyType = new NotifyType(1, "mail_notify");	
		public static const NOTIFY_NEW_FORMATION_TYPE	:NotifyType = new NotifyType(2, "formation_type_notify");	
		
		public static const NOTIFY_QUEST_MAIN			:NotifyType = new NotifyType(3, "quest_main");
		public static const NOTIFY_QUEST_TRANSPORTER	:NotifyType = new NotifyType(4, "quest_transporter");
		public static const NOTIFY_QUEST_DAILY			:NotifyType = new NotifyType(5, "quest_daily");
		
		public static const NOTIFY_NEW_VIP				:NotifyType = new NotifyType(6, "new_vip");
		public static const NOTIFY_CHANGE_RANK_PVP_AI	:NotifyType = new NotifyType(7, "change_rank_pvp_ai");
		public static const NOTIFY_ACTIVITY				:NotifyType = new NotifyType(8, "activity_reward_receivable");
		public static const NOTIFY_FRIEND				:NotifyType = new NotifyType(9, "friends");
		public static const NOTIFY_TUU_LAU_CHIEN		:NotifyType = new NotifyType(10, "tuu lau chien");
		public static const NOTIFY_SHOP_DISCOUNT		:NotifyType = new NotifyType(11, "shop discount");

		//public static const NOTIFY_ARENA_REWARD			:NotifyType = new NotifyType(6, "arena_reward");
		//public static const NOTIFY_CHALLENGE_REWARD		:NotifyType = new NotifyType(7, "challenge_reward");
		//
		//public static const NOTIFY_ARENA_3VS3MM_OPEN	:NotifyType = new NotifyType(8, "arena_3vs3MM_open");
		//public static const NOTIFY_ARENA_1VS1MM_OPEN	:NotifyType = new NotifyType(9, "arena_1vs1MM_open");
		
		
		public function NotifyType(ID:int, name:String = "") {
			super(ID, name);
		}
	}

}