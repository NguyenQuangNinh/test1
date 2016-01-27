package game.net.lobby.response
{
	import core.util.ByteArrayEx;
	
	import flash.utils.ByteArray;
	
	import game.net.ResponsePacket;
	
	/**
	 * ...
	 * @author ...
	 */
	public class ResponseBuyItemShopVipResult extends ResponsePacket
	{
		public var nShopVip:int;
		public var nShopItemID:int;
		public var errorCode:int;
		
		override public function decode(data:ByteArray):void
		{
			nShopVip = data.readInt();
			nShopItemID = data.readInt();
			errorCode = data.readInt();
		}
	}

}