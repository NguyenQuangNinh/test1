package game.flow 
{
	import core.display.layer.Layer;
	import core.display.layer.LayerManager;
	import core.event.EventEx;
	import core.Manager;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	import game.data.vo.lobby.LobbyInfo;
	import game.data.vo.quest_transport.ConditionInfo;
	import game.data.xml.DataType;
	import game.data.xml.FeatureXML;
	import game.enum.FlowActionEnum;
	import game.enum.GameConditionType;
	import game.enum.GameConfigID;
	import game.enum.GameMode;
	import game.Game;
	import game.ui.chat.ChatModule;
	import game.ui.hud.HUDButtonID;
	import game.ui.hud.HUDModule;
	import game.ui.hud.HUDView;
	import game.ui.ModuleID;
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class GoToAction extends EventDispatcher
	{
		private var _info:ConditionInfo;
		
		public function GoToAction() 
		{
			
		}
		
		public function goTo(condition:Object):void {
			_info = condition as ConditionInfo;
			if (condition && condition.xmlData) {
				var hudModule:HUDModule = Manager.module.getModuleByID(ModuleID.HUD) as HUDModule;
				var event:EventEx = new EventEx(HUDView.REQUEST_HUD_VIEW);
				var featureRequire:FeatureXML;
				var message:String = "";				
				var currentLevel:int = Game.database.userdata.level;
				var validAction:Boolean = true;
				switch(condition.xmlData.type) {
				    case GameConditionType.CONDITION_QUEST_TRANSPORTER: // dieu kien unit dang lam nhiem vu tieu cuc
				    case GameConditionType.CONDITION_TRANSPORTER_COUNT: // so lan close quest nhiem vu tieu cuc
						featureRequire = Game.database.gamedata.getData(DataType.FEATURE, HUDButtonID.QUEST_TRANSPORT.ID) as FeatureXML;
						if(featureRequire && currentLevel >= featureRequire.levelRequirement) {
							event.data = ModuleID.QUEST_TRANSPORT;
							hudModule.showHUDModule(event);
						}else {
							validAction = false;							
						}
						break;
					case GameConditionType.CONDITION_ITEM_COMMON: // dem item
						//check if item is legendary
						var itemID:int = condition.xmlData.itemID;
						var itemIDCheck:Array = Game.database.gamedata.getConfigData(GameConfigID.ARR_HERO_SHOP_ID) as Array;
						var exist:Boolean = itemIDCheck && itemIDCheck.indexOf(itemID) > 0 ? true : false;
						if (exist) {
							featureRequire = Game.database.gamedata.getData(DataType.FEATURE, HUDButtonID.RENT_CHARACTER.ID) as FeatureXML;
							if(featureRequire && currentLevel >= featureRequire.levelRequirement) {
								hudModule.closeSelectedModule();
								Manager.display.showModule(ModuleID.SHOP, new Point(0,0), LayerManager.LAYER_POPUP);
							}else {
								validAction = false;							
							}
							break;
						}
					case GameConditionType.CONDITION_UNIT_MAIN_CLASS: // dieu kien thuoc bang nao
					case GameConditionType.CONDITION_FINISH_MISSION: // dieu kien hoan thanh mission
					case GameConditionType.CONDITION_KILL_MOB:  // giet quai
					case GameConditionType.CONDITION_COUNT_ITEM_BY_TYPE: // dem item theo type
						var lobbyinfo:LobbyInfo = new LobbyInfo();
						lobbyinfo.mode = GameMode.PVE_WORLD_CAMPAIGN;
						lobbyinfo.missionID = _info.xmlData.destination;
						lobbyinfo.backModule = Manager.display.getCurrentModule();
						Game.flow.doAction(FlowActionEnum.CREATE_BASIC_LOBBY, lobbyinfo);
						//Game.flow.doAction(FlowActionEnum.CREATE_LOBBY, {mode: GameMode.PVE_WORLD_CAMPAIGN, missionID: _info.xmlData.destination, backModule: Manager.display.getCurrentModule()});
						break;							
				    case GameConditionType.CONDITION_UNIT_STAR: // cap sao cua unit
				    case GameConditionType.CONDITION_UNIT_SKILL: // co ky nang nao do
				    case GameConditionType.CONDITION_UNIT_LEVEL: // level unit
				    case GameConditionType.CONDITION_TRANSMIT_EXP_COUNT: // so lan truyen cong
				    case GameConditionType.CONDITION_UPGRADE_SKILL_COUNT: // so lan thang cap SKILL
						featureRequire = Game.database.gamedata.getData(DataType.FEATURE, HUDButtonID.POWER_TRANSFER.ID) as FeatureXML;
						if(featureRequire && currentLevel >= featureRequire.levelRequirement) {
							event.data = ModuleID.CHARACTER_ENHANCEMENT;
							hudModule.showHUDModule(event);
						}else {
							validAction = false;							
						}
						break;
				    case GameConditionType.CONDITION_SOUL_CRAFT_COUNT: // so lan boi menh
						featureRequire = Game.database.gamedata.getData(DataType.FEATURE, HUDButtonID.SOUL.ID) as FeatureXML;
						if(featureRequire && currentLevel >= featureRequire.levelRequirement) {
							event.data = ModuleID.SOUL_CENTER;
							hudModule.showHUDModule(event);
						}else {
							validAction = false;							
						}
						break;
				    case GameConditionType.CONDITION_DAILY_QUEST_CLOSE_COUNT: // so lan close quest quest nhiem vu hang ngay
						//Manager.display.closeAllPopup();
						featureRequire = Game.database.gamedata.getData(DataType.FEATURE, HUDButtonID.QUEST_DAILY.ID) as FeatureXML;
						if(featureRequire && currentLevel >= featureRequire.levelRequirement) {
							hudModule.closeSelectedModule();
							Manager.display.showModule(ModuleID.QUEST_DAILY, new Point(0, 0), LayerManager.LAYER_POPUP, "top_left", Layer.BLOCK_BLACK);
						}else {
							validAction = false;							
						}
						break;
				    case GameConditionType.CONDITION_ALL_CAMPAIN_STAR_COUNT: // tong so sao cua tat ca cac node pve
						event.data = ModuleID.WORLD_MAP;
						hudModule.showHUDModule(event);
						break;
				    case GameConditionType.CONDITION_PLAY_MODE_COUNT: // so lan PLAY mode  nao do
				    case GameConditionType.CONDITION_WIN_MODE_COUNT: // so lan chien thang mode nao do
						var mode:int = _info.xmlData.destination;
						switch(mode) {
							case GameMode.PVP_1vs1_AI.ID:
								featureRequire = Game.database.gamedata.getData(DataType.FEATURE, HUDButtonID.PVP_RANKING.ID) as FeatureXML;
								if(featureRequire && currentLevel >= featureRequire.levelRequirement) {
									hudModule.closeSelectedModule();
									Manager.display.showModule(ModuleID.CHALLENGE, new Point(), LayerManager.LAYER_POPUP);
								}else {
									validAction = false;							
								}
								break;
							case GameMode.PVP_1vs1_FREE.ID:
							case GameMode.PVP_3vs3_FREE.ID:	
							case GameMode.PVP_2vs2_MM.ID:
							case GameMode.PVP_3vs3_MM.ID:
							case GameMode.PVP_1vs1_MM.ID:
								featureRequire = Game.database.gamedata.getData(DataType.FEATURE, HUDButtonID.ARENA.ID) as FeatureXML;
								if(featureRequire && currentLevel >= featureRequire.levelRequirement) {
									Manager.display.showModule(ModuleID.ARENA, new Point(0, 0), LayerManager.LAYER_POPUP, "top_left", Layer.BLOCK_BLACK);
								}else {
									validAction = false;							
								}
								break;
							case GameMode.HEROIC_TOWER.ID:
								featureRequire = Game.database.gamedata.getData(DataType.FEATURE, HUDButtonID.CHALLENGE_CENTER.ID) as FeatureXML;
								if(featureRequire && currentLevel >= featureRequire.levelRequirement) {
									hudModule.closeSelectedModule();
									Manager.display.showModule(ModuleID.CHALLENGE_CENTER, new Point(), LayerManager.LAYER_POPUP);
								}else {
									validAction = false;							
								}
								break;
							case GameMode.PVE_GLOBAL_BOSS.ID:
								featureRequire = Game.database.gamedata.getData(DataType.FEATURE, HUDButtonID.WORLD_BOSS.ID) as FeatureXML;
								if(featureRequire && currentLevel >= featureRequire.levelRequirement) {
									hudModule.closeSelectedModule();
									Manager.display.showModule(ModuleID.SELECT_GLOBAL_BOSS, new Point(), LayerManager.LAYER_POPUP);
								}else {
									validAction = false;							
								}
								break;
							case GameMode.PVE_HEROIC.ID:
								featureRequire = Game.database.gamedata.getData(DataType.FEATURE, HUDButtonID.HEROIC.ID) as FeatureXML;
								if(featureRequire && currentLevel >= featureRequire.levelRequirement) {
									hudModule.closeSelectedModule();
									Manager.display.to(ModuleID.HEROIC_MAP);
								}else {
									validAction = false;							
								}
								break;
						}						
						break;
					case GameConditionType.CONDITION_HONOR:	//dat bao nhieu diem uy danh lay tu VLMC hay DCVL		
						featureRequire = Game.database.gamedata.getData(DataType.FEATURE, HUDButtonID.PVP_RANKING.ID) as FeatureXML;
						if(featureRequire && currentLevel >= featureRequire.levelRequirement) {
							hudModule.closeSelectedModule();
							Manager.display.showModule(ModuleID.CHALLENGE, new Point(), LayerManager.LAYER_POPUP);
						}else {
							validAction = false;							
						}
						break;
					case GameConditionType.CONDITION_NONE:							
						break;
				    case GameConditionType.CONDITION_ADD_FRIEND: // so lan them ban
						break;
					case GameConditionType.CONDITION_LEVEL:							
						break;
				    case GameConditionType.CONDITION_TIME: // dieu kien den thoi gian nay moi duoc hoan thanh						
						break;
				    case GameConditionType.CONDITION_UNIT_VITALITY: // sinh khi					
						break;
				    case GameConditionType.CONDITION_UNIT_STRENGTH: // suc manh					
						break;
				    case GameConditionType.CONDITION_UNIT_AGILITY: // than phap					
						break;
				    case GameConditionType.CONDITION_UNIT_INTELLIGENT: // tri tue					
						break;
				    case GameConditionType.CONDITION_UNIT_METAL_RESIST: // khang kim					
						break;
				    case GameConditionType.CONDITION_UNIT_WOOD_RESIST: // khang moc					
						break;
				    case GameConditionType.CONDITION_UNIT_WATER_RESIST: // khang thuy					
						break;
				    case GameConditionType.CONDITION_UNIT_FIRE_RESIST: // khang hoa				
						break;
				    case GameConditionType.CONDITION_UNIT_EARTH_RESIST: // khang tho					
						break;
				    case GameConditionType.CONDITION_UNIT_MOVEMENT_SPEED: // di chuyen					
						break;
				    case GameConditionType.CONDITION_UNIT_GROUP_CONDITION: // dieu kien 1 nhom thuoc tinh cua unit					
						break;
				}
				
				if (!validAction) {
					message = "Tính năng " + (featureRequire ? featureRequire.name : "") + " mở ở cấp " + (featureRequire ? featureRequire.levelRequirement : "");
					Manager.display.showMessage(message);
				}
			}
		}
		
	}

}