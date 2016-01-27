package game.net.lobby.request 
{
	import flash.utils.ByteArray;
	import game.net.lobby.LobbyRequestType;
	import game.net.RequestPacket;
	
	/**
	 * ...
	 * @author MaiPTT
	 */
	public class RequestAcceptJoinRoom extends RequestPacket 
	{
		private var roomID:int;
		private var password:Boolean;
		
		public function RequestAcceptJoinRoom(roomID:int, password:Boolean = false) {
			super(LobbyRequestType.HEROIC_ACCEPT_JOIN_ROOM);
			this.roomID = roomID;
			this.password = password;
		}
		
		override public function encode():ByteArray {
			var byteArray:ByteArray = super.encode();
			byteArray.writeInt(roomID);
			byteArray.writeBoolean(password);
			
			return byteArray;
		}
	}

}