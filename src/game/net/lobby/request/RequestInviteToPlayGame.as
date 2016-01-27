package game.net.lobby.request 
{
	import flash.utils.ByteArray;
	import game.net.IntRequestPacket;
	import game.net.lobby.LobbyRequestType;
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class RequestInviteToPlayGame extends IntRequestPacket
	{
		public var roomID:int;
		public var friendID:int;
		
		public function RequestInviteToPlayGame(room_ID:int, friend_ID:int) 
		{
			super(LobbyRequestType.INVITE_TO_PLAY_GAME);
			//type = requestType;
			roomID = room_ID;
			friendID = friend_ID;
		}
		
		override public function encode():ByteArray 
		{
			var data:ByteArray = super.encode();			
			data.writeInt(roomID);
			data.writeInt(friendID);
			return data;
		}	
	}

}