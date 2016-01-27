package game.ui.shop_pack 
{
	import core.display.ModuleBase;
	import core.event.EventEx;
	import core.Manager;
	import core.util.Utility;
	import flash.events.Event;
	import game.data.xml.ShopXML;
	import game.enum.FlowActionEnum;
	import game.enum.ItemType;
	import game.enum.PaymentType;
	import game.Game;
	import game.net.IntResponsePacket;
	import game.net.lobby.LobbyRequestType;
	import game.net.lobby.LobbyResponseType;
	import game.net.lobby.request.RequestBuyItem;
	import game.net.lobby.response.ResponseListItemShopDaily;
	import game.net.RequestPacket;
	import game.net.ResponsePacket;
	import game.net.Server;
	import game.net.StringResponsePacket;
	import game.ui.hud.HUDModule;
	import game.ui.hud.HUDView;
	import game.ui.message.MessageID;
	import game.ui.ModuleID;
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class ShopItemModule extends ModuleBase
	{
		
		private var _itemSelected:ShopXML;
		
		public function ShopItemModule() 
		{
			
		}
		
		override protected function createView():void 
		{
			super.createView();
			
			baseView = new ShopItemView();
			baseView.addEventListener(Event.CLOSE, onCloseHdl);
			baseView.addEventListener(ItemPackMov.BUY_ITEM_PACK, onBuyItemHdl);
			baseView.addEventListener(Event.COMPLETE, onCountDownCompleteHdl);
			baseView.addEventListener(ShopItemView.UPDATE_NEW_ITEM_BOUGHT, onUpdateNewItemBoughtHdl);
		}
		
		private function onUpdateNewItemBoughtHdl(e:Event):void 
		{
			var hudModule:HUDModule = Manager.module.getModuleByID(ModuleID.HUD) as HUDModule;
			if (hudModule && hudModule.baseView) {
				(hudModule.baseView as HUDView).updateShopItemState(1);
			}
		}
		
		private function onCountDownCompleteHdl(e:Event):void 
		{
			Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.GET_SERVER_TIME));
		}
		
		private function onBuyItemHdl(e:EventEx):void 
		{
			//check valid buy item before send packet
			_itemSelected = e.data.info as ShopXML;
			if (_itemSelected)
				Game.network.lobby.sendPacket(new RequestBuyItem(LobbyRequestType.SHOP_BUY_SINGLE_ITEM, _itemSelected.ID, e.data.quantity));
		}
		
		private function onCloseHdl(e:Event):void 
		{
			var hudModule:HUDModule = Manager.module.getModuleByID(ModuleID.HUD) as HUDModule;
			if (hudModule != null && HUDView(hudModule.baseView).shopItemBtn.isSelected) 
			{
				hudModule.updateHUDButtonStatus(ModuleID.SHOP_ITEM, false);
			}
			else 
			{
				Manager.display.hideModule(ModuleID.SHOP_ITEM);
			}
		}
		
		override protected function transitionIn():void 
		{
			super.transitionIn();
			
			Game.network.lobby.addEventListener(Server.SERVER_DATA, onLobbyServerData);	
			Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.GET_LIST_ITEM_BOUGHT_SHOP_DAILY));
			Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.GET_SERVER_TIME));
			//updateTimeCountDown();
			(baseView as ShopItemView).updateItemDisplay(this.extraInfo as int);
		}
		
		private function onLobbyServerData(e:EventEx):void 
		{
			var packet:ResponsePacket = e.data as ResponsePacket;
			switch(packet.type) {
				case LobbyResponseType.RECEIVE_LIST_ITEM_BOUGHT_SHOP_DAILY:
					var packetListItem:ResponseListItemShopDaily = packet as ResponseListItemShopDaily;
					(baseView as ShopItemView).updateListItemBought(packetListItem.itemArr);
					//(view as ShopItemView).updateValidBuy();
					break;
				case LobbyResponseType.BUY_ITEM_RESULT:
					var packetBuyResult:IntResponsePacket = packet as IntResponsePacket;
					Utility.log("buy item result errorcode is: " + packetBuyResult.value);
					switch(packetBuyResult.value) {
						case 0:
							Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.GET_LIST_ITEM_BOUGHT_SHOP_DAILY));
							Manager.display.showMessageID(MessageID.SHOP_ITEM_BUY_SUCCESS);
							break;
							/*BUY_ITEM_SUCCESS            = 0,
							BUY_ITEM_FAILED             = 1,
							BUY_ITEM_FAILED_PACKET      = 2,
							BUY_ITEM_FULL_INVENT        = 3,
							BUY_ITEM_NOT_ENOUGH_MONEY   = 4,
							BUY_ITEM_FAILED_CONDITION   = 5,
							BUY_ITEM_FAILED_MAX_QUANTITY    = 6,
							BUY_ITEM_FAILED_TIME        = 7,
							BUY_ITEM_FAILED_LEVEL       = 8,
							BUY_ITEM_FAILED_VIP_NOT_ITEM    = 9,
							BUY_ITEM_FAILED_VIP_NOT_ENOUGH  = 10,
							BUY_ITEM_FAILED_VIP_MAX_QUANTITY = 11,*/
						case 3:
							Manager.display.showMessageID(MessageID.SHOP_ITEM_BUY_FAIL_FULL_INVENTORY);
							break;
						case 4:
							//Manager.display.showMessageID(MessageID.SHOP_ITEM_BUY_FAIL_NOT_ENOUGH_MONEY);
							if (_itemSelected) {
								switch(_itemSelected.paymentType.ID) {
									case PaymentType.GOLD.ID:
									case PaymentType.XU_NORMAL.ID:
										Game.flow.doAction(FlowActionEnum.PURCHASE_RESOURCE, _itemSelected.paymentType.ID);
										break;
									default:
										Manager.display.showMessageID(MessageID.SHOP_ITEM_BUY_FAIL_NOT_ENOUGH_MONEY);
										break;
								}
							}
							break;
						case 6:
							Manager.display.showMessageID(MessageID.SHOP_ITEM_BUY_FAIL_REACH_MAX_QUANTITY);
							break;
						case 7:
							Manager.display.showMessageID(MessageID.SHOP_ITEM_BUY_FAIL_OUT_OF_TIME);
							break;
						case 8:
							Manager.display.showMessageID(MessageID.SHOP_ITEM_BUY_FAIL_NOT_ENOUGH_LEVEL);
							break;	
						default:
							Manager.display.showMessageID(MessageID.SHOP_ITEM_BUY_FAIL);
							break;
					}
					_itemSelected = null;
					break;
				case LobbyResponseType.RECEIVE_SERVER_TIME:
					var packetTime:StringResponsePacket = packet as StringResponsePacket;
					(baseView as ShopItemView).setTimeCountDown(packetTime.value);
					break;	
			}
		}
		
		override protected function onTransitionOutComplete():void 
		{
			super.onTransitionOutComplete();
			
			Game.network.lobby.removeEventListener(Server.SERVER_DATA, onLobbyServerData);	
		}
	}

}