package game.data.xml.item 
{
	import core.util.Enum;
	import core.util.Utility;
	import game.data.model.item.IItemConfig;
	import game.enum.SoulType;
	/**
	 * ...
	 * @author anhtinh
	 */
	public class SoulXML extends ItemXML
	{
		public var rarity : int;
		public var bonusAttributes : Array;
		public var level2Exp : int;
		public var expIncrementPerLevel : int;
		public var maxLevel : int;
		public var expBase : int;
		public var goldPriceSell : int;
		public var animURL : String = "";
		public var soulType:SoulType;
		public var isRare:Boolean;
		
		public static const RARITY_LEVEL:int = 3;
		
		override public function parseXML(xml : XML) : void 
		{
			super.parseXML(xml);
			
			rarity = xml.Rarity.toString();
			bonusAttributes =  Utility.parseToIntArray(xml.BonusAttributes.toString(), ",");
			level2Exp = xml.Level2Exp.toString();
			expIncrementPerLevel = xml.ExpIncrementPerLevel.toString();
			maxLevel = xml.MaxLevel.toString();
			expBase = xml.ExpBase.toString();
			goldPriceSell = xml.GoldPriceSell.toString();
			animURL = xml.AnimURL.toString();
			
			soulType = Enum.getEnum(SoulType, parseInt(xml.SoulType.toString())) as SoulType;
			
			isRare = rarity >= RARITY_LEVEL;
		}
	}

}