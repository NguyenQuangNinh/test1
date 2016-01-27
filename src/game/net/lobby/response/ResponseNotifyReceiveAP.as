package game.net.lobby.response 
{
	import flash.utils.ByteArray;
	import game.net.ResponsePacket;

	/**
	 * ...
	 * @author ninhnq
	 */
	public class ResponseNotifyReceiveAP extends ResponsePacket
	{
		public var giverID:int;

		override public function decode(data:ByteArray):void 
		{
			giverID = data.readInt();
		}
	}

}