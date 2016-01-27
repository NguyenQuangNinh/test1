package game.data.xml
{
	import core.util.Enum;
	import game.enum.PaymentType;
	
	import game.enum.ItemType;

	public class ExtensionItemXML extends XMLData
	{
		public var itemType:ItemType;
		public var itemID:int;
		public var price:int;
		public var paymentType:PaymentType;
		public var expirationTime:int;
		
		override public function parseXML(xml:XML):void
		{
			super.parseXML(xml);
			itemType = Enum.getEnum(ItemType, xml.ItemType.toString()) as ItemType;
			itemID = xml.ItemID.toString();
			price = xml.Price.toString();
			paymentType = Enum.getEnum(PaymentType, xml.PaymentType.toString()) as PaymentType;
			expirationTime = parseInt(xml.ExpirationTime.toString());
		}
	}
}