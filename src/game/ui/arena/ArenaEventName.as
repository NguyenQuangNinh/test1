package game.ui.arena 
{
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class ArenaEventName 
	{
		//this enum must match with define in server --> keep checking
		//mode selected		
		//pvp_ai = 0
		//pvp_1vs1_free = 1
		//pve = 2
		//pve_boss = 3
		//pvp_3vs3_free = 4
		//pvp_3vs3_matching = 5
		//pvp_1vs1_matching = 6
		/*public static const PVP_FREE:int = 10;
		public static const PvP_1vs1_RANKING:int = 0;
		public static const PVP_1vs1_FREE:int = 1;
		public static const PVP_3vs3_FREE:int = 4;
		public static const PvP_3vs3_MATCHING:int = 5;			
		public static const PvP_1vs1_MATCHING:int = 6;*/			
		
		//mode info selected
		public static const MODE_INFO_JOIN:int = 1;
		public static const MODE_INFO_CREATE_ROOM:int = 2;
		public static const MODE_INFO_CHALLENGE:int = 3;
		public static const MODE_INFO_REFRESH:int = 4;
		public static const MODE_INFO_QUICK_JOIN:int = 5;
		public static const MODE_INFO_SEARCH:int = 6;		
		public static const MODE_INFO_ENTER_LOBBY:int = 7;
		public static const MODE_INFO_MATCHING:int = 8;
		public static const MODE_INFO_REGISTER:int = 9;
		public static const MODE_INFO_SELECTED:String = "modeInfoSelected";
		
		//top leader board and mode state info
		public static const REQUEST_MODE_INFO_STATE:String = "requestModeInfoState";
		public static const REQUEST_MODE_INFO_LEADER_BOARD:String = "requestModeInfoLeaderBoard";
		
		public static const MODE_SELECTED:String = "modeSelected";
		//room list 
		public static const GET_ROOM_LIST:String = "getRoomList";
		public static const ROOM_SELECTED:String = "roomSelected";
		
		public static const CLOSE:String = "arena_close";
		public static const MATCHING_GAME:String = "matchingGame";
		public static const JOIN_ROOM:String = "joinRoom";
		public static const QUICK_JOIN_GAME:String = "quickJoinGame";
		public static const ROOM_CREATED:String = "roomCreated";		
		public static const PLAYER_CHALLENGE_CLICK:String = "playerChallengeClick";

		//arena state
		public static const ARENA_MODE_SELECT:int = 2;
		public static const ARENA_ROOM_SELECT:int = 3;
		public static const ARENA_ROOM_CREATE:int = 4;

	}

}