package game.net
{
	import flash.utils.ByteArray;
	
	import game.enum.ServerResponseType;

	public class ResponsePacket
	{
		public var type:ServerResponseType;
		
		public function decode(data:ByteArray):void {}
	}
}