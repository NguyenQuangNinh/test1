package game.ui.guild 
{
	import game.ui.guild.enum.GuildLogAction;
	import game.ui.guild.enum.GuildRole;
	import game.ui.guild.enum.GuildSkillType;
	/**
	 * ...
	 * @author vu anh
	 */
	public class GuildUtils 
	{
		public static function getRoleName(nMemberType:int):String
		{
			switch (nMemberType)
			{
				case GuildRole.PRESIDENT:
					return "Bang chủ";
				//case 2:
					//return "Phó bang";
				case GuildRole.ELDER:
					return "Trưởng lão";
				case GuildRole.CAPTAIN:
					return "Đội trưởng";
				case GuildRole.MEMBER:
					return "Bang chúng";
			}
			return "";
		}
		
		public static function getGuildActionDes(nType:int, strPlayerCreateName:String, strPlayerTargetName:String, value:int):String
		{
			switch (nType)
			{
				case GuildLogAction.GUILD_ACTION_LOG_ACCEPT_INVITE: return strPlayerTargetName + " đã chấp nhận lời mời vào bang của " + strPlayerCreateName;
				case GuildLogAction.GUILD_ACTION_LOG_LEAVE: return strPlayerCreateName + " đã rời bang";
				case GuildLogAction.GUILD_ACTION_LOG_KICK: return strPlayerCreateName + " đã trục xuất thành viên " + strPlayerTargetName;
				case GuildLogAction.GUILD_ACTION_LOG_TRANSFER_PRESIDENT: return strPlayerCreateName + " đã nhường vị trí bang chủ cho " + strPlayerTargetName;
				case GuildLogAction.GUILD_ACTION_LOG_ACCEPT_REQUEST_JOIN: return strPlayerTargetName + " đã vào bang";
				case GuildLogAction.GUILD_ACTION_LOG_CHANGE_TITLE_ELDER: return strPlayerTargetName + " đã được chuyển chức trách thành " + getRoleName(GuildRole.ELDER);
				case GuildLogAction.GUILD_ACTION_LOG_CHANGE_TITLE_CAPTAIN: return strPlayerTargetName + " đã được chuyển chức trách thành " + getRoleName(GuildRole.CAPTAIN);
				case GuildLogAction.GUILD_ACTION_LOG_CHANGE_TITLE_NORMAL: return strPlayerTargetName + " đã được chuyển chức trách thành " + getRoleName(GuildRole.MEMBER);
				case GuildLogAction.GUILD_ACTION_LOG_DEDICATE_GOLD: return strPlayerCreateName + " đã cống hiến " + value + " bạc cho bang hội.";
				case GuildLogAction.GUILD_ACTION_LOG_DEDICATE_XU: return strPlayerCreateName + " đã cống hiến " + value + " vàng cho bang hội.";
				case GuildLogAction.GUILD_ACTION_LOG_DEDICATE_SKILL: return strPlayerCreateName + " đã cống hiến cho kỹ năng " + GuildSkillType.getGuildSkillType(value) + " của bang hội.";
			}
			return "";
		}
		
		public function GuildUtils() 
		{
			
		}
		
	}

}