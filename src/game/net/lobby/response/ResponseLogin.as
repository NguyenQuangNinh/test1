package game.net.lobby.response
{
	import flash.utils.ByteArray;
	import game.net.ResponsePacket;
	import core.util.Utility;

	public class ResponseLogin extends ResponsePacket
	{
		public var errorCode:int;
		public var userID:int;
		
		override public function decode(data:ByteArray):void
		{
			errorCode = data.readInt();
			if (errorCode == 0)
			{
				userID = data.readInt();
				Utility.crc.init(data.readUnsignedInt());
			}
		}
	}
}