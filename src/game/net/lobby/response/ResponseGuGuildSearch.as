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
	public class ResponseGuGuildSearch extends ResponsePacket
	{
		public var errorCode:int;
		public var guildList:Array;

		override public function decode(data:ByteArray):void 
		{
			errorCode = data.readInt();
			guildList = [];
			while (data.bytesAvailable)
			{
				var info:GuLadderInfo = new GuLadderInfo();
				info.nRank = data.readInt();
				info.nGuildID = data.readInt();
				info.strName = ByteArrayEx(data).readString();
				info.nLevel = data.readInt();
				guildList.push(info);
			}
		}
		
	}

}