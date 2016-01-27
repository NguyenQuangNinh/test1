package game.net.lobby.response
{
	import flash.utils.ByteArray;
	
	import game.net.ResponsePacket;
	
	public class ResponseGetGiftOnlineInfo extends ResponsePacket
	{
		public var nStatusGiftOnline:int;
		public var bCanReceive:Boolean;
		public var nDiffSecond:int;
		
		override public function decode(data:ByteArray):void
		{
			nStatusGiftOnline = data.readInt();
			if (nStatusGiftOnline >= 0)
			{
				bCanReceive = data.readInt() == 1;
				nDiffSecond = data.readInt();
			}
		}
	}
}