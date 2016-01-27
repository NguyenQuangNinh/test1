package game.net.lobby.response
{
	import core.util.ByteArrayEx;
	
	import flash.utils.ByteArray;
	
	import game.net.ResponsePacket;
	
	/**
	 * ...
	 * @author ...
	 */
	public class ResponseMetalFurnaceResult extends ResponsePacket
	{
		public var result:int;
		public var bonusGold:int;

		
		override public function decode(data:ByteArray):void
		{
            result = data.readInt();
            bonusGold = data.readInt();
		}
	}

}