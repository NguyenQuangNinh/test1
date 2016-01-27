package game.net.lobby.request 
{
	import flash.utils.ByteArray;
	import game.net.lobby.LobbyRequestType;
	import game.net.RequestPacket;
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class RequestUnitChangeSkill extends RequestPacket
	{
		
		public var unitIndex:int;
		public var skillIndex:int;
		
		public function RequestUnitChangeSkill(uIndex:int, sIndex:int) 
		{
			super(LobbyRequestType.UNIT_CHANGE_SKILL);
			unitIndex = uIndex;
			skillIndex = sIndex;
		}
		
		
		override public function encode():ByteArray 
		{
			var data:ByteArray = super.encode();
			data.writeInt(unitIndex);
			data.writeInt(skillIndex);
				
			return data;
		}		
	}

}