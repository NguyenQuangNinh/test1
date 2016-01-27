package game.net.lobby.request 
{
	import flash.utils.ByteArray;
	import game.net.lobby.LobbyRequestType;
	import game.net.RequestPacket;
	
	/**
	 * ...
	 * @author MaiPTT
	 */
	public class RequestShopBuySingleItem extends RequestPacket 
	{
		public var shopItemID	:int;
		public var itemQuantity	:int;
		
		public function RequestShopBuySingleItem() {
			super(LobbyRequestType.SHOP_BUY_SINGLE_ITEM);
		}
		
		override public function encode():ByteArray 
		{
			var data:ByteArray = super.encode();
			data.writeInt(shopItemID);
			data.writeInt(itemQuantity);
			
			return data;
		}
	}

}