package game.data.vo.skill 
{

	import game.data.model.Character;
	import game.data.xml.SkillXML;
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class Skill 
	{
		public var skillIndex:int;
		public var level:int;
		// use int instead boolean to utilize sort array
		// 0 --> mean unuse // 1 --> mean used
		public var isEquipped:Boolean;	
		public var xmlData:SkillXML;
		public var stances:Array = [];
		public var skillElement:int = -1;		

		public var owner:Character = null;
		public var inCharacterID:int = -1;
		public var inCharacterSubClass:String = "";
		
		public function Skill() 
		{
			
		}
		
	}

}