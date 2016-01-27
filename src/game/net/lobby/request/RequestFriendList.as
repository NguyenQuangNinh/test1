package game.net.lobby.request 
{
	import flash.utils.ByteArray;
	import game.net.RequestPacket;
	/**
	 * ...
	 * @author ...
	 */
	public class RequestFriendList extends RequestPacket
	{
		public var fromIndex	: int;
		public var toIndex		: int;
		
		public function RequestFriendList(type:int, from:int, to:int) 
		{
			super(type);
			this.fromIndex = from;
			this.toIndex = to;
			
			//trace("From:" + from);
			//trace("To:" + to);
		}
		
		override public function encode():ByteArray 
		{
			var data:ByteArray = super.encode();			
			data.writeInt(fromIndex);
			data.writeInt(toIndex);
			return data;
		}
		
	}

}