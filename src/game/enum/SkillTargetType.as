package game.enum 
{
	/**
	 * ...
	 * @author bangnd2
	 */
	public class SkillTargetType 
	{
		public static const NONE:SkillTargetType 	= new SkillTargetType();
		public static const POINT:SkillTargetType 	= new SkillTargetType();
		public static const UNIT:SkillTargetType 	= new SkillTargetType();
		
		public static const ALL:Array = [NONE, POINT, UNIT];
	}
}