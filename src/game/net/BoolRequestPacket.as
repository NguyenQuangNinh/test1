package game.net 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author bangnd2
	 */
	public class BoolRequestPacket extends RequestPacket 
	{
		public var value:Boolean;
		
		public function BoolRequestPacket(type:int, value:Boolean) 
		{
			super(type);
			this.value = value;
		}
		
		override public function encode():ByteArray 
		{
			var data:ByteArray = super.encode();
			data.writeBoolean(value);
			return data;
		}
	}

}