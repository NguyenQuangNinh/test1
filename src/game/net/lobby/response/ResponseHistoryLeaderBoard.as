package game.net.lobby.response 
{
	import core.util.ByteArrayEx;
	
	import flash.utils.ByteArray;
	
	import game.data.vo.lobby.LobbyPlayerInfo;
	import game.net.ResponsePacket;

	/**
	 * ...
	 * @author TrungLNM
	 */
	public class ResponseHistoryLeaderBoard extends ResponsePacket
	{		
		public var players:Array = [];
		//public var typeRequest:int;
		public var isLastTop:Boolean;
		
		public function ResponseHistoryLeaderBoard() 
		{
			
		}
		
		override public function decode(data:ByteArray):void 
		{
			super.decode(data);
			isLastTop = data.readBoolean();
			//typeRequest = data.readInt();
			
			var info:LobbyPlayerInfo;
			while (data && data.bytesAvailable > 0) {
				info = new LobbyPlayerInfo();
				info.id = data.readInt();
				info.name = ByteArrayEx(data).readString();
				info.eloScore = data.readInt();
				info.rank = data.readInt();							
				players.push(info);
			}
		}
	}

}