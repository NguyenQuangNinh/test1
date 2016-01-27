package game.net.lobby.response 
{
	import flash.utils.ByteArray;
	import game.net.ResponsePacket;
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class ResponseListItemShopDaily extends ResponsePacket
	{
		public var itemArr:Array = []
		
		public function ResponseListItemShopDaily() 
		{
			
		}
		
		override public function decode(data:ByteArray):void 
		{
			super.decode(data);
			
			var size:int = data.readInt();
			for (var i:int = 0; i < size; i++ ) {
				var itemID:int = data.readInt();
				var boughtQuantity:int = data.readInt();
				itemArr.push( { ID: itemID, numBought: boughtQuantity } );
			}
		}
	}

}