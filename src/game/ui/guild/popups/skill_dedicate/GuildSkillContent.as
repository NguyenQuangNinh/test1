package game.ui.guild.popups.skill_dedicate 
{
	import flash.display.MovieClip;
	import game.ui.guild.enum.GuildSkillType;
	/**
	 * ...
	 * @author vu anh
	 */
	public class GuildSkillContent extends MovieClip
	{
		
		public var vitality:GuildSkillItem;
		public var strength:GuildSkillItem;
		public var agility:GuildSkillItem;
		public var intelligent:GuildSkillItem;
		
		public function GuildSkillContent() 
		{

			vitality.type = GuildSkillType.GUILD_SKILL_TYPE_VITALITY;
			vitality.titleTf.text = "TĂNG SINH KHÍ";
			vitality.icon.gotoAndStop("vitality");
			
			strength.type = GuildSkillType.GUILD_SKILL_TYPE_STRENGTH;
			strength.titleTf.text = "TĂNG SỨC MẠNH";
			strength.icon.gotoAndStop("strength");
			
			agility.type = GuildSkillType.GUILD_SKILL_TYPE_AGILITY;
			agility.titleTf.text = "TĂNG THÂN PHÁP";
			agility.icon.gotoAndStop("agility");
	
			intelligent.type = GuildSkillType.GUILD_SKILL_TYPE_INTELLIGENT;
			intelligent.titleTf.text = "TĂNG TRÍ TUỆ";
			intelligent.icon.gotoAndStop("intelligent");
		}
		
	}

}