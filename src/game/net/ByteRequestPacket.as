package game.net 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author bangnd2
	 */
	public class ByteRequestPacket extends RequestPacket 
	{
		public var value:int;
		
		public function ByteRequestPacket(type:int, value:int) 
		{
			super(type);
			this.value = value;
		}
		
		override public function encode():ByteArray 
		{
			var data:ByteArray = super.encode();
			data.writeByte(value);
			return data;
		}
	}

}