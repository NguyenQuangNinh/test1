package game.net.lobby.response 
{
	import core.util.ByteArrayEx;
	import core.util.Enum;
	
	import flash.utils.ByteArray;
	
	import game.data.vo.lobby.LobbyInfo;
	import game.enum.GameMode;
	import game.net.ResponsePacket;

	/**
	 * ...
	 * @author TrungLNM
	 */
	public class ResponseRoomListPvP extends ResponsePacket
	{
		public var rooms:Array = [];
		
		public function ResponseRoomListPvP() 
		{
			
		}
		
		override public function decode(data:ByteArray):void 
		{
			super.decode(data);
			var room:LobbyInfo;
			while (data && data.bytesAvailable > 0) {
				room = new LobbyInfo();
				room.id = data.readInt();
				room.name = ByteArrayEx(data).readString();
				room.mode = Enum.getEnum(GameMode, data.readInt()) as GameMode;
				room.count = data.readInt();
				room.privateLobby = data.readBoolean();
				
				room.nLevelHostRoom = data.readInt();
				room.strNameHostRoom = ByteArrayEx(data).readString();
				
				rooms.push(room);
			}
		}
	}

}