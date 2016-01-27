package game.net.lobby.response
{
	import flash.utils.ByteArray;
	
	import game.enum.ErrorCode;
	import game.net.ResponsePacket;
	
	public class ResponseConvertEventItem extends ResponsePacket
	{
		public var errorCode:int;
		public var eventID:int;
		
		override public function decode(data:ByteArray):void
		{
			errorCode = data.readInt();

			if(errorCode == 0)
			{
				eventID = data.readInt();
			}
		}
	}
}