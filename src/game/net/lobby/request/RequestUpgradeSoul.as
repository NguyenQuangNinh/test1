package game.net.lobby.request 
{
	import flash.utils.ByteArray;
	import game.net.lobby.LobbyRequestType;
	import game.net.RequestPacket;
	/**
	 * ...
	 * @author anhtinh
	 */
	public class RequestUpgradeSoul extends RequestPacket
	{
		
		public var indexFrom : int;
		public var indexTo : int;
		
		public function RequestUpgradeSoul(indexFrom : int, indexTo : int) 
		{
			super(LobbyRequestType.UPGRADE_SOUL);
			this.indexFrom = indexFrom;
			this.indexTo = indexTo;
		}
		
		override public function encode():ByteArray 
		{
			var data:ByteArray = super.encode();			
			data.writeInt(indexFrom);
			data.writeInt(indexTo);
			return data;
		}	
		
	}

}