package game.ui.train
{
	import core.display.layer.LayerManager;
	import core.display.ModuleBase;
	import core.event.EventEx;
	import core.Manager;
	import flash.geom.Point;
	import game.data.vo.lobby.LobbyInfo;
	import game.data.vo.lobby.LobbyPlayerInfo;
	import game.enum.GameConfigID;
	import game.enum.GameMode;
	import game.Game;
	import game.net.IntRequestPacket;
	import game.net.IntResponsePacket;
	import game.net.lobby.LobbyRequestType;
	import game.net.lobby.LobbyResponseType;
	import game.net.lobby.request.RequestJoinRoomPvP;
	import game.net.lobby.response.ResponseCreateRoom;
	import game.net.lobby.response.ResponseJoinRoomPvP;
	import game.net.lobby.response.ResponseRoomListPvP;
	import game.net.lobby.response.ResponseUpdateRoomPvP;
	import game.net.RequestPacket;
	import game.net.ResponsePacket;
	import game.net.Server;
	import game.ui.dialog.DialogID;
	import game.ui.dialog.dialogs.YesNo;
	import game.ui.ModuleID;
	import game.ui.train.data.RoomInfo;

	/**
	 * ...
	 * @author anhtinh
	 */
	public class TrainModule extends ModuleBase
	{
		public static var HOME_PAGE:int = 0;
		public static var ROOM_PAGE:int = 1;
		public var view:TrainView;
		
		public function TrainModule()
		{
		}
		
		override protected function createView():void
		{
			super.createView();
			baseView = new TrainView();
			view = baseView as TrainView;
		}
		
		override protected function preTransitionIn():void
		{
			super.preTransitionIn();
			Game.flow.lock();
			Game.network.lobby.addEventListener(Server.SERVER_DATA, onLobbyServerData);
			view.showHome();
			if (extraInfo && extraInfo.roomId) Game.network.lobby.sendPacket(new RequestJoinRoomPvP(extraInfo.roomId, false));
		}
		
		override protected function onTransitionInComplete():void
		{
			super.onTransitionInComplete();
			Manager.display.showModule(ModuleID.CHAT, new Point(), LayerManager.LAYER_DIALOG);
		}
		
		override protected function onTransitionOutComplete():void
		{
			super.onTransitionOutComplete();
			Game.network.lobby.removeEventListener(Server.SERVER_DATA, onLobbyServerData);
			Game.flow.unlock();
			Manager.display.showModule(ModuleID.CHAT, new Point(), LayerManager.LAYER_SCREEN_TOP);
		}
		
		private function onLobbyServerData(e:EventEx):void
		{
			var packet:ResponsePacket = ResponsePacket(e.data);
			var i:int;
			var errorCode:int;
			switch (packet.type)
			{
				
				// common responses -----------------------------------------------------------------
				
				case LobbyResponseType.ROOM_LIST_PVP:
					var packetRoomList:ResponseRoomListPvP = packet as ResponseRoomListPvP;
					view.home.roomList.updateRoomList(packetRoomList.rooms);
					break;
				case LobbyResponseType.KUNGFU_TRAIN_START:
					view.startKungfu();
					break;
				case LobbyResponseType.LEAVE_GAME_RESULT:
					errorCode = IntResponsePacket(packet).value;
					if (errorCode == 0) 
					{
						view.stopKungfu();
						view.showHome();
					}
					else Manager.display.showMessage("Rời phòng thất bại");
					break;
				case LobbyResponseType.UPDATE_INFO_ROOM_PVP:
					var roomUpdatePacket:ResponseUpdateRoomPvP = packet as ResponseUpdateRoomPvP;
					
					view.roomView.pauseAllAnims();
					view.roomView.resetPlayerCount();
					for (i = 0; i < roomUpdatePacket.players.length; i++) 
					{
						var isHost:Boolean = (i == 0 ? true : false);
						view.roomView.playerJoinRoom(LobbyPlayerInfo(roomUpdatePacket.players[i]).characters[0], isHost);
					}

					if (roomUpdatePacket.players.length == 1) 
					{
						view.roomView.partnerLeft();
					}
					else if (roomUpdatePacket.players.length == 2) view.roomView.partnerId = LobbyPlayerInfo(roomUpdatePacket.players[1]).id;
					break;
				case LobbyResponseType.KUNGFU_TRAIN_READY:
					errorCode = IntResponsePacket(packet).value;
					if (errorCode == 0) 
					{
						view.roomView.partnerReady();
					}
					break;
				case LobbyResponseType.KUNGFU_TRAIN_REWARD:
					errorCode = IntResponsePacket(packet).value;
					if (errorCode == 0) 
					{
						view.roomView.showReward();
					}
					break;
				case LobbyResponseType.KICK_FROM_LOBBY:
					view.stopKungfu();
					view.showHome();
					Manager.display.showDialog(DialogID.YES_NO, null, null, {title: "THÔNG BÁO", message: "Bạn đã bị trục xuất khỏi phòng!", option: YesNo.YES});
					break;
				// ------------------------------------------------------------------------------
					
				// responses for host only -----------------------------------------------------------------
				case LobbyResponseType.CREATE_ROOM: // for host only
					var packetCreateRoom:ResponseCreateRoom = packet as ResponseCreateRoom;
					errorCode = packetCreateRoom.errorCode;
					if (errorCode == 0)
					{
						view.showRoom();
						view.roomView.setHost(true);
						
						var roomInfo:RoomInfo = new RoomInfo();
						roomInfo.index = 0;
						roomInfo.strRoleName = Game.database.userdata.playerName;
						roomInfo.nLevel = Game.database.userdata.level;
						roomInfo.roomId = packetCreateRoom.roomID;
						roomInfo.playerNum = 1;
						view.roomView.setRoomInfo(roomInfo);
						view.roomView.playerJoinRoom(Game.database.userdata.mainCharacter, true);
					}
					else Manager.display.showMessage(getGuildErrorMsg(errorCode, true));
					break;
					
				// -------------------------------------------------------------------------------------------
				
				// responses for partner only -----------------------------------------------------------------
				
				case LobbyResponseType.JOIN_ROOM_BY_ID_RESULT: // for partner only
					errorCode = IntResponsePacket(packet).value;
					if (errorCode == 0) 
					{
						view.showRoom();
						Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.NOTIFY_JOIN_ROOM_READY));	
					}
					else Manager.display.showMessage(getGuildErrorMsg(errorCode, false));
					break;
				case LobbyResponseType.QUICK_JOIN_ROOM_RESULT:
					errorCode = ResponseJoinRoomPvP(packet).errorCode;
					if (errorCode == 0) 
					{
						view.showRoom();
						Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.NOTIFY_JOIN_ROOM_READY));	
					}
					else Manager.display.showMessage(getGuildErrorMsg(errorCode, false));
					break;
				case LobbyResponseType.KUNGFU_ROOM_DESTROY: // for partner only
					view.stopKungfu();
					view.showHome();
					Manager.display.showDialog(DialogID.YES_NO, null, null, {title: "THÔNG BÁO", message: "Người chơi còn lại đã thoát khỏi phòng!", option: YesNo.YES});
					break;
				
			}
		
		}
		
		public function getGuildErrorMsg(errorCode:int, isCreate:Boolean = true):String
		{
			var actStr:String = isCreate ? "Tạo" : "Vào"
			var message:String;
			switch (errorCode)
			{
				case 0:
					break;
				case 1:
					message = actStr + " phòng chỉ điểm võ công thất bại";
					break;
				case 2:
					message = actStr + " phòng chỉ điểm võ công thất bại";
					break;
				case 3:
					message = "Chưa đến thời gian để " + actStr + " phòng";
					break;
				case 4:
					message = "Bạn không đủ level để " + actStr + " phòng";
					break;
				case 26:
					message = "Bạn đã vượt quá số lần chỉ điểm võ công trong ngày";
					break;
				case 17:
					message = "Không tìm thấy phòng phù hợp";
					break;
				case 27:
					message = "Bạn đã vượt quá số lần được chỉ điểm võ công trong ngày";
					break;
				case 28:
					message = "Level của 2 người tham gia phải chênh lệch ít nhất " + Game.database.gamedata.getConfigData(GameConfigID.KUNGFU_TRAIN_LEVEL_DIFF_MIN) + " level và nhiều nhất là " + Game.database.gamedata.getConfigData(GameConfigID.KUNGFU_TRAIN_LEVEL_DIFF_MAX) + " level";
					break;
				default:
					message = actStr + " phòng chỉ điểm võ công thất bại";
					break;
			}
			return message;
		}
	}

}