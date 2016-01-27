package game.net.lobby.request {
	import flash.utils.ByteArray;
	import game.net.RequestPacket;
	/**
	 * ...
	 * @author vu anh
	 */
	public class RequestGetListFromTo extends RequestPacket
	{
		public var from:int;
		public var to:int;
		
		public function RequestGetListFromTo(type:int, from:int, to:int) 
		{
			super(type);
			this.to = to;
			this.from = from;
		}
		
		override public function encode():ByteArray 
		{
			var data:ByteArray = super.encode();			
			data.writeInt(from);
			data.writeInt(to);
			return data;
		}
		
	}

}