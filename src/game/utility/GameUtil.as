package game.utility 
{
	import core.display.layer.Layer;
	import core.display.layer.LayerManager;
	import core.util.Enum;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.utils.Dictionary;
	import game.data.xml.CampaignXML;
	import game.data.xml.MissionXML;
	import game.enum.TuuLauType;
	
	import core.Manager;
	import core.util.TextFieldUtil;
	
	import game.Game;
	import game.data.model.item.ItemFactory;
	import game.data.model.item.SoulItem;
	import game.data.vo.reward.RewardInfo;
	import game.data.vo.suggestion.SuggestionInfo;
	import game.data.xml.BackgroundLayerXML;
	import game.data.xml.BackgroundXML;
	import game.data.xml.BonusAttrNameMappingXML;
	import game.data.xml.BonusAttributeXML;
	import game.data.xml.BulletXML;
	import game.data.xml.CharacterXML;
	import game.data.xml.DataType;
	import game.data.xml.FeatureXML;
	import game.data.xml.LevelFeatureXML;
	import game.data.xml.RewardXML;
	import game.data.xml.SkillXML;
	import game.data.xml.UnitClassXML;
	import game.data.xml.VisualEffectComponentXML;
	import game.data.xml.VisualEffectXML;
	import game.data.xml.XMLData;
	import game.data.xml.item.ItemChestXML;
	import game.data.xml.item.SoulXML;
	import game.enum.ElementRelationship;
	import game.enum.FeatureEnumType;
	import game.enum.Font;
	import game.enum.GameConditionType;
	import game.enum.GameConfigID;
	import game.enum.ItemType;
	import game.enum.Sex;
	import game.ui.ModuleID;
	import game.ui.home.HomeModule;
	import game.ui.hud.HUDModule;

	/**
	 * ...
	 * @author anhtinh
	 */
	public class GameUtil 
	{
		
		public static var fpsTextfield : TextField;
		
		public static const glowFilterYellow : GlowFilter = new GlowFilter(0xffff00, 1, 8, 8, 2);
		
		public static function initFpsTextField() : void {
			if (fpsTextfield == null) {
				fpsTextfield = TextFieldUtil.createTextfield(Font.ARIAL, 16, 100, 20, 0xFF0000, true);
				//fpsTextfield.antiAliasType = AntiAliasType.NORMAL;
				//fpsTextfield.sharpness = 400;
			}
		}

		public static function getTotalPowerTransmission(exp:int, elementRelationship:int):int
		{
			var penalty:int;
			switch(elementRelationship)
			{
				case ElementRelationship.NORMAL:
				case ElementRelationship.GENERATED:
					penalty = 100;
					break;
				case ElementRelationship.GENERATING:
					penalty = 100 + Game.database.gamedata.getConfigData(GameConfigID.TRANMISSION_GENERATING_PERCENT);
					break;
				case ElementRelationship.RESIST:
					penalty = 100 - Game.database.gamedata.getConfigData(GameConfigID.TRANMISSION_OVERCOMING_PERCENT);
					break;
				case ElementRelationship.DESTROY:
					penalty = 0;
					break;
			}

			return exp * (penalty / 100);
		}

		public static function getBonusTextByValue(attributeType : int, valueType:int, value : int, targetType:int = 0, arrTargets:Array = null) : String {
			var result : String = "";
			var bonusNameXML : BonusAttrNameMappingXML = Game.database.gamedata.getData(DataType.BONUS_ATTR_NAME_MAPPING, attributeType) as BonusAttrNameMappingXML;
			var percentSymbol : String = "";
			if (valueType == 2
			|| valueType == 7) percentSymbol = "%";
			if (valueType == 7) {
				value = value / 10;
			}
			result = "+" + value + percentSymbol + " " + (bonusNameXML != null ? bonusNameXML.name : "");
			
			switch(targetType)
			{
				case 1:
					result += " tất cả nhân vật";
					break;
				case 2:
					result += " cho nhân vật chính";
					break;
				case 3:
					//result += " cho nhân vật hệ ";
					var buffElement:String = "";
					if (arrTargets != null)
					{
						for each (var target:int in arrTargets) {
							switch(target)
							{
								case ElementUtil.FIRE:
									buffElement += (buffElement == "") ? "Hỏa" : " , Hỏa";
									break;
								case ElementUtil.EARTH:
									buffElement += (buffElement == "") ? "Thổ" : " , Thổ";
									break;
								case ElementUtil.METAL:
									buffElement += (buffElement == "") ? "Kim" : " , Kim";
									break;
								case ElementUtil.WATER:
									buffElement += (buffElement == "") ? "Thủy" : " , Thủy";
									break;
								case ElementUtil.WOOD:
									buffElement += (buffElement == "") ? "Mộc" : " , Mộc";
									break;
								default:
									break;
							}
						}
					}
					if (buffElement != "")
					{
						result = result + " cho nhân vật hệ " + buffElement;
					}
					break;
				default:
					//result += " tất cả nhân vật";
					break;
			}
			
			return result;
		}
		
		public static function getSoulBonusAttName(bonusID : int) : String {			
			var result : String = "";
			var bonusXML : BonusAttributeXML = Game.database.gamedata.getData(DataType.BONUS_ATTRIBUTE, bonusID) as BonusAttributeXML;
			var value:Number = 0;
			if (bonusXML != null) {
				var bonusNameXML : BonusAttrNameMappingXML = Game.database.gamedata.getData(DataType.BONUS_ATTR_NAME_MAPPING, bonusXML.attributeType) as BonusAttrNameMappingXML;
				if (bonusNameXML != null){
					return  bonusNameXML.name;
				}
			}
			return "";
		}
		
		public static function getSoulBonusValue (bonusID : int, level:int, targetType:int = 0, arrTargets:Array = null) : int {
			if (level < 1) level = 1;
			
			var result : String = "";
			var bonusXML : BonusAttributeXML = Game.database.gamedata.getData(DataType.BONUS_ATTRIBUTE, bonusID) as BonusAttributeXML;
			var value:Number = 0;
			if (bonusXML != null) {
				switch (bonusXML.valueType)
				{
					case 14:
						if (bonusXML.valuePerLevel != 0)
						{
							value = bonusXML.beginValue + (level - 1) / bonusXML.valuePerLevel;
						}
						else
						{
							value = bonusXML.beginValue;
						}
						break;
					default :
						value = bonusXML.beginValue + (level - 1) * bonusXML.valuePerLevel;
						break;
				}

				return value;
			}
			return 0;
		}
		
		public static function getBonusText(bonusID : int, level : int, targetType:int = 0, arrTargets:Array = null) : String {
			if (level < 1) level = 1;
			
			var result : String = "";
			var bonusXML : BonusAttributeXML = Game.database.gamedata.getData(DataType.BONUS_ATTRIBUTE, bonusID) as BonusAttributeXML;
			var value:Number = 0;
			if (bonusXML != null) {
				value = bonusXML.beginValue + (level - 1) * bonusXML.valuePerLevel;
				return getBonusTextByValue(bonusXML.attributeType, bonusXML.valueType, value, targetType, arrTargets);
			}
			return "";
		}
		
		/**
		 * 
		 * @param	rewardIDs : danh sách id các reward
		 * @return	danh sách các rewardXML tương ứng
		 */
		public static function getRewardXMLs(rewardIDs : Array) : Array {
			
			var rs : Array = [];
			if (rewardIDs == null || rewardIDs.length == 0) return rs;
			
			for (var i:int = 0; i < rewardIDs.length; i++) 
			{
				var rewardXML : RewardXML = Game.database.gamedata.getData(DataType.REWARD, rewardIDs[i]) as RewardXML;
				if(rewardXML != null) rs.push(rewardXML);
			}
			
			return rs;
		}
		/**
		 * 
		 * @param	rewardIDs : danh sách id các reward
		 * @return  danh sách các rewardInfo tương ứng
		 */
		public static function getRewardConfigs(rewardIDs : Array) : Array {
			var rs : Array = [];
			var rewardXMLs : Array =  getRewardXMLs(rewardIDs);
			
			for each (var rewardXML:RewardXML in rewardXMLs) 
			{
				var rewardInfo : RewardInfo = new RewardInfo();
				rewardInfo.itemConfig = ItemFactory.buildItemConfig(rewardXML.type, rewardXML.itemID);
				rewardInfo.quantity = rewardXML.quantity;
				rewardInfo.itemID = rewardXML.itemID;
				rewardInfo.itemType = rewardXML.type;
				if(rewardInfo.itemType == ItemType.NONE) continue;
				rs.push(rewardInfo);
			}
			return rs;
		}
		
		/**
		 * 
		 * @param	characterID: id of character need to check
		 * @return  unitID: next level when character get active skill
		 */
		public static function getNextLevelActiveSkill(characterID:int):int {
			//Utility.log("getNextLevelActiveSkill of id  " + characterID);
			var result:int = -1;
			var tempUnitID:Array = [];
			var characterClass:int = checkFinishActive(characterID);
			if (characterClass != -1) {
				//check min start require
				var unitClassXML: UnitClassXML = Game.database.gamedata.getData(DataType.UNITCLASS, characterClass) as UnitClassXML;
				if (unitClassXML) {
					//result = unitClassXML.minStars * 12;
					result = unitClassXML.minStars;
				}
			}else {				
				var characterXML: CharacterXML = Game.database.gamedata.getData(DataType.CHARACTER, characterID) as CharacterXML;
				for (var i:int = 0; i < characterXML.nextIDs.length; i++) {
					tempUnitID.push(getNextLevelActiveSkill(characterXML.nextIDs[i]));
				}	
				//Utility.log("temp unit id found is " + tempUnitID);
				//compare and check min start require
				for (i = 0; i < tempUnitID.length; i++) {
					unitClassXML = Game.database.gamedata.getData(DataType.UNITCLASS, tempUnitID[i]) as UnitClassXML;
					if (unitClassXML) {
						//result = result <= unitClassXML.minStars * 12 ? unitClassXML.minStars * 12 : result;
						result = result <= unitClassXML.minStars ? unitClassXML.minStars : result;
					}					
				}				
			}
			return result;			
		}
		/**
		 * 
		 * @param	int: id of character need to check
		 * @return  int: character class
		 */
		public static function checkFinishActive(characterID:int): int {
			var result:int = -1;			
			var characterXML: CharacterXML = Game.database.gamedata.getData(DataType.CHARACTER, characterID) as CharacterXML;
			var b1:Boolean = characterXML && (characterXML.nextIDs.length > 0) && (characterXML.nextIDs[0] == -1);
			var b2:Boolean = characterXML && characterXML.activeSkills.length > 0;
			result  = (b1 || b2) ? characterXML.characterClass : -1;			
			//Utility.log("checkFinishActive of id  " + characterID + " is " + result);
			return result;
		}
		/**
		 * 
		 * @param	characterID: id of character need to check
		 * @return  unitID: next level when character get passive skill
		 */
		public static function getNextLevelPassiveSkill(characterID:int):int {
			//Utility.log("getNextLevelPassiveSkill of id  " + characterID);
			var result:int = -1;
			var tempUnitID:Array = [];
			var characterClass:int = checkFinishPassive(characterID);
			if (characterClass != -1) {
				//check min start require
				var unitClassXML: UnitClassXML = Game.database.gamedata.getData(DataType.UNITCLASS, characterClass) as UnitClassXML;
				if (unitClassXML) {
					//result = unitClassXML.minStars * 12;
					result = unitClassXML.minStars;
				}
			}else {				
				var characterXML: CharacterXML = Game.database.gamedata.getData(DataType.CHARACTER, characterID) as CharacterXML;
				for (var i:int = 0; i < characterXML.nextIDs.length; i++) {
					tempUnitID.push(getNextLevelPassiveSkill(characterXML.nextIDs[i]));
				}	
				//Utility.log("temp unit id found is " + tempUnitID);
				//compare and check min start require
				for (i = 0; i < tempUnitID.length; i++) {
					unitClassXML = Game.database.gamedata.getData(DataType.UNITCLASS, tempUnitID[i]) as UnitClassXML;
					if (unitClassXML) {
						//result = result <= unitClassXML.minStars * 12 ? unitClassXML.minStars * 12 : result;
						result = result <= unitClassXML.minStars ? unitClassXML.minStars : result;
					}					
				}				
			}
			return result;			
		}
		/**
		 * 
		 * @param	int: id of character need to check
		 * @return  int: character class
		 */
		public static function checkFinishPassive(characterID:int): int {
			var result:int = -1;			
			var characterXML: CharacterXML = Game.database.gamedata.getData(DataType.CHARACTER, characterID) as CharacterXML;
			var b1:Boolean = characterXML && (characterXML.nextIDs.length > 0) && (characterXML.nextIDs[0] == -1);
			var b2:Boolean = characterXML && characterXML.passiveSkill > 0;
			result  = (b1 || b2) ? characterXML.characterClass : -1;			
			//Utility.log("checkFinishPassive of id  " + characterID + " is " + result);
			return result;
		}
		
		public static function getLevelInRange(featureID:int, level:int): XMLData {
			var result:XMLData = null;
			
			var featureXML:LevelFeatureXML = Game.database.gamedata.getData(DataType.LEVEL, featureID) as LevelFeatureXML;
			if (featureXML) {
				var levelDic:Dictionary = featureXML.levelDictionary;
				for each(var data: Object in levelDic) {
					if (data && data.levelFrom && data.levelTo
						&& data.levelFrom <= level && data.levelTo >= level) {						
						result = data as XMLData;
						break;
					}
				}
			}
			
			return result;
		}
		
		public static function getRewardRequireLevelXMLs(featureID:int): Dictionary {
			var featureXML:LevelFeatureXML = Game.database.gamedata.getData(DataType.LEVEL, featureID) as LevelFeatureXML;
			if (featureXML) {
				return featureXML.levelDictionary;
			}
			return null;
		}	
		
		public static function getNextLevelNormalFormationSlotConfig(numNormal:int): XMLData {			
			var result:XMLData = null;
			
			var featureXML:LevelFeatureXML = Game.database.gamedata.getData(DataType.LEVEL, FeatureEnumType.COMMON) as LevelFeatureXML;
			if (featureXML) {
				var levelDic:Dictionary = featureXML.levelDictionary;
				for each(var data: Object in levelDic) {
					if (data && data.normalUnitCount &&
						data.normalUnitCount > numNormal) {						
						result = data as XMLData;
						break;
					}
				}
			}
			
			return result;
		}
		
		public static function getNextLevelLegendFormationSlotConfig(numLegend:int): XMLData {
			var result:XMLData = null;
			
			var featureXML:LevelFeatureXML = Game.database.gamedata.getData(DataType.LEVEL, FeatureEnumType.COMMON) as LevelFeatureXML;
			if (featureXML) {
				var levelDic:Dictionary = featureXML.levelDictionary;
				for each(var data: Object in levelDic) {
					if (data && data.normalUnitCount &&
						data.legendUnitCount > numLegend) {						
						result = data as XMLData;
						break;
					}
				}
			}
			
			return result;
		}
		
		public static function getUnlockFeatureByOnLevelUp() : Array {
			var result : Array = [];
			
			var currentLevel : int = Game.database.userdata.level;
			var lastLevel : int = Game.database.userdata.lastLevel;
			
			if (currentLevel > lastLevel && lastLevel > 0) {
				
				var unlockFeatureDict : Dictionary = Game.database.gamedata.getTable(DataType.FEATURE);
				for each (var featureXML: FeatureXML in unlockFeatureDict) 
				{
					if (lastLevel < featureXML.levelRequirement && currentLevel >= featureXML.levelRequirement) result.push(featureXML);
				}
			}
			
			return result;
		}
		
		public static function getItemRewardsByID(id:int):Array {
			var result:Array = [];
			var rewardXML:RewardXML = Game.database.gamedata.getData(DataType.REWARD, id) as RewardXML;
			if (rewardXML) {
				switch(rewardXML.type) {
					case ItemType.ITEM_SET:
					//case ItemType.AUTO_OPEN_CHEST:
					//case ItemType.CHOICE_CHEST:
					//case ItemType.LUCKY_CHEST:
					//case ItemType.MASTER_INVITATION_CHEST:
					//case ItemType.NORMAL_CHEST:
					//case ItemType.PRESENT_VIP_CHEST:
						var chestXML:ItemChestXML = Game.database.gamedata.getData(DataType.ITEMCHEST, rewardXML.itemID) as ItemChestXML;
						if (chestXML) {
							var arrRewardXML:Array = GameUtil.getRewardXMLs(chestXML.rewardIDs);
							result = result.concat(arrRewardXML);
						}
						break;
					default:
						result.push(rewardXML);
						break;
				}
			}
			return result;
		}
		
		public static function getItemRewardsByIDs(ids:Array):Array 
		{
			var result:Array = [];
			for (var i:int = 0; i < ids.length; i++) 
			{
				result = result.concat(getItemRewardsByID(ids[i]));
			}
			return result;
		}
		
		public static function checkGoToActionValid(type:int):Boolean {
			var result:Boolean = false;
			result = type == GameConditionType.CONDITION_QUEST_TRANSPORTER
					|| type == GameConditionType.CONDITION_TRANSPORTER_COUNT
					|| type == GameConditionType.CONDITION_UNIT_MAIN_CLASS
					|| type == GameConditionType.CONDITION_FINISH_MISSION
					|| type == GameConditionType.CONDITION_ITEM_COMMON
					|| type == GameConditionType.CONDITION_KILL_MOB
					|| type == GameConditionType.CONDITION_COUNT_ITEM_BY_TYPE
					|| type == GameConditionType.CONDITION_UNIT_STAR
					|| type == GameConditionType.CONDITION_UNIT_SKILL
					|| type == GameConditionType.CONDITION_UNIT_LEVEL
					|| type == GameConditionType.CONDITION_TRANSMIT_EXP_COUNT
					|| type == GameConditionType.CONDITION_UPGRADE_SKILL_COUNT
					|| type == GameConditionType.CONDITION_SOUL_CRAFT_COUNT
					|| type == GameConditionType.CONDITION_DAILY_QUEST_CLOSE_COUNT
					|| type == GameConditionType.CONDITION_ALL_CAMPAIN_STAR_COUNT
					|| type == GameConditionType.CONDITION_PLAY_MODE_COUNT
					|| type == GameConditionType.CONDITION_WIN_MODE_COUNT
					|| type == GameConditionType.CONDITION_HONOR;
			return result;			
		}
		
		public static function checkSoulNextLevel(soulItem:SoulItem, expAdd:int):int {
			var nextLevel:int = -1;
			if (soulItem) {
				nextLevel = soulItem.level;
				var tempExp:int = soulItem.exp + expAdd;
				var expRequire:int = (soulItem.xmlData as SoulXML).level2Exp + (soulItem.xmlData as SoulXML).expIncrementPerLevel * (nextLevel - 1);
				while(tempExp >= expRequire /*&& (soulItem.exp > 0) && (expRequire > 0)*/)
				{
					tempExp = tempExp - expRequire;
					nextLevel++;
					expRequire = (soulItem.xmlData as SoulXML).level2Exp + (soulItem.xmlData as SoulXML).expIncrementPerLevel * (nextLevel - 1);
					if (nextLevel > (soulItem.xmlData as SoulXML).maxLevel)
					{
						tempExp = 0;
						break;
					}
				}
				
			}
			
			return nextLevel;			
		}
		
		public static function preloadBackground(urls:Array, ID:int):void
		{
			var backgroundXML:BackgroundXML = Game.database.gamedata.getData(DataType.BACKGROUND, ID) as BackgroundXML;
			if (backgroundXML != null)
			{
				for each (var layerID:int in backgroundXML.layerIDs)
				{
					var backgroundLayerXML:BackgroundLayerXML = Game.database.gamedata.getData(DataType.BACKGROUND_LAYER, layerID) as BackgroundLayerXML;
					if(backgroundLayerXML != null)
					{
						var url:String = backgroundLayerXML.url;
						urls.push(url);
						if(backgroundLayerXML.useAlphaMask)
						{
							var ext:String = url.substring(url.lastIndexOf("."));
							var maskURL:String = url.replace(ext, "_mask" + ext);
							urls.push(maskURL);
						}
					}
				}
			}
		}
		
		public static function preloadCharacter(urls:Array, ID:int, sex:int, includeSkills:Boolean = false):void
		{
			var url:String;
			var characterXML:CharacterXML = Game.database.gamedata.getData(DataType.CHARACTER, ID) as CharacterXML;
			if (characterXML != null)
			{
				url = characterXML.smallAvatarURLs[sex];
				if (url.length > 0 && urls.indexOf(url) == -1) urls.push(url);
				url = characterXML.animURLs[sex];
				if (url.length > 0 && urls.indexOf(url) == -1) urls.push(url);
				var bulletXML:BulletXML = Game.database.gamedata.getData(DataType.BULLET, characterXML.bulletID) as BulletXML;
				if (bulletXML != null)
				{
					preloadVisualEffect(urls, bulletXML.effectID);
				}
				if(includeSkills)
				{
					for(var i:int = 0; i < characterXML.activeSkills.length; ++i)
					{
						preloadSkill(urls, characterXML.activeSkills[i]);
					}
				}
			}
		}
		
		public static function preloadVisualEffect(urls:Array, ID:int):void
		{
			var visualEffectXML:VisualEffectXML = Game.database.gamedata.getData(DataType.VISUAL_EFFECT, ID) as VisualEffectXML;
			var url:String;
			if(visualEffectXML != null)
			{
				for(var j:int = 0; j < visualEffectXML.compositionIDs.length; ++j)
				{
					var visualEffectComponentXML:VisualEffectComponentXML = Game.database.gamedata.getData(DataType.VISUAL_EFFECT_COMPONENT, visualEffectXML.compositionIDs[j]) as VisualEffectComponentXML;
					if(visualEffectComponentXML != null)
					{
						url = visualEffectComponentXML.animURL;
						if (url.length > 0 && urls.indexOf(url) == -1) urls.push(url);
					}
				}
			}
		}
		
		public static function preloadSkill(urls:Array, ID:int):void
		{
			var skillXML:SkillXML = Game.database.gamedata.getData(DataType.SKILL, ID) as SkillXML;
			if(skillXML != null)
			{
				var url:String = skillXML.iconURL;
				if (url.length > 0 && urls.indexOf(url) == -1) urls.push(url);
				for(var i:int = 0; i < skillXML.visualEffectIDs.length; ++i)
				{
					preloadVisualEffect(urls, skillXML.visualEffectIDs[i]);
				}
				for(i = 0; i < skillXML.summonCharacterIDs.length; ++i)
				{
					preloadCharacter(urls, skillXML.summonCharacterIDs[i], Sex.FEMALE);
				}
			}
		}
		
		public static function moveToSuggestion(info:SuggestionInfo):void
		{
			if (info && info.moduleID) {
				var hudModule:HUDModule = Manager.module.getModuleByID(ModuleID.HUD) as HUDModule;
				switch(info.featureType) {
					case 0:
						if (hudModule && hudModule.baseView) {
							hudModule.updateHUDButtonStatus(info.moduleID, true);
						}
						break;
					case 1:
						var homeModule:HomeModule = Manager.module.getModuleByID(ModuleID.HOME) as HomeModule;
						if(hudModule) hudModule.closeSelectedModule();
						if (homeModule && homeModule.baseView) {
							homeModule.onSelectedModule(info.moduleID);
						}
						break;
					case 2:
						Manager.display.showModule(info.moduleID, new Point(0, 0), LayerManager.LAYER_POPUP, "top_left", Layer.BLOCK_BLACK);
						break;
				}
			}
		}
		
		public static function moveToSuggestionSimple(featureType:int, moduleID:ModuleID, extraInfo:Object=null):void {
			switch(featureType) {
				case 0:
					var hudModule:HUDModule = Manager.module.getModuleByID(ModuleID.HUD) as HUDModule;
					if (hudModule && hudModule.baseView) {
						hudModule.extraInfo = extraInfo;
						hudModule.updateHUDButtonStatus(moduleID, true);
					}
					break;
				case 1:
					var homeModule:HomeModule = Manager.module.getModuleByID(ModuleID.HOME) as HomeModule;
					if (homeModule && homeModule.baseView) {
						//homeModule.onSelectedModule(info.moduleID);
					}
					break;
			}
		}
		
		/**
		 * 
		 * @return  TuuLauType: current TuuLauType fit with current user level
		 */	
		public static function getTuuLauFit():TuuLauType
		{
			var result:TuuLauType = null;
			
			var curLevel:int = Game.database.userdata.level;			
			var arrTuuLauType:Array = Enum.getAll(TuuLauType);
			for each (var tuuLau:TuuLauType in arrTuuLauType)
			{
				var campaignData:CampaignXML = Game.database.gamedata.getData(DataType.CAMPAIGN, tuuLau.ID) as CampaignXML;
				
				if (campaignData.levelRequirement <= curLevel && curLevel <= campaignData.maxLevelRequirement)
				{
					result = tuuLau;
					break;
				}				
			}
			
			return result;
		}
		
		/**
		 * 
		 * @return  array: list node in tuu lau
		 */	
		public static function getListTuuLauNode():Array
		{
			var result:Array = [];
			
			var curLevel:int = Game.database.userdata.level;
			var tuuLau:TuuLauType = getTuuLauFit();
			if (tuuLau)
			{
				var arrMissionData:Dictionary = Game.database.gamedata.getTable(DataType.MISSION);
				for each (var missionData:MissionXML in arrMissionData)
				{
					if (missionData.campaignID == tuuLau.ID && missionData.levelRequired <= curLevel && curLevel <= missionData.maxLevelRequirement)
					{
						result.push(missionData);
					}
				}
			}
			
			return result;
		}
	}

}