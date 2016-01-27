package game.net.lobby.request
{
	import flash.utils.ByteArray;
	
	import game.net.RequestPacket;
	import game.net.lobby.LobbyRequestType;
	
	public class RequestPlayerCharacterInfo extends RequestPacket
	{
		public var  playerID:int;
		public var  characterID:int;
		
		public function RequestPlayerCharacterInfo(type:int = LobbyRequestType.GET_PLAYER_CHARACTER_INFO)
		{
			super(type);
		}
		
		override public function encode():ByteArray
		{
			var data:ByteArray = super.encode();
			data.writeInt(playerID);
			data.writeInt(characterID);
			return data;
		}
	}
}