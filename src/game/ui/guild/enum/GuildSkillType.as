package game.ui.guild.enum 
{
	/**
	 * ...
	 * @author vu anh
	 */
	public class GuildSkillType 
	{
		public static const GUILD_SKILL_TYPE_STRENGTH:int = 0;
		public static const GUILD_SKILL_TYPE_AGILITY:int = 1;
		public static const GUILD_SKILL_TYPE_INTELLIGENT:int = 2;
		public static const GUILD_SKILL_TYPE_VITALITY:int = 3;
		public function GuildSkillType() 
		{
			
		}
		public static function getGuildSkillType(type:int):String
		{
			switch(type)
			{
				case GUILD_SKILL_TYPE_STRENGTH:
					return "Sức Mạnh";
				
				case GUILD_SKILL_TYPE_AGILITY:
					return "Sinh Khí";
					
				case GUILD_SKILL_TYPE_INTELLIGENT:
					return "Trí Tuệ";
					
				case GUILD_SKILL_TYPE_VITALITY:
					return "Thân Pháp";
		
			}
			
			return "";
		}
	}

}