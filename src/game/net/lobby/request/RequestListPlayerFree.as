package game.net.lobby.request 
{
	import core.util.Utility;
	import flash.utils.ByteArray;
	import game.net.lobby.LobbyRequestType;
	import game.net.RequestPacket;
	/**
	 * ...
	 * @author DuT
	 */
	public class RequestListPlayerFree extends RequestPacket
	{
		public var from:int;
		public var to:int;
		public var requestType:int;
		
		public function RequestListPlayerFree(requestFromIndex:int, requestToIndex:int, type:int)
		{
			super(LobbyRequestType.GET_PLAYERS_FREE);
			//type = requestType;
			from = requestFromIndex;
			to = requestToIndex;
			requestType = type;
		}
		
		override public function encode():ByteArray 
		{
			var data:ByteArray = super.encode();			
			data.writeInt(requestType);
			data.writeInt(from);
			data.writeInt(to);
			return data;
		}
	}

}