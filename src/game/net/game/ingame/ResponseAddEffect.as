package game.net.game.ingame 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author bangnd2
	 */
	public class ResponseAddEffect extends IngamePacket 
	{
		public var effectID:int;
		public var x:int;
		public var teamID:int
		
		override public function decode(data:ByteArray):void 
		{
			effectID = data.readInt();
			x = data.readInt();
			teamID = data.readByte();
		}
	}
}