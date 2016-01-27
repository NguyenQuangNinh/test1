package game.net.lobby.response 
{
	import core.util.ByteArrayEx;
	import flash.utils.ByteArray;
	import game.net.ResponsePacket;
	/**
	 * ...
	 * @author vuanh
	 */
	public class ResponseGuInvite extends ResponsePacket
	{
		public var nPlayerIDInvite:int;
		public var nPlayerNameInvite:String;
		public var nGuildID:int;
		public var strName:String;


		override public function decode(data:ByteArray):void 
		{
			nPlayerIDInvite = data.readInt();
			nPlayerNameInvite = ByteArrayEx(data).readString();
			nGuildID = data.readInt();
			strName = ByteArrayEx(data).readString();
		}
		
	}

}