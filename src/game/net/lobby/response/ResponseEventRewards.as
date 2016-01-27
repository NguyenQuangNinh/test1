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
	public class ResponseEventRewards extends ResponsePacket
	{
		public var errorCode:int;
		public var eventID:int;
		public var milestoneIndex:int;

		override public function decode(data:ByteArray):void 
		{
			errorCode = data.readInt();
			eventID = data.readInt();
			milestoneIndex = data.readInt();
		}
	}

}