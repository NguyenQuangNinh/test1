package game.data.xml 
{
	/**
	 * ...
	 * @author MaiPTT
	 */
	public class UnitClassXML extends XMLData 
	{
		public var mainClassID			:int = -1;
		public var mainClassName		:String = "";
		public var subClassName			:String = "";
		public var description:String = "";
		public var maxStars				:int = -1;
		public var minStars				:int = -1;
		
		public var strengthPerLevel		:int = -1;
		public var agilityPerLevel		:int = -1;
		public var intelligentPerLevel	:int = -1;
		public var vitalityPerLevel		:int = -1;
		
		public var strengthPerStar		:int = -1;
		public var agilityPerStar		:int = -1;
		public var intelligentPerStar	:int = -1;
		public var vitalityPerStar		:int = -1;
		
		public var damagePerStrength	:int = -1;
		public var armorPerStrength		:int = -1;
		public var knockbackResistPerStrength	:int = -1;
		public var damagePerAgility		:int = -1;
		public var dodgeRatePerAgility	:int = -1;
		public var accuracyPerAgility	:int = -1;
		public var damagePerIntelligent	:int = -1;
		public var magicResistPerIntelligent	:int = -1;
		public var healthPointPerVitality		:int = -1;
		public var maleFirstName		:Array = [];
		public var maleLastName			:Array = [];
		public var femaleFirstName		:Array = [];
		public var femaleLastName		:Array = [];
		public var element				:int   = -1;
		
		override public function parseXML(xml:XML):void 
		{
			super.parseXML(xml);
			mainClassID = parseInt(xml.MainClassID.toString());
			mainClassName = xml.MainClass.toString();
			subClassName = xml.SubClass.toString();
			description = xml.Desc.toString();
			minStars = parseInt(xml.MinStar.toString());
			maxStars = parseInt(xml.MaxStar.toString());
			strengthPerLevel = parseInt(xml.StrengthPerLevel.toString());
			agilityPerLevel = parseInt(xml.AgilityPerLevel.toString());
			intelligentPerLevel = parseInt(xml.IntelligentPerLevel.toString());
			vitalityPerLevel = parseInt(xml.VitalityPerLevel.toString());
			strengthPerStar = parseInt(xml.StrengthPerStar.toString());
			agilityPerStar = parseInt(xml.AgilityPerStar.toString());
			intelligentPerStar = parseInt(xml.IntelligentPerStar.toString());
			vitalityPerStar = parseInt(xml.VitalityPerStar.toString());
			damagePerStrength = parseInt(xml.DamagePerStrength.toString());
			armorPerStrength = parseInt(xml.ArmorPerStrength.toString());
			knockbackResistPerStrength = parseInt(xml.KnockbackResistPerStrength.toString());
			damagePerAgility = parseInt(xml.DamagePerAgility.toString());
			dodgeRatePerAgility = parseInt(xml.DodgeRatePerAgility.toString());
			accuracyPerAgility = parseInt(xml.AccuracyPerAgility.toString());
			damagePerIntelligent = parseInt(xml.DamagePerIntelligent.toString());
			magicResistPerIntelligent = parseInt(xml.MagicResistPerIntelligent.toString());
			healthPointPerVitality = parseInt(xml.HealthPointPerVitality.toString());
			maleFirstName = xml.MaleFirstName.toString().split(",");
			maleLastName = xml.MaleLastName.toString().split(",");
			femaleFirstName = xml.FemaleFirstName.toString().split(",");
			femaleLastName = xml.FemaleLastName.toString().split(",");
			element = parseInt(xml.Element.toString());
		}
	}

}