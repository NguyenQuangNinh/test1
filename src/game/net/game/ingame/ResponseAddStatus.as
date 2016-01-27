package game.net.game.ingame 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author bangnd2
	 */
	public class ResponseAddStatus extends IngamePacket 
	{
		public var effectID:int;
		public var duration:Number;
		public var replace:Boolean;
		
		override public function decode(data:ByteArray):void 
		{
			effectID = data.readInt();
			duration = data.readInt();
			if (duration > 0) duration = duration / 1000;
//			replace = data.readBoolean();
		}
	}
}