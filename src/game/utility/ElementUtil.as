package game.utility 
{
	import core.util.Enum;
	
	import game.Game;
	import game.data.model.Character;
	import game.enum.Element;
	import game.enum.ElementRelationship;
	import game.enum.FormationType;

	/**
	 * ...
	 * @author MaiPTT
	 */
	public class ElementUtil 
	{
		public static const FIRE	:int = 1;
		public static const EARTH	:int = 2;
		public static const METAL	:int = 3;
		public static const WATER	:int = 4;
		public static const WOOD	:int = 5;
		
		public static function getElementRelationship(firstElement:int, secondElement:int):int
		{
			var result:int = ElementRelationship.NORMAL;
			var element:Element = Enum.getEnum(Element, firstElement) as Element;
			if(element != null)
			{
				switch(secondElement)
				{
					case element.create:
						result = ElementRelationship.GENERATING;
						break;
					case element.created:
						result = ElementRelationship.GENERATED;
						break;
					case element.destroy:
						result = ElementRelationship.DESTROY;
						break;
					case element.resist:
						result = ElementRelationship.RESIST;
						break;
				}
			}
			return result;
		}
		
		public static function overComingElement(_srcElement:int):int {
			switch(_srcElement) {
				case METAL:
					return FIRE;
					
				case WOOD:
					return METAL;
					
				case WATER:
					return EARTH;
					
				case FIRE:
					return WATER;
					
				case EARTH:
					return WOOD;
			}
			return -1;
		}
		
		public static function getName(element:int):String {
			switch(element) {
				case METAL:
					return "Kim";
					
				case WOOD:
					return "Mộc";
					
				case WATER:
					return "Thủy";
					
				case FIRE:
					return "Hỏa";
					
				case EARTH:
					return "Thổ";
					
				default:
					return "Vô";
			}
		}
		
		public static function generatingElement(_srcElement:int):int {
			switch(_srcElement) {
				case METAL:
					return EARTH;
					
				case WOOD:
					return WATER;
					
				case WATER:
					return METAL;
					
				case FIRE:
					return WOOD;
					
				case EARTH:
					return FIRE;
			}
			
			return -1;
		}
		
		public static function getNumElementByType(element : int) : int {
			var result : int = 0;
			var formations : Array = Game.database.userdata.getFormation(FormationType.FORMATION_MAIN);
			if (formations != null) {
				
				for (var i:int = 0; i < formations.length; i++) 
				{
					var character:Character = Game.database.userdata.getCharacter(formations[i]);
					if (character && character.element == element) 
						result++;
				}
			}
			
			return result;
		}
	}

}