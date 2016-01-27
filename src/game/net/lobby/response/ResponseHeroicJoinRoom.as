package game.net.lobby.response 
{
	import flash.utils.ByteArray;
	import game.enum.ErrorCode;
	import game.net.ResponsePacket;
	
	/**
	 * ...
	 * @author MaiPTT
	 */
	public class ResponseHeroicJoinRoom extends ResponsePacket 
	{
		public var errorCode:int;
		public var gameMode:int;
		public var caveID:int;
		public var nextMissionID:int;
		public var hardMode:int;
		
		override public function decode(data:ByteArray):void {
			super.decode(data);
			errorCode = data.readInt();
			if (errorCode == ErrorCode.SUCCESS) {
				gameMode = data.readInt();
				caveID = data.readInt();
				nextMissionID = data.readInt();	
				hardMode = data.readInt();
			}
		}
	}

}