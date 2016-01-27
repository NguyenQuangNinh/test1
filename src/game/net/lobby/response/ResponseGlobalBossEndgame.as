package game.net.lobby.response 
{
	import core.util.Enum;
	
	import flash.utils.ByteArray;
	
	import game.data.vo.item.ItemInfo;
	import game.enum.ItemType;
	import game.net.ResponsePacket;
	
	/**
	 * ...
	 * @author MaiPTT
	 */
	public class ResponseGlobalBossEndgame extends ResponsePacket 
	{
		public var result	:Boolean;
		public var rewards	:Array;
		
		override public function decode(data:ByteArray):void {
			result = data.readBoolean();
			var size:int = data.readInt();
			var itemInfo:ItemInfo;
			rewards = [];
			for (var i:int = 0; i < size; i++) {
				itemInfo = new ItemInfo();
				itemInfo.type = Enum.getEnum(ItemType, data.readInt()) as ItemType;
				itemInfo.id = data.readInt();
				itemInfo.quantity = data.readInt();
				
				rewards.push(itemInfo);
			}
		}
	}

}