package game.net.lobby.request 
{
	import core.util.ByteArrayEx;
	import flash.utils.ByteArray;
	import game.net.lobby.LobbyRequestType;
	import game.net.RequestPacket;
	import game.ui.ModuleID;
	/**
	 * ...
	 * @author ...
	 */
	public class RequestCreateBasicRoom extends RequestPacket
	{
		public var strRoomName:String = "";
		public var bIsPrivate:Boolean = false;
		public var nGameMode:int = 0; //GAME_MODE_UNKONW
		public var nPlayerAIID:int = 0;	
		public var nTowerID:int = 0;
		public var nMissionID:int = 0;
		public var nCampaignID:int = 0;
		public var nDifficultyLevel:int = 0;
		public var bOccupied:Boolean = false;
		
		public function RequestCreateBasicRoom() 
		{		
			super(LobbyRequestType.CREATE_BASIC_LOBBY);
			strRoomName = "DefaultRoomName";
			bIsPrivate = false;
			nGameMode = 0;
			nPlayerAIID = 0;
			nTowerID = 0;
			nMissionID = 0;
			nCampaignID = 0;
			nDifficultyLevel = 0;
			bOccupied = false;
		}
		
		override public function encode():ByteArray 
		{
			var data:ByteArrayEx = new ByteArrayEx();
			data.writeString(strRoomName, 32);
			data.writeBoolean(bIsPrivate);
			data.writeInt(nGameMode);
			data.writeInt(nPlayerAIID);
			data.writeInt(nTowerID);
			data.writeInt(nMissionID);
			data.writeInt(nCampaignID);
			data.writeInt(nDifficultyLevel);
			data.writeBoolean(bOccupied);
			return data;
		}
	}

}