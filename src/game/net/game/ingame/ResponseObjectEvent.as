package game.net.game.ingame
{
	import flash.utils.ByteArray;
	
	
	public class ResponseObjectEvent extends IngamePacket
	{
		public var event:int;
		
		override public function decode(data:ByteArray):void
		{
			event = data.readByte();
		}
	}
}