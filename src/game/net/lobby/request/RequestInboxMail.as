package game.net.lobby.request 
{
	import flash.utils.ByteArray;
	import game.net.RequestPacket;
	/**
	 * ...
	 * @author ...
	 */
	public class RequestInboxMail extends RequestPacket
	{
		public var fromIndex	: int;
		public var toIndex		: int;
		
		public function RequestInboxMail(type:int, from:int, to:int) 
		{
			super(type);
			this.fromIndex = from;
			this.toIndex = to;
		}
		
		override public function encode():ByteArray 
		{
			var data:ByteArray = super.encode();			
			data.writeByte(fromIndex);
			data.writeByte(toIndex);
			return data;
		}
		
	}

}