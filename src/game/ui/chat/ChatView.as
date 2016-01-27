package game.ui.chat
{
	import com.riaidea.text.RichTextField;
	import com.riaidea.text.plugins.ShortcutPlugin;
	import components.scroll.VerScroll;
	import components.scroll.VerScrollText;
	import core.display.layer.Layer;
	import core.display.layer.LayerManager;
	import flash.geom.Point;
	import flash.utils.setTimeout;
	import game.data.vo.lobby.LobbyPlayerInfo;
	import game.enum.GameConfigID;
	import game.ui.dialog.DialogID;
	import game.ui.dialog.dialogs.YesNo;
	import game.ui.ingame.replay.GameReplayManager;

import core.util.Enum;

import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import core.Manager;
	import core.display.ViewBase;
	import core.event.EventEx;
	
	import fl.controls.UIScrollBar;
	
	import game.Game;
	import game.data.vo.chat.ChatInfo;
	import game.data.vo.chat.ChatType;
	import game.data.vo.lobby.LobbyInfo;
	import game.enum.FlowActionEnum;
	import game.enum.GameMode;
	import game.net.lobby.request.RequestJoinRoomPvP;
	import game.ui.ModuleID;
	import game.ui.message.SpeakerType;
	
	/**
	 * ...
	 * @author ...
	 */
	public class ChatView extends ViewBase
	{
		private static const LEVEL_REQUIREMENT	:int = 10;
		
		public var sendBtn:SimpleButton;
		public var chatChanelTf:TextField;
		public var chatBoxMov:ChatBoxView;
		public var mesBoxMov:ChatMesView;
		
		private var chatBoxContainer:MovieClip;
		
		private var chatAllBoxTf:RichTextField;
		private var chatGlobalBoxTf:RichTextField;
		private var chatPrivateBoxTf:RichTextField;
		private var chatRoomBoxTf:RichTextField;
		private var chatTeamBoxTf:RichTextField;
		private var chatSpeakerBoxTf:RichTextField;
		private var chatGuildBoxTf:RichTextField;
		
		private var chatMesTf:RichTextField;
		
		private var chatComboBox:ChatComboBox;
		
		public var currentChatType:int;
		
		private var txtFormat:TextFormat;
		
		private var _smileys:Array = [jAcid_smiley, jCool_smiley, jEyelash_smiley, jGawp_smiley, jGrin_smiley, jHmm_smiley, jHuh_smiley, jKiss_smiley, jLaugh_smiley, jSad_smiley, jShocked_smiley, jUnhappy_smiley, jWhat_smiley, jWink_smiley, jXiaoYu_smiley];
		
		private var _isMinimize:Boolean = true;
		
		private var scroller:VerScrollText;
		
		public function ChatView()
		{
			if (stage)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			this.addEventListener(ChatEvent.SEND_CHAT, sendBtnClickHdl);
			this.addEventListener(ChatEvent.CHANGE_CHAT_TYPE, changeChatTypeHdl);
			this.addEventListener(ChatEvent.CHANGE_VIEW_TYPE, changeViewTypeHdl);
			this.addEventListener(ChatEvent.INSERT_SMILE, insertSmiley);
			this.addEventListener(ChatEvent.CHANGE_CHAT_NAME, changeChatNameHdl);
			stage.addEventListener(ChatEvent.MINIMIZE, onMinimizeChatHdl);
			stage.addEventListener(ChatEvent.RESTORE_DOWN, onRestoreDownHdl);
			stage.addEventListener(ChatEvent.SHOW_LEFT_BOTTOM, onShowLeftBottomHdl);
			stage.addEventListener(ChatEvent.SHOW_LEFT_CONNER, onShowLeftConnerHdl);
			mesBoxMov.addEventListener(ChatMesView.MINIMIZE, onChatMinimize);
			mesBoxMov.addEventListener(ChatMesView.MAXIMIZE, onChatMaximize);
			
			//minimizeBtn.addEventListener(MouseEvent.CLICK, onMinimizeBtnClick);
			//minimizeBtn.tabEnabled = false;
			
			txtFormat = new TextFormat("Arial", 12, 0xFFFFFF, false, false, false);
			
			chatBoxMov.init();
			mesBoxMov.init();
			
			chatMesTf = new RichTextField();
			
			chatBoxContainer = new MovieClip();
			chatBoxContainer.x = 0;
			chatBoxContainer.y = 0;
			addChildAt(chatBoxContainer, 1);
			
			chatAllBoxTf = new RichTextField();
			initChatBox(chatAllBoxTf);
			chatAllBoxTf.visible = true;
			chatGlobalBoxTf = new RichTextField();
			initChatBox(chatGlobalBoxTf);
			chatPrivateBoxTf = new RichTextField();
			initChatBox(chatPrivateBoxTf);
			chatRoomBoxTf = new RichTextField();
			initChatBox(chatRoomBoxTf);
			chatTeamBoxTf = new RichTextField();
			initChatBox(chatTeamBoxTf);
			chatSpeakerBoxTf = new RichTextField();
			initChatBox(chatSpeakerBoxTf);
			chatGuildBoxTf = new RichTextField();
			initChatBox(chatGuildBoxTf);
			
			scroller = new VerScrollText(chatAllBoxTf.textfield, chatBoxMov.scrollMov, true);
			
			chatMesTf.x = 107;
			chatMesTf.y = 150;
			
			/*var rect:Rectangle = chatMesTf.getBounds(this);
			   var rectangle:Shape = new Shape(); // initializing the variable named rectangle
			   rectangle.graphics.beginFill(0xFF0000); // choosing the colour for the fill, here it is red
			   rectangle.graphics.drawRect(rect.x, rect.y, rect.width, rect.height); // (x spacing, y spacing, width, height)
			   rectangle.graphics.endFill(); // not always needed but I like to put it in to end the fill
			   rectangle.alpha = 0.5;
			 addChild(rectangle); // adds the rectangle to the stage*/
			
			chatMesTf.setSize(200, 20);
			chatMesTf.type = RichTextField.INPUT;
			chatMesTf.defaultTextFormat = txtFormat;
			chatMesTf.html = false;
			chatMesTf.name = "chatMes";
			chatMesTf.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			addChild(chatMesTf);
			
			chatComboBox = new ChatComboBox();
			chatComboBox.visible = false;
			addChild(chatComboBox);
			
			currentChatType = ChatType.CHAT_TYPE_SERVER;
			
			var splugin:ShortcutPlugin = new ShortcutPlugin();
			var shortcuts:Array = [{shortcut: "/a", src: _smileys[0]}, {shortcut: "/b", src: _smileys[1]}, {shortcut: "/c", src: _smileys[2]}, {shortcut: "/d", src: _smileys[3]}, {shortcut: "/e", src: _smileys[4]}, {shortcut: "/lov", src: _smileys[5]}, {shortcut: "/g", src: _smileys[6]}, {shortcut: "/h", src: _smileys[7]}, {shortcut: "/i", src: _smileys[8]}];
			splugin.addShortcut(shortcuts);
			chatMesTf.addPlugin(splugin);
		
			//FontUtil.setFont(statusTf, Font.ARIAL);
			//statusTf.mouseEnabled = false;
		}
		
		protected function onChatMaximize(event:Event):void
		{
			chatBoxMov.visible = true;
			chatBoxContainer.visible = true;
			//chatBoxMov.scrollMov.visible = true;
		}
		
		private function onChatMinimize(e:Event):void {
			//isMinimize = !_isMinimize;
			chatBoxMov.visible = false;
			chatBoxContainer.visible = false;
			//chatBoxMov.scrollMov.visible = false;
		}
		
		private function onShowLeftBottomHdl(e:Event):void
		{
			this.x = 0;
			this.y = 60;
		}
		
		private function onShowLeftConnerHdl(e:Event):void
		{
			this.x = 0;
			this.y = 0;
		}
		
		private function onRestoreDownHdl(e:EventEx):void
		{
			//chatVisible(true);
		}
		
		private function onMinimizeChatHdl(e:EventEx):void
		{
			chatVisible(false);
		}
		
		private function changeChatNameHdl(e:EventEx):void
		{
			mesBoxMov.setCurrentChatName(e.data as String);
			if(stage) stage.focus = chatMesTf.getTextRenderer();
		}
		
		private function onMinimizeBtnClick(e:MouseEvent):void
		{
			//statusTf.text = chatBoxMov.visible ? "Ẩn" : "Hiện";
			chatVisible(!chatBoxMov.visible);
		}
		
		public function chatVisible(value:Boolean):void
		{
			chatBoxContainer.visible = value;
			chatBoxMov.visible = value;
			mesBoxMov.visible = value;
			chatMesTf.visible = value;
		}
		
		private function insertSmiley(e:EventEx):void
		{
			var smiley:Sprite = e.data as Sprite;
			var smileyClass:Class = getDefinitionByName(getQualifiedClassName(smiley)) as Class;
			chatMesTf.insertSprite(smileyClass, chatMesTf.textfield.caretIndex);
			
			//correct caretIndex of input
			if (chatMesTf.isSpriteAt(chatMesTf.caretIndex))
			{
				chatMesTf.caretIndex++;
			}
		}
		
		private function changeViewTypeHdl(e:EventEx):void
		{
			var viewType:int = e.data as int;
			switchViewType(viewType);
		}
		
		public function switchViewType(viewType:int):void
		{
			chatAllBoxTf.visible = false;
			chatGlobalBoxTf.visible = false;
			chatPrivateBoxTf.visible = false;
			chatGuildBoxTf.visible = false;
			chatRoomBoxTf.visible = false;
			chatTeamBoxTf.visible = false;
			chatSpeakerBoxTf.visible = false;
			
			switch (viewType)
			{
				case ChatType.CHAT_TYPE_ALL: 
					chatAllBoxTf.visible = true;
					scroller.setContent(chatAllBoxTf.textfield);
					break;
				case ChatType.CHAT_TYPE_SERVER: 
					chatGlobalBoxTf.visible = true;
					scroller.setContent(chatGlobalBoxTf.textfield);
					break;
				case ChatType.CHAT_TYPE_PRIVATE: 
					chatPrivateBoxTf.visible = true;
					scroller.setContent(chatPrivateBoxTf.textfield);
					break;
				case ChatType.CHAT_TYPE_ROOM: 
					chatRoomBoxTf.visible = true;
					scroller.setContent(chatRoomBoxTf.textfield);
					break;
				case ChatType.CHAT_TYPE_TEAM: 
					chatTeamBoxTf.visible = true;
					scroller.setContent(chatTeamBoxTf.textfield);
					break;
				case ChatType.CHAT_TYPE_SPEAKER:
					chatSpeakerBoxTf.visible = true;
					scroller.setContent(chatSpeakerBoxTf.textfield);
					break;
				case ChatType.CHAT_TYPE_GUILD:
					chatGuildBoxTf.visible = true;
					scroller.setContent(chatGuildBoxTf.textfield);
					break;
				default: 
					chatAllBoxTf.visible = true;
					break;
			}
			scroller.updateScroll();
		}
		
		private function initChatBox(chatBox:RichTextField):void
		{
			chatBox.x = 30;
			chatBox.y = 0;
			chatBox.setSize(300, 130);
			chatBox.type = RichTextField.DYNAMIC;
			chatBox.defaultTextFormat = txtFormat;
			chatBox.autoScroll = true;
			chatBox.html = true;
			chatBox.setSelectEnable(false);
			chatBox.setMaxLine(100);
			chatBox.visible = false;
			chatBox.addEventListener(TextEvent.LINK, onChatBoxLinkClick);
			//chatBox.addEventListener(MouseEvent.CLICK, onChatBoxMouseClick);
			chatBoxContainer.addChild(chatBox);
		}
		
		private function onChatBoxMouseClick(e:MouseEvent):void
		{
			//if (chatComboBox.visible)
			//{
			//chatComboBox.x = e.localX;
			//chatComboBox.y = e.localY;
			//
			//}
		}
		
		private function onChatBoxLinkClick(e:TextEvent):void
		{
			var playerInfo:Array = e.text.split(',');
			if (stage)
			{

                switch (playerInfo[0].toString()) {
                    case "inviteHeroic":
                        Game.flow.doAction(FlowActionEnum.JOIN_LOBBY_BY_ID, { mode: GameMode.PVE_HEROIC, id: parseInt(playerInfo[1]), campaignID: parseInt(playerInfo[2])} );
                        break;
	                case "invitePVP":
                        Game.flow.doAction(FlowActionEnum.JOIN_LOBBY_BY_ID, { mode: Enum.getEnum(GameMode, parseInt(playerInfo[2])), id: parseInt(playerInfo[1]), pass: Boolean(playerInfo[3])} );
                        break;
					case "[challenge-replay]":
						processChallengeReplayInfo(e.text as String);
						break;
					case "[train-announce-msg]":
						processTrainAnnounce(e.text as String);
						break;
                    default :
                        chatComboBox.targetName = playerInfo[1];
                        chatComboBox.targetId = parseInt(playerInfo[0]);
                        chatComboBox.x = this.stage.mouseX - this.x - 10;
                        chatComboBox.y = this.stage.mouseY - this.y - 5;
                        chatComboBox.visible = true
                }
				
				if (this.y + chatComboBox.y > Game.HEIGHT - chatComboBox.height - 10) chatComboBox.y = Game.HEIGHT - chatComboBox.height - 10 - this.y;
			}
		}
		
		private function processTrainAnnounce(mMes:String):void 
		{
			var pros:Array = mMes.split(",");
			pros.shift();
			// props [0]: host name
			// props [1]: host lvl
			// props [2]: roomId
			// check level require
			var hostLvl:int = parseInt(pros[1]);
			var partnerLvl:int = Game.database.userdata.level;
			var msg:String;
			if (hostLvl < partnerLvl)
			{
				msg = "Không thể vào phòng, Level của người chỉ điểm phải lớn hơn level của người được chỉ điểm!";
				Manager.display.showDialog(DialogID.YES_NO, null, null, {title: "THÔNG BÁO", message: msg, option: YesNo.YES});
				return;
			}
			if (hostLvl - partnerLvl <= Game.database.gamedata.getConfigData(GameConfigID.KUNGFU_TRAIN_LEVEL_DIFF_MIN) || hostLvl - partnerLvl >= Game.database.gamedata.getConfigData(GameConfigID.KUNGFU_TRAIN_LEVEL_DIFF_MAX))
			{
				msg = "Không thể vào phòng, Level của 2 người tham gia phải chênh lệch ít nhất " + Game.database.gamedata.getConfigData(GameConfigID.KUNGFU_TRAIN_LEVEL_DIFF_MIN) + " level và nhiều nhất là " + Game.database.gamedata.getConfigData(GameConfigID.KUNGFU_TRAIN_LEVEL_DIFF_MAX) + " level";
				Manager.display.showDialog(DialogID.YES_NO, null, null, {title: "THÔNG BÁO", message: msg, option: YesNo.YES});
				return;
			}
			Manager.display.showModule(ModuleID.KUNGFU_TRAIN, new Point(0, 0), LayerManager.LAYER_POPUP, "top_left", Layer.BLOCK_BLACK, {roomId: parseInt(pros[2])});
		}
		
		
		private function processChallengeReplayInfo(mMes:String):void
		{
			delayClick();
			var pros:Array = mMes.split(",");
			// remove the first element [challenge-replay]
			pros.shift();
			var teanId:int = parseInt(pros[0]);
			var nTime:int = parseInt(pros[1]);
			
			var activePlayer:LobbyPlayerInfo = new LobbyPlayerInfo();
			activePlayer.id = parseInt(pros[2]);
			activePlayer.owner = parseInt(pros[3]) == 1 ? true : false;
			activePlayer.level = parseInt(pros[4]);
			activePlayer.name = pros[5];
			
			var challengedPlayer:LobbyPlayerInfo = new LobbyPlayerInfo();
			challengedPlayer.id = parseInt(pros[6]);
			challengedPlayer.owner = parseInt(pros[7]) == 1 ? true : false;
			challengedPlayer.level = parseInt(pros[8]);
			challengedPlayer.name = pros[9];
			
			var players:Array = [activePlayer, challengedPlayer];
			GameReplayManager.getInstance().beginReplaying(GameMode.PVP_1vs1_AI, nTime, players, null, teanId);
		}
		
		private function changeChatTypeHdl(e:EventEx):void
		{
			var chatType:int = e.data as int;
			if (currentChatType == ChatType.CHAT_TYPE_PRIVATE && chatType != ChatType.CHAT_TYPE_PRIVATE)
			{
				chatBoxMov.y += 20;
				chatBoxContainer.y += 20;
			}
			
			if (currentChatType != ChatType.CHAT_TYPE_PRIVATE && chatType == ChatType.CHAT_TYPE_PRIVATE)
			{
				chatBoxMov.y -= 20;
				chatBoxContainer.y -= 20;
			}
			currentChatType = chatType;
			if (e.target != mesBoxMov)
			{
				mesBoxMov.switchChatType(chatType);
			}
		}
		
		public function updateChatBoxResult(chatType:int, playerID:int, errorCode:int, chatName:String, chatMes:String):void
		{
			switch(errorCode) {
				case 0:
					var xmlMes:XML = parseChatStringtoXML(chatType, playerID, chatName, chatMes, true);
					switch (chatType)
					{
						case ChatType.CHAT_TYPE_PRIVATE: 
							chatPrivateBoxTf.importXML(xmlMes);
							break;
						default: 
							break;
					}
					chatAllBoxTf.importXML(xmlMes);
					scroller.updateScroll();
					break;
					
				case 2:
					switch (chatType)
					{
						case ChatType.CHAT_TYPE_PRIVATE: 
							chatPrivateBoxTf.append('<font color="#FFCC66">' + chatName + ' offline hoặc không tồn tại.</font>');
							break;
						default: 
							break;
					}
					chatAllBoxTf.append('<font color="#FFCC66">' + chatName + ' offline hoặc không tồn tại.</font>');
					scroller.updateScroll();
					break;
			}
		}
		
		public function updateChatBox(chatType:int, playerID:int, chatName:String, chatMes:String):void
		{		
			var isAutoScroll:Boolean = scroller.isEndScroll();
			chatGlobalBoxTf.autoScroll = isAutoScroll;
			chatPrivateBoxTf.autoScroll = isAutoScroll;
			chatGlobalBoxTf.autoScroll = isAutoScroll;
			chatRoomBoxTf.autoScroll = isAutoScroll;
			chatTeamBoxTf.autoScroll = isAutoScroll;
			chatGuildBoxTf.autoScroll = isAutoScroll;
			chatSpeakerBoxTf.autoScroll = isAutoScroll;
			chatAllBoxTf.autoScroll = isAutoScroll;
			var xmlMes:XML = parseChatStringtoXML(chatType, playerID, chatName, chatMes);
			switch (chatType)
			{
				case ChatType.CHAT_TYPE_SERVER: 
					chatGlobalBoxTf.importXML(xmlMes);
					break;
				case ChatType.CHAT_TYPE_PRIVATE: 
					chatPrivateBoxTf.importXML(xmlMes);
					break;
				case ChatType.CHAT_TYPE_ROOM: 
					chatRoomBoxTf.importXML(xmlMes);
					break;
				case ChatType.CHAT_TYPE_TEAM: 
					chatTeamBoxTf.importXML(xmlMes);
					break;
				case ChatType.CHAT_TYPE_GUILD: 
					chatGuildBoxTf.importXML(xmlMes);
					break;
				case ChatType.CHAT_ERROR:
				case ChatType.SPEAKER_NORMAL:
				case ChatType.SPEAKER_VIP:
					chatSpeakerBoxTf.importXML(xmlMes);
					break;
				default: 
					break;
			}
			//Utility.log(xmlMes.toString());
			chatAllBoxTf.importXML(xmlMes);
			scroller.updateScroll();
		}
		
		public function onSpeakerEnable(type:int):void {
			var chatCommand:String;
			switch(type) {
				case SpeakerType.USER_NORMAL:
					chatCommand = "/loa ";
					break;
					
				case SpeakerType.USER_VIP:
					chatCommand = "/loavip ";
					break;
			}
			
			//if (stage) stage.focus = chatMesTf.getTextRenderer();
			chatMesTf.getTextRenderer().text = chatCommand;
			chatMesTf.getTextRenderer().setSelection(chatCommand.length, chatCommand.length);
		}
		
		private function onKeyDown(e:KeyboardEvent):void
		{
			if (e.keyCode == Keyboard.ENTER)
			{
				//Kiem tra neu nhu nhan nut enter ma ko co noi dung chat thi khong cho send message
				if (chatMesTf.contentLength > 0 && chatMesTf.content != "\r")
				{
					sendMessage();
				}
				chatMesTf.clear();
			}
		}
		
		private function sendMessage():void
		{
			//Utility.log(chatMesTf.exportXML().toString());
			//chatBoxTf.importXML(chatMesTf.exportXML());
			
			/*if (Game.database.userdata.level < LEVEL_REQUIREMENT) {
				updateChatBoxResult(ChatType.CHAT_ERROR, -1, 0, "", "Đại Hiệp cần đạt cấp " + LEVEL_REQUIREMENT + " để tham gia Tán Ngẫu");
				return;
			}*/
			
			var chatInfo:ChatInfo = new ChatInfo();
			chatInfo.type = currentChatType;
			chatInfo.name = "";
			
			var chatMess:String = parseChatXMLtoString(chatMesTf.exportXML());
			if (chatMess.charAt(0) == "/") {
				var chatCommand:String = chatMess.slice(0, chatMess.indexOf(" "));
				chatInfo.chatCommand = chatCommand;
				chatInfo.mes = chatMess.substring(chatMess.indexOf(" ") + 1, chatMess.length);
			} else {
				chatInfo.mes = chatMess;	
			}
			
			switch (currentChatType)
			{
				case ChatType.CHAT_TYPE_PRIVATE: 
					chatInfo.name = mesBoxMov.getCurrenChatName();
					break;
				default: 
					break;
			}
			
			dispatchEvent(new EventEx(ChatEvent.SEND_CHAT_GLOBAL, chatInfo));
		}
		
		private function filterCharSensitive(text:String):String 
		{
			var arrFilter:Array = Manager.resource.getResourceByURL("resource/txt/sensitive_words_chat.txt");
			
			var i:int =0;
			var pattern1:RegExp = new RegExp("<[^<]+?>", "gi");
			var finalStr:String = text.replace(pattern1, "*");                      

			for(i = 0 ; i<arrFilter.length ; i++)
			{
				pattern1 = new RegExp(arrFilter[i], "gi");
				finalStr =  finalStr.replace(pattern1, "*");
			}
			return finalStr;

		}
		
		private function sendBtnClickHdl(e:Event):void
		{
			//Kiem tra neu nhu nhan nut enter ma ko co noi dung chat thi khong cho send message
			if (chatMesTf.contentLength > 0 && chatMesTf.content != "\r")
			{
				sendMessage();
			}
			chatMesTf.clear();
		}
		
		private function getUIScrollBar():UIScrollBar
		{
			var scrollBar:UIScrollBar = new UIScrollBar();
			scrollBar.setStyle("trackUpSkin", ScrollBars_trackSkin);
			scrollBar.setStyle("trackOverSkin", ScrollBars_trackSkin);
			scrollBar.setStyle("trackDownSkin", ScrollBars_trackSkin);
			scrollBar.setStyle("trackDisabledSkin", ScrollBars_trackSkin);
			scrollBar.setStyle("thumbUpSkin", ScrollBars_thumbUpSkin);
			scrollBar.setStyle("thumbOverSkin", ScrollBars_thumbOverSkin);
			scrollBar.setStyle("thumbDownSkin", ScrollBars_thumbDownSkin);
			scrollBar.setStyle("thumbIcon", ScrollBars_thumbIcon);
			scrollBar.setStyle("downArrowUpSkin", ScrollBars_downArrowUpSkin);
			scrollBar.setStyle("downArrowOverSkin", ScrollBars_downArrowOverSkin);
			scrollBar.setStyle("downArrowDownSkin", ScrollBars_downArrowDownSkin);
			scrollBar.setStyle("downArrowDisabledSkin", ScrollBars_downArrowDisabledSkin);
			scrollBar.setStyle("upArrowUpSkin", ScrollBars_upArrowUpSkin);
			scrollBar.setStyle("upArrowOverSkin", ScrollBars_upArrowOverSkin);
			scrollBar.setStyle("upArrowDownSkin", ScrollBars_upArrowDownSkin);
			scrollBar.setStyle("upArrowDisabledSkin", ScrollBars_upArrowDisabledSkin);
			return scrollBar;
		}
		
		private function parseChatStringtoXML(chatType:int, playerID:int, chatName:String, chat:String, send:Boolean = false):XML
		{
			var chatMes:Array = chat.split("\n");
			var xml:XML =           <rtf/>;
			
			var mesTmp:String = "";
			var charBonusCount:int = 0;
			
			var text:String = "";
			
			var chanelName:String;
			var color:String;
			switch (chatType)
			{
				case ChatType.CHAT_TYPE_SERVER: 
					mesTmp = "[T.Giới] ";
					color = "FFFFFF";
					break;
				case ChatType.CHAT_TYPE_PRIVATE: 
					mesTmp = "[Mật] ";
					color = "f791f8";
					chanelName = '<font color="#f791f8">' + "[Mật] ";
					break;
				case ChatType.CHAT_TYPE_GUILD: 
					mesTmp = "[Bang] ";
					color = "41BC4A";
					break;
				case ChatType.CHAT_TYPE_TEAM: 
					mesTmp = "[Đội] ";
					color = "F37C00";
					break;
				case ChatType.CHAT_TYPE_ROOM: 
					mesTmp = "[Phòng] ";
					color = "FFCC66";
					break;
				case ChatType.CHAT_TYPE_SPECIAL: 
					mesTmp = "[Loa] ";
					color = "FFFF00";
					break;
					
				case ChatType.CHAT_ERROR:
					mesTmp = "[Hệ Thống] ";
					color = "FF0000";
					break;
					
				case ChatType.SPEAKER_NORMAL:
					mesTmp = "[Loa Thường] ";
					color = "CC9933";
					break;
				case ChatType.SPEAKER_VIP:
					mesTmp = "[Loa VIP] ";
					color = "FFFF00";
					break;
				default: 
					break;
			}
			chanelName = '<font color="#' + color + '">' + mesTmp;
			charBonusCount += mesTmp.length;
			text += chanelName;
			
			var playerName:String;
			switch (chatType)
			{
				case ChatType.CHAT_TYPE_PRIVATE: 
					if (send)
					{
						playerName = '<font color="#FFFFFF">Ngươi đến </font>[<a href="event:' + playerID + ',' + chatName + '"><font color="#00FF00"><u>' + chatName + '</u></font></a>]';
					}
					else
					{
						playerName = '[<a href="event:' + playerID + ',' + chatName + '"><font color="#00FF00"><u>' + chatName + '</u></font></a>] đến <font color="#FFFFFF">Ngươi</font>';
					}
					mesTmp = "Ngươi n.v ";
					charBonusCount += mesTmp.length;
					charBonusCount += chatName.length + 2;
					break;
				case ChatType.CHAT_ERROR:
					playerName = "";
					if (chatName && chatName.length && (playerID != -1)) {
						if (chatMes[0] && chatMes[0] is String) {
							chatMes[0] = String(chatMes[0]).replace(chatName, '[<a href="event:' + playerID + ',' + chatName + '"><font color="#00FF00"><u>' + chatName + '</u></font></a>]');
						}
					}
					break;
				default: 
					playerName = '[<a href="event:' + playerID + ',' + chatName + '"><font color="#00FF00"><u>' + chatName + '</u></font></a>]';
					charBonusCount += chatName.length + 2;
					
					break
			}
			text += playerName;
			
			mesTmp = ": ";
			charBonusCount += mesTmp.length;
			text += mesTmp;
			// process chatMes 
			var mMes:String = chatMes[0];
			var pros:Array;
			
			if (mMes.indexOf("[challenge-replay]") >= 0)
			{
				mMes = mMes.replace("[challenge-replay]", "");
				pros = mMes.split(",");
				var vsmsg:String = pros[5] + " vs " + pros[9];
				chatMes[0] = 'mời xem trận Hoa Sơn Luận kiếm [<a href="event:[challenge-replay]' + ',' + mMes + '"><font color="#FFFF00"><u>' + vsmsg + '</u></font></a>]';
			}
			
			if (mMes.indexOf("[train-announce-msg]") >= 0)
			{
				mMes = mMes.replace("[train-announce-msg]", "");
				pros = mMes.split(",");
				chatMes[0] = " (Lvl " + pros[1] + ")" + ' mời vào chỉ điểm võ công [<a href="event:[train-announce-msg]' + ',' + mMes + '"><font color="#FFFF00"><u>Tham gia</u></font></a>]';
			}
			// --------------------
			xml.text = text + chatMes[0] + '</font>';
			
			var spritesArray:Array = (String)(chatMes[1]).split(";");
			var xmlSprites:XML =           <sprites/>;
			
			for (var i:int = 0; i < spritesArray.length - 1; i++)
			{
				var IconArray:Array = (String)(spritesArray[i]).split(",");
				var node:XML =            <sprite src={IconArray[0]} index={int(IconArray[1]) + charBonusCount}/>;
				xmlSprites.appendChild(node);
			}
			xml.sprites = xmlSprites;
			//Utility.log(xml.toString());
			return xml;
		}
		
		private function parseChatXMLtoString(xml:XML):String
		{
			var result:String = "";
			var tmpString:Array = (String)(xml.text[0].toString()).split("\r");
			var endLinecount:int = 0;
			for (var i:int = 0; i < tmpString.length; i++)
			{
				if ((String)(tmpString[i]).length > 0)
				{
					result += filterCharSensitive(tmpString[i]);
				}
			}
			result += "\n";
			var sprites:XMLList = xml.sprites.sprite;
			for each (var spriteXML:XML in sprites)
			{
				result += spriteXML.@src + "," + ((int)(spriteXML.@index) - (tmpString.length - 1)) + ";";
			}
			return result;
		}
		
		public function setChatMode(value:ChatMode):void {
			switch(value) {
				case ChatMode.INGAME:
					//onChatFocus(false);
					mesBoxMov.smileConMov.x = -150;
					break;
					
				case ChatMode.NORMAL:
					//onChatFocus(true);
					mesBoxMov.smileConMov.x = 350;
					break;
			}
		}
		
		private function onChatFocus(value:Boolean):void {
			if (stage) {
				if (value) {
					stage.focus = chatMesTf.getTextRenderer();
				} else {
					stage.focus = null;
				}
			}
		}
		
		public function showChatPrivate(targetName:String):void
		{
			chatComboBox.showChatPrivate(targetName);
			chatBoxMov.switchViewType(ChatType.CHAT_TYPE_PRIVATE);
		}
		
		public function get isMinimize():Boolean
		{
			return _isMinimize;
		}
		
		public function set isMinimize(value:Boolean):void
		{
			_isMinimize = value;
			chatVisible(value);
		}
		
		public function delayClick():void
		{
			lock();
			setTimeout(unlock, 4000);
		}
		
		public function lock():void
		{
			this.mouseEnabled = false;
			this.mouseChildren = false;
		}
		
		public function unlock():void
		{
			this.mouseEnabled = true;
			this.mouseChildren = true;
		}
		
	}

}