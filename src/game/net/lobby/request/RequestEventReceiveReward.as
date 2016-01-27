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
	public class RequestEventReceiveReward extends RequestPacket
	{
		public var eventID:int;
		public var eventType:int;
		public var milestoneIndex:int;

		public function RequestEventReceiveReward(type:int, eventID:int, eventType:int, milestoneIndex:int)
		{
			super(type);
			this.eventID = eventID;
			this.eventType = eventType;
			this.milestoneIndex = milestoneIndex;
		}
		
		override public function encode():ByteArray
		{
			var data:ByteArrayEx = new ByteArrayEx();
			data.writeInt(eventID);
			data.writeInt(eventType);
			data.writeInt(milestoneIndex);
			return data;
		}
	}

}