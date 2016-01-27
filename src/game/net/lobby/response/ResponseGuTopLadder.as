package game.net.lobby.response 
{
	import core.util.ByteArrayEx;
	import flash.utils.ByteArray;
	import game.net.lobby.response.data.GuLadderInfo;
	import game.net.ResponsePacket;
	/**
	 * ...
	 * @author vuanh
	 */
	public class ResponseGuTopLadder extends ResponsePacket
	{
		public var guildList:Array;

		override public function decode(data:ByteArray):void 
		{
			guildList = [];
			while (data.bytesAvailable)
			{
				var info:GuLadderInfo = new GuLadderInfo();
				info.nRank = data.readInt() + 1;
				info.nGuildID = data.readInt();
				info.strName = ByteArrayEx(data).readString();
				info.nLevel = data.readInt();
				guildList.push(info);
			}
		}
		
	}

}