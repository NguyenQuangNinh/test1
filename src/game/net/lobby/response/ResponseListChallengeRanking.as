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
	public class ResponseListChallengeRanking extends ResponsePacket
	{
		public var players:Array = [];
		public function ResponseListChallengeRanking() 
		{
			
		}
		
		override public function decode(data:ByteArray):void 
		{
			super.decode(data);
			
			//var info:ChallengePlayerInfo;
			var info:LobbyPlayerInfo;
			while (data && data.bytesAvailable > 0) {
				//info = new ChallengePlayerInfo();
				info = new LobbyPlayerInfo();
				info.id = data.readInt();
				info.name = ByteArrayEx(data).readString();
				info.level = data.readInt();
				info.rank = data.readInt();
				
				//var numCharacters:int = data.readInt();
				//for (var i:int = 0; i < numCharacters; ++i)
				//{					
					//info.characters.push(data.readInt());
					//var exist:int = data.readInt();
 					//var character:Character = new Character();
					//if (exist > -1) {
						//character.decode(data);	
						
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
						character.isMainCharacter = true;
						//player.characters[0] = character;
						info.characters.push(character);
					//}
					//info.characters.push(exist > -1 ? character : null);
				//}
				
				players.push(info);
			}
			
			sortPlayers();			
		}
		
		private function sortPlayers():void {
			players.sortOn(["rank"], [Array.DESCENDING | Array.NUMERIC]).reverse();
		}
	}

}