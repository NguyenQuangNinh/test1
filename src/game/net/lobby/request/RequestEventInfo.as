package game.net.lobby.request
{
	import core.util.ByteArrayEx;
	import core.util.Utility;
	
	import flash.utils.ByteArray;
	
	import game.net.RequestPacket;
	import game.ui.chat.ChatModule;
	
	/**
	 * ...
	 * @author NINHNQ
	 */
	public class RequestEventInfo extends RequestPacket
	{
		public var eventID:int;
		public var eventType:int;
		
		public function RequestEventInfo(type:int, eventID:int, eventType:int)
		{
			super(type);
			this.eventID = eventID;
			this.eventType = eventType;
		}
		
		override public function encode():ByteArray
		{
			var data:ByteArrayEx = new ByteArrayEx();
			data.writeInt(eventID);
			data.writeInt(eventType);
			return data;
		}
	}

}