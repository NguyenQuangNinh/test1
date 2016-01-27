package game.ui.chat
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import game.ui.guild.enum.GuildRole;
	
	import core.Manager;
	import core.display.layer.Layer;
	import core.display.layer.LayerManager;
	import core.event.EventEx;
	
	import game.Game;
	import game.data.vo.chat.ChatType;
	import game.net.IntRequestPacket;
	import game.net.lobby.LobbyRequestType;
	import game.ui.ModuleID;
	
	/**
	 * ...
	 * @author ...
	 */
	public class ChatComboBox extends Sprite
	{
		public var targetName:String;
		public var targetId:int;
		
		public function ChatComboBox()
		{
			var background:Shape = new Shape();
			background.graphics.beginFill(0x000000, 0.7);
			background.graphics.lineStyle(1, 0x999999, 0.8);
			background.graphics.drawRect(0, 0, 84, 110);
			background.graphics.endFill();
			addChild(background);
			
			var viewButton:ChatComboBoxButton = new ChatComboBoxButton();
			viewButton.setButtonName("Xem");
			viewButton.x = 2;
			viewButton.y = 5;
			viewButton.addEventListener(MouseEvent.CLICK, viewButton_onClicked);
			addChild(viewButton);
			
			var privateButton:ChatComboBoxButton = new ChatComboBoxButton();
			privateButton.setButtonName("Mật");
			privateButton.x = 2;
			privateButton.y = 25;
			privateButton.addEventListener(MouseEvent.CLICK, onPrivateButtonClick);
			addChild(privateButton);
			
			var inviteButton:ChatComboBoxButton = new ChatComboBoxButton();
			inviteButton.setButtonName("Mời");
			inviteButton.x = 2;
			inviteButton.y = 45;
			inviteButton.addEventListener(MouseEvent.CLICK, onInviteButtonClick);
			addChild(inviteButton);
			
			var addFriendButton:ChatComboBoxButton = new ChatComboBoxButton();
			addFriendButton.setButtonName("Hảo hữu");
			addFriendButton.x = 2;
			addFriendButton.y = 65;
			addFriendButton.addEventListener(MouseEvent.CLICK, onAddFriendButtonClick);
			addChild(addFriendButton);
			
			if (Game.database.userdata.guildId >= 0 && Game.database.userdata.guildMemberType >= GuildRole.CAPTAIN)
			{
				var guildInviteButton:ChatComboBoxButton = new ChatComboBoxButton();
				guildInviteButton.setButtonName("Mời bang");
				guildInviteButton.x = 2;
				guildInviteButton.y = 85;
				guildInviteButton.addEventListener(MouseEvent.CLICK, guildInviteButtonClick);
				addChild(guildInviteButton);
			}
			
			addEventListener(MouseEvent.ROLL_OUT, onMouseOut);
		}
		
		private function guildInviteButtonClick(e:MouseEvent):void 
		{
			Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.GU_INVITE_SEND, targetId));
			this.visible = false;
		}
		
		protected function viewButton_onClicked(event:MouseEvent):void
		{
			visible = false;
			Manager.display.showModule(ModuleID.PLAYER_PROFILE, new Point(), LayerManager.LAYER_POPUP, "top_left", Layer.BLOCK_BLACK, targetId);
		}
		
		private function onAddFriendButtonClick(e:MouseEvent):void
		{
			Game.friend.addFriendByID(targetId);
			this.visible = false;
		}
		
		private function onInviteButtonClick(e:MouseEvent):void
		{
			if (Manager.display.checkVisible(ModuleID.LOBBY))
			{
				Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.INVITE_TO_PLAY_GAME, targetId));
			}
			this.visible = false;
		}
		
		private function onPrivateButtonClick(e:MouseEvent):void
		{
			dispatchEvent(new EventEx(ChatEvent.CHANGE_CHAT_TYPE, ChatType.CHAT_TYPE_PRIVATE, true));
			dispatchEvent(new EventEx(ChatEvent.CHANGE_CHAT_NAME, targetName, true));
			this.visible = false;
		}
		
		private function onMouseOut(e:MouseEvent):void
		{
			this.visible = false;
		}
		
		public function showChatPrivate(targetName:String):void
		{
			dispatchEvent(new EventEx(ChatEvent.CHANGE_CHAT_TYPE, ChatType.CHAT_TYPE_PRIVATE, true));
			dispatchEvent(new EventEx(ChatEvent.CHANGE_CHAT_NAME, targetName, true));
		}
	}

}