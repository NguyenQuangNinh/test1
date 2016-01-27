package game.net.lobby.response
{
	import flash.utils.ByteArray;
	
	import game.net.ResponsePacket;
	
	public class ResponseGetPaymentEventInfo extends ResponsePacket
	{
		public var eventID:int = 0;
		public var currentXuCharged:int = 0;
		public var dayRemain:int = 0;
		public var paymentRewardSize:int = 0;
		public var arrRewardStatus:Array = [];
		
		override public function decode(data:ByteArray):void
		{
			eventID = data.readInt();
			if (eventID > 0)
			{
				currentXuCharged = data.readInt();
				dayRemain = data.readInt();
				paymentRewardSize = data.readInt();
				for (var i:int = 0; i < paymentRewardSize; i++)
				{
					var status:int = data.readInt();
					arrRewardStatus.push(status);
				}
			}
		}
	}
}