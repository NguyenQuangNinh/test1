package game.ui.friend.gui
{
	import com.greensock.TweenMax;
	import core.display.layer.Layer;
	import core.Manager;
	import core.util.FontUtil;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

	import game.enum.Font;
	import game.Game;
	import game.net.IntRequestPacket;
	import game.net.lobby.LobbyRequestType;
	import game.ui.chat.ChatModule;
	import game.ui.ModuleID;
	
	/**
	 * ...
	 * @author chuongth2
	 */
	public class FriendItem extends MovieClip
	{
		public var btnInfo:SimpleButton;
		public var btnMsg:SimpleButton;
		public var btnDel:SimpleButton;
		public var okBtn:SimpleButton;
		public var rejectBtn:SimpleButton;

		public var receiveAPBtn:SimpleButton;
		public var giveAPBtn:SimpleButton;

		public var levelTf:TextField;
		public var roleNameTf:TextField;

		private var _isOnline:Boolean;
		private var _playerID:int;
		private var _roleName:String;
		
		public function FriendItem()
		{
			FontUtil.setFont(levelTf, Font.TAHOMA, true);
			FontUtil.setFont(roleNameTf, Font.TAHOMA, true);

			btnInfo.addEventListener(MouseEvent.CLICK, onBtnInfo);
			btnMsg.addEventListener(MouseEvent.CLICK, onBtnMsg);
			btnDel.addEventListener(MouseEvent.CLICK, onBtnDel);
			receiveAPBtn.addEventListener(MouseEvent.CLICK, receiveClickHdl);
			giveAPBtn.addEventListener(MouseEvent.CLICK, giveClickHdl);
			okBtn.addEventListener(MouseEvent.CLICK, acceptAddHdl);
			rejectBtn.addEventListener(MouseEvent.CLICK, rejectAddHdl);

			receiveAPBtn.visible = Game.database.userdata.level >= Game.database.gamedata.getConfigData(201);
			giveAPBtn.visible = Game.database.userdata.level >= Game.database.gamedata.getConfigData(201);

			okBtn.visible = false;
			rejectBtn.visible = false;

			roleNameTf.autoSize = TextFieldAutoSize.LEFT;
		}

		private function rejectAddHdl(event:MouseEvent):void
		{
			Game.friend.acceptAddFriend(_playerID, false);
		}

		private function acceptAddHdl(event:MouseEvent):void
		{
			Game.friend.acceptAddFriend(_playerID, true);
		}

		private function giveClickHdl(event:MouseEvent):void
		{
			if (_playerID > 0)
				Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.FRIEND_GIVE_AP, _playerID));
		}

		private function receiveClickHdl(event:MouseEvent):void
		{
			if (_playerID > 0)
				Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.FRIEND_RECEIVE_AP, _playerID));
		}
		
		private function onBtnDel(e:MouseEvent):void
		{
			if (_playerID > 0)
				Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.DELETE_FRIEND, _playerID));
		}
		
		private function onBtnMsg(e:MouseEvent):void
		{
			var moduleChat:ChatModule = Manager.module.getModuleByID(ModuleID.CHAT) as ChatModule;
			if (moduleChat != null)
			{
				moduleChat.showChatPrivate(_roleName);
			}
		}
		
		private function onBtnInfo(e:MouseEvent):void
		{
			Manager.display.showPopup(ModuleID.PLAYER_PROFILE,  Layer.BLOCK_BLACK, _playerID);
		}
		
		public function set isOnline(value:Boolean):void
		{
			_isOnline = value;
			var nSaturation:int = _isOnline == true ? 1 : 0;
			TweenMax.to(this, 0, {alpha: 1, colorMatrixFilter: {saturation: nSaturation}});
		}

		public function set isPending(value:Boolean):void
		{
			if(value)
			{
				btnDel.visible = false;
				btnInfo.visible = false;
				btnMsg.visible = false;
				giveAPBtn.visible = false;
				receiveAPBtn.visible = false;
				levelTf.visible = false;

				okBtn.visible = true;
				rejectBtn.visible = true;
				roleNameTf.x = levelTf.x;
			}
			else
			{
				btnDel.visible = true;
				btnInfo.visible = true;
				btnMsg.visible = true;
				giveAPBtn.visible = true;
				receiveAPBtn.visible = true;
				levelTf.visible = true;

				okBtn.visible = false;
				rejectBtn.visible = false;
			}
		}

		public function init(obj:Object):void
		{
			if (obj != null)
			{
				if(obj.pending)
				{
					_playerID = obj.id;
					_roleName = obj.name;
					roleNameTf.text = obj.name + " yêu cầu kết bạn.";
					isPending = obj.pending;
				}
				else
				{
					_playerID = obj.id;
					_roleName = obj.name;
					roleNameTf.text = obj.name;
					levelTf.text = "Lv:" + obj.level;
					isPending = obj.pending;
					enableReceive(obj.canReceive);
					enableGive(obj.canGive);
					isOnline = obj.online;
				}
			}
		}

		public function enableGive(value:Boolean):void
		{
			giveAPBtn.visible = value;
		}

		public function enableReceive(value:Boolean):void
		{
			receiveAPBtn.visible = value;
		}

		public function get playerID():int {return _playerID;}
	}

}