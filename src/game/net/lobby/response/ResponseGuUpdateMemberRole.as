package game.net.lobby.response 
{
	import core.util.ByteArrayEx;
	import flash.utils.ByteArray;
	import game.net.ResponsePacket;
	/**
	 * ...
	 * @author vuanh
	 */
	public class ResponseGuUpdateMemberRole extends ResponsePacket
	{
		public var nPlayerID:int;
		public var nMemberType:int;

		override public function decode(data:ByteArray):void 
		{
			nPlayerID = data.readInt();
			nMemberType = data.readByte();
		}
		
	}

}