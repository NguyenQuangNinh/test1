package game.ui.hud
{
	import core.util.Enum;

	import game.ui.ModuleID;

	public class HUDButtonID extends Enum
	{
		public static const WORLD_BOSS:HUDButtonID = new HUDButtonID(14, [ModuleID.HOME, ModuleID.WORLD_MAP]
				, "worldBossBtn");
		public static const RENT_CHARACTER:HUDButtonID = new HUDButtonID(17, [ModuleID.HOME, ModuleID.WORLD_MAP]
				, "rentCharacterBtn");
		public static const PVP_RANKING:HUDButtonID = new HUDButtonID(15, [ModuleID.HOME, ModuleID.WORLD_MAP]
				, "pvpRankingBtn");
		public static const QUEST_DAILY:HUDButtonID = new HUDButtonID(16, [ModuleID.HOME, ModuleID.WORLD_MAP]
				, "questDailyBtn");
		public static const CHANGE_FORMATION:HUDButtonID = new HUDButtonID(11, [ModuleID.HOME, ModuleID.WORLD_MAP, ModuleID.HEROIC_TOWER, ModuleID.GLOBAL_BOSS, ModuleID.LOBBY, ModuleID.EXPRESS]
				, "changeFormationBtn");
		public static const FORMATION_TYPE:HUDButtonID = new HUDButtonID(10, [ModuleID.HOME, ModuleID.WORLD_MAP, ModuleID.HEROIC_TOWER, ModuleID.GLOBAL_BOSS, ModuleID.HEROIC_MAP, ModuleID.HEROIC_LOBBY, ModuleID.LOBBY, ModuleID.EXPRESS]
				, "formationTypeBtn");
		public static const FRIEND:HUDButtonID = new HUDButtonID(13, [ModuleID.HOME, ModuleID.WORLD_MAP, ModuleID.HEROIC_TOWER, ModuleID.GLOBAL_BOSS, ModuleID.HEROIC_MAP, ModuleID.HEROIC_LOBBY, ModuleID.EXPRESS]
				, "friendBtn");
		public static const GUILD:HUDButtonID = new HUDButtonID(32, [ModuleID.HOME, ModuleID.WORLD_MAP, ModuleID.HEROIC_TOWER, ModuleID.GLOBAL_BOSS, ModuleID.HEROIC_MAP, ModuleID.HEROIC_LOBBY, ModuleID.EXPRESS]
				, "guildBtn");
		public static const EVENTS_HOT:HUDButtonID = new HUDButtonID(34, [ModuleID.HOME, ModuleID.WORLD_MAP, ModuleID.HEROIC_TOWER, ModuleID.GLOBAL_BOSS, ModuleID.HEROIC_MAP, ModuleID.HEROIC_LOBBY]
				, "eventsHotBtn");
		public static const TREASURE:HUDButtonID = new HUDButtonID(35, [ModuleID.HOME, ModuleID.WORLD_MAP, ModuleID.HEROIC_TOWER, ModuleID.GLOBAL_BOSS, ModuleID.HEROIC_MAP, ModuleID.HEROIC_LOBBY]
				, "treasureBtn");
		public static const ACTIVITY:HUDButtonID = new HUDButtonID(33, [ModuleID.HOME, ModuleID.WORLD_MAP, ModuleID.HEROIC_TOWER, ModuleID.GLOBAL_BOSS, ModuleID.HEROIC_MAP, ModuleID.HEROIC_LOBBY]
				, "activityBtn");
		public static const POWER_TRANSFER:HUDButtonID = new HUDButtonID(9, [ModuleID.HOME, ModuleID.WORLD_MAP, ModuleID.HEROIC_TOWER, ModuleID.GLOBAL_BOSS, ModuleID.HEROIC_MAP, ModuleID.HEROIC_LOBBY, ModuleID.LOBBY, ModuleID.EXPRESS]
				, "powerTransferBtn");
		public static const INVENTORY:HUDButtonID = new HUDButtonID(8, [ModuleID.HOME, ModuleID.WORLD_MAP, ModuleID.HEROIC_TOWER, ModuleID.GLOBAL_BOSS, ModuleID.HEROIC_MAP, ModuleID.HEROIC_LOBBY, ModuleID.LOBBY, ModuleID.EXPRESS]
				, "inventoryBtn");
		public static const SOUL:HUDButtonID = new HUDButtonID(7, [ModuleID.HOME, ModuleID.WORLD_MAP, ModuleID.HEROIC_TOWER, ModuleID.GLOBAL_BOSS, ModuleID.HEROIC_MAP, ModuleID.HEROIC_LOBBY, ModuleID.LOBBY, ModuleID.EXPRESS]
				, "soulBtn");
		public static const QUEST_MAIN:HUDButtonID = new HUDButtonID(12, [ModuleID.HOME, ModuleID.WORLD_MAP]
				, "questMainBtn");

		public static const WORLD_MAP:HUDButtonID = new HUDButtonID(1, [ModuleID.HOME]
				, "worldMapBtn");
		public static const ARENA:HUDButtonID = new HUDButtonID(2, [ModuleID.HOME, ModuleID.WORLD_MAP]
				, "arenaBtn");
		public static const METAL_FURNACE:HUDButtonID = new HUDButtonID(3, [ModuleID.HOME, ModuleID.WORLD_MAP, ModuleID.HEROIC_TOWER, ModuleID.GLOBAL_BOSS, ModuleID.HEROIC_MAP, ModuleID.HEROIC_LOBBY]
				, "metalFurnaceBtn");
		public static const LUCKY_GIFT:HUDButtonID = new HUDButtonID(4, [ModuleID.HOME, ModuleID.WORLD_MAP, ModuleID.HEROIC_TOWER]
				, "luckyGiftBtn");
		public static const PRESENT:HUDButtonID = new HUDButtonID(5, [ModuleID.HOME, ModuleID.WORLD_MAP]
				, "presentBtn");
		public static const QUEST_TRANSPORT:HUDButtonID = new HUDButtonID(6, [ModuleID.HOME, ModuleID.WORLD_MAP]
				, "questTransportBtn");

		public static const SOUND:HUDButtonID = new HUDButtonID(28, [ModuleID.HOME, ModuleID.WORLD_MAP, ModuleID.HEROIC_TOWER, ModuleID.GLOBAL_BOSS, ModuleID.HEROIC_MAP, ModuleID.HEROIC_LOBBY, ModuleID.INGAME_PVP]
				, "soundBtn");
		public static const INVITE:HUDButtonID = new HUDButtonID(36, [ModuleID.HOME, ModuleID.WORLD_MAP, ModuleID.HEROIC_TOWER, ModuleID.GLOBAL_BOSS, ModuleID.HEROIC_MAP, ModuleID.HEROIC_LOBBY, ModuleID.INGAME_PVP]
				, "inviteBtn");
		public static const MAIL:HUDButtonID = new HUDButtonID(23, [ModuleID.HOME, ModuleID.WORLD_MAP, ModuleID.EXPRESS]
				, "mailBtn");
		public static const CONSUME_EVENT:HUDButtonID = new HUDButtonID(21, [ModuleID.HOME]
				, "consumeEventBtn");
		public static const CHALLENGE_CENTER:HUDButtonID = new HUDButtonID(18, [ModuleID.HOME]
				, "challengeCenterBtn");

		public static const HEROIC:HUDButtonID = new HUDButtonID(19, [ModuleID.HOME]
				, "heroicBtn");

		public static const CHANGE_RECIPE:HUDButtonID = new HUDButtonID(20, [ModuleID.HOME, ModuleID.WORLD_MAP, ModuleID.EXPRESS]
				, "changeRecipeBtn");
		public static const CHARGE_EVENT:HUDButtonID = new HUDButtonID(22, [ModuleID.HOME]
				, "chargeEventBtn");

		public static const GIFT_ONLINE:HUDButtonID = new HUDButtonID(25, [ModuleID.HOME, ModuleID.HEROIC_TOWER, ModuleID.WORLD_MAP]
				, "giftOnlineBtn");

		public static const LEADER_BOARD:HUDButtonID = new HUDButtonID(24, [ModuleID.HOME, ModuleID.WORLD_MAP]
				, "leaderBoardBtn");
		public static const SHOP_ITEM:HUDButtonID = new HUDButtonID(26, [ModuleID.HOME, ModuleID.WORLD_MAP, ModuleID.HEROIC_MAP, ModuleID.HEROIC_LOBBY, ModuleID.HEROIC_TOWER, ModuleID.GLOBAL_BOSS, ModuleID.LOBBY, ModuleID.EXPRESS]
				, "shopItemBtn");
		public static const SECRET_MERCHANT:HUDButtonID = new HUDButtonID(27, [ModuleID.HOME]
				, "secretMerchantBtn");
		public static const CHAT:HUDButtonID = new HUDButtonID(29, [ModuleID.HOME, ModuleID.WORLD_MAP, ModuleID.HEROIC_TOWER, ModuleID.GLOBAL_BOSS, ModuleID.HEROIC_MAP, ModuleID.HEROIC_LOBBY, ModuleID.LOADING, ModuleID.LOBBY, ModuleID.SHOP]
				, "btnChat");
		public static const DAILY_TASK:HUDButtonID = new HUDButtonID(30, [ModuleID.HOME]
				, "btnDailyTask");
		public static const ATTENDANCE:HUDButtonID = new HUDButtonID(31, [ModuleID.HOME]
				, "btnAttendance");
		public static const TUULAUCHIEN:HUDButtonID = new HUDButtonID(36, [ModuleID.HOME]
				, "tuuLauChienBtn");
				
		public static const KUNGFU_TRAIN:HUDButtonID = new HUDButtonID(40, [ModuleID.HOME]
				, "trainBtn");
		public static const WIKI:HUDButtonID = new HUDButtonID(41, [ModuleID.HOME]
				, "wikiBtn");
		public static const MYSTIC_BOX:HUDButtonID = new HUDButtonID(42, [ModuleID.HOME]
				, "mysticBoxBtn");
		public static const EXPRESS:HUDButtonID = new HUDButtonID(43, [ModuleID.HOME]
				, "expressBtn");
		public static const DICE:HUDButtonID = new HUDButtonID(44, [ModuleID.HOME]
				, "diceBtn");
		public static const SHOP_DISCOUNT:HUDButtonID = new HUDButtonID(45, [ModuleID.HOME]
				, "shopDiscountBtn");
		public static const VIP_PROMOTION:HUDButtonID = new HUDButtonID(46, [ModuleID.HOME]
				, "vipPromotionBtn");
		public static const REDUCE_EFFECT:HUDButtonID = new HUDButtonID(47, [ModuleID.HOME, ModuleID.WORLD_MAP, ModuleID.HEROIC_TOWER, ModuleID.GLOBAL_BOSS, ModuleID.HEROIC_MAP, ModuleID.HEROIC_LOBBY, ModuleID.INGAME_PVP]
				, "reduceEffectBtn");
		public static const DIVINE_WEAPON:HUDButtonID = new HUDButtonID(48, [ModuleID.HOME]
				, "divineWeaponBtn");
		
		public function HUDButtonID(ID:int, moduleIDs:Array, name:String = "")
		{
			super(ID, name);
			this.moduleIDs = moduleIDs;
		}

		private var moduleIDs:Array = [];

		public function getModuleIDs():Array { return moduleIDs; }
	}
}