package game.net.lobby.response
{
	import flash.utils.ByteArray;
	
	import game.net.ResponsePacket;
	
	public class ResponseInventoryInfo extends ResponsePacket
	{
		public var characterMaxSlot:int;
		public var itemMaxSlot:int;
		public var soulMaxSlot:int;
		
		override public function decode(data:ByteArray):void
		{
			characterMaxSlot = data.readInt();
			itemMaxSlot = data.readInt();
			soulMaxSlot = data.readInt();
		}
	}
}