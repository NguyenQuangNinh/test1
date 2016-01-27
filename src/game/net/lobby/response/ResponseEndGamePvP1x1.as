package game.net.lobby.response 
{
	import core.util.Enum;
	
	import flash.utils.ByteArray;
	
	import game.data.vo.item.ItemInfo;
	import game.enum.ItemType;
	import game.net.ResponsePacket;
	
	/**
	 * ...
	 * @author bangnd2
	 */
	public class ResponseEndGamePvP1x1 extends ResponsePacket 
	{
		public var result:Boolean;
		public var newRank:int;
		public var oldRank:int;
		public var fixRewards:Array = [];
		public var randomRewards:Array = [];
		
		override public function decode(data:ByteArray):void 
		{
			result = data.readBoolean();
			//oldRank = data.readInt();
			//newRank = data.readInt();
			
			var itemData:ItemInfo;
			if (result) {
				var numFixRewards:int = data.readInt();
				for (var i:int = 0; i < numFixRewards; i++) {
					itemData = new ItemInfo();
					itemData.type = Enum.getEnum(ItemType, data.readInt()) as ItemType;
					itemData.id = data.readInt();
					itemData.quantity = data.readInt();
					
					fixRewards.push(itemData);
				}
				
				var numRandomRewards:int = data.readInt();
				for (i = 0; i < numRandomRewards; i ++ ) {
					itemData = new ItemInfo();
					itemData.type = Enum.getEnum(ItemType, data.readInt()) as ItemType;
					itemData.id = data.readInt();
					itemData.quantity = data.readInt();
					
					randomRewards.push(itemData);
				}
			} else {
				fixRewards = [];
				randomRewards = [];
			}
		}
	}
}