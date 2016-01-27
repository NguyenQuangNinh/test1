package game.net 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author bangnd2
	 */
	public class IntResponsePacket extends ResponsePacket 
	{
		public var value:int;
		
		override public function decode(data:ByteArray):void 
		{
			value = data.readInt();
		}
	}

}