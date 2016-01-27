package game.net.game.ingame 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author bangnd2
	 */
	public class ResponseReleaseSkill extends IngamePacket 
	{
		public var skillID:int;
		public var targetPoint:int;
		public var duration:Number;
		
		override public function decode(data:ByteArray):void 
		{
			skillID = data.readInt();
			targetPoint = data.readInt();
			duration = data.readInt() / 1000;
		}
	}

}