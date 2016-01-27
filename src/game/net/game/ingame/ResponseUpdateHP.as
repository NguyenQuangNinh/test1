package game.net.game.ingame
{
	import flash.utils.ByteArray;
	
	
	public class ResponseUpdateHP extends IngamePacket
	{
		public var currentHP:int;
		public var critical:Boolean;
		
		override public function decode(data:ByteArray):void
		{
			currentHP = data.readInt();
			critical = data.readBoolean();
		}
	}
}