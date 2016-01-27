package game.net.lobby.response
{
	
	import flash.utils.ByteArray;
	
	import core.util.Enum;
	import core.util.Utility;
	
	import game.data.model.item.BaseItem;
	import game.data.model.item.ItemFactory;
	import game.enum.ItemType;
	import game.net.ResponsePacket;
	
	/**
	 * ...
	 * @author anhtinh
	 */
	public class ResponseItemInventory extends ResponsePacket
	{
		public var items:Array; //Item array
		
		override public function decode(data:ByteArray):void
		{
			items = [];
			var i:int = 0;
			while (data.bytesAvailable >= 16)
			{
				var id:int = data.readInt();
				var type:ItemType = Enum.getEnum(ItemType, data.readInt()) as ItemType;
				//Utility.log("inventory had items: ");
				//if (type != ItemType.EMPTY_SLOT)
					//Utility.log("item in inventory: " + type.name);
				var item:BaseItem;
				item = ItemFactory.createItem(type, id);
				item.decode(data);
				item.index = i;
				items.push(item);
				i++;
			}
		
		}
	
	}

}