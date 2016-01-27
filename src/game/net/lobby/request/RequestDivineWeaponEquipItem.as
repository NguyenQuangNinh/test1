package game.net.lobby.request 
{
	import flash.utils.ByteArray;
	import game.net.lobby.LobbyRequestType;
	import game.net.RequestPacket;
	/**
	 * ...
	 * @author anhtinh
	 */
	public class RequestDivineWeaponEquipItem extends RequestPacket
	{
		public var unitIndex:int;
        public var dwSlotIndex:int;
		public function RequestDivineWeaponEquipItem(unitIndex : int, dwSlotIndex : int)
		{
			super(LobbyRequestType.DIVINE_WEAPON_EQUIP_ITEM);
			this.unitIndex = unitIndex;
            this.dwSlotIndex = dwSlotIndex;
		}
		
		override public function encode():ByteArray 
		{
			var data:ByteArray = super.encode();			
			data.writeInt(unitIndex);
			data.writeInt(dwSlotIndex);
			return data;
		}	
	}

	
		
}