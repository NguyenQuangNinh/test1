package game.net.lobby.response 
{
	import flash.utils.ByteArray;
	import game.net.ResponsePacket;
	/**
	 * ...
	 * @author anhtinh
	 */
	public class ResponseEndGamePvpReward extends ResponsePacket
	{
		public var result:Boolean;
		public var score:int;
		
		override public function decode(data:ByteArray):void
		{
			result = data.readBoolean();
			score = data.readInt();
		}
		
	}

}