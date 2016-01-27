package game.net.lobby.request 
{
	import flash.utils.ByteArray;
	import game.net.lobby.LobbyRequestType;
	import game.net.RequestPacket;
	/**
	 * ...
	 * @author anhtinh
	 */
	public class RequestDivineWeaponUnequipItem extends RequestPacket
	{
		public var unitIndex:int;
		public function RequestDivineWeaponUnequipItem(unitIndex : int)
		{
			super(LobbyRequestType.DIVINE_WEAPON_UNEQUIP_ITEM);
			this.unitIndex = unitIndex;
		}
		
		override public function encode():ByteArray 
		{
			var data:ByteArray = super.encode();			
			data.writeInt(unitIndex);
			return data;
		}	
	}

	
		
}