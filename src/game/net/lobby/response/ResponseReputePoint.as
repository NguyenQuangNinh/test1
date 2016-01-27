package game.net.lobby.response 
{
	import flash.utils.ByteArray;
	import game.net.ResponsePacket;
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class ResponseReputePoint extends ResponsePacket
	{
		public var arrClass:Array = [];
		public var arrPoint:Array = [];
		
		public function ResponseReputePoint() 
		{
			
		}
		
		
		override public function decode(data:ByteArray):void 
		{
			super.decode(data);
			
			var numClass:int = data.readInt();
			for (var i:int = 0; i < numClass; i++ ) {
				arrClass.push(data.readInt());
				arrPoint.push(data.readInt());
			}
		}
	}

}