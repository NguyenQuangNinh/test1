package game.enum 
{
	import core.util.Enum;
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class SuggestionEnum extends Enum
	{
		public static const SUGGEST_UPGRADE_CHARACTER	:SuggestionEnum = new SuggestionEnum(1, "suggest_upgrade_character");
		public static const SUGGEST_UPGRADE_STAR		:SuggestionEnum = new SuggestionEnum(2, "suggest_upgrade_star");
		public static const SUGGEST_UPGRADE_SKILL		:SuggestionEnum = new SuggestionEnum(3, "suggest_upgrade_skill");
		public static const DAILY_TASK				:SuggestionEnum = new SuggestionEnum(4, "daily_task");
		public static const SUGGEST_LEVEL_UP			:SuggestionEnum = new SuggestionEnum(5, "suggest_level_up");

		public function SuggestionEnum(ID:int, name:String = "") 
		{
			super(ID, name);
		}
		
	}

}