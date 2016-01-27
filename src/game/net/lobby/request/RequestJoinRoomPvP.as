package game.net.lobby.request 
{
	import flash.utils.ByteArray;
	import game.net.lobby.LobbyRequestType;
	import game.net.RequestPacket;
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class RequestJoinRoomPvP extends RequestPacket
	{
		
		public var roomID:int;
		public var beInvited:Boolean;
		
		public function RequestJoinRoomPvP(id: int, beInvited:Boolean = false) 
		{
			super(LobbyRequestType.JOIN_ROOM_PVP);
			roomID = id;
			this.beInvited = beInvited;
		}
		
		override public function encode():ByteArray 
		{
			var data:ByteArray = super.encode();
			data.writeInt(roomID);
			data.writeBoolean(beInvited);
			return data;
		}
	}

}