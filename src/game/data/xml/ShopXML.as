package game.data.xml 
{
	import core.util.Enum;
	import core.util.Utility;
	import game.enum.PaymentType;
	
	import game.enum.ItemType;
	import game.enum.ShopID;

	/**
	 * ...
	 * @author MaiPTT
	 */
	public class ShopXML extends XMLData 
	{
		public var itemID			:int = -1;
		public var discount			:int = 0;
		public var shopID			:ShopID = null;
		public var type				:ItemType = null;
		public var itemPriority		:int = 0;
		public var maxBuyNum		:int = -1;
		public var expirationTime	:int = -1;
		public var paymentType		:PaymentType;
		public var price			:int = -1;
		public var enable			:Boolean = false;
		public var levelRequire		:int = 1;
		public var serverID			:Array = [];
		public var conditions		:Array = [];
		public var stackOneBuy		:int = -1;
		
		override public function parseXML(xml:XML):void 
		{
			super.parseXML(xml);
		
			itemID = parseInt(xml.ItemID.toString());
			if (xml.Discount) discount = parseInt(xml.Discount.toString());
			shopID = Enum.getEnum(ShopID, xml.ShopID.toString()) as ShopID;
			type = Enum.getEnum(ItemType, xml.ItemType.toString()) as ItemType;
			itemPriority = parseInt(xml.Priority.toString());
			maxBuyNum = parseInt(xml.SellQuantity.toString());
			stackOneBuy = parseInt(xml.StackQuantity.toString());
			expirationTime = parseInt(xml.ExpirationTime.toString());
			paymentType = Enum.getEnum(PaymentType, xml.PaymentType.toString()) as PaymentType;
			price = parseInt(xml.Price.toString());			
			enable = parseInt(xml.Enable.toString()) > 0;
			levelRequire = parseInt(xml.LevelRequirement.toString());
			serverID = Utility.parseToIntArray(xml.ServerIDs.toString());
			conditions = Utility.parseToIntArray(xml.Conditions.toString());
		}
		
		public function clone():ShopXML
		{
			var obj:ShopXML = new ShopXML();
			obj.ID = ID;
			obj.itemID = itemID;
			obj.discount = discount;
			obj.shopID = shopID;
			obj.type = type;
			obj.itemPriority = itemPriority;
			obj.maxBuyNum = maxBuyNum;
			obj.expirationTime = expirationTime;
			obj.paymentType = paymentType;
			obj.expirationTime = expirationTime;
			obj.price = price;
			obj.enable = enable;
			obj.levelRequire = levelRequire;
			obj.serverID = serverID;
			obj.conditions = conditions;
			obj.stackOneBuy = stackOneBuy;
			
			return obj;
		}
		
	}

}