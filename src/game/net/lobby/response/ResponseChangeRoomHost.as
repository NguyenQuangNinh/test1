package game.net.lobby.response 
{

	import core.util.ByteArrayEx;

	import flash.utils.ByteArray;
	import game.net.ResponsePacket;

	/**
	 * ...
	 * @author ninhnq
	 */
	public class ResponseChangeRoomHost extends ResponsePacket
	{
		public var errorCode:int;
		public var newHostID:int;
		public var name:String;
		override public function decode(data:ByteArray):void 
		{
			errorCode = data.readInt();
			if(errorCode == 0)
			{
				newHostID = data.readInt();
				name = ByteArrayEx(data).readString();
			}
		}
	}

}