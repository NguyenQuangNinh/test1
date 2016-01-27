package game.net.lobby.request 
{
	import flash.utils.ByteArray;
	import game.enum.LeaderBoardTypeEnum;
	//import game.data.enum.topleader.LeaderBoardTypeEnum;
	import game.net.lobby.LobbyRequestType;
	import game.net.RequestPacket;
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class RequestHistoryLeaderBoard extends RequestPacket
	{		
		public var weekIndex:int;
		public var fromIndex:int;
		public var toIndex:int;
		
		public function RequestHistoryLeaderBoard(type:int, index:int, from:int, to:int ) 
		{
			switch(type) {
				case LeaderBoardTypeEnum.TOP_1VS1_MM:					
					super(LobbyRequestType.PVP1vs1_MM_HISTORY_TOP_LEADER_BOARD);
					break;
				case LeaderBoardTypeEnum.TOP_3VS3_MM:
					//super(LobbyRequestType.PVP3vs3_MM_HISTORY_TOP_LEADER_BOARD);
					break;
			}
			weekIndex = index;
			fromIndex = from;
			toIndex = to;
		}
		
		override public function encode():ByteArray 
		{
			var data:ByteArray =  super.encode();
			data.writeInt(weekIndex);
			data.writeInt(fromIndex);
			data.writeInt(toIndex);
			return data;
		}
	}

}