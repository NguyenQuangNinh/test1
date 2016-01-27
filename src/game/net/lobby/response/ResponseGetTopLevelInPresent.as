package game.net.lobby.response
{
	import core.util.ByteArrayEx;
	import flash.utils.ByteArray;
	import game.data.vo.lobby.LobbyPlayerInfo;
	import game.net.ResponsePacket;
	
	/**
	 * ...
	 * @author chuongth2
	 */
	public class ResponseGetTopLevelInPresent extends ResponsePacket
	{
		public var players:Array = [];
		public var nDetaDiffDays:int;
		public var nDiffSeconds:int;
		
		public function ResponseGetTopLevelInPresent()
		{
		
		}
		
		override public function decode(data:ByteArray):void
		{
			players = [];
			super.decode(data);
			nDetaDiffDays = data.readInt();
			nDiffSeconds = data.readInt();
			
			var info:LobbyPlayerInfo;
			var index:int = 0;
			while (data && data.bytesAvailable > 0)
			{
				info = new LobbyPlayerInfo();
				info.index = index++;
				info.id = data.readInt();
				info.name = ByteArrayEx(data).readString();
				info.level = data.readInt();
				if (info != null)
					players.push(info);
			}
		}
	}

}