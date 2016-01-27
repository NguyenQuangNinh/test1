package game.net.lobby.response
{
	import flash.utils.ByteArray;
	import game.net.ResponsePacket;

	public class ResponseGameServerAddress extends ResponsePacket
	{
		public var IP:String;
		public var port:int;
		
		override public function decode(data:ByteArray):void
		{
			var IPElements:Array = [];
			for(var i:int = 0; i < 4; ++i)
			{
				IPElements[i] = data.readUnsignedByte();
			}
			port = data.readShort();
			IP = IPElements.join(".");
		}
	}
}