package game.net.lobby.response 
{
	import core.util.ByteArrayEx;
	import core.util.Enum;

	import flash.utils.ByteArray;

	import game.data.xml.event.EventType;

	import game.net.ResponsePacket;

	/**
	 * ...
	 * @author chuongth2
	 */
	public class ResponseEventInfo extends ResponsePacket
	{
		public var eventID:int;
		public var eventType:int;
		public var currentAcc:int;
		public var receivedRewardIndexs:Array = [];
		public var isActivated:Boolean = false; //Ap dung doi voi EventType.ACTIVATE: da bam nut kich hoat tich luy theo ngay hay chua?

		override public function decode(data:ByteArray):void 
		{
			eventID = data.readInt();

			if(eventID <= 0) return;

			eventType = data.readInt();

			if(eventType == EventType.ACTIVATE.ID)
			{
				isActivated = data.readBoolean();
			}

			currentAcc = data.readInt();

			var size:int = data.readInt();
			for (var i:int = 0; i < size; i++ )
			{
				receivedRewardIndexs.push(data.readInt());
			}
		}
	}

}