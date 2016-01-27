package game.data.gamemode 
{
	import core.util.Utility;
	
	import game.Game;
	import game.data.model.Character;
	import game.data.vo.lobby.LobbyPlayerInfo;
	/**
	 * ...
	 * @author MaiPTT
	 */
	public class ModeDataPVEHeroic extends ModeDataPvE 
	{
		private static const NUM_CHARACTER_PER_PLAYER:int = 2;

		public var formationIndex	:Array = [];
		public var isHost			:Boolean = false;
		public var caveID			:int = -1;
		public var formationTypeID	:int = -1;
		public var formationTypeLevel	:int = -1;
		private var players			:Array = []; /*LobbyPlayerInfo*/
		public var difficulty		:int;
		public var campaignStep		:int = -1;
		public var autoStart:Boolean = false;

		public function ModeDataPVEHeroic() {
			
		}
		
		public function setPlayers(value:Array):void {
			players = value;
			if (players) {
				for each (var player:LobbyPlayerInfo in players) {
					if (player && (player.id == Game.database.userdata.userID)) {
						isHost = player.owner;
						break;
					}
				}
			}
		}
		
		public function getPlayers():Array {
			return players;
		}
		
		public function buildFormation():Array {
			var formation:Array = [];
			/*for (var j:int = 0; j < formationIndex.length; j++) {
				var playerIndex:int = (int) (formationIndex[j] / NUM_CHARACTER_PER_PLAYER);
				for each(var player:LobbyPlayerInfo in players) {
					if (player && player.index == playerIndex) {						
						for (var i:int = 0; i < NUM_CHARACTER_PER_PLAYER; i++) {					
							var character:Character = player.characters[i % NUM_CHARACTER_PER_PLAYER] as Character;					
							if (player.id == Game.database.userdata.userID) {
								//set skill for character
								character.skills = Game.database.userdata.getCharacter(character.ID).skills;
							}
							formation[player.index * NUM_CHARACTER_PER_PLAYER + i] = character;
							Utility.log("init formation for player " + player.name + " at index "
									+ (player.index * NUM_CHARACTER_PER_PLAYER + i) + " with character " + character.name);
						}
					}
				}
			}*/
			
			//for each (var formationIndex:int in formationIndex) {
			for (var i:int = 0; i < formationIndex.length; i++) {
				var f_Index:int = formationIndex[i];
				var playerIndex:int = Math.floor(f_Index / NUM_CHARACTER_PER_PLAYER);
				for each (var player:LobbyPlayerInfo in players) {
					if (player && player.index == playerIndex) {
						var character:Character = player.characters[f_Index % NUM_CHARACTER_PER_PLAYER];
						var characterSex:int = player.charactersSex[f_Index % NUM_CHARACTER_PER_PLAYER];						
						if (character && character.xmlData) {
							character.sex = characterSex;
							formation[i] = character;
							if (player.id == Game.database.userdata.userID) {
								//set skill for character of self
								character.skills = Game.database.userdata.getCharacter(character.ID).skills;
							}
							Utility.log("init formation for player " + player.name + " at index "
									+ i + " with character " + character.name);
						}
					}
				}
			}
			
			return formation;
		}
	}

}