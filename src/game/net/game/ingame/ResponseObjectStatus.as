package game.net.game.ingame
{
	import flash.utils.ByteArray;
	
	
	public class ResponseObjectStatus extends IngamePacket
	{
		public var status:int;
		
		override public function decode(data:ByteArray):void
		{
			status = data.readByte();
		}
	}
}