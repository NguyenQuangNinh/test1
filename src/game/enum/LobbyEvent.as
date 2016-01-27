package game.enum 
{
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class LobbyEvent 
	{
		//player info slot
		public static const VIEW_PLAYER:String = "viewLobbyPlayer";
		public static const SWAP_PLAYER:String = "swapLobbyPlayer";
		public static const KICK_PLAYER:String = "kickLobbyPlayer";
		
		//invite player slot
		public static const PLAYER_INVITE_CLICK:String = "playerInviteClick";
		
		//lobby view
		public static const BACK_TO_HOME:String = "backToHome";
		public static const START_PVP_GAME:String = "startPvPGame";
		public static const GET_PLAYER_LIST:String = "getPlayerList";
		public static const CANCEL_MATCHING:String = "cancelMatchMatching";
		public static const PLAYER_REQUEST:String = "playerRequest";
		
		public function LobbyEvent() 
		{
			
		}
		
	}

}