package game.net.game.ingame 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author bangnd2
	 */
	public class ResponseRemoveStatus extends IngamePacket 
	{
		public var effectID:int;
		
		override public function decode(data:ByteArray):void 
		{
			effectID = data.readInt();
		}
	}

}