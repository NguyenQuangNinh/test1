package game.net.lobby.response 
{
	import core.util.ByteArrayEx;
	
	import flash.utils.ByteArray;
	
	import game.net.ResponsePacket;

	/**
	 * ...
	 * @author chuongth2
	 */
	public class ResponseChangeRecipe extends ResponsePacket 
	{
		public var errorCode:int;
		public var itemID:int;
		public var itemType:int;
		public var quantity:int;

		
		override public function decode(data:ByteArray):void 
		{
			errorCode = data.readInt();
			if (errorCode == 0)//success
			{
				itemID = data.readInt();
				itemType = data.readInt();
				quantity = data.readInt();
			}
		}
		
	}

}