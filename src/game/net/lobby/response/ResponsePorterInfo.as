package game.net.lobby.response 
{
	import core.Manager;
	import core.util.ByteArrayEx;
	import core.util.Enum;
	import core.util.Utility;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import game.Game;
	import game.data.model.item.ItemFactory;
	import game.data.vo.express.PorterVO;
	import game.data.vo.reward.RewardInfo;
	import game.enum.ItemType;
	import game.enum.PorterType;
	import game.net.ResponsePacket;
	/**
	 * ...
	 * @author anhtinh
	 */
	public class ResponsePorterInfo extends ResponsePacket
	{
		public var errorCode:int;
		public var playerID : int;
		public var name:String;
		public var level:int;
		public var element:int;
		public var porterType:PorterType;
		public var elapsedTransportTime:int;
		public var robRemainCount:int;
		public var timeRemainRob:int; //Thoi gian con lai co the cuop
		public var robEnable:Boolean;
		public var rewards:Array = [];

		override public function decode(data:ByteArray):void 
		{
			errorCode = data.readInt();
			if(errorCode == 0)
			{
				playerID = data.readInt();
				name = ByteArrayEx(data).readString();
				level = data.readInt();
				element = data.readInt();
				porterType = Enum.getEnum(PorterType, data.readInt()) as PorterType;
				elapsedTransportTime = data.readInt();
				robRemainCount = data.readInt();
				timeRemainRob = data.readInt();
				robEnable = data.readBoolean();

				var itemData:RewardInfo;
				while(data.bytesAvailable > 0)
				{
					itemData = new RewardInfo();
					itemData.itemID = data.readInt();
					itemData.itemType = Enum.getEnum(ItemType, data.readInt()) as ItemType;
					itemData.quantity = data.readInt();
					itemData.itemConfig =  ItemFactory.buildItemConfig( itemData.itemType, itemData.itemID);
					rewards.push(itemData);
				}
			}
		}
		
	}

}