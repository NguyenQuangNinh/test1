package game.net.lobby.response
{
	import flash.utils.ByteArray;
	
	import core.Manager;
	import core.util.Enum;
	
	import game.Game;
	import game.data.model.Character;
	import game.enum.FormationType;
	import game.net.ResponsePacket;

	public class ResponseFormation extends ResponsePacket
	{
		public var userID:int;
		public var formationType:FormationType;
		public var formation:Array;
		public var formationCharacterIDs:Array = [];
		
		override public function decode(data:ByteArray):void
		{
			formation = Manager.pool.pop(Array) as Array;
			formation = [];
			userID = data.readInt();
			formationType = Enum.getEnum(FormationType, data.readInt()) as FormationType;
			
			for(var i:int = 0; i < Game.MAX_CHARACTER; ++i)
			{
				var character:Character = Manager.pool.pop(Character) as Character;
				character.decode(data);
				formationCharacterIDs[i] = character.ID;
				if (character.ID > -1 && character.xmlData != null) 
					formation[i] = userID == Game.database.userdata.userID ? Game.database.userdata.getCharacter(character.ID) : character;					
				else 
					formation[i] = null;
			}
		}
	}
}