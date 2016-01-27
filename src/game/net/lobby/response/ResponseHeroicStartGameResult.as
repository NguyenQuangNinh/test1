package game.net.lobby.response 
{
	import flash.utils.ByteArray;
	import game.net.ResponsePacket;
	
	/**
	 * ...
	 * @author MaiPTT
	 */
	public class ResponseHeroicStartGameResult extends ResponsePacket 
	{
		public var errorCode	:int;
		public var playerID		:int;
		public var missionID	:int;
		
		override public function decode(data:ByteArray):void {
			super.decode(data);
			errorCode = data.readInt();
			playerID = data.readInt();
			missionID = data.readInt();
		}
	}

}