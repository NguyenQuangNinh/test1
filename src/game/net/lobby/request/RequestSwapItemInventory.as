package game.net.lobby.request 
{
	import flash.utils.ByteArray;
	import game.net.RequestPacket;
	/**
	 * ...
	 * @author bangnd2
	 */
	public class RequestSwapItemInventory extends RequestPacket 
	{
		public var indexSource:int;
		public var indexTarget:int;
		
		public function RequestSwapItemInventory(type:int, indexSource:int, indexTarget:int) 
		{
			super(type);
			this.indexSource = indexSource;
			this.indexTarget = indexTarget;
		}
		
		override public function encode():ByteArray 
		{
			var data:ByteArray = super.encode();
			data.writeInt(indexSource);
			data.writeInt(indexTarget);
			return data;
		}
	}

}