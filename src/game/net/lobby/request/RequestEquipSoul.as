package game.net.lobby.request 
{
	import flash.utils.ByteArray;
	import game.net.lobby.LobbyRequestType;
	import game.net.RequestPacket;
	/**
	 * ...
	 * @author anhtinh
	 */
	public class RequestEquipSoul extends RequestPacket
	{
		public var unitIndex : int;
		public var soulIndex : int;
		public var slotIndex : int;
		
		public function RequestEquipSoul(unitIndex : int, soulIndex : int, slotIndex : int) 
		{
			super(LobbyRequestType.EQUIP_SOUL);
			this.unitIndex = unitIndex;
			this.soulIndex = soulIndex;
			this.slotIndex = slotIndex;
		}
		
		override public function encode():ByteArray 
		{
			var data:ByteArray = super.encode();			
			data.writeInt(unitIndex);
			data.writeInt(soulIndex);
			data.writeInt(slotIndex);
			return data;
		}	
	}

	
		
}