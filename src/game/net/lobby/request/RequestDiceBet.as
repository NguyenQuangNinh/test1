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
	public class RequestDiceBet extends RequestPacket
	{
		public var autoSave:Boolean;
		public var isGreater:Boolean;
		
		public function RequestDiceBet(type:int, autoSave:Boolean, isGreater:Boolean)
		{
			super(type);
			this.autoSave = autoSave;
			this.isGreater = isGreater;
		}
		
		override public function encode():ByteArray
		{
			var data:ByteArrayEx = new ByteArrayEx();
			data.writeBoolean(autoSave);
			data.writeBoolean(isGreater);
			return data;
		}
	}

}