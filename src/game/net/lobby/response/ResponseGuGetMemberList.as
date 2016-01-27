package game.net.lobby.response 
{
	import core.util.ByteArrayEx;
	import flash.utils.ByteArray;
	import game.net.lobby.response.data.GuJoinRequestInfo;
	import game.net.lobby.response.data.GuMemberInfo;
	import game.net.ResponsePacket;
	/**
	 * ...
	 * @author vuanh
	 */
	public class ResponseGuGetMemberList extends ResponsePacket
	{
		public var memberList:Array;
		override public function decode(data:ByteArray):void 
		{
			memberList = [];
			var info:GuMemberInfo;
			while (data.bytesAvailable)
			{
				info = new GuMemberInfo();
				info.nPlayerID = data.readInt();
				info.strRoleName = ByteArrayEx(data).readString();
				info.nLevel = data.readInt();
				info.nMemberType = data.readInt();
				info.nTotalDedicationPoint = data.readInt();
				info.nOfflineTime = data.readInt();
		
				memberList.push(info);
			}
		}
		
	}

}