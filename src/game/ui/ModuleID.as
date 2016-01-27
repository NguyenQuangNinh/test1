package game.ui
{
	import core.util.Enum;

	import game.ui.dice.DiceModule;

	import game.ui.express.ExpressModule;

	import game.ui.divine_weapon.DivineWeaponModule;

	import game.ui.mystic_box.MysticBoxModule;
	import game.ui.shop_discount.ShopDiscountModule;
	import game.ui.tuu_lau_chien.TuuLauChienModule;
	import game.ui.train.TrainModule;

	import game.ui.activity_point.ActivityPointModule;
	import game.ui.arena.ArenaModule;
	import game.ui.attendance.AttendanceModule;
	import game.ui.challenge.ChallengeModule;
	import game.ui.challenge_center.ChallengeCenterModule;
	import game.ui.change_formation.ChangeFormationModule;
	import game.ui.change_formation_challenge.ChangeFormationChallengeModule;
	import game.ui.change_recipe.ChangeRecipeModule;
	import game.ui.character_enhancement.CharacterEnhancementModule;
	import game.ui.character_info.CharacterInfoModule;
	import game.ui.charge_event.ChargeEventModule;
	import game.ui.chat.ChatModule;
	import game.ui.consume_event.ConsumeEventModule;
	import game.ui.create_character.CreateCharacterModule;
	import game.ui.daily_task.DailyTaskModule;
	import game.ui.dialog.DialogModule;
	import game.ui.dialog_vip.DialogVIPModule;
	import game.ui.effect.EffectModule;
	import game.ui.events.EventsHotModule;
	import game.ui.formation.FormationModule;
	import game.ui.formation_type.FormationTypeModule;
	import game.ui.friend.FriendModule;
	import game.ui.game_levelup.GameLevelUpModule;
	import game.ui.gift_online.GiftOnlineModule;
	import game.ui.global_boss.GlobalBossModule;
	import game.ui.global_boss_top.GlobalBossTopModule;
	import game.ui.guild.GuildModule;
	import game.ui.heal_ap.HealApModule;
	import game.ui.heal_hp.HealHpModule;
	import game.ui.heroic.lobby.HeroicLobbyModule;
	import game.ui.heroic.world_map.HeroicMapModule;
	import game.ui.heroic_tower.HeroicTowerModule;
	import game.ui.home.HomeModule;
	import game.ui.hud.HUDModule;
	import game.ui.ingame.pve.IngamePVEModule;
	import game.ui.ingame.pvp.IngamePVPModule;
	import game.ui.inventory.InventoryModule;
	import game.ui.inventoryitem.InventoryItemModule;
	import game.ui.invite_player.InvitePlayerModule;
	import game.ui.leader_board.LeaderBoardModule;
	import game.ui.loading.LoadingModule;
	import game.ui.lobby.LobbyModule;
	import game.ui.lucky_gift.LuckyGiftModule;
	import game.ui.mail.MailModule;
	import game.ui.master_invitation.MasterInvitationModule;
	import game.ui.message.MessageModule;
	import game.ui.metal_furnace.MetalFurnaceModule;
	import game.ui.open_present_vip.OpenPresentVipModule;
	import game.ui.payment.PaymentModule;
	import game.ui.player_profile.PlayerProfileModule;
	import game.ui.preloader.PreloaderModule;
	import game.ui.present.PresentModule;
	import game.ui.quest_daily.QuestDailyModule;
	import game.ui.quest_main.QuestMainModule;
	import game.ui.quest_transport.QuestTransportModule;
	import game.ui.select_global_boss.SelectGlobalBossModule;
	import game.ui.shop.ShopModule;
	import game.ui.shop.shop_secret_merchant.ShopSecretMerchantModule;
	import game.ui.shop_pack.ShopItemModule;
	import game.ui.soul_center.SoulCenterModule;
	import game.ui.suggestion.SuggestionModule;
	import game.ui.test.TestModule;
	import game.ui.tooltip.TooltipModule;
	import game.ui.top_bar.TopBarModule;
	import game.ui.treasure.TreasureModule;
	import game.ui.tutorial.TutorialModule;
	import game.ui.vip_promotion.VIPPromotionModule;
	import game.ui.waitting.WaittingModule;
	import game.ui.wiki.WikiModule;
	import game.ui.worldmap.WorldMapModule;

	/**
	 *
	 * @author ...
	 */
	public class ModuleID extends Enum
	{
		public static const HOME:ModuleID = new ModuleID(1, "home", HomeModule);
		public static const HUD:ModuleID = new ModuleID(2, "hud", HUDModule);
		public static const TOP_BAR:ModuleID = new ModuleID(3, "top_bar", TopBarModule);
		public static const WORLD_MAP:ModuleID = new ModuleID(4, "world_map", WorldMapModule);
		public static const INVENTORY_UNIT:ModuleID = new ModuleID(5, "inventory", InventoryModule);
		public static const INVENTORY_ITEM:ModuleID = new ModuleID(6, "inventory_item", InventoryItemModule);
		public static const FORMATION_TYPE:ModuleID = new ModuleID(7, "formation_type", FormationTypeModule);
		public static const SOUL_CENTER:ModuleID = new ModuleID(8, "soul_center", SoulCenterModule);
		public static const TOOLTIP:ModuleID = new ModuleID(9, "tooltip", TooltipModule);
		public static const INGAME_PVE:ModuleID = new ModuleID(10, "ingame_pve", IngamePVEModule);
		public static const INGAME_PVP:ModuleID = new ModuleID(11, "ingame_pvp", IngamePVPModule);
		public static const FORMATION:ModuleID = new ModuleID(12, "formation", FormationModule);
		public static const CHARACTER_INFO:ModuleID = new ModuleID(13, "character_info", CharacterInfoModule);
		public static const LOADING:ModuleID = new ModuleID(14, "loading", LoadingModule);
		public static const LOBBY:ModuleID = new ModuleID(15, "lobby", LobbyModule);
		public static const ARENA:ModuleID = new ModuleID(16, "arena", ArenaModule);
		public static const CHALLENGE:ModuleID = new ModuleID(17, "challenge", ChallengeModule);
		public static const MESSAGE:ModuleID = new ModuleID(18, "message", MessageModule);
		public static const CREATE_CHARACTER:ModuleID = new ModuleID(19, "create_character", CreateCharacterModule);
		public static const DIALOG:ModuleID = new ModuleID(20, "dialog", DialogModule);
		public static const INVITE_PLAYER:ModuleID = new ModuleID(21, "invite_player", InvitePlayerModule);
		public static const SHOP:ModuleID = new ModuleID(22, "shop", ShopModule);
		public static const PRELOADER:ModuleID = new ModuleID(23, "preloader", PreloaderModule);
		public static const LEADER_BOARD:ModuleID = new ModuleID(24, "leader_board", LeaderBoardModule);
		public static const CHARACTER_ENHANCEMENT:ModuleID = new ModuleID(25, "character_enhancement", CharacterEnhancementModule);
		public static const QUEST_TRANSPORT:ModuleID = new ModuleID(26, "quest_transport", QuestTransportModule);
		public static const CHANGE_FORMATION:ModuleID = new ModuleID(27, "change_formation", ChangeFormationModule);
		public static const TEST:ModuleID = new ModuleID(28, "test", TestModule);
		public static const EFFECT:ModuleID = new ModuleID(29, "", EffectModule);
		public static const CHAT:ModuleID = new ModuleID(30, "chat", ChatModule);
		public static const QUEST_MAIN:ModuleID = new ModuleID(31, "quest_main", QuestMainModule);
		public static const QUEST_DAILY:ModuleID = new ModuleID(32, "quest_daily", QuestDailyModule);
		public static const METAL_FURNACE:ModuleID = new ModuleID(33, "metal_furnace", MetalFurnaceModule);
		public static const LUCKY_GIFT:ModuleID = new ModuleID(34, "lucky_gift", LuckyGiftModule);	//chuongth
		public static const MAIL_BOX:ModuleID = new ModuleID(35, "mail", MailModule);				//chuongth
		public static const PRESENT:ModuleID = new ModuleID(36, "present", PresentModule);			//chuongth
		public static const FRIEND:ModuleID = new ModuleID(37, "friend", FriendModule);			//chuongth
		public static const HEAL_HP:ModuleID = new ModuleID(38, "heal_hp", HealHpModule);
		public static const HEAL_AP:ModuleID = new ModuleID(39, "heal_ap", HealApModule);
		public static const CHANGE_FORMATION_CHALLENGE:ModuleID = new ModuleID(40, "change_formation_challenge", ChangeFormationChallengeModule);
		public static const GAME_LEVEL_UP:ModuleID = new ModuleID(41, "game_levelup", GameLevelUpModule);
		public static const SELECT_GLOBAL_BOSS:ModuleID = new ModuleID(42, "select_global_boss", SelectGlobalBossModule);
		public static const GLOBAL_BOSS:ModuleID = new ModuleID(43, "global_boss", GlobalBossModule);
		public static const CHALLENGE_CENTER:ModuleID = new ModuleID(44, "challenge_center", ChallengeCenterModule);
		public static const HEROIC_MAP:ModuleID = new ModuleID(45, "heroic_map", HeroicMapModule);
		public static const HEROIC_LOBBY:ModuleID = new ModuleID(46, "heroic_lobby", HeroicLobbyModule);
		public static const HEROIC_TOWER:ModuleID = new ModuleID(47, "heroic_tower", HeroicTowerModule);
		public static const CHANGE_RECIPE:ModuleID = new ModuleID(48, "change_recipe", ChangeRecipeModule);
		public static const CONSUME_EVENT:ModuleID = new ModuleID(49, "consume_event", ConsumeEventModule);
		public static const DIALOG_VIP:ModuleID = new ModuleID(50, "dialog_vip", DialogVIPModule);
		public static const CHARGE_EVENT:ModuleID = new ModuleID(51, "charge_event", ChargeEventModule);
		public static const SHOP_ITEM:ModuleID = new ModuleID(52, "shop_item", ShopItemModule);
		public static const GIFT_ONLINE:ModuleID = new ModuleID(53, "gift_online", GiftOnlineModule);
		public static const PLAYER_PROFILE:ModuleID = new ModuleID(54, "player_profile", PlayerProfileModule);
		public static const SHOP_SECRET_MERCHANT:ModuleID = new ModuleID(55, "shop_secret_merchant", ShopSecretMerchantModule);
		public static const MASTER_INVITATION:ModuleID = new ModuleID(56, "master_invitation", MasterInvitationModule);
		public static const OPEN_PRESENT_VIP:ModuleID = new ModuleID(57, "open_present_vip", OpenPresentVipModule);
		public static const TUTORIAL:ModuleID = new ModuleID(58, "tutorial", TutorialModule);
		public static const PAYMENT:ModuleID = new ModuleID(59, "payment", PaymentModule);
		public static const WAITTING:ModuleID = new ModuleID(60, "waitting", WaittingModule);
		public static const DAILY_TASK:ModuleID = new ModuleID(61, "daily_task", DailyTaskModule);
		public static const ATTENDANCE:ModuleID = new ModuleID(62, "attendance", AttendanceModule);
		public static const GLOBAL_BOSS_TOP:ModuleID = new ModuleID(63, "global_boss_top", GlobalBossTopModule);
		public static const GUILD:ModuleID = new ModuleID(64, "guild", GuildModule);
		public static const ACTIVITY:ModuleID = new ModuleID(65, "activity", ActivityPointModule);
		public static const EVENTS_HOT:ModuleID = new ModuleID(66, "events_hot", EventsHotModule);
		public static const TREASURE:ModuleID = new ModuleID(67, "treasure", TreasureModule);
		public static const TUULAUCHIEN:ModuleID = new ModuleID(68, "tuu_lau_chien", TuuLauChienModule);
		public static const KUNGFU_TRAIN:ModuleID = new ModuleID(69, "train", TrainModule);
		public static const SUGGESTION:ModuleID = new ModuleID(70, "suggestion", SuggestionModule);
		public static const WIKI:ModuleID = new ModuleID(71, "wiki", WikiModule);
		public static const MYSTIC_BOX:ModuleID = new ModuleID(72, "mystic_box", MysticBoxModule);
		public static const EXPRESS:ModuleID = new ModuleID(73, "express", ExpressModule);
		public static const DICE:ModuleID = new ModuleID(74, "dice", DiceModule);
		public static const SHOP_DISCOUNT:ModuleID = new ModuleID(75, "shop_discount", ShopDiscountModule);
		public static const VIP_PROMOTION:ModuleID = new ModuleID(76, "vip_promotion", VIPPromotionModule);
		public static const DIVINE_WEAPON:ModuleID = new ModuleID(77, "divine_weapon", DivineWeaponModule);


		//public var url:String;

		public function ModuleID(ID:int, name:String, clas:Class)
		{
			//this.url = url;
			super(ID, name);
			this.clas = clas;
		}

		public var clas:Class;
	}

}