package game.net.game.ingame 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author bangnd2
	 */
	public class ResponseInt extends IngamePacket 
	{
		public var value:int;
		
		override public function decode(data:ByteArray):void 
		{
			value = data.readInt();
		}
	}
}