package game.data.xml
{

	import core.util.Enum;

	import game.data.vo.item.ItemInfo;
	import game.enum.ItemType;

	public class VIPDiscountXML extends XMLData
	{
		public var orgPrice:int;
		public var discountedPrice:int;
		public var items:Array = [];
		
		override public function parseXML(xml:XML):void
		{
			super.parseXML(xml);
			orgPrice = parseInt(xml.Price.toString());
			discountedPrice = parseInt(xml.Discount.toString());

			var item:ItemInfo;
			for each (var record:XML in xml.Items.Item)
			{
				item = new ItemInfo();
				item.id = parseInt(record.ID.toString());
				item.type = Enum.getEnum(ItemType, parseInt(record.Type.toString())) as ItemType;
				item.quantity = parseInt(record.Quantity.toString());
				items.push(item);
			}
		}
	}
}