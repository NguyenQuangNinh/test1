package game.ui.present
{
	import core.display.layer.Layer;
	import core.display.ModuleBase;
	import core.event.EventEx;
	import core.Manager;
	import core.util.Utility;
	import flash.events.DataEvent;
	import flash.events.Event;
	import game.enum.DialogEventType;
	import game.Game;
	import game.net.IntRequestPacket;
	import game.net.IntResponsePacket;
	import game.net.lobby.LobbyRequestType;
	import game.net.lobby.LobbyResponseType;
	import game.net.lobby.response.ResponseBuyItemShopVipResult;
	import game.net.lobby.response.ResponseGetRewardGiftCode;
	import game.net.lobby.response.ResponseGetRewardRequireLevelInfo;
	import game.net.lobby.response.ResponseGetShopVipInfo;
	import game.net.lobby.response.ResponseGetTopLevelInPresent;
	import game.net.lobby.response.ResponseLeaderBoard;
	import game.net.RequestPacket;
	import game.net.ResponsePacket;
	import game.net.Server;
	import game.net.StringRequestPacket;
	import game.ui.dialog.DialogID;
	import game.ui.hud.HUDModule;
	import game.ui.ModuleID;
	
	/**
	 * ...
	 * @author chuongth2
	 */
	public class PresentModule extends ModuleBase
	{
		
		public static const CLOSE_PRESENT_VIEW:String = "close_Present_View";
		public static const REQUEST_REWARD_GIFT_CODE:String = "request_Reward_GiftCode";
		
		private var cacheNotifyBtnName:String = "";
		
		public function PresentModule()
		{
		
		}
		
		override protected function createView():void
		{
			super.createView();
			baseView = new PresentView();
			baseView.addEventListener(CLOSE_PRESENT_VIEW, closePresentViewHandler);
			baseView.addEventListener(REQUEST_REWARD_GIFT_CODE, requestGiftCodeHandler);
		}
		
		override protected function transitionIn():void
		{
			super.transitionIn();
			PresentView(baseView).reset();
			//action cache notify
			if (cacheNotifyBtnName != "")
				setButtonPresentNotify(cacheNotifyBtnName, true);
			cacheNotifyBtnName = "";
		}
		
		override protected function onTransitionInComplete():void
		{
			super.onTransitionInComplete();
			Game.network.lobby.addEventListener(Server.SERVER_DATA, onLobbyServerResponeHdl);
			if(extraInfo==null)
				PresentView(baseView).setIndex(0);
			else
				PresentView(baseView).setIndex(extraInfo.tap as int);
		}
		
		override protected function onTransitionOutComplete():void
		{
			super.onTransitionOutComplete();
			Game.network.lobby.removeEventListener(Server.SERVER_DATA, onLobbyServerResponeHdl);
		
		}
		
		private function requestGiftCodeHandler(e:EventEx):void
		{
			var giftcode:String = e.data as String;
			//btn giftcode
			Game.network.lobby.sendPacket(new StringRequestPacket(LobbyRequestType.GET_REWARD_GIFT_CODE, giftcode, 32));
		}
		
		private function onLobbyServerResponeHdl(e:EventEx):void
		{
			var packet:ResponsePacket = e.data as ResponsePacket;
			switch (packet.type)
			{
				case LobbyResponseType.GET_TOP_LEVEL_IN_PRESENT: 
				{
					
					var packetGetTopLevelInPresent:ResponseGetTopLevelInPresent = packet as ResponseGetTopLevelInPresent;
					if (packetGetTopLevelInPresent != null)
						PresentView(baseView).updatePresentTop(packetGetTopLevelInPresent);
				}
					break;
				case LobbyResponseType.GET_REWARD_GIFT_CODE_RESULT: 
				{
					var packetGetRewardGiftCode:ResponseGetRewardGiftCode = packet as ResponseGetRewardGiftCode;
					if (packetGetRewardGiftCode != null)
					{
						PresentView(baseView).giftCodeView.btnGiftCode.mouseEnabled = true;
						
						var obj:Object = {};
						obj.errorcode = packetGetRewardGiftCode._errorCode;
						obj.arrRewardID = [];
						switch (packetGetRewardGiftCode._errorCode)
						{
							case 0:
								obj.content = "Phần thưởng Giftcode";
								obj.arrRewardID = packetGetRewardGiftCode._arrRewardID;
								obj.noAnim = true;
								Manager.display.showDialog(DialogID.GIFT_CODE_DIALOG, onOkGiftCodeDialog, null, obj, Layer.BLOCK_ALPHA);
								break;
							case 1:
								Manager.display.showMessage("Gift code nhập không hợp lệ ^^");
								break;
							case 3:
								Manager.display.showMessage("Gift code đã được sử dụng trước đó ^^");
								break;
							case 4:
								Manager.display.showMessage("Gift code không được nhập 2 lần liên tiếp trong 3 giây ^^");
								break;
							case 5:
								Manager.display.showMessage("Gift code nhập sai");
								break;
							case 6:
								Manager.display.showMessage("Level không phù hợp để nhận giftcode");
								break;
							case 7:
								Manager.display.showMessage("Server không hợp lệ");
								break;
						}
					}
				}
					break;
				case LobbyResponseType.GET_REWARD_REQUIRE_LEVEL_INFO: 
				{
					var packetResponseGetRewardRequireLevelInfo:ResponseGetRewardRequireLevelInfo = packet as ResponseGetRewardRequireLevelInfo;
					PresentView(baseView).initRewardLevelView(packetResponseGetRewardRequireLevelInfo);
				}
					break;
				case LobbyResponseType.RECEIVE_REWARD_REQUIRE_LEVEL: 
				{
					
					var packetResponse:IntResponsePacket = packet as IntResponsePacket;
					if (packetResponse)
					{
						switch (packetResponse.value)
						{
							case 0: //success
								Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.GET_REWARD_REQUIRE_LEVEL_INFO));
								Manager.display.showMessage("Nhận thưởng thành công");
								break;
							case 1: //fail
								break;
							case 2: //full inventory
								Manager.display.showMessage("Hành Trang đã đầy");
								break;
							case 3: //đã nhận rồi
								Manager.display.showMessage("Đại Hiệp đã nhận thưởng rồi");
								break;
							case 4: //ko đủ level
								Manager.display.showMessage("Đại Hiệp không đủ cấp để nhận thưởng");
								break;
						}
					}
				}
					break;
				
				case LobbyResponseType.BUY_ITEM_SHOP_VIP_RESULT: 
				{
					var packetResponseBuyItemShopVip:ResponseBuyItemShopVipResult = packet as ResponseBuyItemShopVipResult;
					if (packetResponseBuyItemShopVip)
					{
						switch (packetResponseBuyItemShopVip.errorCode)
						{
							case 0: //success
								switch (packetResponseBuyItemShopVip.nShopVip)
							{
								case 1: 
								{
									Manager.display.showMessage("Nhận Ngũ phái đại để tử thành công");
									Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.GET_SHOP_VIP_INFO, 1));
								}
									break;
								case 3: 
								{
									Manager.display.showMessage("Mua Đệ tử chân truyền thành công");
									Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.GET_SHOP_VIP_INFO, 3));
								}
									break;
								case 5: 
								{
									Manager.display.showMessage("Mua Cao thủ ngũ phái thành công");
									Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.GET_SHOP_VIP_INFO, 5));
								}
									break;
							}
								
								break;
							case 3: //full inventory
								Manager.display.showMessage("Đội hình đã đầy");
								break;
							case 4: //ko du vang
								Manager.display.showMessage("Không đủ vàng");
								break;
							case 11: //đã nhận rồi
								Manager.display.showMessage("Đại Hiệp đã nhận mua 1 đệ tử rồi");
								break;
							default: 
								//Manager.display.showMessage("Thao tác thất bại ^^");
								break;
						}
					}
				}
					break;
				
				case LobbyResponseType.GET_SHOP_VIP_INFO: 
				{
					var packetGetShopVipInfo:ResponseGetShopVipInfo = packet as ResponseGetShopVipInfo;
					if (packetGetShopVipInfo)
					{
						PresentView(baseView).updateShopVip(packetGetShopVipInfo);
					}
					
				}
					break;
			}
		}
		
		public function onOkGiftCodeDialog(_data:Object):void
		{
			var x:int = 0;
			x++;
		}
		
		private function closePresentViewHandler(e:Event):void
		{
			var hudModule:HUDModule = Manager.module.getModuleByID(ModuleID.HUD) as HUDModule;
			if (hudModule != null)
			{
				hudModule.updateHUDButtonStatus(ModuleID.PRESENT, false);
			}
		
			//Manager.display.hideModule(ModuleID.PRESENT);
		}
		
		public function setButtonPresentNotify(btnName:String, val:Boolean):void
		{
			if (baseView)
				PresentView(baseView).setNotify(btnName, val);
			else
			{
				//cache cho lan sau
				cacheNotifyBtnName = btnName;
			}
		}
	}

}