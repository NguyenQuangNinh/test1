package game.ui.game_levelup
{
	import core.display.ModuleBase;
	import core.Manager;
	import flash.utils.Dictionary;
	import game.data.model.Character;
	import game.data.xml.CampaignXML;
	import game.data.xml.DataType;
	import game.data.xml.FeatureXML;
	import game.data.xml.FormationTypeXML;
	import game.data.xml.LevelCommonXML;
	import game.enum.FeatureEnumType;
	import game.enum.GameConfigID;
	import game.enum.ShopID;
	import game.Game;
	import game.ui.ModuleID;
	import game.ui.shop.ShopModule;
	import game.ui.shop_pack.ShopItemModule;
	import game.ui.shop_pack.ShopItemView;
	import game.utility.GameUtil;
	
	/**
	 * ...
	 * @author anhtinh & chuongth2
	 */
	public class GameLevelUpModule extends ModuleBase
	{
		
		public function GameLevelUpModule()
		{
		
		}
		
		override protected function createView():void
		{
			super.createView();
			baseView = new GameLevelUpView();
		
		}
		
		override protected function onTransitionOutComplete():void
		{
			super.onTransitionOutComplete();
			GameLevelUpView(baseView).reset();
		
		}
		
		override protected function onTransitionInComplete():void
		{
			super.onTransitionInComplete();
			GameLevelUpView(baseView).playLevelUp(Game.database.userdata.level, getUnlockInfos());
		}
		
		private function getUnlockInfos():Array
		{
			var infos:Array = [];
			var obj:Object = {};
			var currentLevel:int = Game.database.userdata.level;
			var lastLevel:int = Game.database.userdata.lastLevel;
			
			if (currentLevel > lastLevel && lastLevel > 0)
			{
				// Tính năng mới
				var unlockFeatures:Array = GameUtil.getUnlockFeatureByOnLevelUp();
				if (unlockFeatures.length > 0)
				{
					for each (var featureXML:FeatureXML in unlockFeatures)
					{
						obj = {};
						obj.text = "Mở tính năng " + featureXML.name;
						obj.url = featureXML.url;
						infos.push(obj);
					}
				}
				
				// Tăng chỉ số
				var levelXML:LevelCommonXML = GameUtil.getLevelInRange(FeatureEnumType.COMMON, currentLevel) as LevelCommonXML;
				var lastlevelXML:LevelCommonXML = GameUtil.getLevelInRange(FeatureEnumType.COMMON, lastLevel) as LevelCommonXML;
				if (levelXML && lastlevelXML && levelXML.levelFrom > lastlevelXML.levelTo)
				{ //co unlock
					if (levelXML.appPerRegen > lastlevelXML.appPerRegen)
					{
						var initAP:int = Game.database.gamedata.getConfigData(GameConfigID.AP_INIT_CAPACITY) as int;
						var apAddedText:String = "Thể Lực : " + (initAP + lastlevelXML.appPerRegen) + " > " + (initAP + levelXML.appPerRegen) + " (+" + (levelXML.appPerRegen - lastlevelXML.appPerRegen) + ")"
						obj = {};
						obj.text = apAddedText;
						obj.url = "resource/image/icon_hud/the_luc.png";
						infos.push(obj);
					}
					
					if (levelXML.normalUnitCount > lastlevelXML.normalUnitCount)
					{
						var unitCountText:String = "Đội Hình tăng thêm " + (levelXML.normalUnitCount - lastlevelXML.normalUnitCount);
						obj = {};
						obj.text = unitCountText;
						obj.url = "resource/image/icon_hud/button_doihinh.png";
						infos.push(obj);
					}
					
					if (levelXML.legendUnitCount > lastlevelXML.legendUnitCount)
					{
						var legendUnitCountText:String = "Đội Hình tăng thêm " + (levelXML.legendUnitCount - lastlevelXML.legendUnitCount) + " đại hiệp";
						obj = {};
						obj.text = legendUnitCountText;
						obj.url = "resource/image/icon_hud/button_doihinh.png";
						infos.push(obj);
					}
					
				}
				
				// Trận hình mới
				
				var dicFormationType:Dictionary = Game.database.gamedata.getTable(DataType.FORMATION_TYPE);
				if (dicFormationType)
				{
					var mainCharacter:Character = Game.database.userdata.mainCharacter;
					if (mainCharacter)
					{
						for each (var formationTypeXml:FormationTypeXML in dicFormationType)
						{
							if (formationTypeXml && currentLevel == formationTypeXml.arrLevelUnlock[mainCharacter.element])
							{
								obj = {};
								obj.text = "Trận hình: " + formationTypeXml.name;
								obj.url = formationTypeXml.iconUrl;
								infos.push(obj);
							}
						}
					}
				}
				
				//campaign mới
				var dicCampaign:Dictionary = Game.database.gamedata.getTable(DataType.CAMPAIGN);
				if (dicCampaign)
				{
					for each (var campaignXml:CampaignXML in dicCampaign)
					{
						if (campaignXml && currentLevel == campaignXml.levelRequirement)
						{
							obj = {};
							obj.text = "Tham gia được: " + campaignXml.name;
							obj.url = "resource/image/icon_hud/button_chiendich.png";
							infos.push(obj);
						}
					}
				}

				//item shop new
				var shopModule:ShopItemModule = Manager.module.getModuleByID(ModuleID.SHOP_ITEM) as ShopItemModule;
				if (shopModule && shopModule.baseView) {
					(shopModule.baseView as ShopItemView).updateItemDisplay(ShopID.ITEM.ID);
				}
			}
			
			return infos;
		}
	}

}