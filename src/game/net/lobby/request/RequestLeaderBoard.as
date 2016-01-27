package game.net.lobby.request 
{
	import flash.utils.ByteArray;
	import game.net.lobby.LobbyRequestType;
	import game.net.RequestPacket;
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class RequestLeaderBoard extends RequestPacket
	{
		public static const LEADER_BOARD_RANKING:int = 1;
		public static const LEADER_BOARD_LEVEL:int = 2;
		
		public var requestType:int;
		public var fromIndex:int;
		public var toIndex:int;
		
		public function RequestLeaderBoard(type:int, from:int, to:int ) 
		{
			super(LobbyRequestType.LEADER_BOARD);
			requestType = type;
			fromIndex = from;
			toIndex = to;
		}
		
		override public function encode():ByteArray 
		{
			var data:ByteArray =  super.encode();
			data.writeInt(requestType);
			data.writeInt(fromIndex);
			data.writeInt(toIndex);
			return data;
		}
	}

}