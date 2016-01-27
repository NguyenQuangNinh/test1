package game.net
{
	import flash.utils.ByteArray;

	public class ByteResponsePacket extends ResponsePacket
	{
		public var value:int;
		
		override public function decode(data:ByteArray):void
		{
			value = data.readByte();
		}
	}
}