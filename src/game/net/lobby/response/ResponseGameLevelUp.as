package game.net.lobby.response 
{
	import flash.utils.ByteArray;
	import game.net.ResponsePacket;
	/**
	 * ...
	 * @author anhtinh
	 */
	public class ResponseGameLevelUp extends ResponsePacket
	{
		
		public var currentLevel:int;
		public var lastLevel:int;
		
		override public function decode(data:ByteArray):void 
		{
			currentLevel = data.readInt();
			lastLevel = data.readInt();
		}
		
	}

}