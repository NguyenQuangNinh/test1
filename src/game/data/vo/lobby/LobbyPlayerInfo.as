package game.data.vo.lobby 
{
	import game.data.model.Character;

	/**
	 * ...
	 * @author TrungLNM
	 */
	public class LobbyPlayerInfo 
	{
		public var teamIndex:int;
		public var id:int;
		public var index:int;
		public var owner:Boolean;
		public var level:int;
		public var rank:int;
		public var name:String = "";			
		public var guide:String = "";
		public var characters:Array = [];								
		public var charactersSex:Array = [];								
		
		public var eloScore:int = -1;		
		public var championPoint:int = -1;
		public var damage:int = -1;
		public var maxFloor:int = -1;
		/*public var playerID:int;
		public var maxFloor:int;
		public var name:String;
		public var rank:int;*/
		
		public function LobbyPlayerInfo() 
		{
			
		}
		
		public function getTeamLeader():Character
		{
			for each(var character:Character in characters)
			{
				if(character != null && character.isMainCharacter) return character;
			}
			return null;
		}
		
		public function reset():void 
		{
			teamIndex = -1;
			id = -1;
			index = -1;
			owner = false;
			level = -1;
			rank = -1;
			name = "";			
			guide = "";
			characters.length = 0;								
			charactersSex.length = 0;								
			
			eloScore = -1;		
			championPoint = -1;
			damage = -1;
			maxFloor = -1;
		}
	}

}