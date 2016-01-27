package game.net.lobby.request
{
	import core.util.ByteArrayEx;
	import core.util.Utility;
	
	import flash.utils.ByteArray;
	
	import game.net.RequestPacket;
	import game.ui.chat.ChatModule;
	
	/**
	 * ...
	 * @author chuongth2
	 */
	public class RequestLuckyGift extends RequestPacket
	{
		public var spinNum:int;
		
		public function RequestLuckyGift(type:int, spinNum:int)
		{
			super(type);
			this.spinNum = spinNum;
		}
		
		override public function encode():ByteArray
		{
			var data:ByteArrayEx = new ByteArrayEx();
			data.writeInt(spinNum);
			return data;
		}
	}

}