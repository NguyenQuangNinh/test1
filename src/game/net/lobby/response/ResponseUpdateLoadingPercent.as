package game.net.lobby.response 
{
	import flash.utils.ByteArray;
	import game.net.ResponsePacket;
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class ResponseUpdateLoadingPercent extends ResponsePacket
	{
		
		public var percents:Array = [];
		
		public function ResponseUpdateLoadingPercent() 
		{
			
		}
		
		
		override public function decode(data:ByteArray):void 
		{
			super.decode(data);
			while (data && data.bytesAvailable > 0) {
				var playerID:int = data.readInt();
				var playerPercent:int = data.readInt();
				
				percents.push({ID: playerID, percent: playerPercent});
			}
		}
	}

}