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
	public class ResponseGetAvailableEvents extends ResponsePacket
	{
		public var eventIDs:Array = [];

		override public function decode(data:ByteArray):void 
		{
			while(data.bytesAvailable)
			{
				eventIDs.push(data.readInt());
			}
		}
	}

}