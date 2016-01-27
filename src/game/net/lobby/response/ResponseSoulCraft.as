package game.net.lobby.response 
{
	import flash.utils.ByteArray;
	import game.net.ResponsePacket;
	/**
	 * ...
	 * @author anhtinh
	 */
	public class ResponseSoulCraft extends ResponsePacket
	{
		public var result : int; 		// : 0: mệnh khí, 1: phế mệnh, các số khác: thất bại
		public var soulIndex : int;		// index cua (menh khi / phe khi) nhan duoc
		
		override public function decode(data:ByteArray):void
		{
			result = data.readInt();
			soulIndex = data.readInt();
		}
		
	}

}