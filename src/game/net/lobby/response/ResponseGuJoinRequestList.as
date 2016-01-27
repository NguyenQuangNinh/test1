package game.net.lobby.response 
{
	import core.util.ByteArrayEx;
	import flash.utils.ByteArray;
	import game.net.lobby.response.data.GuJoinRequestInfo;
	import game.net.ResponsePacket;
	/**
	 * ...
	 * @author vuanh
	 */
	public class ResponseGuJoinRequestList extends ResponsePacket
	{
		public var requestList:Array;
		override public function decode(data:ByteArray):void 
		{
			requestList = [];
			var info:GuJoinRequestInfo;
			while (data.bytesAvailable)
			{
				info = new GuJoinRequestInfo();
				info.nPlayerID = data.readInt();
				info.nLevel = data.readInt();
				info.strRoleName = ByteArrayEx(data).readString();
				requestList.push(info);
			}
		}
		
	}

}