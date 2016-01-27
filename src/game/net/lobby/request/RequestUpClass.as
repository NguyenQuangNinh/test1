package game.net.lobby.request 
{
	import flash.utils.ByteArray;
	import game.net.lobby.LobbyRequestType;
	import game.net.RequestPacket;
	
	/**
	 * ...
	 * @author MaiPTT
	 */
	public class RequestUpClass extends RequestPacket 
	{
		public var slotIndex	:int;
		public var nextID		:int;
		
		public function RequestUpClass() 
		{
			super(LobbyRequestType.LEVEL_UP_CLASS);
		}
		
		override public function encode():ByteArray 
		{
			var data:ByteArray =  super.encode();
			data.writeInt(slotIndex);
			data.writeInt(nextID);
			
			return data;
		}
	}

}