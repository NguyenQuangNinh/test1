package game.net.lobby.response 
{
	import core.Manager;
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
	public class ResponsePorterPlayerInfo extends ResponsePacket
	{
		public var porterType:PorterType; //Loai tieu xa dang tien hanh van tieu
		public var elapsedTransportTime:int;
		public var robbedRemainCount:int; //So lan bi cuop con lai
		public var transportRemainCount:int; // So lan Van Tieu con lai
		public var raidRemainCountInDay:int; // So lan di cuop con lai
		public var refreshPorterType:PorterType; //Loai tieu xa hien tai co the thue (sau khi refresh)
		public var numOfRefresh:int; // So lan refresh hien tai
		public var rewards:Array = [];

		override public function decode(data:ByteArray):void 
		{
			var type:int = data.readInt();

			refreshPorterType = Enum.getEnum(PorterType, data.readInt()) as PorterType;
			numOfRefresh = data.readInt();

			if(type > 0)
			{
				porterType = Enum.getEnum(PorterType, type) as PorterType;
				elapsedTransportTime = data.readInt();
				robbedRemainCount = data.readInt();
				transportRemainCount = data.readInt();
				raidRemainCountInDay = data.readInt();

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