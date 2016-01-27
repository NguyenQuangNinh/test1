package game.net.lobby.response 
{
	import core.util.ByteArrayEx;
	import flash.utils.ByteArray;
	import game.net.lobby.response.data.GuFriendInfo;
	import game.net.lobby.response.data.GuJoinRequestInfo;
	import game.net.ResponsePacket;
	/**
	 * ...
	 * @author vuanh
	 */
	public class ResponseGuGetFriendList extends ResponsePacket
	{
		public var friendList:Array;
		override public function decode(data:ByteArray):void 
		{
			friendList = [];
			var info:GuFriendInfo;
			while (data.bytesAvailable)
			{
				info = new GuFriendInfo();
				info.nPlayerID = data.readInt();
				info.nLevel = data.readInt();
				info.strRoleName = ByteArrayEx(data).readString();
				friendList.push(info);
			}
		}
		
	}

}