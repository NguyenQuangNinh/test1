package game.ui.shop.shop_secret_merchant 
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.utils.Timer;
	
	import core.Manager;
	import core.display.ViewBase;
	import core.event.EventEx;
	import core.util.FontUtil;
	import core.util.Utility;
	
	import game.Game;
	import game.data.model.shop.SecretMerchantShopConfig;
	import game.data.xml.DataType;
	import game.data.xml.SecretMerchantEventXML;
	import game.data.xml.ShopXML;
	import game.enum.ErrorCode;
	import game.enum.Font;
	import game.net.IntResponsePacket;
	import game.net.RequestPacket;
	import game.net.ResponsePacket;
	import game.net.Server;
	import game.net.lobby.LobbyRequestType;
	import game.net.lobby.LobbyResponseType;
	import game.net.lobby.response.ResponseSecretMerchantInfo;
	import game.net.lobby.response.ResponseSecretMerchantList;
	import game.ui.ModuleID;
	import game.utility.UtilityUI;
	
	/**
	 * ...
	 * @author MaiPTT
	 */
	public class ShopSecretMerchantView extends ViewBase 
	{
		private static const REFRESH_DURATION	:int = 5000;
		public var btnClose				:SimpleButton;
		public var itemsScrollbar		:ShopItemScrollbar;
		public var itemsMovMask			:MovieClip;
		public var itemsMovContent		:MovieClip;
		public var listPlayersScrollbar	:ListPlayerScrollbar;
		public var listPlayersMovMask	:MovieClip;
		public var listPlayersMovContent:MovieClip;
		public var txtTimer				:TextField;
		
		private var items				:Array;
		private var listPlayers			:Array;
		private var soldItemsID			:Array;
		private var soldItemsQuantity	:Array;
		private var requestTimer		:Timer;
		private var timer				:Timer;
		private var timerCount			:int;
		
		public function ShopSecretMerchantView() {
			items = [];
			listPlayers = [];
			requestTimer = new Timer(REFRESH_DURATION, 0);
			timer = new Timer(1000, 0);
			timerCount = -1;
			timer.addEventListener(TimerEvent.TIMER, onTimerEventHdl);
			requestTimer.addEventListener(TimerEvent.TIMER, onTimerEventHdl);
			initUI();
			btnClose.addEventListener(MouseEvent.CLICK, onBtnClickHdl);
		}
		
		override public function transitionIn():void {
			super.transitionIn();
			Game.network.lobby.addEventListener(Server.SERVER_DATA, onResponseServerDataHdl);
			if (!requestTimer.running) {
				requestTimer.start();
			}
			var secretMerchantShop:SecretMerchantEventXML = Game.database.gamedata.getData(DataType.SECRET_MERCHANT_EVENT,
															Game.database.userdata.secretMerchantEventID) as SecretMerchantEventXML;
			if (secretMerchantShop) {
				for each (var serverConfig:SecretMerchantShopConfig in secretMerchantShop.serverDatas) {
					if (serverConfig && serverConfig.serverID == parseInt(Game.database.flashVar.server)) {
						break;
					}
				}
			}
			
			if (serverConfig) {
				for (var i:int = 0; i < serverConfig.openTime.length; i++) {
					var timeNow:Number = new Date().getTime() + Game.database.userdata.serverTimeDifference;
					if (timeNow >= serverConfig.openTime[i]
						&& timeNow < serverConfig.closeTime[i]) {
							timerCount = Math.floor((serverConfig.closeTime[i] - timeNow) / 1000);
							timer.repeatCount = timerCount;
							if (!timer.running) {
								timer.start();
							}
							break;
						}
				}
			}
		}
		
		override protected function transitionInComplete():void {
			super.transitionInComplete();
			Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.SECRET_MERCHANT_INFO));
			Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.SECRET_MERCHANT_LIST_PLAYERS));
		}
		
		override public function transitionOut():void {
			super.transitionOut();
			Game.network.lobby.removeEventListener(Server.SERVER_DATA, onResponseServerDataHdl);
			if (requestTimer.running) {
				requestTimer.stop();
			}
		}
		
		private function onTimerEventHdl(e:TimerEvent):void {
			switch(e.target) {
				case requestTimer:
					Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.SECRET_MERCHANT_INFO));
					Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.SECRET_MERCHANT_LIST_PLAYERS));	
					break;
					
				case timer:
					timerCount --;
					txtTimer.text = Utility.math.formatTime("H-M-S", timerCount);
					if (timerCount == 0) {
						timer.stop();
						Manager.display.hideModule(ModuleID.SHOP_SECRET_MERCHANT);
					}
					break;
			}
		}
		
		private function onResponseServerDataHdl(e:EventEx):void {
			var packet:ResponsePacket = e.data as ResponsePacket;
			switch(packet.type) {
				case LobbyResponseType.SECRET_MERCHANT_INFO:
					onResponseItemsInfo(packet as ResponseSecretMerchantInfo);
					break;
					
				case LobbyResponseType.BUY_ITEM_RESULT:
					onResponseBuyItemResult(packet as IntResponsePacket);
					break;
					
				case LobbyResponseType.SECRET_MERCHANT_PLAYERS_LIST:
					onResponseMerchantPlayersList(packet as ResponseSecretMerchantList);
					break;
			}
		}
		
		private function onResponseMerchantPlayersList(packet:ResponseSecretMerchantList):void {
			for each (var consumePlayerView:ConsumePlayerView in listPlayers) {
				listPlayersMovContent.removeChild(consumePlayerView);
				Manager.pool.push(consumePlayerView, ConsumePlayerView);
			}
			listPlayers.splice(0);
			
			var item_y:int = 0;
			for each (var data:ConsumePlayer in packet.players) {
				consumePlayerView = Manager.pool.pop(ConsumePlayerView) as ConsumePlayerView;
				consumePlayerView.setData(data);
				consumePlayerView.y = item_y + 10;
				listPlayersMovContent.addChild(consumePlayerView);
				listPlayers.push(consumePlayerView);
				
				item_y += consumePlayerView.height;
			}
			
			if (!listPlayersScrollbar.isInit) {
				listPlayersScrollbar.init(listPlayersMovContent
								, listPlayersMovMask, "vertical", true, false, false, 15);
			} else {
//				listPlayersScrollbar.reInit();
				listPlayersScrollbar.update();
			}
		}
		
		private function onResponseBuyItemResult(packet:IntResponsePacket):void {
			Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.SECRET_MERCHANT_INFO));
			switch(packet.value) {
				case ErrorCode.SUCCESS:
					Manager.display.showMessage("Chúc mừng bạn đã mua thành công");
					Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.SECRET_MERCHANT_LIST_PLAYERS));
					break;
					
				case 3:
					Manager.display.showMessage("Thùng đồ của bạn đã đầy, không thể mua thêm.");
					break;
					
				case 4:
					Manager.display.showMessage("Bạn không đủ tiền để mua vật phẩm này");
					break;
					
				case 5:
					Manager.display.showMessage("Bạn không đạt đủ yêu cầu để mua vật phẩm này.");
					break;
					
				case 6:
					Manager.display.showMessage("Vượt quá số lượng mua tối đa.");
					break;
			}
		}
		
		private function onResponseItemsInfo(packet:ResponseSecretMerchantInfo):void {
			soldItemsID == null ? soldItemsID = [] : soldItemsID.splice(0);
			soldItemsQuantity == null ? soldItemsQuantity = [] : soldItemsQuantity.splice(0);
			soldItemsID = packet.shopIDs;
			soldItemsQuantity = packet.quantities;
			initShopView();
		}
		
		private function onBtnClickHdl(e:MouseEvent):void {
			switch(e.target) {
				case btnClose:
					Manager.display.hideModule(ModuleID.SHOP_SECRET_MERCHANT);
					break;
			}
		}
		
		private function initShopView():void {
			for each (var shopItem:ShopItem in items) {
				itemsMovContent.removeChild(shopItem);
				shopItem.reset();
				Manager.pool.push(shopItem, ShopItem);
			}
			items.splice(0);
			
			var length:int = Math.min(soldItemsID.length, soldItemsQuantity.length);
			for (var index:int = 0; index < length; index++) {
				var shopXML:ShopXML = Game.database.gamedata.getData(DataType.SHOP, soldItemsID[index]) as ShopXML;
				if (shopXML) {
					shopItem = Manager.pool.pop(ShopItem) as ShopItem;
					shopItem.setData(shopXML);
					shopItem.setQuantity(shopXML.maxBuyNum - soldItemsQuantity[index]);
					shopItem.x = 35 + (index % 2) * 242;
					shopItem.y = 13 + Math.floor(index / 2) * 110;
					itemsMovContent.addChild(shopItem);
					items.push(shopItem);
				} else {
					Utility.error("Shop Secret Merchant ID: " + soldItemsID[index] + " not found");
				}
			}
			
			if (!itemsScrollbar.isInit) {
				itemsScrollbar.init(itemsMovContent
								, itemsMovMask, "vertical", true, false, false, 20);
			} else {
//				itemsScrollbar.reInit();
				itemsScrollbar.update();
			}
		}
		
		private function initUI():void {
			btnClose = UtilityUI.getComponent(UtilityUI.CLOSE_BTN) as SimpleButton;
			btnClose.x = 1065;
			btnClose.y = 125;
			addChild(btnClose);
			
			FontUtil.setFont(txtTimer, Font.ARIAL);
			
			itemsScrollbar.init(itemsMovContent
								, itemsMovMask, "vertical", true, false, false, 20);
			listPlayersScrollbar.init(listPlayersMovContent
									, listPlayersMovMask, "vertical", true, false, false, 15 );
		}
	}

}