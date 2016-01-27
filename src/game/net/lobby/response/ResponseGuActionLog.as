package game.net.lobby.response 
{
	import core.util.ByteArrayEx;
	import flash.utils.ByteArray;
	import game.net.lobby.response.data.GuLogItemInfo;
	import game.net.ResponsePacket;
	/**
	 * ...
	 * @author vuanh
	 */
	public class ResponseGuActionLog extends ResponsePacket
	{
		public var logArr:Array;

		override public function decode(data:ByteArray):void 
		{
			logArr = [];
			var info:GuLogItemInfo;
			while (data.bytesAvailable)
			{
				info = new GuLogItemInfo();
				info.nType = data.readInt();
				info.strPlayerCreateName = ByteArrayEx(data).readString();
				info.strPlayerTargetName = ByteArrayEx(data).readString();
				info.value = data.readInt();
				info.time = data.readUnsignedInt();
				logArr.push(info);
			}
			logArr.reverse();
		}
		
	}

}