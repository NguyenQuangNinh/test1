package game.ui.shop_discount
{

	import core.Manager;
	import core.display.ModuleBase;
	import core.event.EventEx;
	import core.util.Utility;

	import flash.events.Event;

	import game.Game;
	import game.enum.PlayerAttributeID;
	import game.net.IntRequestPacket;
	import game.net.IntResponsePacket;
	import game.net.RequestPacket;
	import game.net.ResponsePacket;
	import game.net.Server;
	import game.net.lobby.LobbyRequestType;
	import game.net.lobby.LobbyResponseType;
	import game.net.lobby.response.ResponseDiscountShopItems;
	import game.ui.ModuleID;
	import game.ui.hud.HUDModule;

	import mx.events.Request;

	/**
	 * ...
	 * @author
	 */
	public class ShopDiscountModule extends ModuleBase
	{

		public function ShopDiscountModule()
		{

		}

		private function get view():ShopDiscountView
		{
			return baseView as ShopDiscountView;
		}

		override protected function createView():void
		{
			baseView = new ShopDiscountView();
			baseView.addEventListener("close", closeHandler);
			baseView.addEventListener(ShopDiscountView.BUY, buyHandler);
			baseView.addEventListener(ShopDiscountView.REFRESH_ITEM, refreshItemHdl);

		}

		private function refreshItemHdl(event:EventEx):void
		{
			Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.REQUEST_DISCOUNT_SHOP_ITEMS));
		}

		private function buyHandler(event:EventEx):void
		{
			Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.REQUEST_BUY_DISCOUNT_SHOP_ITEM, event.data as int));
		}

		override protected function preTransitionIn():void
		{
			super.preTransitionIn();
		}

		override protected function onTransitionInComplete():void
		{
			super.onTransitionInComplete();
			Game.network.lobby.addEventListener(Server.SERVER_DATA, onLobbyServerData);
			Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.REQUEST_DISCOUNT_SHOP_ITEMS));
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
				case LobbyResponseType.SHOP_DISCOUNT_ITEMS_RESULT:
					listItemsResult(packet as ResponseDiscountShopItems);
					break;
				case LobbyResponseType.SHOP_DISCOUNT_BUY_ITEM_RESULT:
					buyItemResult(packet as IntResponsePacket);
					break;

			}
		}

		private function buyItemResult(packet:IntResponsePacket):void
		{
			Utility.log("buyItemResult:" + packet.value);
			switch (packet.value)
			{
			    case 0://success
				    Manager.display.showMessageID(77);
				    Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.REQUEST_DISCOUNT_SHOP_ITEMS));
				    Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.GET_PLAYER_INFO_ATTRIBUTE, PlayerAttributeID.GOLD.ID));
				    Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.GET_PLAYER_INFO_ATTRIBUTE, PlayerAttributeID.XU.ID));
			        break;
			    case 1://fail
					Manager.display.showMessage("Mua vật phẩm thất bại");
			        break;
			    case 2://not enough money
				    Manager.display.showMessage("Không đủ vàng");
			        break;
				case 3://ITEM_IS_NOT_LISTED
					Manager.display.showMessage("Vật phẩm mua không tồn tại");
			        break;
			    case 4://CAN_NOT_BUY_MORE
				    Manager.display.showMessage("Đã hết số lần mua");
			        break;
			    case 5://NO_ITEM_LEFT_TO_BUY
				    Manager.display.showMessage("Đã bán hết vật phẩm");
			        break;
			}
		}

		private function listItemsResult(packet:ResponseDiscountShopItems):void
		{
			Utility.log("listItemsResult:" + packet.errorCode);
			switch (packet.errorCode)
			{
			    case 0://success
				    view.updateData(packet);
			        break;
			    case 1://fail

			        break;
			}
		}

		private function closeHandler(e:Event):void
		{
			var hudModule:HUDModule = Manager.module.getModuleByID(ModuleID.HUD) as HUDModule;
			if (hudModule != null)
			{
				hudModule.updateHUDButtonStatus(ModuleID.SHOP_DISCOUNT, false);
			}
		}
	}

}