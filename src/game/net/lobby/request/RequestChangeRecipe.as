package game.net.lobby.request
{
	import flash.utils.ByteArray;
	import game.net.RequestPacket;
	
	/**
	 * ...
	 * @author chuongth2
	 */
	public class RequestChangeRecipe extends RequestPacket
	{
		private var itemType:int;
		private var itemID:int;
		private var quantity:int;
		public function RequestChangeRecipe(type:int, itemType:int, itemID:int, quantity:int)
		{
			super(type);
			this.itemType = itemType;
			this.itemID = itemID;
			this.quantity = quantity;
		}
		
		override public function encode():ByteArray
		{
			var data:ByteArray = super.encode();
			data.writeInt(itemID);
			data.writeInt(itemType);
			data.writeInt(quantity);
			return data;
		}
	}

}