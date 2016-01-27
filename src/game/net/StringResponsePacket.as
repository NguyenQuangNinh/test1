package game.net 
{
	import core.util.ByteArrayEx;
	
	import flash.utils.ByteArray;

	/**
	 * ...
	 * @author trunglnm
	 */
	public class StringResponsePacket extends ResponsePacket 
	{
		public var value:String;
		
		override public function decode(data:ByteArray):void 
		{
			value = ByteArrayEx(data).readString();
		}
	}

}