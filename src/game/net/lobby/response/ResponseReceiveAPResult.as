package game.net.lobby.response 
{
	import flash.utils.ByteArray;
	import game.net.ResponsePacket;

	/**
	 * ...
	 * @author ninhnq
	 */
	public class ResponseReceiveAPResult extends ResponsePacket
	{
		public var errorCode:int;
		public var receiverID:int;

		override public function decode(data:ByteArray):void 
		{
			errorCode = data.readInt();
			if(errorCode == 0)
			{
				receiverID = data.readInt();
			}
		}
	}

}