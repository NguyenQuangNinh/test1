package game.net.lobby.response 
{
	import flash.utils.ByteArray;
	import game.net.ResponsePacket;
	/**
	 * ...
	 * @author ninhnq
	 */
	public class ResponseVIPPromotionPlayerInfo extends ResponsePacket
	{
		public var errorCode:int;
		public var isBuyableList:Array = [];

		public function ResponseVIPPromotionPlayerInfo()
		{
			
		}		
		
		override public function decode(data:ByteArray):void 
		{
			errorCode = data.readInt();
			if(errorCode == 0)
			{
				while(data.bytesAvailable > 0)
				{
					isBuyableList.push(data.readBoolean());
				}
			}
		}
	}

}