package game.data.model
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import core.event.EventEx;
	
	import game.Game;
	import game.net.IntRequestPacket;
	import game.net.lobby.LobbyRequestType;
	
	public class UIData extends EventDispatcher
	{
		public static const DATA_CHANGED:String = "dataChanged";
		public static const MAIN_CHARACTER_CHANGED:String = "mainCharacterChanged";
		public static const MATERIAL_CHARACTERS_CHANGED:String = "materialCharactersChanged";
		public static const CHARACTER_SKILL_CHANGED:String = "characterSkillChanged";
		
		public static const MAX_MATERIAL_CHARACTERS:int = 5;
		
		private var detailCharacterID:int;
		private var characterSkillID:int;
		private var mainCharacterID:int;
		private var upgradeCharacterID:int;
		
		private var materialCharacterIDs:Array;
		
		public function UIData()
		{
			materialCharacterIDs = [];
			reset();
		}
		
		public function reset():void
		{
			detailCharacterID = -1;
			mainCharacterID = -1;
			characterSkillID = -1;
			for(var i:int = 0; i < MAX_MATERIAL_CHARACTERS; ++i)
			{
				materialCharacterIDs[i] = -1;
			}
			dispatchEvent(new Event(MAIN_CHARACTER_CHANGED));
			dispatchEvent(new Event(MATERIAL_CHARACTERS_CHANGED));
			dispatchEvent(new Event(CHARACTER_SKILL_CHANGED));
		}
		
		public function setDetailCharacterID(ID:int):void
		{
			detailCharacterID = ID;
		}
		
		public function getDetailCharacterID():int
		{
			return detailCharacterID;
		}
		
		public function getCharacterSkillID():int {
			return characterSkillID;
		}
		
		public function setCharacterSkillID(ID:int):void {
			characterSkillID = ID;
			dispatchEvent(new Event(CHARACTER_SKILL_CHANGED));
		}
		
		public function setMainCharacterID(ID:int):void
		{
			mainCharacterID = ID;
			dispatchEvent(new Event(MAIN_CHARACTER_CHANGED));
		}
		
		public function getMainCharacterID():int
		{
			return mainCharacterID;
		}
		
		public function addMaterialCharacterID(ID:int):void
		{
			var index:int = materialCharacterIDs.indexOf(-1);
			if(index != -1)
			{
				materialCharacterIDs[index] = ID;
				dispatchEvent(new Event(MATERIAL_CHARACTERS_CHANGED));
			}
		}
		
		public function removeMaterialCharacter(ID:int):void
		{
			var index:int = materialCharacterIDs.indexOf(ID);
			if(index != -1)
			{
				materialCharacterIDs[index] = -1;
				dispatchEvent(new Event(MATERIAL_CHARACTERS_CHANGED));
			}
		}
		
		public function getMaterialCharacterIDs():Array
		{
			return materialCharacterIDs;
		}
		
		public function clearMaterialCharacterIDs():void
		{
			for(var i:int = 0; i < MAX_MATERIAL_CHARACTERS; ++i)
			{
				materialCharacterIDs[i] = -1;
			}
			dispatchEvent(new Event(MATERIAL_CHARACTERS_CHANGED));
		}
	}
}