package game.net.lobby.response 
{
	import core.util.ByteArrayEx;
	import flash.utils.ByteArray;
	import game.net.ResponsePacket;
	import game.ui.shop.shop_secret_merchant.ConsumePlayer;
	
	/**
	 * ...
	 * @author MaiPTT
	 */
	public class ResponseSecretMerchantList extends ResponsePacket 
	{
		public var players	:Array = [];
		
		override public function decode(data:ByteArray):void {
			super.decode(data);
			var length:int = data.readInt();
			var player:ConsumePlayer;
			for (var i:int = 0; i < length; i++) {
				player = new ConsumePlayer();
				player.playerID = data.readInt();
				player.playerName = (ByteArrayEx)(data).readString();
				player.shopID = data.readInt();
				player.quantity = data.readInt();
				
				players.push(player);
			}
		}
	}

}