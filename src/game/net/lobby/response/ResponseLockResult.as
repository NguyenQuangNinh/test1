package game.net.lobby.response 
{
	import core.util.ByteArrayEx;
	import core.util.Enum;

	import flash.utils.ByteArray;

	import game.data.xml.event.EventType;

	import game.net.ResponsePacket;

	/**
	 * ...
	 * @author ninhnq
	 */
	public class ResponseLockResult extends ResponsePacket
	{
		public var errorCode:int;
		public var index:int = 0;

		override public function decode(data:ByteArray):void 
		{
			errorCode = data.readInt();

			if(errorCode == 0)
			{ // success
				index = data.readInt();
			}
		}
	}

}