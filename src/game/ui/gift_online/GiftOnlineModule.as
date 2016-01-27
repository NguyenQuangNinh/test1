package game.ui.gift_online
{
	import core.display.ModuleBase;
	import core.event.EventEx;
	import core.Manager;
	import flash.events.Event;
	import game.Game;
	import game.net.IntResponsePacket;
	import game.net.lobby.LobbyRequestType;
	import game.net.lobby.LobbyResponseType;
	import game.net.lobby.response.ResponseGetGiftOnlineInfo;
	import game.net.RequestPacket;
	import game.net.ResponsePacket;
	import game.net.Server;
	import game.ui.hud.gui.GiftOnlineButton;
	import game.ui.hud.HUDButtonID;
	import game.ui.hud.HUDModule;
	import game.ui.hud.HUDView;
	import game.ui.ModuleID;
	
	/**
	 * ...
	 * @author chuongth2
	 */
	public class GiftOnlineModule extends ModuleBase
	{
		public static const CLOSE_GIFT_ONLINE_VIEW:String = "close_Gift_Online_View";
		
		override protected function createView():void
		{
			super.createView();
			baseView = new GiftOnlineView();
			baseView.addEventListener(CLOSE_GIFT_ONLINE_VIEW, onCloseView);
		}
		
		private function onCloseView(e:Event):void
		{
			var hudModule:HUDModule = Manager.module.getModuleByID(ModuleID.HUD) as HUDModule;
			if (hudModule != null)
			{
				hudModule.updateHUDButtonStatus(ModuleID.GIFT_ONLINE, false);
			}
		}
		
		override protected function transitionIn():void
		{
			super.transitionIn();
			
			Game.network.lobby.addEventListener(Server.SERVER_DATA, onLobbyServerData);
			Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.GET_GIFT_ONLINE_INFO));
		}
		
		override protected function onTransitionInComplete():void
		{
			super.onTransitionInComplete();
		
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
				case LobbyResponseType.GET_GIFT_ONLINE_INFO: 
					onGetGiftOnlineInfo(packet as ResponseGetGiftOnlineInfo);
					break;
				case LobbyResponseType.RECEIVE_GIFT_ONLINE_REWARD: 
					onReceiveGiftOnlineReward(packet as IntResponsePacket);
					break;
			}
		}
		
		private function onGetGiftOnlineInfo(responseGetGiftOnlineInfo:ResponseGetGiftOnlineInfo):void
		{
			GiftOnlineView(baseView).update(responseGetGiftOnlineInfo);
			var hudModule:HUDModule = Manager.module.getModuleByID(ModuleID.HUD) as HUDModule;
			if (hudModule)
			{
				
				var btn:GiftOnlineButton = HUDView(hudModule.baseView).getBtnInstanceByName(HUDButtonID.GIFT_ONLINE.name) as GiftOnlineButton;
				if (btn)
				{
					btn.startCountDown(responseGetGiftOnlineInfo.nDiffSecond);
				}
			}
		}
		
		private function onReceiveGiftOnlineReward(intResponsePacket:IntResponsePacket):void
		{
			switch (intResponsePacket.value)
			{
				case 0: //success
					Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.GET_GIFT_ONLINE_INFO));
					Manager.display.showMessage("Nhận thành công^^");
					
					var hudModule:HUDModule = Manager.module.getModuleByID(ModuleID.HUD) as HUDModule;
					if (hudModule)
					{
						hudModule.setButtonNotify(HUDButtonID.GIFT_ONLINE.name, false, null);
					}
					
					break;
				case 1: //fail
					Manager.display.showMessage("Nhận thưởng thất bại ^^");
					break;
				case 2: //khong du xu
					Manager.display.showMessage("Không đủ vàng để nhận thưởng nhanh ^^");
					break;
				case 3: //full inventory
					Manager.display.showMessage("Thùng đồ đã đầy ^^");
					break;
				case 4: //chua du thoi gian online
					Manager.display.showMessage("Chưa đủ thời gian online ^^");
					break;
			}
		}
	}

}