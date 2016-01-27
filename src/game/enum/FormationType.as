package game.enum 
{
	import core.util.Enum;

	/**
	 * ...
	 * @author TrungLNM
	 */
	public class FormationType extends Enum
	{
		public static const FORMATION_MAIN			:FormationType = new FormationType(0, 8, "main");
		public static const FORMATION_CHALLENGE		:FormationType = new FormationType(1, 8, "challenge");
		public static const FORMATION_TEMP			:FormationType = new FormationType(2, 8, "challenge_temp");
		public static const HEROIC					:FormationType = new FormationType(3, 2, "heroic");
		
		public var maxCharacter:int;
		
		public function FormationType(ID:int, maxCharacter:int, name:String=""):void
		{
			super(ID, name);
			this.maxCharacter = maxCharacter;
		}
	}
}