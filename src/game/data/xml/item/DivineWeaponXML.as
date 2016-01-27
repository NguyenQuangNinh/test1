package game.data.xml.item {
import core.util.Enum;

import game.enum.Element;
import game.enum.ItemType;

/**
	 * ...
	 * @author dinhhq
	 */
	public class DivineWeaponXML extends ItemXML
	{
		public var urlBigIcon:String;
		public var level:uint = 1;
		public var urlBorder:String = "";
		public var numbOfAttributes:int;
		/*public var maxAttributeLevel:int;
		public var nextMaxAttributeLevel:int;*/
		public var element:Element;
		public var arrAttribUpgradeRecipe:Array = [];
        public var arrStarUpgradeRecipe:Array = [];

		override public function parseXML(xml : XML) : void 
		{
			super.parseXML(xml);
			urlBigIcon = xml.BigIconURL.toString();
			level = xml.Level.toString();
			urlBorder = xml.BAnimURL.toString();
			numbOfAttributes = xml.NumOfAttrib.toString();
			/*maxAttributeLevel = xml.MaxAttribLevel.toString();
			nextMaxAttributeLevel = xml.NextMaxAttribLevel.toString();*/
			element = Enum.getEnum(Element, xml.Element.toString()) as Element;
            for each (var material1:XML in xml.AttribUpgradeRecipe.Material){
                var itemType1:ItemType = Enum.getEnum(ItemType,material1.Type.toString()) as ItemType;
                arrAttribUpgradeRecipe.push({ID: material1.ID.toString(), Type: itemType1, Count: material1.Quantity.toString()});
            }
            if (level != 5)
            {
                for each (var material2:XML in xml.StarUpgradeRecipe.Material){
                    var itemType2:ItemType = Enum.getEnum(ItemType,material2.Type.toString()) as ItemType;
                    arrStarUpgradeRecipe.push({ID: material2.ID.toString(), Type: itemType2, Count: material2.Quantity.toString()});
                }
            }

		}
	}

}