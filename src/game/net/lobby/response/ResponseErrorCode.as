package game.net.lobby.response
{
	import flash.utils.ByteArray;
	
	import game.net.ResponsePacket;
	
	public class ResponseErrorCode extends ResponsePacket
	{
		public var requestType:int;
		public var errorCode:int;
		
		override public function decode(data:ByteArray):void
		{
			requestType = data.readInt();
			errorCode = data.readInt();
		}
	}
}