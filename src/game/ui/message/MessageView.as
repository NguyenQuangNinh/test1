package game.ui.message
{
	import core.display.layer.Layer;
	import core.display.ViewBase;
	import core.event.EventEx;
	import core.Manager;
	import core.util.FontUtil;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormatAlign;
	import game.data.xml.DataType;
	import game.data.xml.MessageXML;
	import game.enum.Font;
	import game.Game;
	import game.net.ByteResponsePacket;
	import game.net.lobby.LobbyResponseType;
	import game.net.lobby.response.ResponseGlobalAnnouncement;
	import game.net.ResponsePacket;
	import game.net.Server;
	import game.ui.chat.ChatModule;
	import game.ui.dialog.DialogID;
	import game.ui.dialog.dialogs.YesNo;
	import game.ui.ModuleID;
	
	
	
	/**
	 * ...
	 * @author MaiPTT
	 */
	public class MessageView extends ViewBase
	{
		public static const SHOW_MESSAGE:String = "message_view_show_message";
		private static const MAX_DISPLAY_MESSAGES:int = 10;
		
		public var movContent:MovieClip;
		public var movSpeaker:SpeakerView;
		private var _messageIDs:Array;
		private var _currentMessageID:int;
		private var _messageData:MessageXML;
		private var _messageContent:String;
		private var miniLoading:MiniLoadingView;
		
		public function MessageView()
		{
			addEventListener(Event.ADDED_TO_STAGE, onInit);
		}
		
		public function setMiniLoadingVisible(value:Boolean):void {
			miniLoading.visible = value;
		}
		
		public function getMiniLoadingVisible():Boolean {
			return miniLoading.visible;
		}
		
		override protected function transitionInComplete():void
		{
			super.transitionInComplete();
			this.mouseChildren = false;
			this.mouseEnabled = false;
		}
		
		private function onInit(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onInit);
			miniLoading = new MiniLoadingView();
			miniLoading.mouseChildren = false;
			miniLoading.mouseEnabled = false;
			addChild(miniLoading);
			
			_messageIDs = [];
			_currentMessageID = -1;
			movContent.visible = false;
			
			FontUtil.setFont(txtMessage, Font.ARIAL);
			txtMessage.getTextFormat().align = TextFormatAlign.CENTER;
			
			stage.addEventListener(SHOW_MESSAGE, onShowMessageHdl);
			movContent.addEventListener("message_play_complete", onPlayAnimCompleteHdl);
		
			movSpeaker = new SpeakerView();
			addChild(movSpeaker);;
		}
		
		private function onShowMessageHdl(e:EventEx):void
		{
			var id:int = e.data as int;
			if (id)
			{
				messageID = id;
			}
		}
		
		public function set messageID(messageID:int):void
		{
			var messageXML:MessageXML = Game.database.gamedata.getData(DataType.MESSAGE, messageID) as MessageXML;
			if (messageXML != null && (_messageIDs.indexOf(messageXML.content) == -1))
			{
				_messageIDs.push(messageXML.content);
				if (_messageIDs.length == 1)
				{
					showMessage();
				}
			}
		}
		
		public function addMessage(message:String):void
		{
			if (_messageIDs.indexOf(message) == -1)
			{
				_messageIDs.push(message);
				if (_messageIDs.length == 1 && movContent.visible == false)
					showMessage();
			}
		}
		
		private function showMessage():void
		{
			var message:String = _messageIDs[0];
			if (message != null)
			{
				txtMessage.text = message;
				movContent.visible = true;
				movContent.play();
				movBackground.play();
			}
			else
			{
				movContent.visible = false;
			}
		}
		
		private function onPlayAnimCompleteHdl(e:Event):void
		{
			_messageIDs.shift();
			showMessage();
		}
		
		private function get txtMessage():TextField
		{
			return movContent.movMessage.txtMessage;
		}
		
		private function get movBackground():MovieClip
		{
			return movContent.movBackground;
		}
		
		override public function transitionIn():void
		{
			super.transitionIn();
			Game.network.lobby.addEventListener(Server.SERVER_DATA, onLobbyServerData);
			Game.network.lobby.addEventListener(Server.SERVER_DISCONNECTED, onLobbyServerDisconnected);
		}
		
		override public function transitionOut():void
		{
			super.transitionOut();
			Game.network.lobby.removeEventListener(Server.SERVER_DATA, onLobbyServerData);
			Game.network.lobby.removeEventListener(Server.SERVER_CONNECTED, onLobbyServerDisconnected);
		}
		
		private function onLobbyServerData(e:EventEx):void
		{
			var packet:ResponsePacket = ResponsePacket(e.data);
			switch (packet.type)
			{
				case LobbyResponseType.LOGIN_CONFLICT_ACC: 
					onConflictAcc(packet as ByteResponsePacket);
					break;
					
				case LobbyResponseType.GLOBAL_ANNOUCEMENT:
					onResponseGlobalAnnouncement(packet as ResponseGlobalAnnouncement);
					break;
			}
		}
		
		private function onResponseGlobalAnnouncement(packet:ResponseGlobalAnnouncement):void {
			movSpeaker.showAnnouncement(packet.annoucementType, packet.userName, packet.message, packet.highPriority, packet.repeat);
			ChatModule(Manager.module.getModuleByID(ModuleID.CHAT)).showSystemAnnouncement(packet.annoucementType, packet.userName, packet.message, packet.userID);
		}
		
		protected function onLobbyServerDisconnected(event:Event):void
		{
			var dialogData:Object = {};
			dialogData.title = "Mất kết nối";
			dialogData.message = "Bạn bị mất kết nối với máy chủ, xin vui lòng thử lại";
			dialogData.option = YesNo.YES;
			Manager.display.showDialog(DialogID.YES_NO, onConflictAccYes, null, dialogData, Layer.BLOCK_BLACK);
		}
		
		private function onConflictAcc(packet:ByteResponsePacket):void
		{
			if (packet.value == 1)
			{
				//Manager.display.showMessageID(MessageID.LOGIN_CONFLICT_ACC);
				var dialogData:Object = {};
				dialogData.title = "Đăng nhập trùng";
				dialogData.message = "Tài khoản này đã bị đăng nhập ở nơi khác";
				dialogData.option = YesNo.YES;
				Manager.display.showDialog(DialogID.YES_NO, onConflictAccYes, null, dialogData, Layer.BLOCK_BLACK);
			}
		}
		
		private function onConflictAccYes(data:Object):void
		{
		
		}
	}

}