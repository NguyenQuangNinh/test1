package game
{
	import core.Manager;
	import core.event.EventEx;
	import core.util.Utility;

	import flash.utils.Dictionary;

	import game.net.lobby.request.RequestFriendList;
	import game.net.StringRequestPacket;
	import game.net.lobby.response.ResponseNotifyAddFriend;
	import game.ui.friend.FriendView;
	
	import game.enum.ErrorCode;
	import game.net.IntRequestPacket;
	import game.net.IntResponsePacket;
	import game.net.ResponsePacket;
	import game.net.Server;
	import game.net.lobby.LobbyRequestType;
	import game.net.lobby.LobbyResponseType;
	
	public class FriendManager
	{
		public var addPendingList:Array = new Array();

		public function FriendManager()
		{
			Game.network.lobby.addEventListener(Server.SERVER_DATA, lobby_onPacketReceived);
		}
		
		protected function lobby_onPacketReceived(event:EventEx):void
		{
			var packet:ResponsePacket = event.data as ResponsePacket;
			switch (packet.type)
			{
				case LobbyResponseType.ADD_FRIEND_RESULT: 
					onAddFriendResult(IntResponsePacket(packet).value);
					break;
				case LobbyResponseType.FRIEND_NOTIFY_ADD:
					onNotifyAddFriendResult(packet as ResponseNotifyAddFriend);
					break;
			}
		}

		private function onNotifyAddFriendResult(packet:ResponseNotifyAddFriend):void
		{
			Utility.log("notify add friend, name=" + packet.name);

			for each (var object:Object in addPendingList)
			{
				if(object.id == packet.playerID) return;
			}

			var obj:Object = { };
			obj.id = packet.playerID;
			obj.name = packet.name;
			obj.pending = true;

			addPendingList.push(obj);
		}
		
		private function onAddFriendResult(errorCode:int):void
		{
			Utility.log("add friend, errorCode=" + errorCode);
			switch (errorCode)
			{
				case ErrorCode.SUCCESS: 
					Manager.display.showMessage("Kết bạn thành công");
					Game.network.lobby.sendPacket(new RequestFriendList(LobbyRequestType.REQUEST_FRIEND_LIST, 0, FriendView.PAGE_NUM));
					break;
				case ErrorCode.ADD_FRIEND_EXISTED: 
					Manager.display.showMessage("Đã có trong danh sách bạn bè");
					break;
				case ErrorCode.ADD_FRIEND_NO_EXIST_FRIEND: 
					Manager.display.showMessage("Hảo hữu này không online hoặc không tồn tại");
					break;
				case ErrorCode.ADD_FRIEND_MAX_FRIENDS: 
					Manager.display.showMessage("Đã đạt số lượng bạn tối đa");
					break;
				default: 
					Manager.display.showMessage("Không thể kết bạn");
					break;
			}
		}
		
		public function addFriendByID(playerID:int):void
		{
			if (playerID > 0)
				Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.ADD_FRIEND_BY_ID, playerID));
		}
		
		public function addFriendByRoleName(roleName:String):void
		{
			if (roleName != "")
				Game.network.lobby.sendPacket(new StringRequestPacket(LobbyRequestType.ADD_FRIEND_BY_ROLE_NAME, roleName, 32));
		}

		public function acceptAddFriend(playerID:int = -1, accept:Boolean = false):void
		{
			for each (var object:Object in addPendingList)
			{
				if(object.id == playerID)
				{
					addPendingList.splice(addPendingList.indexOf(object), 1);
				}
			}

			if (accept)
			{
				addFriendByID(playerID);
			}
			else
			{
				Game.network.lobby.sendPacket(new RequestFriendList(LobbyRequestType.REQUEST_FRIEND_LIST, 0, FriendView.PAGE_NUM));
			}
		}
	}
}