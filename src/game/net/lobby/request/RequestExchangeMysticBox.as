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
	public class RequestExchangeMysticBox extends RequestPacket
	{
		public var itemID:int;
		public var quantity:int;
		
		public function RequestExchangeMysticBox(type:int, itemID:int, quantity:int)
		{
			super(type);
			this.itemID = itemID;
			this.quantity = quantity;
		}
		
		override public function encode():ByteArray
		{
			var data:ByteArrayEx = new ByteArrayEx();
			data.writeInt(itemID);
			data.writeInt(quantity);
			return data;
		}
	}

}