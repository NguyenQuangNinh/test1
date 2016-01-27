package game.ui.chat 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import core.event.EventEx;
	
	import game.data.vo.chat.ChatType;
	/**
	 * ...
	 * @author ...
	 */
	public class ChatBoxView extends MovieClip
	{
		public var scrollMov:MovieClip;
		public var chatChanelAllBtn		: ChatChanelButton;
		public var chatChanelGlobalBtn	: ChatChanelButton;
		public var chatChanelRoomBtn	: ChatChanelButton;
		public var chatChanelPrivateBtn	: ChatChanelButton;
		public var chatChanelSpeakerBtn	: ChatChanelButton;
		public var guildChatBtn			: ChatChanelButton;
		public var background:MovieClip;
		
		private var currentViewType:int;
		private var currentChatType:int;
		
		public function switchViewType(viewType:int) : void
		{
			currentViewType = viewType;	
			
			chatChanelAllBtn.setSelected(false);
			chatChanelGlobalBtn.setSelected(false);
			chatChanelRoomBtn.setSelected(false);
			chatChanelPrivateBtn.setSelected(false);
			chatChanelSpeakerBtn.setSelected(false);
			guildChatBtn.setSelected(false);
			
			switch(currentViewType)
			{
				case ChatType.CHAT_TYPE_SERVER:
					chatChanelGlobalBtn.setSelected(true);
					break;
				case ChatType.CHAT_TYPE_PRIVATE:
					chatChanelPrivateBtn.setSelected(true);
					break;
				case ChatType.CHAT_TYPE_ROOM:
					chatChanelRoomBtn.setSelected(true);
					break;
				case ChatType.CHAT_TYPE_ALL:
					chatChanelAllBtn.setSelected(true);
					break;
				case ChatType.CHAT_TYPE_SPEAKER:
					chatChanelSpeakerBtn.setSelected(true);
					break;
				case ChatType.CHAT_TYPE_GUILD:
					guildChatBtn.setSelected(true);
					break;
				default:
					break;
			}
		}
		
		
		public function ChatBox() : void
		{
		}
		
		private function initButton(button:ChatChanelButton, name:String):void
		{
			button.setButtonName(name);
			button.gotoAndStop(1);
		}
		
		public function init():void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			initButton(chatChanelAllBtn, "Tất cả");
			initButton(chatChanelGlobalBtn, "Server");
			initButton(chatChanelRoomBtn, "Phòng");
			initButton(chatChanelPrivateBtn, "Riêng");
			initButton(chatChanelSpeakerBtn, "Loa");
			initButton(guildChatBtn, "Bang");
			
			chatChanelAllBtn.addEventListener(MouseEvent.CLICK, chatChanelClickHdl);
			chatChanelGlobalBtn.addEventListener(MouseEvent.CLICK, chatChanelClickHdl);
			chatChanelRoomBtn.addEventListener(MouseEvent.CLICK, chatChanelClickHdl);
			chatChanelPrivateBtn.addEventListener(MouseEvent.CLICK, chatChanelClickHdl);
			chatChanelSpeakerBtn.addEventListener(MouseEvent.CLICK, chatChanelClickHdl);
			guildChatBtn.addEventListener(MouseEvent.CLICK, chatChanelClickHdl);
		}
		
		private function chatChanelClickHdl(e:Event):void 
		{
			switch(e.target)
			{
				case chatChanelAllBtn:
					update(ChatType.CHAT_TYPE_ALL, ChatType.CHAT_TYPE_ALL);
					break;
				case chatChanelGlobalBtn:
					update(ChatType.CHAT_TYPE_SERVER, ChatType.CHAT_TYPE_SERVER);
					break;	
				case chatChanelRoomBtn:
					update(ChatType.CHAT_TYPE_ROOM, ChatType.CHAT_TYPE_ROOM);
					break;
				case chatChanelPrivateBtn:
					update(ChatType.CHAT_TYPE_PRIVATE, ChatType.CHAT_TYPE_PRIVATE);
					break;
				case chatChanelSpeakerBtn:
					update(ChatType.CHAT_TYPE_SPEAKER, ChatType.CHAT_TYPE_SPEAKER);
					break;
				case guildChatBtn:
					update(ChatType.CHAT_TYPE_GUILD, ChatType.CHAT_TYPE_GUILD);
					break;
				default:
					break;
			}		
		}
		
		public function update(viewType:int, chatType:int):void {
			currentViewType = viewType;
			currentChatType = chatType;
			switchViewType(currentViewType);
			dispatchEvent(new EventEx(ChatEvent.CHANGE_CHAT_TYPE, currentChatType, true));			
			dispatchEvent(new EventEx(ChatEvent.CHANGE_VIEW_TYPE, currentViewType, true));	
		}
	}

}