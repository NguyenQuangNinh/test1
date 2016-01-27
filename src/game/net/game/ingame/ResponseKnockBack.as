package game.net.game.ingame
{
	import flash.utils.ByteArray;
	
	
	public class ResponseKnockBack extends IngamePacket
	{
		public var speed:int;
		public var acceleration:Number;
		
		override public function decode(data:ByteArray):void
		{
			speed = data.readShort();
			acceleration = data.readFloat();
		}
	}
}