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
	public class ResponseSoulInventory extends ResponsePacket
	{
		
		public var souls:Array;		//SoulItem array
		
		override public function decode(data:ByteArray):void
		{
			
			var numOfSoul : int = data.readInt();
			
			souls = [];
			
			for (var j:int = 0; j < numOfSoul; j++) 
			{
				var id:int = data.readInt();
				var type:ItemType = Enum.getEnum(ItemType, data.readInt()) as ItemType;
				var item:SoulItem;
				
				item = ItemFactory.createItem(type, id, SoulItem) as SoulItem;
				item.decode(data);
				//item.locked = data.readBoolean();
				item.index = j;
				souls.push(item);
			}
			
		}
		
	}

}