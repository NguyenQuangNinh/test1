package game.net.lobby.request 
{
	import flash.utils.ByteArray;
	import game.net.lobby.LobbyRequestType;
	import game.net.RequestPacket;
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class RequestChangeLobbySlot extends RequestPacket
	{
		public var teamID:int;
		public var slotIndex:int;
		
		public function RequestChangeLobbySlot(id:int, index:int) 
		{
			super(LobbyRequestType.CHANGE_LOBBY_PLAYER_SLOT);
			teamID = id;
			slotIndex = index;
		}
		
		override public function encode():ByteArray 
		{
			var data:ByteArray =  super.encode();
			data.writeInt(teamID);
			data.writeInt(slotIndex);
			return data;
		}
	}

}