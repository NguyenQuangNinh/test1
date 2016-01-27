package game.net.lobby.request 
{
	import core.util.ByteArrayEx;
	import core.util.Utility;
	
	import flash.utils.ByteArray;
	
	import game.net.RequestPacket;
	import game.ui.chat.ChatModule;

	/**
	 * ...
	 * @author ...
	 */
	public class RequestChat extends RequestPacket
	{
		public var name:String;
		public var mes:String;
		
		public function RequestChat(type:int, name:String, mes:String) 
		{
			super(type);
			this.name = name;
			this.mes = mes;
		}		
		
		override public function encode():ByteArray 
		{
			var data:ByteArrayEx = new ByteArrayEx();
			data.writeString(name, ChatModule.MAX_PLAYER_NAME_LENGHT);
			data.writeString(mes, ChatModule.MAX_CHAT_LENGHT);
			return data;
		}
	}

}