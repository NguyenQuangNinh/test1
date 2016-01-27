package game.net.lobby.request 
{
	import flash.utils.ByteArray;
	import game.net.lobby.LobbyRequestType;
	import game.net.RequestPacket;
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class RequestFormation extends RequestPacket
	{
		public var userID:int;
		public var formationType:int;
		
		public function RequestFormation(type: int, id:int) 
		{
			super(LobbyRequestType.GET_FORMATION);
			formationType = type;
			userID = id;			
		}
		
		override public function encode():ByteArray 
		{
			var data:ByteArray = super.encode();
			data.writeInt(formationType);
			data.writeInt(userID);
			return data;			
		}
		
	}

}