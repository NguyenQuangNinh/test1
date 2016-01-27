package game.enum 
{
	import core.util.Enum;
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class PlayerType extends Enum
	{
		
		public static const FRIEND_PLAYER:PlayerType = new PlayerType(0, 1, "friend_player");
		public static const SERVER_PLAYER:PlayerType = new PlayerType(1, 0, "server_player");
		public static const GUILD_PLAYER:PlayerType = new PlayerType(2, 2, "guild_player");
		
		public var type:int;
		
		public function PlayerType(ID:int, playerType:int, name:String = "") 
		{
			super(ID, name);
			type = playerType;
		}
		
	}

}