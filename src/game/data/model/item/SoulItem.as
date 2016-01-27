package game.data.model.item
{
	import flash.utils.ByteArray;
	import game.data.xml.DataType;
	import game.data.xml.item.SoulXML;
	import game.enum.ItemType;
	import game.enum.SoulType;
	import game.Game;
	
	/**
	 * ...
	 * @author anhtinh
	 */
	public class SoulItem extends Item
	{
		public var exp:int;
		public var level:int;
		public var locked:Boolean = false;
		private var _usedInMerge:Boolean = false;
		
		public function SoulItem()
		{
		
		}
		
		override public function init(xmlID:int, type:ItemType):void
		{
			super.init(xmlID, type);
			xmlData = Game.database.gamedata.getData(DataType.ITEMSOUL, xmlID) as SoulXML;
			if (xmlData == null)
			{
				var soulXML:SoulXML = new SoulXML();
				soulXML.ID = 0;
				soulXML.type = ItemType.EMPTY_SLOT;
				
				xmlData = soulXML;
			}
		}
		
		public function get soulXML():SoulXML
		{
			return xmlData as SoulXML;
		}
		
		override public function decode(data:ByteArray):void
		{
			
			level = data.readInt();
			exp = data.readInt();
			locked = data.readBoolean();
		}
		
		public static function compare(soul1:SoulItem, soul2:SoulItem):Boolean
		{
			
			if (soul1 == null || soul2 == null)
				return false;
			
			return (soul1.soulXML.ID == soul2.soulXML.ID) 
					&& (soul1.soulXML.type == soul2.soulXML.type) 
					&& (soul1.index == soul2.index) 
					&& (soul1.exp == soul2.exp)
					&& (soul1.level == soul2.level);
		
		}
		
		public function isBadSoul():Boolean
		{
			return soulXML.type == ItemType.ITEM_BAD_SOUL;
		}
		
		public function isRecipeSoul():Boolean 
		{
			return soulXML.soulType == SoulType.SOUL_RECIPE;
		}
		
		public function isGoodSoul():Boolean
		{
			return soulXML.type == ItemType.ITEM_SOUL;
		}
		
		public function get usedInMerge():Boolean {
			return _usedInMerge;
		}
		
		public function set usedInMerge(used:Boolean):void {
			_usedInMerge = used;
		}
		
		public function getSoulExp():int {
			var result:int = 0;
			
			if (xmlData) {
				result = exp + (xmlData as SoulXML).expBase;
				
				if (level > 1) {
					for (var i:int = 2; i <= level; i++) {
						result += (xmlData as SoulXML).level2Exp + (xmlData as SoulXML).expIncrementPerLevel * (i - 2);
					}
				}
				
			}
			//Utility.log( "SoulItem.getSoulExp for soul " + (xmlData as SoulXML).name + " at level " + level + " is " + result);
			return result;			
		}
	}

}