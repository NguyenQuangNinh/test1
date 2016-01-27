package game.net.lobby.request 
{
	import flash.utils.ByteArray;
	import game.net.lobby.LobbyRequestType;
	import game.net.RequestPacket;
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class RequestUpgradeSkill extends RequestPacket
	{
		
		public var characterIndex:int;
		public var skillIndex: int;		
		
		public function RequestUpgradeSkill(character_Index:int, skill_Index:int ) 
		{
			super(LobbyRequestType.UPGRADE_SKILL);
			characterIndex = character_Index;
			skillIndex = skill_Index;
		}
		
		override public function encode():ByteArray 
		{
			var data:ByteArray = super.encode();
			data.writeInt(characterIndex);
			data.writeInt(skillIndex);	
			return data;
		}
		
	}

}