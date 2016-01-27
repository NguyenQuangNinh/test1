package game.net.lobby.request 
{
	import flash.utils.ByteArray;
	import game.net.lobby.LobbyRequestType;
	import game.net.RequestPacket;
	
	/**
	 * ...
	 * @author MaiPTT
	 */
	public class RequestQuickJoinBasicRoom extends RequestPacket 
	{
		public var nModeID:int = 0;//Mode Unknow
		public var nCampaignID:int = -1;
		public var nDifficultyLevel:int = -1; 
		
		public function RequestQuickJoinBasicRoom() {
			super(LobbyRequestType.QUICK_JOIN_BASIC_ROOM);
			nModeID = 0;
			nCampaignID = -1;
			nDifficultyLevel = -1;
		}
		
		override public function encode():ByteArray {
			var byteArray:ByteArray = super.encode();
			byteArray.writeInt(nModeID);
			byteArray.writeInt(nCampaignID);
			byteArray.writeInt(nDifficultyLevel);			
			return byteArray;
		}
	}

}