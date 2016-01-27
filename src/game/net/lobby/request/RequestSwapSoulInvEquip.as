package game.net.lobby.request 
{
	import flash.utils.ByteArray;
	import game.net.lobby.LobbyRequestType;
	import game.net.RequestPacket;
	/**
	 * ...
	 * @author anhtinh
	 */
	public class RequestSwapSoulInvEquip extends RequestPacket
	{
		public var unitIndex : int;
		public var indexFrom : int;
		public var indexTo : int;
		
		
		public function RequestSwapSoulInvEquip(unitIndex : int, indexFrom : int, indexTo : int ) 
		{
			super(LobbyRequestType.SWAP_SOUL_INV_EQUIP);
			this.unitIndex = unitIndex;
			this.indexFrom = indexFrom;
			this.indexTo = indexTo;
		}
		
		override public function encode():ByteArray 
		{
			var data:ByteArray = super.encode();			
			data.writeInt(unitIndex);
			data.writeInt(indexFrom);
			data.writeInt(indexTo);
			return data;
		}	
	}

}