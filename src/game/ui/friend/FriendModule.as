package game.ui.friend
{
	import core.display.ModuleBase;
	import core.event.EventEx;
	import core.Manager;
	import core.util.Utility;

	import flash.events.Event;
	import game.data.model.UserData;
	import game.Game;
	import game.net.IntResponsePacket;
	import game.net.RequestPacket;
	import game.net.lobby.LobbyRequestType;
	import game.net.lobby.LobbyResponseType;
	import game.net.lobby.response.ResponseGiveAPResult;
	import game.net.lobby.response.ResponseNotifyReceiveAP;
	import game.net.lobby.response.ResponseReceiveAPResult;
	import game.net.lobby.response.ResponseRequestFriendList;
	import game.net.ResponsePacket;
	import game.net.Server;
	import game.ui.hud.HUDModule;
	import game.ui.ModuleID;
	
	/**
	 * ...
	 * @author chuongth2
	 */
	public class FriendModule extends ModuleBase
	{
		public static const CLOSE_FRIEND_VIEW:String = "close_Friend_View";
		
		public function FriendModule()
		{
		
		}
		
		override protected function createView():void
		{
			super.createView();
			baseView = new FriendView();
			
			baseView.addEventListener(CLOSE_FRIEND_VIEW, closeFriendHandler);
		
		}
		
		private function closeFriendHandler(e:Event):void
		{
			var hudModule:HUDModule = Manager.module.getModuleByID(ModuleID.HUD) as HUDModule;
			if (hudModule != null)
			{
				hudModule.updateHUDButtonStatus(ModuleID.FRIEND, false);
			}
			//Manager.display.hideModule(ModuleID.FRIEND);
		}
		
		override protected function transitionIn():void
		{
			super.transitionIn();
			FriendView(baseView).requestFriendList();
		}
		
		override protected function preTransitionIn():void
		{
			super.preTransitionIn();
			Game.database.userdata.addEventListener(UserData.REQUEST_FRIEND_LIST, onRequestFriendList);
		}
		
		override protected function onTransitionInComplete():void
		{
			super.onTransitionInComplete();
			Game.network.lobby.addEventListener(Server.SERVER_DATA, onLobbyServerData);
		
		}
		
		override protected function onTransitionOutComplete():void
		{
			super.onTransitionOutComplete();
			Game.network.lobby.removeEventListener(Server.SERVER_DATA, onLobbyServerData);
			Game.database.userdata.removeEventListener(UserData.REQUEST_FRIEND_LIST, onRequestFriendList);
		}
		
		private function onRequestFriendList(e:EventEx):void
		{
			var packet:ResponseRequestFriendList = e.data as ResponseRequestFriendList;
			if (packet != null)
			{
				var list:Array = Game.friend.addPendingList.concat(packet._arrFriend);
				FriendView(baseView).showFriendList(packet._totalFriend, list);
			}
		}
		
		private function onLobbyServerData(e:EventEx):void
		{
			var packet:ResponsePacket = ResponsePacket(e.data);
			switch (packet.type)
			{
				case LobbyResponseType.DELETE_FRIEND_RESULT: 
					onDeleteFriendResult(packet as IntResponsePacket);
					break;
				case LobbyResponseType.FRIEND_GIVE_AP_RESULT:
					onGiveAPResult(packet as ResponseGiveAPResult);
					break;
				case LobbyResponseType.FRIEND_RECEIVE_AP_RESULT:
					onReceiveAPResult(packet as ResponseReceiveAPResult);
					break;
				case LobbyResponseType.FRIEND_NOTIFY_RECEIVE_AP:
					onNotifyReceiveAP(packet as ResponseNotifyReceiveAP);
					break;
			}
		}

		private function onNotifyReceiveAP(packet:ResponseNotifyReceiveAP):void
		{
			Utility.log("notifyReceiveAP from:" + packet.giverID);
			FriendView(baseView).notifyReceiveAP(packet.giverID);
		}

		private function onReceiveAPResult(packet:ResponseReceiveAPResult):void
		{
			Utility.log("onReceiveAPResult:" + packet.errorCode);
			switch (packet.errorCode)
			{
				case 0:// success
					Manager.display.showMessageID(135);
					FriendView(baseView).apSuccessHandler(false, packet.receiverID);
					Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.GET_PLAYER_INFO));
					break;
				case 1:// fail
					Manager.display.showMessageID(136);
					break;
				case 2:// OVER_MAX_TIMES = 2
					Manager.display.showMessageID(137);
					break;
				case 3:// DIDNT_SEND
					Manager.display.showMessageID(138);
					break;
				case 4:// MAX_AP
					Manager.display.showMessageID(139);
					break;
				case 5:// INVALID_LEVEL
					Manager.display.showMessageID(147);
					break;
			}
		}

		private function onGiveAPResult(intResponsePacket:ResponseGiveAPResult):void
		{
			Utility.log("onGiveAPResult:" + intResponsePacket.errorCode);
			switch (intResponsePacket.errorCode)
			{
				case 0:// success
					Manager.display.showMessageID(129);
					FriendView(baseView).apSuccessHandler(true, intResponsePacket.giverID);
					break;
				case 1:// fail
					Manager.display.showMessageID(130);
					break;
				case 2:// OVER_MAX_TIMES = 2
					Manager.display.showMessageID(131);
					break;
				case 3:// ALREADY_SEND_TO_THIS_ONE
					Manager.display.showMessageID(132);
					break;
				case 4:// RECEIVER_NOT_ONLINE
					Manager.display.showMessageID(133);
					break;
				case 5:// RECEIVER_OVER_MAX_TIMES
					Manager.display.showMessageID(134);
					break;
				case 6:// RECEIVER_IS_YOURSELF
					Manager.display.showMessageID(146);
					break;
				case 7:// INVALID_LEVEL
					Manager.display.showMessageID(147);
					break;
				case 8:// RECEIVER_INVALID_LEVEL
					Manager.display.showMessageID(148);
					break;
			}
		}
		
		/*private function onAddFriendResult(intResponsePacket:IntResponsePacket):void
		{
			switch (intResponsePacket.value)
			{
				case 0: //success
					{
						if(view)
							FriendView(view).requestFriendList();
						Manager.display.showMessage("Kết bạn thành công :)");
					}
					break;
				case 1: //error
					break;
				case 2: //exist
					Manager.display.showMessage("Đã kết bạn rồi :)");
					break;
				case 3: //no exist
					Manager.display.showMessage("Người chơi này không tồn tại :(");
					break;
				case 4: //max friend
					Manager.display.showMessage("Vượt quá giới hạn kết bạn :(");
					break;
			}
		}*/
		
		private function onDeleteFriendResult(intResponsePacket:IntResponsePacket):void
		{
			switch (intResponsePacket.value)
			{
				case 0: //success
					FriendView(baseView).requestFriendList();
					break;
				case 1: //error
					break;
			}
		}
	}

}