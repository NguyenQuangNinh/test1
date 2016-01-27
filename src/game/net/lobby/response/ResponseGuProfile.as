package game.net.lobby.response 
{
	import core.util.ByteArrayEx;
	import flash.utils.ByteArray;
	import game.net.ResponsePacket;
	/**
	 * ...
	 * @author vuanh
	 */
	public class ResponseGuProfile extends ResponsePacket
	{
		public var strName:String;

		override public function decode(data:ByteArray):void 
		{
			strName = ByteArrayEx(data).readString();
		}
		
	}

}