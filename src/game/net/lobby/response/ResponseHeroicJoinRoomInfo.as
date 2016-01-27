package game.net.lobby.response 
{
	import flash.utils.ByteArray;
	import game.net.ResponsePacket;
	
	/**
	 * ...
	 * @author MaiPTT
	 */
	public class ResponseHeroicJoinRoomInfo extends ResponsePacket 
	{
		public var caveID	:int = -1;
		public var hardMode	:int = -1;
		
		override public function decode(data:ByteArray):void {
			super.decode(data);
			caveID = data.readInt();
			hardMode = data.readInt();
		}
		
	}

}