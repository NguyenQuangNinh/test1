package game.net.lobby.response
{
	import core.util.Enum;
	
	import flash.utils.ByteArray;
	
	import game.data.model.item.ItemFactory;
	import game.data.vo.item.ItemInfo;
	import game.enum.ItemType;
	import game.net.ResponsePacket;
	
	public class ResponseRewardPacket extends ResponsePacket
	{
		public var fixedItems:Array = [];
		public var randomItems:Array = [];
		
		override public function decode(data:ByteArray):void
		{
			var length:int = data.readInt();
			var i:int;
			var itemType:ItemType;
			var itemID:int;
			var item:ItemInfo;
			for(i = 0; i < length; ++i)
			{
				item = new ItemInfo();
				item.type 		= Enum.getEnum(ItemType,  data.readInt()) as ItemType;
				item.id 								= data.readInt();
				item.quantity 							= data.readInt();
				fixedItems.push(item);
			}
			length = data.readInt();
			for(i = 0; i < length; ++i)
			{
				item = new ItemInfo();
				item.type 		= Enum.getEnum(ItemType,  data.readInt()) as ItemType;
				item.id 								= data.readInt();
				item.quantity 							= data.readInt();
				randomItems.push(item);
			}
		}
	}
}