package game.net.game.ingame
{
	import flash.utils.ByteArray;
	
	
	public class ResponseCreateBullet extends IngamePacket
	{
		public var effectID:int;
		public var x:int;
		public var y:int;
		public var teamID:int;
		public var speed:int;
		public var nCharacterIDCreate:int;
		
		override public function decode(data:ByteArray):void
		{
			effectID = data.readShort();
			x = data.readShort();
			y = data.readShort();
			teamID = data.readByte();
			speed = data.readShort();
			nCharacterIDCreate = data.readInt();
			//trace("create bullet nCharacterIDCreate " + nCharacterIDCreate);
		}
	}
}