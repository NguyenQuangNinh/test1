package game.net.lobby.response 
{
	import core.util.Enum;
	
	import flash.utils.ByteArray;
	
	import game.data.model.item.BaseItem;
	import game.data.model.item.ItemFactory;
	import game.data.model.item.SoulItem;
	import game.enum.ItemType;
	import game.net.ResponsePacket;

	/**
	 * ...
	 * @author anhtinh
	 */
	public class ResponseSoulCraftAuto extends ResponsePacket
	{
		public var result : int;
		public var size : int;
		public var souls : Array;
		public var npcs : Array;
		
		override public function decode(data:ByteArray):void
		{
			
			result = data.readInt();
			size = data.readInt();
			souls = [];
			npcs = [];
			
			for (var i:int = 0; i < size; i++) 
			{
				var id:int = data.readInt();
				var type:ItemType = Enum.getEnum(ItemType, data.readInt()) as ItemType;
				var item:BaseItem;
				
				item = ItemFactory.createItem(type, id, SoulItem);
				item.decode(data);
				
				souls.push(item);
				
				npcs.push(data.readInt());
			}
			
		}
	}

}