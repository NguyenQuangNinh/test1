package game.net.lobby.response 
{
	import core.util.ByteArrayEx;
	
	import flash.utils.ByteArray;
	
	import game.data.model.Character;
	import game.data.vo.lobby.LobbyPlayerInfo;
	import game.net.ResponsePacket;

	/**
	 * ...
	 * @author TrungLNM
	 */
	public class ResponseTopLeaderBoard extends ResponsePacket
	{
		public var players:Array = [];
		
		public function ResponseTopLeaderBoard() 
		{
			
		}
		
		override public function decode(data:ByteArray):void 
		{
			super.decode(data);
			var player:LobbyPlayerInfo;
			while (data && data.bytesAvailable > 0) {
				player = new LobbyPlayerInfo();
				player.id = data.readInt();
				player.name = ByteArrayEx(data).readString();
				player.level = data.readInt();
				player.rank = data.readInt();
				
				//more info
				//unitID
				var xmlID:int = data.readInt();
				//gender
				var gender:int = data.readByte();
				//firstNameID
				//var firstNameID:int = data.readInt();
				//lastNameID
				//var lastNameID:int = data.readInt();
				//make main character ID just for display avatar
				var character:Character = new Character(xmlID);
				character.xmlID = xmlID;
				character.sex = gender;
				//character.firstNameIndex = firstNameID;
				//character.lastNameIndex = lastNameID;				
				player.characters[0] = character;
				
				players.push(player);
			}
		}
		
	}

}