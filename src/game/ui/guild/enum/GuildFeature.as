package game.ui.guild.enum 
{
	/**
	 * ...
	 * @author vu anh
	 */
	public class GuildFeature 
	{
		public static const PRESIDENT:Array = [GuildMemberAction.INVITE_MEMBER, GuildMemberAction.REMOVE_MEMBER, GuildMemberAction.CHANGE_ROLE, GuildMemberAction.UPGRATE_GUILD, GuildMemberAction.DISTRIBUTE_RESOURCE,
											   GuildMemberAction.REFUSE_PRESIDENT, GuildMemberAction.UPDATE_ANNOUCE, GuildMemberAction.UPDATE_NOTICE, GuildMemberAction.VIEW_JOIN_REQUEST];
		public static const VICE:Array = [GuildMemberAction.INVITE_MEMBER, GuildMemberAction.REMOVE_MEMBER, GuildMemberAction.CHANGE_ROLE, GuildMemberAction.UPGRATE_GUILD,
										  GuildMemberAction.VIEW_JOIN_REQUEST, GuildMemberAction.LEAVE_GUILD];
		public static const ELDER:Array = [GuildMemberAction.INVITE_MEMBER, GuildMemberAction.REMOVE_MEMBER, GuildMemberAction.CHANGE_ROLE, GuildMemberAction.VIEW_JOIN_REQUEST,
											, GuildMemberAction.LEAVE_GUILD];
		public static const CAPTAIN:Array = [GuildMemberAction.INVITE_MEMBER, GuildMemberAction.REMOVE_MEMBER, GuildMemberAction.LEAVE_GUILD];
		public static const NORMAL:Array = [GuildMemberAction.INVITE_MEMBER, GuildMemberAction.LEAVE_GUILD];
	
		public function GuildFeature() 
		{
			
		}
		
		public static function getGuildFeature(roleId:int):Array
		{
			switch(roleId)
			{
				case GuildRole.PRESIDENT:
					return PRESIDENT;
				//case 2:
					//return VICE;
				case GuildRole.ELDER:
					return ELDER;
				case GuildRole.CAPTAIN:
					return CAPTAIN;
				case GuildRole.MEMBER:
					return NORMAL;
			}
			return [];
		}
		
	}

}