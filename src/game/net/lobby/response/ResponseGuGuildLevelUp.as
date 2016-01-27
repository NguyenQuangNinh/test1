package game.net.lobby.response 
{
	import core.util.ByteArrayEx;
	import flash.utils.ByteArray;
	import game.net.ResponsePacket;
	/**
	 * ...
	 * @author vuanh
	 */
	public class ResponseGuGuildLevelUp extends ResponsePacket
	{
		public var strRoleName:String;
		public var level:int;

		override public function decode(data:ByteArray):void 
		{
			strRoleName = ByteArrayEx(data).readString();
			level = data.readInt();
		}
		
	}

}