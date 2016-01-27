package game.ui.chat
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import core.event.EventEx;
	import core.util.FontUtil;
	import core.util.MovieClipUtils;
	
	import game.data.vo.chat.ChatType;
	import game.enum.Font;
	
	/**
	 * ...
	 * @author ...
	 */
	public class ChatMesView extends MovieClip
	{
		static public const MINIMIZE:String = "minimize";
		static public const MAXIMIZE:String = "maximize";
		
		public var chatChanelChoseBtn:ChatChanelButton;
		public var chatChanelSpeakerBtn:ChatChanelButton;
		public var chatChanelGlobalBtn:ChatChanelButton;
		public var chatChanelRoomBtn:ChatChanelButton;
		public var chatChanelPrivateBtn:ChatChanelButton;
		public var guildChatBtn:ChatChanelButton;
		
		public var chatChanelChoseBgMov:MovieClip;
		public var chatNameMov:MovieClip;
		public var chatNameTf:TextField
		public var roomNameTf:TextField
		public var smileBtn:SimpleButton;
		public var smileConMov:MovieClip;
		public var btnUp:SimpleButton;
		public var btnDown:SimpleButton;
		public var bg:MovieClip;
		private var currentChatType:int;
		
		private var _smileys:Array = [jAcid_smiley, jCool_smiley, jEyelash_smiley, jGawp_smiley, jGrin_smiley, jHmm_smiley, jHuh_smiley, jKiss_smiley, jLaugh_smiley, jSad_smiley, jShocked_smiley, jUnhappy_smiley, jWhat_smiley, jWink_smiley, jXiaoYu_smiley];
		
		public function ChatMesView()
		{
			bg.mouseEnabled = false;
			this.mouseEnabled = false;
			btnUp.visible = false;
		}
		
		private function initButton(button:ChatChanelButton, name:String):void
		{
			button.setButtonName(name);
			button.gotoAndStop(1);
		}
		
		public function init():void
		{
			FontUtil.setFont(roomNameTf, Font.ARIAL, true);
			chatChanelChoseBtn.visible = false;
			chatChanelChoseBtn.addEventListener(MouseEvent.CLICK, onChatChanelChoseBtnClick);
			
			chatChanelSpeakerBtn.addEventListener(MouseEvent.CLICK, onChoseChatChanelHdl);
			chatChanelGlobalBtn.addEventListener(MouseEvent.CLICK, onChoseChatChanelHdl);
			chatChanelRoomBtn.addEventListener(MouseEvent.CLICK, onChoseChatChanelHdl);
			chatChanelPrivateBtn.addEventListener(MouseEvent.CLICK, onChoseChatChanelHdl);
			guildChatBtn.addEventListener(MouseEvent.CLICK, onChoseChatChanelHdl);
			
			
			smileBtn.addEventListener(MouseEvent.CLICK, onBtnClickHdl);
			btnUp.addEventListener(MouseEvent.CLICK, onBtnClickHdl);
			btnDown.addEventListener(MouseEvent.CLICK, onBtnClickHdl);
			
			initButton(chatChanelSpeakerBtn, "Loa");
			initButton(chatChanelGlobalBtn, "Server");
			initButton(chatChanelRoomBtn, "Phòng");
			initButton(chatChanelPrivateBtn, "Riêng");
			initButton(guildChatBtn, "Bang");

			
			initButton(chatChanelChoseBtn, "Server");
			chatChanelBtnVisible(false);
			currentChatType = ChatType.CHAT_TYPE_SERVER;
			FontUtil.setFont(chatNameTf, Font.ARIAL, true);
			chatNameVisible(false);
			
			smileConMov.visible = false;
			createSmileys();
			chatNameTf.text = "Nhập tên";
		}
		
		private function insertSmiley(evt:MouseEvent):void
		{
			var smiley:Sprite = evt.currentTarget as Sprite;
			dispatchEvent(new EventEx(ChatEvent.INSERT_SMILE, smiley, true));
		}
		
		private function createSmileys():void
		{
			for (var i:int = 0; i < _smileys.length; i++)
			{
				var smiley:Sprite = new _smileys[i]() as Sprite;
				smileConMov.addChild(smiley);
				smiley.x = (i % 5) * 30 + 2;
				smiley.y = Math.floor(i / 5) * 30 + 2;
				smiley.buttonMode = true;
				smiley.addEventListener(MouseEvent.CLICK, insertSmiley);
			}
		}
		
		private function onBtnClickHdl(e:MouseEvent):void
		{
			switch(e.target) {
				case smileBtn:
					smileConMov.visible = !smileConMov.visible;
					break;
				case btnUp:
					btnUp.visible = false;
					btnDown.visible = true;
					dispatchEvent(new Event(MAXIMIZE));
					break;
				case btnDown:
					btnDown.visible = false;
					btnUp.visible = true;
					dispatchEvent(new Event(MINIMIZE));
					break;
			}
		}
		
		private function chatNameVisible(value:Boolean):void
		{
			chatNameMov.visible = value;
			chatNameTf.visible = value;
		}
		
		public function switchChatType(chatType:int):void
		{
			currentChatType = chatType;
			if (currentChatType == ChatType.CHAT_TYPE_PRIVATE)
			{
				chatNameVisible(true);
			}
			else
			{
				chatNameVisible(false);
			}
			
			var buttonName:String;
			var color:int;
			switch (chatType)
			{
				case ChatType.CHAT_TYPE_ALL: 
					buttonName = "Tất cả";
					color = 0xFFFF55;
					break;
				case ChatType.CHAT_TYPE_SERVER: 
					buttonName = "Server";
					color = 0xFFFF55;
					break;
				case ChatType.CHAT_TYPE_ROOM: 
					buttonName = "Phòng";
					color = 0x3399FF;
					break;
				case ChatType.CHAT_TYPE_PRIVATE: 
					buttonName = "Riêng";
					color = 0xFF55FF;
					break;
				case ChatType.CHAT_TYPE_GUILD: 
					buttonName = "Bang";
					color = 0xFF9955;
					break;
				case ChatType.CHAT_TYPE_TEAM: 
					buttonName = "Đội";
					color = 0x00FFFF;
					break;
				case ChatType.CHAT_TYPE_SPEAKER:
					buttonName = "Loa";
					color = 0xffff55;
					break;
				default: 
					break;
			}
			chatChanelChoseBtn.setButtonName(buttonName, color);
			roomNameTf.text = buttonName;
			roomNameTf.textColor = color;
		}
		
		private function onChoseChatChanelHdl(e:MouseEvent):void
		{
			var button:ChatChanelButton = e.target as ChatChanelButton;
			switch (button)
			{
				case chatChanelSpeakerBtn: 
					currentChatType = ChatType.CHAT_TYPE_SPEAKER;
					break;
				case chatChanelGlobalBtn: 
					currentChatType = ChatType.CHAT_TYPE_SERVER;
					break;
				case chatChanelRoomBtn: 
					currentChatType = ChatType.CHAT_TYPE_ROOM;
					break;
				case chatChanelPrivateBtn: 
					currentChatType = ChatType.CHAT_TYPE_PRIVATE;
					break;
				case guildChatBtn: 
					currentChatType = ChatType.CHAT_TYPE_GUILD;
					break;
				default: 
					break;
			}
			chatChanelBtnVisible(false);
			switchChatType(currentChatType);
			dispatchEvent(new EventEx(ChatEvent.CHANGE_CHAT_TYPE, currentChatType, true));
		}
		
		public function getCurrenChatName():String
		{
			var nameArray:Array = chatNameTf.text.split("\r");
			var name:String = nameArray[0];
			return name;
		}
		
		public function setCurrentChatName(name:String):void
		{
			chatNameTf.text = name;
		}
		
		private function onChatChanelChoseBtnClick(e:MouseEvent):void
		{
			chatChanelBtnVisible(!chatChanelSpeakerBtn.visible);
		}
		
		private function chatChanelBtnVisible(value:Boolean):void
		{
			chatChanelSpeakerBtn.visible = value;
			chatChanelGlobalBtn.visible = value;
			chatChanelRoomBtn.visible = value;
			chatChanelPrivateBtn.visible = value;
			chatChanelChoseBgMov.visible = value;
			guildChatBtn.visible = value;
		}
	
	}

}