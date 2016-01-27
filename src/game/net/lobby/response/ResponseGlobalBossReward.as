package game.net.lobby.response 
{
	import core.util.Enum;
	
	import flash.utils.ByteArray;
	
	import game.Game;
	import game.data.vo.item.ItemInfo;
	import game.enum.ItemType;
	import game.net.ResponsePacket;
	
	/**
	 * ...
	 * @author MaiPTT
	 */
	public class ResponseGlobalBossReward extends ResponsePacket 
	{
		public var rewards:Array;
		public var bonusGold:int;

		override public function decode(data:ByteArray):void {
			super.decode(data);
			var size:int = data.readInt();
			rewards = [];
			var itemInfo:ItemInfo;
			for (var i:int = 0; i < size; i++) 
			{
				itemInfo = new ItemInfo();
				itemInfo.id = data.readInt();
				rewards.push(itemInfo);
			}
			Game.database.userdata.globalBossData.timeUp = data.readBoolean();
			bonusGold = data.readInt();
		}
	}

}