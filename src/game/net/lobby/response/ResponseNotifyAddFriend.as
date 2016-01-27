package game.net.lobby.response 
{

	import core.util.ByteArrayEx;

	import flash.utils.ByteArray;
	import game.net.ResponsePacket;

	/**
	 * ...
	 * @author ninhnq
	 */
	public class ResponseNotifyAddFriend extends ResponsePacket
	{
		public var name:String;
		public var playerID:int;

		override public function decode(data:ByteArray):void 
		{
			playerID = data.readInt();
			name = ByteArrayEx( data).readString();
		}
	}

}