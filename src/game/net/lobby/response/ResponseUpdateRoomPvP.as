package game.net.lobby.response
{
	import flash.utils.ByteArray;
	
	import core.util.ByteArrayEx;
	import core.util.Utility;
	
	import game.Game;
	import game.data.model.Character;
	import game.data.vo.lobby.LobbyPlayerInfo;
	import game.data.vo.skill.Skill;
	import game.data.vo.skill.Stance;
	import game.data.xml.CharacterXML;
	import game.data.xml.DataType;
	import game.data.xml.SkillXML;
	import game.data.xml.StanceXML;
	import game.data.xml.UnitClassXML;
	import game.enum.Sex;
	import game.enum.UnitType;
	import game.net.ResponsePacket;

	public class ResponseUpdateRoomPvP extends ResponsePacket
	{
		public var roomName:String = "";
		public var heroicCampaignStep:int = 0;
		public var heroicCampaignID:int = 0;
		public var heroicCampaignDifficultyLevel:int = 0;
		public var numPlayers:int;
		public var players:Array = [];
		
		override public function decode(data:ByteArray):void
		{
			roomName = ByteArrayEx(data).readString();
			heroicCampaignStep = data.readInt();
			heroicCampaignID = data.readInt();
			heroicCampaignDifficultyLevel = data.readInt();
			numPlayers = data.readInt();
			//Utility.log("response update room pvp, numPlayers=" + numPlayers);
			for(var i:int = 0; i < numPlayers; ++i)
			{
				var teamIndex:int = data.readInt();
				var index:int = data.readInt();
				var owner:Boolean = data.readBoolean();
				var level:int = data.readInt();
				var id:int = data.readInt();
				var name:String = ByteArrayEx(data).readString();
				var numCharacters:int = data.readInt();
				
				var characters:Array = [];
				var charactersSex:Array = [];
				for (var j:int = 0; j < numCharacters; j++)
				{
					var exist:int = data.readInt();
 					//var character:Character = new Character();	
					if (exist > -1) {
						//character.decode(data);
						var xmlID:int = data.readInt();
						var gender:int = data.readByte();
						var character:Character = new Character(xmlID);
						var unitClassXML:UnitClassXML = Game.database.gamedata.getData(DataType.UNITCLASS, character.xmlData.characterClass) as UnitClassXML;
						character.element = unitClassXML.element;
						character.isMainCharacter = data.readBoolean();
						
						var firstNameIndex:int = data.readInt();
						var lastNameIndex:int = data.readInt();
						character.level = data.readInt();
						var rarity:int = data.readInt();
						var characterIndex:int = data.readInt();
						character.ID = characterIndex;
						character.rarity = rarity;
						character.sex = gender;
						character.name = getName(character, firstNameIndex, lastNameIndex, gender, name);	
						character.expiredTime = data.readInt();
						//get skill from server
						var skillsLength:int = data.readInt();
						var skill:Skill;
						var skills:Array = [];
						for (var k:int = 0; k < skillsLength; k++)
						{
							skill = new Skill();
							skill.skillIndex = data.readInt();
							skill.xmlData = Game.database.gamedata.getData(DataType.SKILL, data.readInt()) as SkillXML;
							if (skill.xmlData)
							{
								for (var m:int = 0; m < skill.xmlData.stanceIDs.length; m++)
								{
									var stance:Stance = new Stance();
									stance.xmlData = Game.database.gamedata.getData(DataType.STANCE, skill.xmlData.stanceIDs[m]) as StanceXML;
									skill.stances.push(stance);
								}
							}
							skill.isEquipped = true;
							skill.level = data.readInt();	
							skills.push(skill);
						}
						character.skills = skills;
					}
					characters.push(exist > -1 ? character : null);
					charactersSex.push(exist > -1 ? gender : -1);
					//character.name = j == 0 ? name : "";
					/*if(character.xmlData)
						Utility.log("character has been create has id " + xmlID + " and icon " + character.xmlData.getIconURL());*/
				}
				
				var playerObj:LobbyPlayerInfo = new LobbyPlayerInfo();
				playerObj.teamIndex = teamIndex;
				playerObj.index = index;
				playerObj.owner = owner;
				playerObj.level = level;
				playerObj.id = id;
				playerObj.name = name;
				playerObj.characters = characters;
				playerObj.charactersSex = charactersSex;
				
				players.push(playerObj);
			}
		}
		
		private function getName(character:Character, firstNameIndex:int, lastNameIndex:int, sex:int, mainCharacterName:String):String {
			var name:String = "";
			if (character.isMainCharacter) {
				name = mainCharacterName;
				return name;
			}
			var xmlData:CharacterXML = character.xmlData;
			if (xmlData) {
				var unitClassXML:UnitClassXML = Game.database.gamedata.getData(DataType.UNITCLASS, xmlData.characterClass) as UnitClassXML;
				if (unitClassXML) {
					switch(xmlData.type) {
						case UnitType.HERO:
						case UnitType.MASTER:
							name = xmlData.name;
							break;
							
						default:
							if (sex == Sex.MALE) {
								if (firstNameIndex >= 0 && firstNameIndex < unitClassXML.maleFirstName.length) {
									name = unitClassXML.maleFirstName[firstNameIndex];
								}
								
								if (lastNameIndex >= 0 && lastNameIndex < unitClassXML.maleLastName.length) {
									name += " " + unitClassXML.maleLastName[lastNameIndex];
								}
							} else {
								if (firstNameIndex >= 0 && firstNameIndex < unitClassXML.femaleFirstName.length) {
									name = unitClassXML.femaleFirstName[firstNameIndex];
								}
								
								if (lastNameIndex >= 0 && lastNameIndex < unitClassXML.femaleLastName.length) {
									name += " " + unitClassXML.femaleLastName[lastNameIndex];
								}
							}
							break;
					}
				}
			}
			
			return name;
		}
	}
}