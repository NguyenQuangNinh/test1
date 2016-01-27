package game.ui.dice
{

	import core.Manager;
	import core.display.ModuleBase;
	import core.event.EventEx;
	import core.util.Utility;

	import flash.events.Event;

	import game.Game;
	import game.enum.PlayerAttributeID;
	import game.net.BoolRequestPacket;
	import game.net.IntRequestPacket;
	import game.net.IntResponsePacket;
	import game.net.RequestPacket;
	import game.net.ResponsePacket;
	import game.net.Server;
	import game.net.lobby.LobbyRequestType;
	import game.net.lobby.LobbyResponseType;
	import game.net.lobby.request.RequestDiceBet;
	import game.net.lobby.request.RequestLeaderBoard;
	import game.net.lobby.response.ResponseDiceBetResult;
	import game.net.lobby.response.ResponseDiceBuyExtraBetResult;
	import game.net.lobby.response.ResponseDiceLog;
	import game.net.lobby.response.ResponseDicePlayerInfo;
	import game.net.lobby.response.ResponseDiceRollResult;
	import game.net.lobby.response.ResponseLeaderBoard;
	import game.ui.ModuleID;
	import game.ui.hud.HUDModule;

	/**
	 * ...
	 * @author
	 */
	public class DiceModule extends ModuleBase
	{

		public function DiceModule()
		{

		}

		private function get view():DiceView
		{
			return baseView as DiceView;
		}

		override protected function createView():void
		{
			baseView = new DiceView();
			baseView.addEventListener("close", closeHandler);
			baseView.addEventListener(DiceView.START, startHdl);
			baseView.addEventListener(DiceView.BET, betHdl);
			baseView.addEventListener(DiceView.GET_LOG, getlogHdl);
			baseView.addEventListener(DiceView.RECEIVE_REWARD, getRewardHdl);
			baseView.addEventListener(DiceView.UPDATE_RANKING, updateRankingHdl);
		}

		private function updateRankingHdl(event:EventEx):void
		{
			Game.network.lobby.sendPacket(new RequestLeaderBoard(8,	event.data.from, event.data.to));
		}

		private function getRewardHdl(event:EventEx):void
		{
			Game.network.lobby.sendPacket(new BoolRequestPacket(LobbyRequestType.DICE_RECEIVE_REWARD, view.autoFix.isChecked()));
		}

		private function getlogHdl(event:EventEx):void
		{
			Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.REQUEST_DICE_LOG));
		}

		private function betHdl(event:EventEx):void
		{
			Game.network.lobby.sendPacket(new RequestDiceBet(LobbyRequestType.REQUEST_BET_DICE, event.data.isAutoSave, event.data.isGreater));
		}

		private function startHdl(event:EventEx):void
		{
			Game.network.lobby.sendPacket(new BoolRequestPacket(LobbyRequestType.REQUEST_ROLL_DICE, event.data as Boolean));
		}

		override protected function preTransitionIn():void
		{
			super.preTransitionIn();
		}

		override protected function onTransitionInComplete():void
		{
			super.onTransitionInComplete();
			Game.network.lobby.addEventListener(Server.SERVER_DATA, onLobbyServerData);
			Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.DICE_GET_PLAYER_INFO));

			view.rankList.updatePage();
		}

		override protected function onTransitionOutComplete():void
		{
			super.onTransitionOutComplete();
			Game.network.lobby.removeEventListener(Server.SERVER_DATA, onLobbyServerData);
		}

		private function onLobbyServerData(e:EventEx):void
		{
			var packet:ResponsePacket = ResponsePacket(e.data);
			switch (packet.type)
			{
				case LobbyResponseType.DICE_BET_RESULT:
					onBetResultHdl(packet as ResponseDiceBetResult);
					break;
				case LobbyResponseType.DICE_GET_PLAYER_INFO_RESULT:
					onGetPlayerInfoResult(packet as ResponseDicePlayerInfo);
					break;
				case LobbyResponseType.DICE_GET_REWARD_RESULT:
					onGetRewardResult(packet as IntResponsePacket);
					break;
				case LobbyResponseType.DICE_ROLL_RESULT:
					onDiceRollResult(packet as ResponseDiceRollResult);
					break;
				case LobbyResponseType.DICE_LOG_RESULT:
					onDiceLogResult(packet as ResponseDiceLog);
					break;
				case LobbyResponseType.LEADER_BOARD:
					onRankingUpdateHdl(packet as ResponseLeaderBoard);
					break;
			}
		}

		private function onRankingUpdateHdl(packet:ResponseLeaderBoard):void
		{
			Utility.log("onRankingUpdateHdl:" + packet.players.length);
			view.updateRankList(packet.players);
		}

		private function onDiceLogResult(packet:ResponseDiceLog):void
		{
			Utility.log("onDiceLogResult:" + packet.errorCode);
			switch (packet.errorCode)
			{
			    case 0://success
				    view.showLog(packet);
			        break;
			    case 1://fail
			        break;
			}
		}

		private function onDiceRollResult(packet:ResponseDiceRollResult):void
		{
			Utility.log("onDiceRollResult:" + packet.errorCode);
			switch (packet.errorCode)
			{
			    case 0://success
				    Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.GET_PLAYER_INFO_ATTRIBUTE, PlayerAttributeID.XU.ID));
				    view.showDiceRollResult(packet);
			        break;
			    case 1://fail

			        break;
			    case 2://not enough money
					Manager.display.showMessageID(152);
			        break;
				case 3://GAME_ALREADY_STARTED

					break;
				case 4://LAST_GAME_LOST

					break;
				case 8://FULL EVENT
					Manager.display.showMessage("Thất bại. Điểm tích lũy đã đạt mức tối đa.");
					break;
			}
		}

		private function onGetRewardResult(packet:IntResponsePacket):void
		{
			Utility.log("onGetRewardResult:" + packet.value);
			switch (packet.value)
			{
			    case 0://success
					Manager.display.showMessage("Phần thưởng đã gửi vào Hộp Thư.");
			        break;
			    case 1://fail
					Manager.display.showMessage("Nhận thưởng thất bại");
			        break;
				case 7://ALREADY_RECEIVE
					Manager.display.showMessage("Chưa đủ điểm để nhận mốc tiếp theo.");
					break;
				case 8://FULL EVENT
					Manager.display.showMessage("Không còn phần thưởng để nhận.");
					break;
			}
		}

		private function onGetPlayerInfoResult(packet:ResponseDicePlayerInfo):void
		{
			Utility.log("onGetPlayerInfoResult:" + packet.errorCode);
			switch (packet.errorCode)
			{
			    case 0://success
					view.updateInfo(packet);
			        break;
			    case 1://fail
			        break;
			}
		}

		private function onBetResultHdl(packet:ResponseDiceBetResult):void
		{
			Utility.log("onBetResultHdl:" + packet.errorCode);
			switch (packet.errorCode)
			{
			    case 0://success
				    view.showBetResult(packet);
			        break;
			    case 1://fail

			        break;
			    case 2://not enough money

			        break;
			}

		}

		private function closeHandler(e:Event):void
		{
			var hudModule:HUDModule = Manager.module.getModuleByID(ModuleID.HUD) as HUDModule;
			if (hudModule != null)
			{
				hudModule.updateHUDButtonStatus(ModuleID.DICE, false);
			}
		}
	}

}