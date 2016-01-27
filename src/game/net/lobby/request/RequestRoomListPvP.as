package game.net.lobby.request 
{
	import flash.utils.ByteArray;
	import game.net.lobby.LobbyRequestType;
	import game.net.RequestPacket;
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class RequestRoomListPvP extends RequestPacket
	{
		
		public var from:int;
		public var to:int;
		public var mode:int;
		
		public function RequestRoomListPvP(fromIndex:int, toIndex:int, requestMode:int) 
		{
			super(LobbyRequestType.ROOM_LIST_PVP);
			from = fromIndex;
			to = toIndex;
			mode = requestMode;
		}
		
		override public function encode():ByteArray 
		{
			var data:ByteArray = super.encode();
			data.writeInt(from);
			data.writeInt(to);
			data.writeInt(mode);
			return data;
		}
	}

}