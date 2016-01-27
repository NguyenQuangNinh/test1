package game.ui.mystic_box
{

	import core.Manager;
	import core.display.ModuleBase;
	import core.event.EventEx;
	import core.util.Utility;

	import flash.events.Event;

	import game.Game;
	import game.data.model.Inventory;
	import game.data.model.UserData;
	import game.enum.ErrorCode;
	import game.enum.FlowActionEnum;
	import game.enum.PaymentType;
	import game.net.IntResponsePacket;
	import game.net.RequestPacket;
	import game.net.ResponsePacket;
	import game.net.Server;
	import game.net.lobby.LobbyRequestType;
	import game.net.lobby.LobbyResponseType;
	import game.net.lobby.request.RequestExchangeMysticBox;
	import game.net.lobby.response.ResponseExchangeMysticBoxResult;
	import game.net.lobby.response.ResponseMysticBoxLog;

	import game.ui.ModuleID;

	import game.ui.hud.HUDModule;

	import game.ui.mystic_box.gui.ExchangeItem;

	/**
	 * ...
	 * @author
	 */
	public class MysticBoxModule extends ModuleBase
	{

		public function MysticBoxModule()
		{

		}

		private function get view():MysticBoxView
		{
			return baseView as MysticBoxView;
		}

		override protected function createView():void
		{
			baseView = new MysticBoxView();
			baseView.addEventListener("close", closeHandler);
			baseView.addEventListener(ExchangeItem.EXCHANGE, onExchangeHdl);
			baseView.addEventListener(MysticBoxView.BUY_EXTRA_USE, onBuyExtraUseHdl);
		}

		private function onBuyExtraUseHdl(event:EventEx):void
		{
			Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.REQUEST_BUY_EXTRA_USE_MYSTIC_BOX));
		}

		private function onExchangeHdl(event:EventEx):void
		{
			Game.network.lobby.sendPacket(new RequestExchangeMysticBox(LobbyRequestType.EXCHANGE_MYSTIC_BOX, event.data.id, event.data.quantity));
		}

		override protected function preTransitionIn():void
		{
			super.preTransitionIn();
		}

		override protected function onTransitionInComplete():void
		{
			super.onTransitionInComplete();
			Game.network.lobby.addEventListener(Server.SERVER_DATA, onLobbyServerData);
			Game.database.userdata.addEventListener(UserData.UPDATE_PLAYER_INFO, onUpdatePlayerInfo);
			Game.database.inventory.addEventListener(Inventory.UPDATE_ITEM, onInventoryItemUpdate);

			Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.REQUEST_MYSTIC_BOX_LOG));
			Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.GET_ITEM_INVENTORY));
			Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.GET_PLAYER_INFO));

//			view.updateNumOfUse();
		}

		override protected function onTransitionOutComplete():void
		{
			super.onTransitionOutComplete();
			Game.network.lobby.removeEventListener(Server.SERVER_DATA, onLobbyServerData);
			Game.database.userdata.removeEventListener(UserData.UPDATE_PLAYER_INFO, onUpdatePlayerInfo);
			Game.database.inventory.removeEventListener(Inventory.UPDATE_ITEM, onInventoryItemUpdate);
		}

		private function onInventoryItemUpdate(event:Event):void
		{
			view.updateItems();
		}

		private function onUpdatePlayerInfo(e:Event):void
		{
			view.update();
		}

		private function onLobbyServerData(e:EventEx):void
		{
			var packet:ResponsePacket = ResponsePacket(e.data);
			switch (packet.type)
			{
				case LobbyResponseType.EXCHANGE_MYSTIC_BOX_RESULT:
						onExchangeResult(packet as ResponseExchangeMysticBoxResult);
					break;
				case LobbyResponseType.MYSTIC_BOX_LOG_RESULT:
						onLogResult(packet as ResponseMysticBoxLog);
					break;
				case LobbyResponseType.MYSTIC_BOX_BUY_RESULT:
						onBuyResult(packet as IntResponsePacket);
					break;
			}
		}

		private function onBuyResult(packet:IntResponsePacket):void
		{
			Utility.log("onBuyResult > " + packet.value);
			switch(packet.value)
			{
				case ErrorCode.SUCCESS:
					Manager.display.showMessageID(159);
					Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.GET_PLAYER_INFO));
					break;
				case ErrorCode.FAIL:
					Manager.display.showMessageID(160);
					break;
				case 2: //not enough money
					Game.flow.doAction(FlowActionEnum.PURCHASE_RESOURCE, PaymentType.XU_NORMAL.ID);
					break;
				case 3: //SECRET_GIFT_BUY_USE_MORE_FAIL_CONFIG
					Utility.error("Hop qua than bi config sai");
					break;
			}
		}

		private function onLogResult(packet:ResponseMysticBoxLog):void
		{
			view.showLog(packet.logs);
		}

		private function onExchangeResult(packet:ResponseExchangeMysticBoxResult):void
		{
			Utility.log("onExchangeMysticBoxResult: " + packet.errorCode);
			switch (packet.errorCode)
			{
				case 0://Success
					view.showAnim(packet.vo);
					Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.GET_ITEM_INVENTORY));
					break;
				case 1://Fail
					break;
				case 2://not enough money
					Manager.display.showMessage("Không đủ tiền");
					break;
				case 3://UPGRADE_FAIL_NOT_ENOUGH_LEVEL
					Manager.display.showMessageID(147);
					break;
				case 4://UPGRADE_FAIL_CONFIG
					Manager.display.showMessage("Chưa config dữ liệu");
					break;
				case 5://UPGRADE_FAIL_NOT_ENOUGH_ITEM_SOURCE
					Manager.display.showMessageID(156);
					break;
				case 6://UPGRADE_FAIL_FULL_INVENTORY
					Manager.display.showMessageID(157);
					break;
				case 7://SECRET_GIFT_UPGRADE_FAIL_TIME_OVER
					Manager.display.showMessageID(161);
					break;
			}

			Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.GET_PLAYER_INFO));
		}

		override protected function preTransitionOut():void
		{
			super.preTransitionOut();
		}

		private function closeHandler(e:Event):void
		{
			var hudModule:HUDModule = Manager.module.getModuleByID(ModuleID.HUD) as HUDModule;
			if (hudModule != null)
			{
				hudModule.updateHUDButtonStatus(ModuleID.MYSTIC_BOX, false);
			}
		}
	}

}