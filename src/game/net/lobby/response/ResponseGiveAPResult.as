package game.net.lobby.response 
{
	import flash.utils.ByteArray;
	import game.net.ResponsePacket;

	/**
	 * ...
	 * @author ninhnq
	 */
	public class ResponseGiveAPResult extends ResponsePacket
	{
		public var errorCode:int;
		public var giverID:int;

		override public function decode(data:ByteArray):void 
		{
			errorCode = data.readInt();
			if(errorCode == 0)
			{
				giverID = data.readInt();
			}
		}
	}

}