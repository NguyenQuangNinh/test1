package game.net.lobby.response 
{
	import core.util.ByteArrayEx;
	import flash.utils.ByteArray;
	import game.net.ResponsePacket;
	/**
	 * ...
	 * @author vuanh
	 */
	public class ResponseGuChatMessage extends ResponsePacket
	{
		public var nType:uint; // 1byte
		public var nPlayerID:int;
		public var strRoleName:String;
		public var strMessage:String;

		override public function decode(data:ByteArray):void 
		{
			nType = data.readUnsignedByte();
			nPlayerID = data.readInt();
			strRoleName = ByteArrayEx(data).readString();
			strMessage = ByteArrayEx(data).readString();
		}
		
	}

}