package game.net.game.ingame
{
	import flash.utils.ByteArray;

	public class ResponseShort extends IngamePacket
	{
		public var value:int;
		
		override public function decode(data:ByteArray):void
		{
			value = data.readShort();
		}
	}
}