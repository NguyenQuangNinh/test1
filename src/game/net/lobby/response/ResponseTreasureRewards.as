package game.net.lobby.response 
{
	import core.util.ByteArrayEx;
	import core.util.Enum;

	import flash.utils.ByteArray;

	import game.data.xml.event.EventType;

	import game.net.ResponsePacket;

	/**
	 * ...
	 * @author ninhnq
	 */
	public class ResponseTreasureRewards extends ResponsePacket
	{
		public var errorCode:int;
		public var rewardIndex:Array = [];

		override public function decode(data:ByteArray):void 
		{
			errorCode = data.readInt();

			if(errorCode == 0)
			{ // success
				var size:int = data.readInt();

				for (var i:int = 0; i < size; i++)
				{
					rewardIndex.push(data.readInt());
				}
			}
		}
	}

}