package game.net.lobby.request
{
	import core.util.ByteArrayEx;
	import core.util.Utility;
	
	import flash.utils.ByteArray;
	
	import game.net.RequestPacket;
	import game.ui.chat.ChatModule;
	
	/**
	 * ...
	 * @author chuongth2
	 */
	public class RequestBuyItemShopVip extends RequestPacket
	{
		public var shopItemID:int;
		public var quantity:int;
		public var shopVip:int;
		
		public function RequestBuyItemShopVip(type:int, shopItemID:int, quantity:int, shopVip:int)
		{
			super(type);
			this.shopItemID = shopItemID;
			this.quantity = quantity;
			this.shopVip = shopVip;
		}
		
		override public function encode():ByteArray
		{
			var data:ByteArrayEx = new ByteArrayEx();
			data.writeInt(shopItemID);
			data.writeInt(quantity);
			data.writeInt(shopVip);
			return data;
		}
	}

}