package game.data.model 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.ByteArray;
	
	import core.Manager;
	import core.util.ByteArrayEx;
	import core.util.Enum;
	import core.util.Utility;
	
	import game.Game;
	import game.data.model.item.BaseItem;
	import game.data.model.item.ItemFactory;
	import game.data.model.item.SoulItem;
	import game.data.vo.skill.Skill;
	import game.data.vo.skill.Stance;
	import game.data.xml.CharacterXML;
	import game.data.xml.DataType;
	import game.data.xml.SkillXML;
	import game.data.xml.StanceXML;
	import game.data.xml.UnitClassXML;
	import game.enum.ElementRelationship;
	import game.enum.GameConfigID;
	import game.enum.ItemType;
	import game.enum.Sex;
	import game.enum.SkillType;
	import game.enum.UnitType;
	import game.utility.ElementUtil;

	/**
	 * ...
	 * @author bangnd2
	 */
	public class Character extends EventDispatcher
	{
		public static const XML_ID_CHANGED:String = "xmlIDChanged";
		public static const CURRENT_STAR_CHANGED:String = "currentStarChanged";
		public static const BATTLE_POINT_CHANGED:String = "battlePointChanged";
		public static const LUCKY_POINT_CHANGED:String = "luckyPointChanged";
		public static const UPDATED:String = "updated";
		
		//ID here is index of inventory
		public var ID:int;		
		public var xmlData:CharacterXML;
		public var rarity:int;
		public var currentStar:int;
		public var maxStar:int;
		public var level:int;
		public var exp:int;
		public var strength:int;
		public var agility:int;
		public var intelligent:int;
		public var vitality:int;
		public var HP:int;
		public var physicalDamage:int;
		public var attackSpeed:int;
		public var physicalCriticalChance:int;
		public var physicalCriticalDamage:int;
		public var magicalPower:int;
		public var magicalCriticalChance:int;
		public var magicalCriticalDamage:int;
		public var meleeAttackRange:int;
		public var rangerAttackRange:int;
		public var movementSpeed:int;
		public var blockingChance:int;
		public var physicalAccuracy:int;
		public var physicalArmor:int;
		public var magicalArmor:int;
		public var knockbackChance:int;
		public var knockbackDistance:int;
		public var knockbackResistChance:int;
		public var knockbackResistDistance:int;
		public var metalResistance:int;
		public var woodResistance:int;
		public var waterResistance:int;
		public var fireResistance:int;
		public var earthResistance:int;
		public var metalDestroy:int;
		public var woodDestroy:int;
		public var waterDestroy:int;
		public var fireDestroy:int;
		public var earthDestroy:int;
		public var skills:Array = [];
		
		public var isInMainFormation		:Boolean;
		public var isInChallengeFormation	:Boolean;
		public var isInHeroicFormation		:Boolean;
		public var isInQuestTransport		:Boolean;
		
		public var maxExp:int;
		public var transmissionExp:int;
		public var isMainCharacter	:Boolean;
		public var name				:String;
		public var sex				:int;
		public var firstNameIndex	:int;
		public var lastNameIndex	:int;
		public var element			:int;
		public var unitClassXML		:UnitClassXML;
		public var expiredTime		:int;
		public var soulItems		:Array = [];
		public var xmlID			:int;
		public var additionVitality		:int;
		public var additionStrength		:int;
		public var additionAgility		:int;
		public var additionIntelligent	:int;
		public var additionHP			:int;
		public var additionPhysicalDamage	:int;
		public var additionAttackSpeed		:int;
		public var additionPhysicalCriticalChance	:int;
		public var additionPhysicalCriticalDamage	:int;
		public var additionMagicalPower				:int;
		public var additionMagicalCriticalChance	:int;
		public var additionMagicalCriticalDamage	:int;
		public var additionMeleeAttackRange			:int;
		public var additionRangerAttackRange		:int;
		public var additionMovementSpeed			:int;
		public var additionBlockingChance			:int;
		public var additionPhysicalAccuracy		:int;
		public var additionPhysicalArmor		:int;
		public var additionMagicalArmor			:int;
		public var additionKnockbackChance		:int;
		public var additionKnockbackDistance	:int;
		public var additionKnockbackResistChance:int;
		public var additionKnockbackResistDistance	:int;
		public var additionMetalResistance		:int;
		public var additionWoodResistance		:int;
		public var additionWaterResistance		:int;
		public var additionFireResistance		:int;
		public var additionEarthResistance		:int;
		public var additionMetalDestroy		:int;
		public var additionWoodDestroy		:int;
		public var additionWaterDestroy		:int;
		public var additionFireDestroy		:int;
		public var additionEarthDestroy		:int;
		public var evolutionStars				:Array = [];
		public var currentLuckyPoint:int;
		public var maxLuckyPoint:int;
		public var battlePoint:int;
		public var isLock:Boolean = false;
		public var isKeepLuck:Boolean = false;
        public var divineWeaponEquiped      :int; //slot index của thần binh đã trang bị

		public function Character(xmlID:int = -1) {	
			reset();
			xmlData = Game.database.gamedata.getData(DataType.CHARACTER, xmlID) as CharacterXML;
			if (xmlData)
			{
				unitClassXML = Game.database.gamedata.getData(DataType.UNITCLASS, xmlData.characterClass) as UnitClassXML;
				//cap nhat thong tin base value tu xml
			} 
			
		}

		public function get guildAdditionVitality():int
		{
			if (!Game.database.userdata.guildInfo) return 0;
			return Game.database.gamedata.getConfigData(GameConfigID.GUILD_SKILL_ADDITIONAL_VITALITY)[Game.database.userdata.guildInfo.guildVitalitySkillLvl];
		}
		
		public function get guildAdditionStrength():int
		{
			if (!Game.database.userdata.guildInfo) return 0;
			return Game.database.gamedata.getConfigData(GameConfigID.GUILD_SKILL_ADDITIONAL_STRENGTH)[Game.database.userdata.guildInfo.guildStrengthSkillLvl];
		}
		
		public function get guildAdditionAgility():int
		{
			if (!Game.database.userdata.guildInfo) return 0;
			return Game.database.gamedata.getConfigData(GameConfigID.GUILD_SKILL_ADDITIONAL_AGILITY)[Game.database.userdata.guildInfo.guildAgilitySkillLvl];
		}
		
		public function get guildAdditionIntelligent():int
		{
			if (!Game.database.userdata.guildInfo) return 0;
			return Game.database.gamedata.getConfigData(GameConfigID.GUILD_SKILL_ADDITIONAL_INTELLIGENT)[Game.database.userdata.guildInfo.guildIntelligentSkillLvl];
		}
		
		public function isExpired():Boolean { return expiredTime <= 0 && expiredTime != -1; }
		
		public function getTransferEXP(targetElement:int):int
		{
			var elementRelationship:int = ElementUtil.getElementRelationship(element, targetElement);
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
			return transmissionExp * (penalty/100);
		}
		
		public function getNextEXP():int
		{
			var nextEXP:int = 0;
			var config:Array = Game.database.gamedata.getConfigData(GameConfigID.EXP_TABLE);
			if(config != null) nextEXP = config[level + 1];
			return nextEXP;
		}
		
		public function decode(data:ByteArray):void
		{			
			//xml id here is mapped with id table in xml
			ID = data.readInt();
			if (ID < 0)
			{
				return;
			}
			decodeCharacterData(data);
		}
		
		public function decodeCharacterData(data:ByteArray):void {
			xmlID = data.readInt();
			xmlData = Game.database.gamedata.getData(DataType.CHARACTER, xmlID) as CharacterXML;
			if (xmlData)
			{
				unitClassXML = Game.database.gamedata.getData(DataType.UNITCLASS, xmlData.characterClass) as UnitClassXML;
				if (!unitClassXML)
				{
					Utility.error("undefined unit class xml ID: " + xmlData.characterClass);
				}
			} 
			else
			{
				Utility.error("undefined character xml ID: " + xmlID);
			}
			rarity = data.readInt();
			currentStar = data.readInt();
			maxStar = data.readInt();
			level = data.readInt();
			exp = data.readInt();
			maxExp = data.readInt();
			transmissionExp = data.readInt();
			isInMainFormation = data.readBoolean();
			isInChallengeFormation = data.readBoolean();
			isInHeroicFormation = data.readBoolean();
			isInQuestTransport = data.readBoolean();
			isMainCharacter = data.readBoolean();
			if (isMainCharacter) name = ByteArrayEx(data).readString();
			sex = data.readByte();
			firstNameIndex = data.readInt();
			lastNameIndex = data.readInt();
			if (unitClassXML)
			{
				if (!isMainCharacter)
				{
					name = "";
					switch(xmlData.type)
					{
						case UnitType.HERO:
						case UnitType.MASTER:
							name = xmlData.name;
							break;
						
						case UnitType.COMMON:
							if (sex == Sex.MALE) {
								if (firstNameIndex >= 0 && firstNameIndex < unitClassXML.maleFirstName.length) {
									name = unitClassXML.maleFirstName[firstNameIndex];
								}
								
								if (lastNameIndex >= 0 && lastNameIndex < unitClassXML.maleLastName.length) {
									name += " " + unitClassXML.maleLastName[lastNameIndex];
								}
							} else {
								if (firstNameIndex >= 0 && firstNameIndex < unitClassXML.femaleFirstName.length) {
									name = unitClassXML.femaleFirstName[firstNameIndex];
								}
								
								if (lastNameIndex >= 0 && lastNameIndex < unitClassXML.femaleLastName.length) {
									name += " " + unitClassXML.femaleLastName[lastNameIndex];
								}
							}
							break;
					}
				}
				element = unitClassXML.element;
			}
			expiredTime = data.readInt();
			strength = data.readInt();
			agility = data.readInt();
			intelligent = data.readInt();
			vitality = data.readInt();
			HP = data.readInt();
			physicalDamage = data.readInt();
			data.readInt(); // discard
			attackSpeed = data.readInt();
			physicalCriticalChance = data.readInt();
			physicalCriticalDamage = data.readInt();
			magicalPower = data.readInt();
			magicalCriticalChance = data.readInt();
			magicalCriticalDamage = data.readInt();
			meleeAttackRange = data.readInt();
			rangerAttackRange = data.readInt();
			movementSpeed = data.readInt();
			blockingChance = data.readInt();
			physicalAccuracy = data.readInt();
			physicalArmor = data.readInt();
			magicalArmor = data.readInt();
			knockbackChance = data.readInt();
			knockbackDistance = data.readInt();
			knockbackResistChance = data.readInt();
			knockbackResistDistance = data.readInt();
			metalDestroy = data.readInt();
			woodDestroy = data.readInt();
			waterDestroy = data.readInt();
			fireDestroy = data.readInt();
			earthDestroy = data.readInt();
			metalResistance = data.readInt();
			woodResistance = data.readInt();
			waterResistance = data.readInt();
			fireResistance = data.readInt();
			earthResistance = data.readInt();
			additionStrength = data.readInt();
			additionAgility = data.readInt();
			additionIntelligent = data.readInt();
			additionVitality = data.readInt();
			additionHP = data.readInt();
			additionPhysicalDamage = data.readInt();
			data.readInt();
			additionAttackSpeed = data.readInt();
			additionPhysicalCriticalChance = data.readInt();
			additionPhysicalCriticalDamage = data.readInt();
			additionMagicalPower = data.readInt();
			additionMagicalCriticalChance = data.readInt();
			additionMagicalCriticalDamage = data.readInt();
			additionMeleeAttackRange = data.readInt();
			additionRangerAttackRange = data.readInt();
			additionMovementSpeed = data.readInt();
			additionBlockingChance = data.readInt();
			additionPhysicalAccuracy = data.readInt();
			additionPhysicalArmor = data.readInt();
			additionMagicalArmor = data.readInt();
			additionKnockbackChance = data.readInt();
			additionKnockbackDistance = data.readInt();
			additionKnockbackResistChance = data.readInt();
			additionKnockbackResistDistance = data.readInt();
			additionMetalDestroy = data.readInt();
			additionWoodDestroy = data.readInt();
			additionWaterDestroy = data.readInt();
			additionFireDestroy = data.readInt();
			additionEarthDestroy = data.readInt();
			additionMetalResistance = data.readInt();
			additionWoodResistance = data.readInt();
			additionWaterResistance = data.readInt();
			additionFireResistance = data.readInt();
			additionEarthResistance = data.readInt();
			
			var skillsLength:int = data.readInt();
			var skill:Skill;
			skills = [];
			for (var i:int = 0; i < skillsLength; i++)
			{
				var skillIndex:int = data.readInt();
				var skillXMLID:int = data.readInt();
				var skillLevel:int = data.readInt();
				var isEquiped:Boolean = Boolean(data.readInt());
				if(skillXMLID > 0)
				{
					skill = new Skill();
					skill.skillIndex = skillIndex;
					skill.xmlData = Game.database.gamedata.getData(DataType.SKILL, skillXMLID) as SkillXML;
					if (skill.xmlData)
					{
						for (var j:int = 0; j < skill.xmlData.stanceIDs.length; j++)
						{
							var stance:Stance = new Stance();
							stance.active = j % 2 == 0;	//temp cheat here --> need changed to real value after then
							stance.xmlData = Game.database.gamedata.getData(DataType.STANCE, skill.xmlData.stanceIDs[j]) as StanceXML;
							skill.stances.push(stance);
						}
					}
					skill.level = skillLevel;	
					skill.isEquipped = isEquiped;
					skill.inCharacterID = ID;
					skill.inCharacterSubClass = unitClassXML ? unitClassXML.subClassName : "";
					skills.push(skill);
				}
			}
			
			currentLuckyPoint = data.readInt();
			maxLuckyPoint = data.readInt();
			
			var soulItemsLength:int = data.readInt();
			var soulSlots : Array = [];
			for (var k:int = 0; k < soulItemsLength; k++) 
			{
				var id:int = data.readInt();
				var type:ItemType = Enum.getEnum(ItemType, data.readInt()) as ItemType;
				var item:BaseItem;
				
				item = ItemFactory.createItem(type, id, SoulItem);
				item.index = k;
				item.decode(data);
				//data.readBoolean(); //QuocTPB,TrungLNM: Decode menh khi
				soulSlots.push(item);
			}
			
			this.soulItems = soulSlots;
			
			battlePoint = data.readInt();
			isLock = data.readBoolean();
			isKeepLuck = data.readBoolean();
            divineWeaponEquiped = data.readInt();
			//Utility.log("battlePoint=" + battlePoint);
		}
		
		public function upClassEnable():Boolean {
			if (xmlData) {
				if ((currentStar > maxStar)
					&& xmlData.nextIDs.length > 0) {
						return true;
				}
			}
			return false;
		}
		
		public function isEvolvable():Boolean
		{
			if(xmlData == null || xmlData.type == UnitType.MASTER) return false;
			var unitClass:UnitClassXML = Game.database.gamedata.getData(DataType.UNITCLASS, xmlData.characterClass) as UnitClassXML;
			if(unitClass != null)
			{
				if(currentStar >= unitClass.maxStars) return true;
				if((level % 12 == 0) && (exp >= getNextEXP()) && (currentStar < maxStar))
				{
					return true;
				}
			}
			return false;
		}

		/**
		 * là đệ tử
		 * @return
		 */
		public function isCommon():Boolean
		{
			return (xmlData != null && xmlData.type == UnitType.COMMON);
		}

		/**
		 * la cao nhan an danh
		 * @return
		 */
		public function isMystical() : Boolean 
		{
			return (xmlData != null && xmlData.type == UnitType.MASTER);
		}
		
		public function isLegendary():Boolean
		{
			return (xmlData != null && xmlData.type == UnitType.HERO);
		}
		
		public function getEvolutionStars():Array {
			if (evolutionStars != null) {
				evolutionStars = [];
				if (xmlData) {
					var nextCharacterID:int;
					var characterXML:CharacterXML = xmlData;
					var classXML:UnitClassXML;
					while (characterXML != null) 
					{
						classXML = Game.database.gamedata.getData(DataType.UNITCLASS, characterXML.characterClass) as UnitClassXML;
						if(classXML != null) evolutionStars.push(classXML.maxStars);
						characterXML = Game.database.gamedata.getData(DataType.CHARACTER, characterXML.nextIDs[0]) as CharacterXML;
					}
				}
			}
			return evolutionStars;
		}
		
		public function getEquipSkill(type:SkillType):Skill {
			for each (var skill:Skill in skills) {
				if (skill.isEquipped && skill.xmlData && skill.xmlData.type == type)
					return skill;
			}
			return null;
		}
		
		public function getSkills():Array
		{
			var result:Array = [];
			var skill:Skill;
			for(var i:int = 0; i < skills.length; ++i)
			{
				skill = skills[i];
				if(skill != null && skill.xmlData != null && skill.isEquipped) result.push(skill);
			}
			return result;
		}
		
		public function getSkillByIndex(index:int):Skill {
			var result:Skill = null;
			var skill:Skill;
			for (var i:int = 0; i < skills.length; i++) {
				skill = skills[i];
				if (skill.skillIndex == index) {
					result = skill;
					break;
				}				
			}
			
			return result;
		}
		
		public function reset():void
		{
			expiredTime = -1;
		}
		
		public function clone() : Character {
			var cloneCharacter:Character = Manager.pool.pop(Character) as Character;
			cloneCharacter.cloneInfo(this);
			return cloneCharacter;
		}
		
		public function cloneInfo(info:Character):void {
			if (info)
			{
				var xmlIDChanged:Boolean = false;
				var currentStarChanged:Boolean = false;
				var battlePointChanged:Boolean = false;
				var luckyPointChanged:Boolean = false;
				ID = info.ID;
				if(xmlID != info.xmlID)
				{
					xmlID = info.xmlID;
					xmlIDChanged = true;
				}
				rarity = info.rarity
				if(info.currentStar != currentStar)
				{
					currentStar = info.currentStar;
					currentStarChanged = true;
				}
				maxStar = info.maxStar;
				level = info.level;
				exp = info.exp;
				strength = info.strength;
				agility = info.agility;
				intelligent = info.intelligent;
				vitality = info.vitality;
				HP = info.HP
				physicalDamage = info.physicalDamage;
				attackSpeed = info.attackSpeed;
				physicalCriticalChance = info.physicalCriticalChance
				physicalCriticalDamage = info.physicalCriticalDamage;
				magicalPower = info.magicalPower;
				magicalCriticalChance = info.magicalCriticalChance;
				magicalCriticalDamage = info.magicalCriticalDamage;
				meleeAttackRange = info.meleeAttackRange
				rangerAttackRange = info.rangerAttackRange;
				movementSpeed = info.movementSpeed;
				blockingChance = info.blockingChance;
				physicalAccuracy = info.physicalAccuracy;
				physicalArmor = info.physicalArmor;
				magicalArmor = info.magicalArmor;
				knockbackChance = info.knockbackChance;
				knockbackDistance = info.knockbackDistance;
				knockbackResistChance = info.knockbackResistChance;
				knockbackResistDistance = info.knockbackResistDistance;
				metalResistance = info.metalResistance;
				woodResistance = info.woodResistance
				waterResistance = info.waterResistance;			
				fireResistance = info.fireResistance;
				earthResistance = info.earthResistance;
				metalDestroy = info.metalDestroy;
				woodDestroy = info.woodDestroy
				waterDestroy = info.waterDestroy;
				fireDestroy = info.fireDestroy;
				earthDestroy = info.earthDestroy;
				
				//skills:Array = [];
				skills = info.skills ? info.skills.slice() : [];
				
				isInMainFormation = info.isInMainFormation;
				isInChallengeFormation = info.isInChallengeFormation;
				isInQuestTransport = info.isInQuestTransport;
				
				maxExp = info.maxExp;
				transmissionExp = info.transmissionExp;
				isMainCharacter	= info.isMainCharacter;
				name = info.name;
				sex = info.sex;
				firstNameIndex = info.firstNameIndex;
				lastNameIndex = info.lastNameIndex;
				element = info.element;
				expiredTime	= info.expiredTime;
				
				//soulItems		:Array = [];
				soulItems = info.soulItems ? info.soulItems.slice() : [];
				
				//xmlData:CharacterXML;
				xmlData = info.xmlData ? info.xmlData : null;
				//unitClassXML		:UnitClassXML;
				unitClassXML = info.unitClassXML ? info.unitClassXML : null;
				
				additionVitality = info.additionVitality;
				additionStrength = info.additionStrength;
				additionAgility	= info.additionAgility;
				additionIntelligent	= info.additionIntelligent;
				additionHP = info.additionHP;
				additionPhysicalDamage = info.additionPhysicalDamage;
				additionAttackSpeed	= info.additionAttackSpeed;
				additionPhysicalCriticalChance = info.additionPhysicalCriticalChance
				additionPhysicalCriticalDamage = info.additionPhysicalCriticalDamage;
				additionMagicalPower = info.additionMagicalPower;
				additionMagicalCriticalChance = info.additionMagicalCriticalChance;
				additionMagicalCriticalDamage = info.additionMagicalCriticalDamage;
				additionMeleeAttackRange = info.additionMeleeAttackRange;
				additionRangerAttackRange = info.additionRangerAttackRange;
				additionMovementSpeed = info.additionMovementSpeed;
				additionBlockingChance = info.additionBlockingChance;
				additionPhysicalAccuracy = info.additionPhysicalAccuracy;
				additionPhysicalArmor = info.additionPhysicalArmor;
				additionMagicalArmor = info.additionMagicalArmor;
				additionKnockbackChance = info.additionKnockbackChance;
				additionKnockbackDistance = info.additionKnockbackDistance;
				additionKnockbackResistChance = info.additionKnockbackResistDistance
				additionKnockbackResistDistance = info.additionKnockbackResistChance
				additionMetalResistance = info.additionMetalResistance;
				additionWoodResistance = info.additionWoodResistance;
				additionWaterResistance = info.additionWaterResistance;
				additionFireResistance = info.additionFireResistance;
				additionEarthResistance = info.additionEarthResistance;
				additionMetalDestroy = info.additionMetalDestroy;
				additionWoodDestroy = info.additionWoodDestroy;
				additionWaterDestroy = info.additionWaterDestroy;
				additionFireDestroy = info.additionFireDestroy;
				additionEarthDestroy = info.additionEarthDestroy;
				//private var evolutionStars				:Array;
				evolutionStars = info.evolutionStars ? info.evolutionStars.slice() : [];
				if(info.currentLuckyPoint != currentLuckyPoint)
				{
					currentLuckyPoint = info.currentLuckyPoint;
					//Utility.log("luckyPoint=" + currentLuckyPoint);
					luckyPointChanged = true;
				}
				maxLuckyPoint = info.maxLuckyPoint;
				if(info.battlePoint != battlePoint)
				{
					battlePoint = info.battlePoint;
					battlePointChanged = true;
				}

				isLock = info.isLock;
				isKeepLuck = info.isKeepLuck;

				if(xmlIDChanged) dispatchEvent(new Event(XML_ID_CHANGED));
				if(currentStarChanged) dispatchEvent(new Event(CURRENT_STAR_CHANGED));
				if(battlePointChanged) dispatchEvent(new Event(BATTLE_POINT_CHANGED));
				if(luckyPointChanged) dispatchEvent(new Event(LUCKY_POINT_CHANGED));
				dispatchEvent(new Event(UPDATED));
			}
		}

		public function setXML(ID:int):void
		{
			xmlData = Game.database.gamedata.getData(DataType.CHARACTER, ID) as CharacterXML;
			if (xmlData)
			{
				unitClassXML = Game.database.gamedata.getData(DataType.UNITCLASS, xmlData.characterClass) as UnitClassXML;
				//cap nhat thong tin base value tu xml
			}
		}

		public function get hasSoulEquiped():Boolean
		{
			var hasSoulEquiped:Boolean = false;
			for each(var soul:SoulItem in soulItems)
			{
				if(soul != null && soul.level > 0)
				{
					hasSoulEquiped = true;
					break;
				}
			}
			return hasSoulEquiped;
		}
		
		public function isRemovable():Boolean
		{
			return isMainCharacter == false && isInMainFormation == false && isInChallengeFormation == false && isInQuestTransport == false && isLock == false;
		}

        public function hasDivineWeapon():Boolean{
            return (divineWeaponEquiped >= 0);
        }
	}
}