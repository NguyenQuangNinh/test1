package game.net.lobby.response 
{
	import flash.utils.ByteArray;
	import game.net.ResponsePacket;
	/**
	 * ...
	 * @author ninhnq
	 */
	public class ResponseDiceBuyExtraBetResult extends ResponsePacket
	{
		public var errorCode:int;
		public var currBetCount:int;

		public function ResponseDiceBuyExtraBetResult()
		{
			
		}		
		
		override public function decode(data:ByteArray):void 
		{
			errorCode = data.readInt();
			if(errorCode == 0)
			{
				currBetCount = data.readInt();
			}
		}
	}

}