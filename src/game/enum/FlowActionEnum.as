package game.enum 
{
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class FlowActionEnum 
	{			
		//public static const PRELOAD_INIT_GAME	:int = 1;
		//public static const INIT_GAME_NEW_ROLE	:int = 2;
		//public static const INIT_GAME_REGISTERED_ROLE	:int = 3;
		
		//for drag drop flow
		public static const CHANGE_FORMATION:int = 4;
		public static const INSERT_TO_FORMATION:int = 5;
		public static const REMOVE_FROM_FORMATION:int = 6;
		
		//flow game from out to ingame
		//public static const CREATE_LOBBY:int = 10;	//CHUA DUNG
		public static const START_LOBBY:int = 11;
		//public static const START_LOADING_RESOURCE:int = 12;
		public static const CONTINUE_PLAY_GAME:int = 13;
		public static const JOIN_LOBBY_BY_ID:int = 14;
		//static public const UPDATE_HEROIC_FORMATION:int = 15;
		static public const QUICK_JOIN:int = 16;
		public static const CREATE_BASIC_LOBBY:int = 17;
		public static const LEAVE_GAME:int = 18;
		
		//for action completed
		public static const CREATE_LOBBY_SUCCESS:int = 100;
		public static const CREATE_LOBBY_FAIL:int = 101;
		public static const START_LOBBY_SUCCESS:int = 102;
		public static const REQUEST_MATCHING_SUCCESS:int = 103;
		public static const END_GAME_RESULT:int = 104;
		public static const LEAVE_LOBBY_SUCCESS:int = 105;
		public static const JOIN_LOBBY_SUCCESS:int = 106;
		public static const START_GAME_ERR_CODE	:int = 107;
		public static const JOIN_HEROIC_SUCCESS:int = 108;
		public static const LEAVE_GAME_SUCCESS:int = 109;
		public static const QUICK_JOIN_SUCCESS:int = 110;
		public static const QUICK_JOIN_FAIL:int	= 111;
		public static const LEAVE_LOBBY_FAIL:int = 112;
		public static const UPDATE_LOBBY_INFO_SUCCESS:int = 113;
		public static const START_LOADING_RESOURCE_SUCCESS:int = 114;
		public static const START_LOADING_RESOURCE_REPLAY:int = 115;
		public static const GAME_END_REPLAY:int = 116;
		
		public static const GO_TO_ACTION:int = 1000;
		
		//for purchase resource
		public static const PURCHASE_RESOURCE:int = 200;
		
		
		public function FlowActionEnum() 
		{
			
		}
		
	}

}