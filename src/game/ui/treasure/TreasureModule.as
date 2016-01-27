package game.ui.treasure
{

	import core.Manager;
	import core.display.ModuleBase;
	import core.event.EventEx;
	import core.util.Utility;

	import flash.events.Event;

	import game.Game;
	import game.data.model.UserData;
	import game.net.IntRequestPacket;
	import game.net.RequestPacket;
	import game.net.ResponsePacket;
	import game.net.Server;
	import game.net.lobby.LobbyRequestType;
	import game.net.lobby.LobbyResponseType;
	import game.net.lobby.response.ResponseTreasureLog;
	import game.net.lobby.response.ResponseTreasureRewards;
	import game.ui.ModuleID;
	import game.ui.hud.HUDModule;

	/**
	 * ...
	 * @author ninhnq
	 */
	public class TreasureModule extends ModuleBase
	{

		public static const REQUEST_REWARD_TREASURE:String = "request_reward_treasure";
		public static const CLOSE_TREASURE:String = "close_treasure";

		public function TreasureModule()
		{

		}

		override protected function createView():void
		{
			super.createView();
			baseView = new TreasureView();
			baseView.addEventListener(REQUEST_REWARD_TREASURE, requestRewardHdl);
			baseView.addEventListener(CLOSE_TREASURE, closeTreasure);
		}

		private function closeTreasure(e:Event):void
		{
			var hudModule:HUDModule = Manager.module.getModuleByID(ModuleID.HUD) as HUDModule;
			if (hudModule != null)
			{
				hudModule.updateHUDButtonStatus(ModuleID.TREASURE, false);
			}
		}

		override protected function preTransitionIn():void
		{
			super.preTransitionIn();
			view.init();
		}

		override protected function onTransitionInComplete():void
		{
			super.onTransitionInComplete();
			Game.network.lobby.addEventListener(Server.SERVER_DATA, onLobbyServerData);
			Game.database.userdata.addEventListener(UserData.UPDATE_PLAYER_INFO, onUpdatePlayerInfo);

			if(!view.isRunning()) Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.TREASURE_REQUEST_LOG));
		}

		override protected function onTransitionOutComplete():void
		{
			super.onTransitionOutComplete();
			Game.network.lobby.removeEventListener(Server.SERVER_DATA, onLobbyServerData);
			Game.database.userdata.removeEventListener(UserData.UPDATE_PLAYER_INFO, onUpdatePlayerInfo);
		}

		private function requestRewardHdl(e:EventEx):void
		{
			Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.TREASURE_REQUEST_REWARD, e.data as int));
		}

		private function onLobbyServerData(e:EventEx):void
		{
			var packet:ResponsePacket = ResponsePacket(e.data);
			switch (packet.type)
			{
				case LobbyResponseType.TREASURE_LOG_RESULT:
					onRequestLogResponse(packet as ResponseTreasureLog);
					break;
				case LobbyResponseType.TREASURE_REWARD_RESULT:
					onTreasureRewardsResponse(packet as ResponseTreasureRewards);
					break;
			}
		}

		private function onTreasureRewardsResponse(packet:ResponseTreasureRewards):void
		{
			Utility.log("onTreasureRewardsResponse : " + packet.errorCode);
			switch (packet.errorCode)
			{
				case 0: //success
					view.updateTreasureView(packet.rewardIndex);
					break;
				case 1: //fail
					Manager.display.showMessageID(140);
					view.failHandler();
					break;
				case 2: //khong du tien
					Manager.display.showMessageID(141);
					view.failHandler();
					break;
				case 3: //Hết số lần quay trong ngày
					Manager.display.showMessageID(142);
					view.failHandler();
					break;
				case 4: //Vuot qua so lan quay trong ngay
					Manager.display.showMessageID(143);
					view.failHandler();
					break;
				case 5: //Thoi gian khong hop le
					Manager.display.showMessageID(144);
					view.failHandler();
					break;
			}
		}

		private function onRequestLogResponse(packet:ResponseTreasureLog):void
		{
			Utility.log("onRequestLogResponse : " + packet.rewardIndex);

			switch (packet.errorCode)
			{
				case 0: //success
					view.setLog(packet.rewardIndex);
					break;
				case 1: //fail
					Manager.display.showMessageID(140);
					view.failHandler();
					break;
				case 3: //Thoi gian khong hop le
					Manager.display.showMessageID(144);
					view.failHandler();
					break;
			}
		}

		private function onUpdatePlayerInfo(e:Event):void
		{
			view.init();
		}

		public function get view():TreasureView
		{
			return baseView as TreasureView;
		}

	}

}