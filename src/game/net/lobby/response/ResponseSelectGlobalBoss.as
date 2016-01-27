package game.net.lobby.response 
{
	import flash.utils.ByteArray;
	import game.net.ResponsePacket;
	
	/**
	 * ...
	 * @author MaiPTT
	 */
	public class ResponseSelectGlobalBoss extends ResponsePacket 
	{
		public var result		:int = -1;
		public var arrBoss		:Array = [];
		
		override public function decode(data:ByteArray):void {
			super.decode(data);
			result = data.readInt();
			if (result == 0) {
				var size:int = data.readInt();
				var obj:Object;
				for (var i:int = 0; i < size; i++) {
					obj = new Object();
					obj.missionID 	= data.readInt();
					obj.status 		= data.readInt();
					obj.damage		= data.readInt();
					
					arrBoss.push(obj);
				}
			}
		}
	}

}