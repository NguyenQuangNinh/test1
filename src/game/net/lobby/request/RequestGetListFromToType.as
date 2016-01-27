package game.net.lobby.request {
	import flash.utils.ByteArray;
	import game.net.RequestPacket;
	/**
	 * ...
	 * @author vu anh
	 */
	public class RequestGetListFromToType extends RequestPacket
	{
		public var nType:int;
		public var from:int;
		public var to:int;
		
		public function RequestGetListFromToType(type:int, from:int, to:int, nType:int) 
		{
			super(type);
			this.to = to;
			this.from = from;
			this.nType = nType;
		}
		
		override public function encode():ByteArray 
		{
			var data:ByteArray = super.encode();			
			data.writeInt(nType);
			data.writeInt(from);
			data.writeInt(to);
			return data;
		}
		
	}

}