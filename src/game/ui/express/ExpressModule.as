package game.ui.express
{

	import core.Manager;
	import core.display.ModuleBase;
	import core.display.layer.Layer;
	import core.display.layer.LayerManager;
	import core.event.EventEx;
	import core.util.Utility;

	import flash.events.Event;
	import flash.geom.Point;

	import game.Game;
	import game.data.vo.lobby.LobbyInfo;
	import game.data.vo.lobby.LobbyPlayerInfo;
	import game.enum.FlowActionEnum;
	import game.enum.FormationType;
	import game.enum.GameMode;
	import game.enum.PlayerAttributeID;
	import game.enum.PorterType;
	import game.net.IntRequestPacket;
	import game.net.IntResponsePacket;
	import game.net.RequestPacket;
	import game.net.ResponsePacket;
	import game.net.Server;
	import game.net.lobby.LobbyRequestType;
	import game.net.lobby.LobbyResponseType;
	import game.net.lobby.request.RequestFormation;
	import game.net.lobby.response.ResponseExpressRefresh;
	import game.net.lobby.response.ResponseFormation;
	import game.net.lobby.response.ResponsePorterInfo;
	import game.net.lobby.response.ResponsePorterList;
	import game.net.lobby.response.ResponsePorterPlayerInfo;
	import game.ui.ModuleID;
	import game.ui.dialog.DialogID;
	import game.ui.dialog.dialogs.YesNo;
	import game.ui.hud.HUDModule;
	import game.ui.ingame.replay.GameReplayManager;

	/**
	 * ...
	 * @author ninhnq
	 */
	public class ExpressModule extends ModuleBase
	{
		private var _playerTarget:LobbyPlayerInfo = new LobbyPlayerInfo();

		public function ExpressModule()
		{
		}

		private function get view():ExpressView
		{
			return baseView as ExpressView;
		}

		override protected function createView():void
		{
			super.createView();
			baseView = new ExpressView();
			baseView.addEventListener(Event.CLOSE, onCloseHdl);
			baseView.addEventListener(ExpressView.START, onStartHdl);
			baseView.addEventListener(ExpressView.BUY_RED, onBuyRedHdl);
			baseView.addEventListener(ExpressView.REFRESH, onRefreshHdl);
			baseView.addEventListener(ExpressView.SELECT_PORTER, onSelectPorterHdl);
			baseView.addEventListener(ExpressView.RAID, onRaidHdl);
			baseView.addEventListener(ExpressView.COMPLETE, onTransportCompleteHdl);

		}

		override protected function preTransitionIn():void
		{
			super.preTransitionIn();
		}

		override protected function onTransitionInComplete():void
		{
			super.onTransitionInComplete();
			Game.network.lobby.addEventListener(Server.SERVER_DATA, onLobbyServerData);

			Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.EXPRESS_GET_LIST));
			Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.EXPRESS_GET_PLAYER_INFO));
		}

		override protected function onTransitionOutComplete():void
		{
			super.onTransitionOutComplete();
			Game.network.lobby.removeEventListener(Server.SERVER_DATA, onLobbyServerData);
		}

		override protected function transitionIn():void
		{
			super.transitionIn();
			Manager.display.showModule(ModuleID.HUD, new Point(0, 0), LayerManager.LAYER_HUD, "top_left", Layer.NONE);
			Manager.display.showModule(ModuleID.TOP_BAR, new Point(0, 0), LayerManager.LAYER_TOP);
			Manager.display.showModule(ModuleID.CHAT, new Point(0, 0), LayerManager.LAYER_SCREEN_TOP, "top_left");

			view.hireDlg.close();
			view.porterInfoDlg.close();
		}

		private function onStartHdl(event:EventEx):void
		{
			var type:PorterType = event.data as PorterType;
			Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.EXPRESS_START, type.ID));
		}

		private function onBuyRedHdl(event:EventEx):void
		{
			Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.EXPRESS_HIRE_RED_PORTER));
		}

		private function onRefreshHdl(event:EventEx):void
		{
			var price:int = event.data as int;
			if(price == 0)
			{
				Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.EXPRESS_REFRESH));
			}
			else
			{
				var obj:Object = {};
				obj.title = "Thông Báo";
				obj.message = "Đã hết số lần miến phí. Sử dụng " + price + " Vàng để làm mới?";
				obj.option = YesNo.YES | YesNo.CLOSE;

				Manager.display.showDialog(DialogID.YES_NO, agreeToBuy, null, obj, Layer.BLOCK_BLACK);
			}
		}

		private function agreeToBuy(data:Object):void {
			Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.EXPRESS_REFRESH));
		}

		private function onSelectPorterHdl(event:EventEx):void
		{
			Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.EXPRESS_GET_PORTER_INFO, event.data as int));
		}

		private function onTransportCompleteHdl(event:EventEx):void
		{
			Manager.display.showMessage("Đã hoàn tất Vận Tiêu");
			Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.EXPRESS_GET_PLAYER_INFO));
		}

		private function onRaidHdl(event:EventEx):void
		{
			_playerTarget.reset();
			_playerTarget.id = event.data.playerID;
			Game.network.lobby.sendPacket(new RequestFormation(FormationType.FORMATION_CHALLENGE.ID, _playerTarget.id));
		}

		private function onLobbyServerData(e:EventEx):void
		{
			var packet:ResponsePacket = ResponsePacket(e.data);
			switch (packet.type)
			{
				case LobbyResponseType.RESPONSE_EXPRESS_PORTER_LIST:
					onReceivePorterList(packet as ResponsePorterList);
					break;
				case LobbyResponseType.RESPONSE_EXPRESS_HIRE_RED_PORTER_RESULT:
					onHireRedResult(packet as IntResponsePacket);
					break;
				case LobbyResponseType.RESPONSE_EXPRESS_PLAYER_INFO:
					onReceivePlayerInfo(packet as ResponsePorterPlayerInfo);
					break;
				case LobbyResponseType.RESPONSE_EXPRESS_PORTER_INFO:
					onReceivePorterInfo(packet as ResponsePorterInfo);
					break;
				case LobbyResponseType.RESPONSE_EXPRESS_REFRESH_RESULT:
					onRefreshResult(packet as ResponseExpressRefresh);
					break;
				case LobbyResponseType.RESPONSE_EXPRESS_START_RESULT:
					onStartResult(packet as IntResponsePacket);
					break;
				case LobbyResponseType.FORMATION:
					onReceiveTargetFormation(packet as ResponseFormation);
					break;
			}
		}

		private function onReceiveTargetFormation(packet:ResponseFormation):void
		{
			if (GameReplayManager.getInstance().isReplaying) return;
			switch(packet.formationType) {
				case FormationType.FORMATION_CHALLENGE:
					if (_playerTarget) {
						if (_playerTarget.id == packet.userID) {
							Game.database.userdata.lobbyPlayers = [];
							//here was change by remove the last info ~ myself
							var self:LobbyPlayerInfo = new LobbyPlayerInfo();
							self.id = Game.database.userdata.userID;
							//self.characters = Game.database.userdata.getFormationChallenge();
							self.characters = Game.database.userdata.formation;
							self.teamIndex = 1;
							self.owner = true;
							self.level = Game.database.userdata.level;
							self.name = Game.database.userdata.playerName;
							Game.database.userdata.lobbyPlayers[0] = self;

							_playerTarget.teamIndex = 2;
							_playerTarget.characters = packet.formation;
							Game.database.userdata.lobbyPlayers[1] = _playerTarget;

							createRoom();
						}
					}else {
						Utility.error("can not go to loading by error NULL player challenge pvp AI");
					}
					break;
			}
		}

		private function createRoom():void
		{
			var occupyInfo:LobbyInfo = new LobbyInfo();
			occupyInfo.challengeID = _playerTarget.id;
			occupyInfo.mode = GameMode.PVE_EXPRESS_WAR_PVP;
			occupyInfo.backModule = ModuleID.EXPRESS;
			Game.flow.doAction(FlowActionEnum.CREATE_BASIC_LOBBY, occupyInfo);
		}

		private function onStartResult(packet:IntResponsePacket):void
		{
			Utility.log("onStartResult: " + packet.value);

			switch (packet.value)
			{
				case 0://Success
					view.hireDlg.close();
					Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.EXPRESS_GET_LIST));
					Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.EXPRESS_GET_PLAYER_INFO));
					break;
				case 1://Fail
					break;
				case 2://Not enough money
					Manager.display.showMessage("Không đủ vàng");
					break;
				case 3://Max
					Manager.display.showMessage("Đã hết số lần vận tiêu trong ngày");
					break;
			}
		}

		private function onRefreshResult(packet:ResponseExpressRefresh):void
		{
			Utility.log("onRefreshResult: " + packet.errorCode);

			switch (packet.errorCode)
			{
				case 0://Success
					Manager.display.showMessage("Làm mới được: " + packet.porterType.name);
					view.refreshResult(packet.porterType,packet.numOfRefresh);
					Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.GET_PLAYER_INFO_ATTRIBUTE, PlayerAttributeID.XU.ID));
					break;
				case 1://Fail
					Manager.display.showMessage("Thất bại");
					break;
				case 2://Not enough money
					Manager.display.showMessage("Không đủ vàng");
					break;
				case 3://Max
					Manager.display.showMessage("Đã hết số lần làm mới trong ngày");
					break;
			}
		}

		private function onReceivePorterInfo(packet:ResponsePorterInfo):void
		{
			Utility.log("onReceivePorterInfo: " + packet.errorCode);

			switch (packet.errorCode)
			{
				case 0:
					view.porterInfoDlg.show(packet);
					break;
				default :
					Manager.display.showMessage("Tiêu xa không tồn tại.");
			}
		}

		private function onReceivePlayerInfo(packet:ResponsePorterPlayerInfo):void
		{
			view.updateMyInfo(packet);
		}

		private function onHireRedResult(packet:IntResponsePacket):void
		{
			Utility.log("onHireRedResult: " + packet.value);

			switch (packet.value)
			{
				case 0://Success
					Manager.display.showMessage("Thuê thành công: " + PorterType.RED.name);
					view.hireDlg.selectPorter(PorterType.RED);
					Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.GET_PLAYER_INFO_ATTRIBUTE, PlayerAttributeID.XU.ID));
					break;
				case 1://Fail
					Manager.display.showMessage("Thất bại");
					break;
				case 2://Not enough money
					Manager.display.showMessage("Không đủ vàng");
					break;
				case 3://Already in red
					Manager.display.showMessage("Thất bại. Tiêu xa hiện tại đang là " + PorterType.RED.name);
					break;
			}
		}

		private function onReceivePorterList(packet:ResponsePorterList):void
		{
			Utility.log("onReceivePorterList: length:" + packet.porters.length);
			view.updatePorterList(packet);
		}

		private function onCloseHdl(e:Event):void
		{
			var hudModule:HUDModule = Manager.module.getModuleByID(ModuleID.HUD) as HUDModule;
			if (hudModule != null)
			{
				hudModule.updateHUDButtonStatus(ModuleID.EXPRESS, false);
			}

			Manager.display.to(ModuleID.HOME);
		}
	}

}