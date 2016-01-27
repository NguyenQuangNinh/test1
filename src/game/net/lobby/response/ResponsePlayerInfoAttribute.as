package game.net.lobby.response
{
	import flash.utils.ByteArray;
	
	import game.net.ResponsePacket;
	
	public class ResponsePlayerInfoAttribute extends ResponsePacket
	{
		public var attributeID:int;
		public var value:int;
		
		override public function decode(data:ByteArray):void
		{
			attributeID = data.readInt();
			value = data.readInt();
		}
	}
}