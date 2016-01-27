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
	public class ResponseSoulInfo extends ResponsePacket
	{
		public var npcIndex : int;
		public var freeDivineRemain : int;
		public var freeDivineTotal : int;
		public var goldDivineRemain : int;
		public var goldDivineTotal : int;
		public var vipDivineRemain : int;
		public var vipDivineTotal : int;
		public var exchangePoint : int;
		
		public var souls:Array;		//SoulItem array
		
		override public function decode(data:ByteArray):void
		{
			
			npcIndex = data.readInt();
			freeDivineRemain = data.readInt();
			freeDivineTotal = data.readInt();
			goldDivineRemain = data.readInt();
			goldDivineTotal = data.readInt();
			vipDivineRemain = data.readInt();
			vipDivineTotal = data.readInt();
			exchangePoint = data.readInt();
			var numOfSoul : int = data.readInt();
			
			souls = [];
			
			for (var j:int = 0; j < numOfSoul; j++) 
			{
				var id:int = data.readInt();
				var type:ItemType = Enum.getEnum(ItemType, data.readInt()) as ItemType;
				var item:BaseItem;
				
				item = ItemFactory.createItem(type, id, SoulItem);
				item.decode(data);
				item.index = j;
				souls.push(item);
			}
			
			
		}
		
		public function get totalDivine() : int {
			var result : int = 0;
			if (freeDivineTotal == -1 || goldDivineTotal == -1 || vipDivineTotal == -1) {
				return int.MAX_VALUE;
			}
			return (freeDivineRemain + goldDivineRemain + vipDivineRemain);
		}
		
	}

}