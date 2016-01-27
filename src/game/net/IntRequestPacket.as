package game.net 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author bangnd2
	 */
	public class IntRequestPacket extends RequestPacket 
	{
		public var value:int;
		
		public function IntRequestPacket(type:int, value:int) 
		{
			super(type);
			this.value = value;
		}
		
		override public function encode():ByteArray 
		{
			var data:ByteArray = super.encode();
			data.writeInt(value);
			return data;
		}
	}

}