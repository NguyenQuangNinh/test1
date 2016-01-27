package game.net.game.ingame
{
	import flash.utils.ByteArray;
	
	
	public class ResponseCreateObject extends IngamePacket
	{
		public var xmlID:int;
		public var x:int;
		public var y:int;
		public var teamID:int;
		public var speed:int;
		public var maxHP:int;
		public var currentHP:int;
		public var formationIndex:int;
		public var userID:int;
		public var currentMP:int;
		public var attackSpeed:int;
		
		override public function decode(data:ByteArray):void
		{
			xmlID 		= data.readShort();
			x 			= data.readShort();
			y 			= data.readShort();
			teamID		= data.readByte();
			speed		= data.readShort();
			maxHP		= data.readInt();
			currentHP	= data.readInt();
			formationIndex = data.readByte();
			userID 		= data.readInt();
			currentMP 	= data.readInt();
			attackSpeed = data.readShort();
		}
	}
}