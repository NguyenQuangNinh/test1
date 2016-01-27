package game.net.lobby.request 
{
	import core.util.ByteArrayEx;
	import flash.utils.ByteArray;
	import game.net.lobby.LobbyRequestType;
	import game.net.RequestPacket;
	import game.ui.chat.ChatModule;
	
	/**
	 * ...
	 * @author MaiPTT
	 */
	public class RequestUseSpeaker extends RequestPacket 
	{
		private var itemType		:int;
		private var speakerValue	:int;
		private var message			:String;
		
		public function RequestUseSpeaker(itemType:int, speakerValue:int, message:String) 
		{
			super(LobbyRequestType.USE_SPEAKER);
			this.itemType = itemType;
			this.speakerValue = speakerValue;
			this.message = message;
		}
		
		override public function encode():ByteArray {
			var byteArr:ByteArrayEx = new ByteArrayEx();
			byteArr.writeInt(speakerValue);
			byteArr.writeString(message, ChatModule.MAX_CHAT_LENGHT);
			return byteArr;
		}
		
	}

}