package game.net.lobby.response 
{
	import core.util.ByteArrayEx;
	import flash.utils.ByteArray;
	import game.net.lobby.response.data.GuJoinRequestInfo;
	import game.net.lobby.response.data.GuMemberInfo;
	import game.net.ResponsePacket;
	import game.ui.guild.enum.GuildRole;
	/**
	 * ...
	 * @author vuanh
	 */
	public class ResponseGuGetElderList extends ResponsePacket
	{
		public var memberList:Array;
		override public function decode(data:ByteArray):void 
		{
			memberList = [];
			var info:GuMemberInfo;
			var ind:int = 1;
			while (data.bytesAvailable)
			{
				info = new GuMemberInfo();
				info.index = ind;
				ind++;
				info.nMemberType = GuildRole.ELDER;
				info.nPlayerID = data.readInt();
				info.strRoleName = ByteArrayEx(data).readString();
				info.nLevel = data.readInt();
				info.nTotalDedicationPoint = data.readInt();
		
				memberList.push(info);
			}
		}
		
	}

}