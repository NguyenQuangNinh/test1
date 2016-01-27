package game.ui.chat
{
	import core.display.DisplayManager;
	import core.display.layer.Layer;
	import core.display.layer.LayerManager;
	import core.display.ModuleBase;
	import core.event.EventEx;
	import core.Manager;
	import core.util.Enum;
	import core.util.Utility;

	import flash.events.Event;
	import flash.geom.Point;
	import flash.net.SharedObject;
	import flash.utils.getTimer;
	import flash.utils.Timer;
	import game.enum.ItemType;
	import game.net.lobby.request.RequestUseSpeaker;
	import game.ui.message.SpeakerType;
	import game.ui.ModuleID;
	
	import game.Game;
	import game.data.vo.chat.ChatInfo;
	import game.data.vo.chat.ChatType;
	import game.net.ResponsePacket;
	import game.net.Server;
	import game.net.StringRequestPacket;
	import game.net.lobby.LobbyRequestType;
	import game.net.lobby.LobbyResponseType;
	import game.net.lobby.request.RequestChat;
	import game.net.lobby.response.ResponseChatNotify;
	import game.net.lobby.response.ResponseChatResult;
	
	/**
	 * ...
	 * @author ...
	 */
	public class ChatModule extends ModuleBase
	{
		public static const MAX_CHAT_LENGHT:int = 512;
		public static const MAX_PLAYER_NAME_LENGHT:int = 32;
		public static const CHAT_COOL_DOWN:int = 5000;
		private var lastChat:int;
		
		public function ChatModule() {
			lastChat = getTimer();
		}
		
		override protected function createView():void
		{
			super.createView();
			baseView = new ChatView();
			ChatView(baseView).gotoAndStop(1);
			ChatView(baseView).addEventListener(ChatEvent.SEND_CHAT_GLOBAL, onSendChat);
			
			Game.network.lobby.addEventListener(Server.SERVER_DATA, onLobbyServerData);
			Manager.resource.load(["resource/txt/sensitive_words_chat.txt"], null);
		}
		
		public function onSendChat(e:EventEx):void
		{
			var data:ChatInfo = e.data as ChatInfo;
			if (data)
			{
				switch(data.chatCommand) {
					case "/loa":
						if (checkSpeakerItems()) {
							Game.network.lobby.sendPacket(new RequestUseSpeaker(ItemType.SPEAKER.ID,
																					SpeakerType.USER_NORMAL,
																					data.mes));	
						}
						break;
						
					case "/loavip":
						if (checkSpeakerItems()) {
							Game.network.lobby.sendPacket(new RequestUseSpeaker(ItemType.SPEAKER.ID,
																					SpeakerType.USER_VIP,
																					data.mes));	
						}
						break;
						
					default:
						switch (data.type) {
							case ChatType.CHAT_TYPE_ALL:
							case ChatType.CHAT_TYPE_SERVER: 
								sendChatGlobal(data.mes, true);
								break;
							case ChatType.CHAT_TYPE_PRIVATE: 
								Game.network.lobby.sendPacket(new RequestChat(LobbyRequestType.CHAT_PRIVATE, data.name, data.mes));
								break;
							case ChatType.CHAT_TYPE_ROOM: 
								Game.network.lobby.sendPacket(new StringRequestPacket(LobbyRequestType.CHAT_ROOM, data.mes, MAX_CHAT_LENGHT));
								break;
							case ChatType.CHAT_TYPE_TEAM: 
								Game.network.lobby.sendPacket(new StringRequestPacket(LobbyRequestType.CHAT_TEAM, data.mes, MAX_CHAT_LENGHT));
								break;
							case ChatType.CHAT_TYPE_GUILD: 
								Game.network.lobby.sendPacket(new StringRequestPacket(LobbyRequestType.GU_CHAT_SEND_MESSAGE, data.mes, MAX_CHAT_LENGHT));
								break;
							default: 
								break;
						}
						break;
				}
			}
		}
		
		private function checkSpeakerItems():Boolean 
		{
			if (Game.database.inventory.getItemsByType(ItemType.SPEAKER).length) {
				return true;
			}
			Manager.display.showMessage("Đại Hiệp không có loa trong Hành Trang");
			return false;
		}

		private var currSentMessage:String = "";
		private var spamCount:int = 0;
		private var spam:Boolean = false;

		private function isSpam(mess:String):Boolean
		{
			return false;

			if(spam)
			{
				return true;
			}

			var likely:Number = Utility.compareStrings(mess, currSentMessage);

//			trace(likely);

			if(likely > 0.8)
			{
				spamCount++;
			}
			else
			{
				spamCount = 0;
			}

			currSentMessage = mess;

			spam = spamCount > 5;

			return spam;
		}

		public function sendChatGlobal(mes:String, checkSpam:Boolean = false):void
		{
			if (getTimer() - lastChat >= CHAT_COOL_DOWN) {
				if(checkSpam && isSpam(mes))
				{
					ChatView(baseView).updateChatBox(ChatType.CHAT_TYPE_SERVER, Game.database.userdata.userID, Game.database.userdata.playerName, mes);
				}
				else
				{
					Game.network.lobby.sendPacket(new StringRequestPacket(LobbyRequestType.CHAT_GLOBAL, mes, MAX_CHAT_LENGHT));
				}
				lastChat = getTimer();
			} else {
				var packetResponse:ResponseChatResult = new ResponseChatResult();
				packetResponse.chatType = ChatType.CHAT_ERROR;
				packetResponse.errorCode = 0;
				packetResponse.name = "";
				packetResponse.playerID = -1;
				packetResponse.mes = "Đợi " + Math.abs(Math.ceil((CHAT_COOL_DOWN -(getTimer() - lastChat)) / 1000)) + "s để chat tiếp nhé";
				onChatResult(packetResponse);
			}
		}
		
		override protected function transitionIn():void 
		{
			super.transitionIn();
			onChangeScreenHdl(null);
			if (baseView) {
				(ChatView)(baseView).isMinimize = true;
			}
			Manager.display.addEventListener(DisplayManager.CHANGE_SCREEN, onChangeScreenHdl);
		}
		
		override protected function transitionOut():void {
			super.transitionOut();
			Manager.display.removeEventListener(DisplayManager.CHANGE_SCREEN, onChangeScreenHdl);
		}
		
		private function onChangeScreenHdl(e:Event):void {
			var chatModes:Array = Enum.getAll(ChatMode);
			for each (var chatMode:ChatMode in Enum.getAll(ChatMode)) {
				if (chatMode && (chatMode.getModuleIDs().indexOf(Manager.display.getCurrentModule()) > -1)) {
					if (baseView) {
						baseView.x = chatMode.point.x;
						baseView.y = chatMode.point.y;
					} 
					break;
				}
			}
			
			if (ChatView(baseView)) {
				ChatView(baseView).setChatMode(chatMode);
			}
		}
		
		private function onLobbyServerData(e:EventEx):void
		{
			var packet:ResponsePacket = ResponsePacket(e.data);
			
			switch (packet.type)
			{
				case LobbyResponseType.CHAT_NOTIFY: 
					onChatNotify(packet as ResponseChatNotify);
					break;
				case LobbyResponseType.CHAT_RESPONSE: 
					onChatResult(packet as ResponseChatResult);
					break;
			}
		}
		
		private function onChatResult(responseChatResult:ResponseChatResult):void
		{
			ChatView(baseView).updateChatBoxResult(responseChatResult.chatType, responseChatResult.playerID, responseChatResult.errorCode, responseChatResult.name, responseChatResult.mes);
		}
		
		private function onChatNotify(chatNotify:ResponseChatNotify):void
		{
			ChatView(baseView).updateChatBox(chatNotify.chatType, chatNotify.playerId, chatNotify.name, chatNotify.mes);
		}
		
		public function showChatPrivate(targetName:String):void
		{
			if (baseView)
			{
				ChatView(baseView).showChatPrivate(targetName);
				ChatView(baseView).chatVisible(true);
			}
		}
		
		public function enableSpeaker(speakerType:int):void {
			if (baseView) {
				if (!baseView.visible) {
					for each (var chatMode:ChatMode in Enum.getAll(ChatMode)) {
						if (chatMode && (chatMode.getModuleIDs().indexOf(Manager.display.getCurrentModule()) > -1)) {
							Manager.display.showModule(ModuleID.CHAT, new Point(chatMode.point.x, chatMode.point.y), LayerManager.LAYER_SCREEN_TOP, "top_left", Layer.NONE);
							break;
						}
					}
					
					ChatView(baseView).setChatMode(chatMode);
				}
				
				ChatView(baseView).isMinimize = true;
				ChatView(baseView).onSpeakerEnable(speakerType);
			}
		}
		
		public function showSystemAnnouncement(annoucementType:int, userName:String, message:String, userID:int):void {
			if (baseView) {
				switch(annoucementType) {
					case 0: //system
						ChatView(baseView).updateChatBox(ChatType.CHAT_ERROR, userID, userName, message);
						break;
						
					case 1: //loa thuong
						ChatView(baseView).updateChatBox(ChatType.SPEAKER_NORMAL, userID, userName, message);
						break;
						
					case 2: //loa vip
						ChatView(baseView).updateChatBox(ChatType.SPEAKER_VIP, userID, userName, message);
						break;
				}
			}
		}
	}
}