package game.net.lobby.response 
{
	import flash.utils.ByteArray;
	import game.net.ResponsePacket;
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class ResponseQuestTransportState extends ResponsePacket
	{
		
		public var state:int;
		public var remainQuest:int;
		public var elapseTimeToNextRandom:int;		
		
		public function ResponseQuestTransportState() 
		{
			
		}
		
		override public function decode(data:ByteArray):void 
		{
			super.decode(data);
			state = data.readInt();
			remainQuest = data.readInt();
			elapseTimeToNextRandom = data.readInt();
		}
	}

}