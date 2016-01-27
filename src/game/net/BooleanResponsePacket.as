package game.net 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author MaiPTT
	 */
	public class BooleanResponsePacket extends ResponsePacket 
	{
		public var result:Boolean;
		
		override public function decode(data:ByteArray):void {
			result = data.readBoolean();
		}
	}

}