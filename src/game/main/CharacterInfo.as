package game.main 
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import game.data.model.Character;
	import game.data.xml.DataType;
	import game.data.xml.ElementData;
	import game.Game;
	
	/**
	 * ...
	 * @author bangnd2
	 */
	public class CharacterInfo extends Sprite 
	{
		private var txtElement:TextField;
		private var txtRarity:TextField;
		private var txtStar:TextField;
		private var txtLevel:TextField;
		private var txtStrength:TextField;
		private var txtAgility:TextField;
		private var txtIntelligent:TextField;
		private var txtVitality:TextField;
		private var txtHP:TextField;
		private var txtPhysicalDamage:TextField;
		private var txtAttackSpeed:TextField;
		private var txtPhysicalCriticalChance:TextField;
		private var txtPhysicalCriticalDamage:TextField;
		private var txtMagicalPower:TextField;
		private var txtMagicalCriticalChance:TextField;
		private var txtMagicalCriticalDamage:TextField;
		private var txtMeleeAttackRange:TextField;
		private var txtRangerAttackRange:TextField;
		private var txtMovementSpeed:TextField;
		private var txtBlockingChance:TextField;
		private var txtPhysicalAccuracy:TextField;
		private var txtPhysicalArmor:TextField;
		private var txtMagicalArmor:TextField;
		private var txtKnockbackChance:TextField;
		private var txtKnockbackDistance:TextField;
		private var txtKnockbackResistChance:TextField;
		private var txtKnockbackResistDistance:TextField;
		private var txtMetalResistance:TextField;
		private var txtWoodResistance:TextField;
		private var txtWaterResistance:TextField;
		private var txtFireResistance:TextField;
		private var txtEarthResistance:TextField;
		
		public function CharacterInfo() 
		{
			txtElement = new TextField();
			txtElement.width = 200;
			txtElement.height = 20;
			addChild(txtElement);
			
			txtRarity = new TextField();
			txtRarity.width = 200;
			txtRarity.height = 20;
			txtRarity.y = 20;
			addChild(txtRarity);
			
			txtStar = new TextField();
			txtStar.width = 200;
			txtStar.height = 20;
			txtStar.y = 40;
			addChild(txtStar);
			
			txtLevel = new TextField();
			txtLevel.width = 200;
			txtLevel.height = 20;
			txtLevel.y = 60;
			addChild(txtLevel);
			
			txtStrength = new TextField();
			txtStrength.width = 200;
			txtStrength.height = 20;
			txtStrength.y = 80;
			addChild(txtStrength);
			
			txtAgility = new TextField();
			txtAgility.width = 200;
			txtAgility.height = 20;
			txtAgility.y = 100;
			addChild(txtAgility);
			
			txtIntelligent = new TextField();
			txtIntelligent.width = 200;
			txtIntelligent.height = 20;
			txtIntelligent.y = 120;
			addChild(txtIntelligent);
			
			txtVitality = new TextField();
			txtVitality.width = 200;
			txtVitality.height = 20;
			txtVitality.y = 140;
			addChild(txtVitality);
			
			txtHP = new TextField();
			txtHP.width = 200;
			txtHP.height = 20;
			txtHP.y = 160;
			addChild(txtHP);
			
			txtPhysicalDamage = new TextField();
			txtPhysicalDamage.width = 200;
			txtPhysicalDamage.height = 20;
			txtPhysicalDamage.y = 180;
			addChild(txtPhysicalDamage);
			
			txtAttackSpeed = new TextField();
			txtAttackSpeed.width = 200;
			txtAttackSpeed.height = 20;
			txtAttackSpeed.y = 200;
			addChild(txtAttackSpeed);
			
			txtPhysicalCriticalChance = new TextField();
			txtPhysicalCriticalChance.width = 200;
			txtPhysicalCriticalChance.height = 20;
			txtPhysicalCriticalChance.y = 220;
			addChild(txtPhysicalCriticalChance);
			
			txtPhysicalCriticalDamage = new TextField();
			txtPhysicalCriticalDamage.width = 200;
			txtPhysicalCriticalDamage.height = 20;
			txtPhysicalCriticalDamage.y = 240;
			addChild(txtPhysicalCriticalDamage);
			
			txtMagicalPower = new TextField();
			txtMagicalPower.width = 200;
			txtMagicalPower.height = 20;
			txtMagicalPower.y = 260;
			addChild(txtMagicalPower);
			
			txtMagicalCriticalChance = new TextField();
			txtMagicalCriticalChance.width = 200;
			txtMagicalCriticalChance.height = 20;
			txtMagicalCriticalChance.y = 280;
			addChild(txtMagicalCriticalChance);
			
			txtMagicalCriticalDamage = new TextField();
			txtMagicalCriticalDamage.width = 200;
			txtMagicalCriticalDamage.height = 20;
			txtMagicalCriticalDamage.y = 300;
			addChild(txtMagicalCriticalDamage);
			
			txtMeleeAttackRange = new TextField();
			txtMeleeAttackRange.width = 200;
			txtMeleeAttackRange.height = 20;
			txtMeleeAttackRange.y = 320;
			addChild(txtMeleeAttackRange);
			
			txtRangerAttackRange = new TextField();
			txtRangerAttackRange.width = 200;
			txtRangerAttackRange.height = 20;
			txtRangerAttackRange.y = 340;
			addChild(txtRangerAttackRange);
			
			txtMovementSpeed = new TextField();
			txtMovementSpeed.width = 200;
			txtMovementSpeed.height = 20;
			txtMovementSpeed.y = 360;
			addChild(txtMovementSpeed);
			
			txtBlockingChance = new TextField();
			txtBlockingChance.width = 200;
			txtBlockingChance.height = 20;
			txtBlockingChance.y = 380;
			addChild(txtBlockingChance);
			
			txtPhysicalAccuracy = new TextField();
			txtPhysicalAccuracy.width = 200;
			txtPhysicalAccuracy.height = 20;
			txtPhysicalAccuracy.y = 400;
			addChild(txtPhysicalAccuracy);
			
			txtPhysicalArmor = new TextField();
			txtPhysicalArmor.width = 200;
			txtPhysicalArmor.height = 20;
			txtPhysicalArmor.y = 420;
			addChild(txtPhysicalArmor);
			
			txtMagicalArmor = new TextField();
			txtMagicalArmor.width = 200;
			txtMagicalArmor.height = 20;
			txtMagicalArmor.y = 440;
			addChild(txtMagicalArmor);
			
			txtKnockbackChance = new TextField();
			txtKnockbackChance.width = 200;
			txtKnockbackChance.height = 20;
			txtKnockbackChance.y = 460;
			addChild(txtKnockbackChance);
			
			txtKnockbackDistance = new TextField();
			txtKnockbackDistance.width = 200;
			txtKnockbackDistance.height = 20;
			txtKnockbackDistance.y = 480;
			addChild(txtKnockbackDistance);
			
			txtKnockbackResistChance = new TextField();
			txtKnockbackResistChance.width = 200;
			txtKnockbackResistChance.height = 20;
			txtKnockbackResistChance.y = 500;
			addChild(txtKnockbackResistChance);
			
			txtKnockbackResistDistance = new TextField();
			txtKnockbackResistDistance.width = 200;
			txtKnockbackResistDistance.height = 20;
			txtKnockbackResistDistance.y = 520;
			addChild(txtKnockbackResistDistance);
			
			txtMetalResistance = new TextField();
			txtMetalResistance.width = 200;
			txtMetalResistance.height = 20;
			txtMetalResistance.y = 540;
			addChild(txtMetalResistance);
			
			txtWoodResistance = new TextField();
			txtWoodResistance.width = 200;
			txtWoodResistance.height = 20;
			txtWoodResistance.y = 560;
			addChild(txtWoodResistance);
			
			txtWaterResistance = new TextField();
			txtWaterResistance.width = 200;
			txtWaterResistance.height = 20;
			txtWaterResistance.y = 580;
			addChild(txtWaterResistance);
			
			txtFireResistance = new TextField();
			txtFireResistance.width = 200;
			txtFireResistance.height = 20;
			txtFireResistance.y = 600;
			addChild(txtFireResistance);
			
			txtEarthResistance = new TextField();
			txtEarthResistance.width = 200;
			txtEarthResistance.height = 20;
			txtEarthResistance.y = 620;
			addChild(txtEarthResistance);
		}
		
		public function setData(character:Character):void
		{
			var elementData:ElementData = Game.database.gamedata.getData(DataType.ELEMENT, character.xmlData.element) as ElementData;
			txtElement.text = elementData.name;
			txtRarity.text = "Rarity: " + character.rarity;
			txtStar.text = "Star: " + character.currentStar + "/" + character.maxStar;
			txtLevel.text = "Level: " + character.level + " (" + character.exp + ")";
			txtStrength.text = "Strength: " + character.strength;
			txtAgility.text = "Agility: " + character.agility;
			txtIntelligent.text = "Intelligent: " + character.intelligent;
			txtVitality.text = "Vitality: " + character.vitality;
			txtHP.text = "HP: " + character.HP;
			txtPhysicalDamage.text = "Physical damage: " + character.physicalDamage;
			txtAttackSpeed.text = "Attack speed: " + character.attackSpeed/1000 + "s";
			txtPhysicalCriticalChance.text = "Physical critical chance: " + character.physicalCriticalChance + "%";
			txtPhysicalCriticalDamage.text = "Physical critical damage: " + character.physicalCriticalDamage + "%";
			txtMagicalPower.text = "Magical power: " + character.magicalPower + "%";
			txtMagicalCriticalChance.text = "Magical critical chance: " + character.magicalCriticalChance + "%";
			txtMagicalCriticalDamage.text = "Magical critical damage: " + character.magicalCriticalDamage + "%";
			txtMeleeAttackRange.text = "Melee attack range: " + character.meleeAttackRange;
			txtRangerAttackRange.text = "Ranger attack range: " + character.rangerAttackRange;
			txtMovementSpeed.text = "Movement speed: " + character.movementSpeed;
			txtBlockingChance.text = "Blocking chance: " + character.blockingChance + "%";
			txtPhysicalAccuracy.text = "Physical accuracy: " + character.physicalAccuracy + "%";
			txtPhysicalArmor.text = "Physical armor: " + character.physicalArmor;
			txtMagicalArmor.text = "Magical armor: " + character.magicalArmor;
			txtKnockbackChance.text = "Knockback chance: " + character.knockbackChance + "%";
			txtKnockbackDistance.text = "Knockback distance: " + character.knockbackDistance;
			txtKnockbackResistChance.text = "Knockback resist chance: " + character.knockbackResistChance + "%";
			txtKnockbackResistDistance.text = "Knockback resist distance: " + character.knockbackResistDistance;
			txtMetalResistance.text = "Metal resistance: " + character.metalResistance + "%";
			txtWoodResistance.text = "Wood resistance: " + character.woodResistance + "%";
			txtWaterResistance.text = "Water resistance: " + character.waterResistance + "%";
			txtFireResistance.text = "Fire resistance: " + character.fireResistance + "%";
			txtEarthResistance.text = "Earth resistance: " + character.earthResistance + "%";
		}
	}
}