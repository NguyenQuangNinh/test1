package game.net.lobby.request 
{
	import core.util.ByteArrayEx;
	import flash.utils.ByteArray;
	import game.net.RequestPacket;
	/**
	 * ...
	 * @author vu anh
	 */
	public class RequestBasePacket extends RequestPacket
	{
		public var ba:ByteArrayEx;
		public function RequestBasePacket(type:int):void
		{
			super(type);
			ba = new ByteArrayEx();
		}
		
		override public function encode():ByteArray
		{
			return ba;
		}
		
	}

}