package game.net.lobby.response
{
	import core.util.ByteArrayEx;
	
	import flash.utils.ByteArray;
	
	import game.data.model.Character;
	import game.data.vo.lobby.LobbyPlayerInfo;
	import game.net.ResponsePacket;

	public class ResponseListPlayersFree extends ResponsePacket
	{
		public var players:Array = [];
		
		override public function decode(data:ByteArray):void
		{
			var player:LobbyPlayerInfo;
			while (data && data.bytesAvailable > 0) {				
				/*var player:InviteFriendInfo = new InviteFriendInfo();
				player.name = ByteArrayUtil.readString(data);
				player.level = data.readInt();
				var numCharacters:int = data.readInt();
				for (var i:int = 0; i < numCharacters; ++i)
				{					
					player.characters.push(data.readInt());
				}
				players.push(player);*/
				player = new LobbyPlayerInfo();
				player.id = data.readInt();
				player.name = ByteArrayEx(data).readString();
				player.level = data.readInt();
				/*var numCharacters:int = data.readInt();
				for (var i:int = 0; i < numCharacters; ++i)
				{					
					var exist:int = data.readInt();
 					var character:Character = new Character();
					if (exist > -1) {
						character.decode(data);						
					}
					player.characters.push(exist > -1 ? character : null);
				}*/
				var xmlID:int = data.readInt();
				var gender:int = data.readByte();
				var character:Character = new Character(xmlID);
				character.xmlID = xmlID;
				character.sex = gender;
				character.isMainCharacter = true;
				
				player.characters.push(character);
				players.push(player);
			}
			players = players.sort(sortListDescending);
		}
		
		public function sortListDescending(a:LobbyPlayerInfo, b:LobbyPlayerInfo):int
		{
			if (a.level > b.level)
				return -1;
			else if (a.level < b.level)
				return 1;
			return 0;
		}
		
		public function sortListAscending(a:LobbyPlayerInfo, b:LobbyPlayerInfo):int
		{
			if (a.level > b.level)
				return 1;
			else if (a.level < b.level)
				return -1;
			return 0;
		}
		
	}
}