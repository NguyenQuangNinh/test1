package game.net.lobby.response 
{
	import flash.utils.ByteArray;
	import game.net.ResponsePacket;
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class ResponseQuestTransportListSastified extends ResponsePacket
	{
		
		public var value:Array = [];
		
		public function ResponseQuestTransportListSastified() 
		{
			
		}
		
		override public function decode(data:ByteArray):void 
		{
			super.decode(data);
			if(data && data.bytesAvailable > 0){
				var size:int = data.readInt();
				for (var i:int = 0; i < size; i++) {
					value.push(data.readInt());
				}
			}
		}
	}

}