package game.net.lobby.response
{
	import core.util.ByteArrayEx;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	import game.net.ResponsePacket;
	
	public class ResponseChallengeReplayInfo extends ResponsePacket
	{
		public var ba:ByteArray;
		
		override public function decode(data:ByteArray):void
		{
			if (ba) ba.clear();
			ba = new ByteArray();
			ba.endian = Endian.LITTLE_ENDIAN;
			ba.writeBytes(data, 0, data.bytesAvailable);
			ba.position = 0;
		}
	}
}