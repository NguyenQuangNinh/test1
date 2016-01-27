package game.net.lobby.response 
{
	import core.util.ByteArrayEx;
	
	import flash.utils.ByteArray;
	
	import game.data.vo.challenge.HistoryInfo;
	import game.net.ResponsePacket;

	/**
	 * ...
	 * @author TrungLNM
	 */
	public class ResponseChallengeHistory extends ResponsePacket
	{
		public var historys:Array = []
		
		public function ResponseChallengeHistory() 
		{
			
		}
		
		override public function decode(data:ByteArray):void 
		{
			super.decode(data);
			var history:HistoryInfo;
			var index:int = 0;
			while (data && data.bytesAvailable > 0) {
				history = new HistoryInfo();
				history.index = index;
				history.activeAttack = data.readBoolean();
				history.isWin = data.readBoolean();
				history.playerID = data.readInt();
				history.name = ByteArrayEx(data).readString();
				history.rank = data.readInt();
				history.time = ByteArrayEx(data).readString();
				history.nTimeCreate = data.readUnsignedInt();
				index++;
				historys.push(history);
			}
		}
		
	}

}