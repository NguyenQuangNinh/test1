package game.net.lobby.response 
{
	import core.util.Enum;
	import core.util.Utility;
	
	import flash.utils.ByteArray;
	
	import game.data.vo.item.ItemInfo;
	import game.enum.ItemType;
	import game.net.ResponsePacket;

	/**
	 * ...
	 * @author ...
	 */
	public class ResponseEndGamePVP1vs1MM extends ResponsePacket
	{
		public var gameMode:int;
		public var result:Boolean;
		public var eloScore:int;
		public var honorScore:int;
		public var fixReward : Array = [];
		public var randomReward : Array = [];
		
		override public function decode(data : ByteArray) : void
		{
			Utility.log("@@@@ ResponseEndGamePVP1vs1MM");
			gameMode = data.readInt();
			result = data.readBoolean();
			eloScore = data.readInt();
			honorScore =  data.readInt();
			var itemData : ItemInfo;
			var numFixReward : int = data.readInt();
			for (var i:int = 0; i < numFixReward; i++) 
			{				
				itemData = new ItemInfo();
				itemData.type = Enum.getEnum(ItemType, data.readInt()) as ItemType;
				itemData.id = data.readInt();
				itemData.quantity = data.readInt();				
				fixReward.push(itemData);
			}
			
			var numRandomReward : int = data.readInt();
			for (var j:int = 0; j < numRandomReward; j++) 
			{
				itemData = new ItemInfo();
				itemData.type = Enum.getEnum(ItemType, data.readInt()) as ItemType;
				itemData.id = data.readInt();
				itemData.quantity = data.readInt();				
				randomReward.push(itemData);
			}			
		}
		
	}

}