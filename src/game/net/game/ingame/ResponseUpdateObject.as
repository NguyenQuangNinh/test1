package game.net.game.ingame
{
	import flash.utils.ByteArray;
	
	
	public class ResponseUpdateObject extends IngamePacket
	{
		public var x:int;
		public var velocity:int;
		public var acceleration:int;
		
		override public function decode(data:ByteArray):void
		{
			
			x 				= data.readShort();
			velocity 		= data.readShort();
			acceleration 	= data.readShort();
			//trace("update object =================== objectID " + this.objectID + " x " + x);
		}
	}
}