package game.net 
{
	import core.util.ByteArrayEx;
	import core.util.Utility;
	
	import flash.utils.ByteArray;

	/**
	 * ...
	 * @author bangnd2
	 */
	public class StringRequestPacket extends RequestPacket 
	{
		public var value:String = "";
		public var length: int = -1;
		
		public function StringRequestPacket(type:int, value:String, length:int = 0):void
		{
			super(type);
			this.value = value;
			this.length = length;
		}
		
		override public function encode():ByteArray 
		{
			var data:ByteArrayEx = new ByteArrayEx();
			data.writeString(value, length);
			return data;
		}
	}

}