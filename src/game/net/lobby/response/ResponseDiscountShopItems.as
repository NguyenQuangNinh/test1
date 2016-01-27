package game.net.lobby.response 
{

	import core.util.Enum;

	import flash.utils.ByteArray;

	import game.data.vo.discount_shop.DiscountItemVO;
	import game.enum.ItemType;
	import game.net.ResponsePacket;
	/**
	 * ...
	 * @author ninhnq
	 */
	public class ResponseDiscountShopItems extends ResponsePacket
	{
		public var errorCode:int;
		public var countDownTime:int;
		public var list:Array = [];

		public function ResponseDiscountShopItems()
		{
			
		}		
		
		override public function decode(data:ByteArray):void 
		{
			errorCode = data.readInt();
			if(errorCode == 0)
			{
				countDownTime = data.readInt();
				while(data.bytesAvailable > 0)
				{
					var item:DiscountItemVO  = new DiscountItemVO();
					item.ID = data.readInt();
					item.itemID = data.readInt();
					item.itemType = Enum.getEnum(ItemType,data.readInt()) as ItemType;
					item.quantity = data.readInt();
					item.numItemLeft = data.readInt();
					item.maxBuyTimes = data.readInt();
					item.numBuyLeft = data.readInt();
					item.orgPrice = data.readInt();
					item.discountedPrice = data.readInt();
					list.push(item);
				}
			}
		}
	}

}