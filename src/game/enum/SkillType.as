package game.enum 
{
	import core.util.Enum;

	/**
	 * ...
	 * @author TrungLNM
	 */
	public class SkillType extends Enum
	{
		public static const ACTIVE	:SkillType = new SkillType(0);
		public static const PASSIVE	:SkillType = new SkillType(1);
		
		public function SkillType(ID:int, name:String="") 
		{
			super(ID, name);
		}
		
	}

}