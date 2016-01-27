package game.data.xml 
{
	import core.util.Enum;
	import game.data.model.item.IItemConfig;
	import game.data.model.item.ItemFactory;
	
	import game.enum.ItemType;

	/**
	 * ...
	 * @author anhtinh
	 */
	public class RewardXML extends XMLData
	{
		
		public var itemID		:int = -1;
		public var type			:ItemType = null;
		public var quantity		:int = -1;
		public var rate	:int = -1;
		public var requirement		:int = -1;
		
		
		override public function parseXML(xml:XML):void 
		{
			super.parseXML(xml);
			
			itemID = parseInt(xml.ItemID.toString());
			type = Enum.getEnum(ItemType, xml.Type) as ItemType;
			quantity = parseInt(xml.Quantity.toString());
			rate = parseInt(xml.Rate.toString());
			requirement = parseInt(xml.Requirement.toString());
		}
		
		
		public function getItemInfo(): IItemConfig {
			//var itemConfig:IItemConfig = ItemFactory.buildItemConfig(rewardXML.type, rewardXML.itemID) as IItemConfig;
			
			var info:IItemConfig = ItemFactory.buildItemConfig(type, itemID) as IItemConfig;
			return info;
		}
	}

}