package game.net
{
	import core.util.ByteArrayEx;
	
	import flash.utils.ByteArray;

	public class RequestPacket
	{
		protected var type:int;
		
		public function RequestPacket(type:int):void
		{
			this.type = type;
		}
		
		public function encode():ByteArray
		{
			return new ByteArrayEx();
		}
		
		public function getType():int { return type; }
	}
}