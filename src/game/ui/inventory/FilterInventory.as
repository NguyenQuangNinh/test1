package game.ui.inventory 
{
	import game.data.model.Character;
	import game.data.vo.skill.Skill;
	import game.enum.ConditionType;
	import game.enum.UnitType;
	/**
	 * ...
	 * @author MaiPTT
	 */
	public class FilterInventory {
		
		public static function filterByType(characters:Array, type:int, value:int):Array {
			if (!characters) return null;
			
			var character	:Character;
			var index		:int = -1;
			var rs			:Array = [];
			
			switch(type) {
				case ConditionType.NONE:
					for each (character in characters) {
						if (character) {
							rs.push(character.ID);
						}
					}
					break;
					
				case ConditionType.UP_SKILL:
					for each (character in characters) {
						if (character) {
							for each (var skill:Skill in character.skills) {
								if (skill && skill.xmlData) {
									rs.push(character.ID);
									continue;
								}
							}
						}
					}
					
					break;
					
				case ConditionType.ATTACH_SOUL:
					for each (character in characters) {
						if (character) {
							if ( !character.isMystical() && character.soulItems && character.soulItems.length > 0) {
								rs.push(character.ID);
							}
						}	
					}
					
					break;
					
				case ConditionType.INSERT_FORMATION:
					for each (character in characters){
						if (character && character.xmlData) {
							if (character.xmlData.type != UnitType.MASTER) {
								rs.push(character.ID);
							}
						}
					}
					
					break;
					
				case ConditionType.UP_STAR:
					for each (character in characters) {
						if (character && character.isEvolvable()) {
							rs.push(character.ID);
						}	
					}
					
					break;
					
				case ConditionType.LEVEL_UP_ENHANCEMENT:
					for each (character in characters) {
						if (character && !character.isMystical()) {
							rs.push(character.ID);
						}
					}
					break;
			}
			
			return rs;
		}
	}

}