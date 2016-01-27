package game.net.lobby.request 
{
	import core.util.ByteArrayEx;
	import flash.utils.ByteArray;
	import game.net.lobby.LobbyRequestType;
	import game.net.RequestPacket;
	import game.ui.chat.ChatModule;
	
	/**
	 * ...
	 * @author MaiPTT
	 */
	public class RequestUseItems extends RequestPacket
	{
		private var itemType:int;
		private var itemID	:int;
		private var quantity:int;
		
		public function RequestUseItems(itemType:int, itemID:int, quantity:int)
		{
			super(LobbyRequestType.CONSUME_ITEM);
			this.itemType = itemType;
			this.itemID = itemID;
			this.quantity = quantity;
		}
		
		override public function encode():ByteArray {
			var byteArr:ByteArrayEx = new ByteArrayEx();
			byteArr.writeInt(itemType);
			byteArr.writeInt(itemID);
			byteArr.writeInt(quantity);
			return byteArr;
		}
		
	}

}