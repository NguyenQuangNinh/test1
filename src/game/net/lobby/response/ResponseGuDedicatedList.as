package game.net.lobby.response 
{
	import core.util.ByteArrayEx;
	import flash.utils.ByteArray;
	import game.net.lobby.response.data.GuDedicatedMemberInfo;
	import game.net.lobby.response.data.GuJoinRequestInfo;
	import game.net.ResponsePacket;
	/**
	 * ...
	 * @author vuanh
	 */
	public class ResponseGuDedicatedList extends ResponsePacket
	{
		public var dedicatedList:Array;
		override public function decode(data:ByteArray):void 
		{
			dedicatedList = [];
			var info:GuDedicatedMemberInfo;
			while (data.bytesAvailable)
			{
				info = new GuDedicatedMemberInfo();
				info.nPlayerID = data.readInt();
				info.strRoleName = ByteArrayEx(data).readString();
				info.nDPThisWeek = data.readInt();
				info.nDPLastWeek = data.readInt();
				info.nTotalDP = data.readInt();
				dedicatedList.push(info);
			}
		}
		
	}

}