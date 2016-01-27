package game.net.lobby.response 
{
	import core.util.ByteArrayEx;
	import flash.utils.ByteArray;
	import game.data.vo.challenge.HistoryInfo;
	import game.net.ResponsePacket;
	/**
	 * ...
	 * @author ...
	 */
	public class ResponseTuuLauChienHistory extends ResponsePacket
	{
		
		public var historyInfo: Array = [];
		
		public function ResponseTuuLauChienHistory() 
		{
			
		}
		
		override public function decode(data:ByteArray):void 
		{
			super.decode(data);

			var size:int = data.readInt();
			
			for (var i:int = 0; i < size; i++)
			{
				//history parse
				var history:HistoryInfo = new HistoryInfo();
				history.isWin = data.readBoolean();
				history.playerID = data.readInt();
				history.type = data.readInt();
				history.name = ByteArrayEx(data).readString();
				history.nTimeCreate = data.readUnsignedInt();
				history.time = ByteArrayEx(data).readString();
				history.numResourceRob = data.readInt();
				
				historyInfo.push(history);
			}
		}
		
	}

}