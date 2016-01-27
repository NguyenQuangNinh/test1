package game.ui.open_present_vip
{
	import core.display.ModuleBase;
	import core.event.EventEx;
	import core.Manager;
	import flash.events.Event;
	import game.enum.ErrorCode;
	import game.Game;
	import game.net.IntResponsePacket;
	import game.net.lobby.LobbyRequestType;
	import game.net.lobby.LobbyResponseType;
	import game.net.lobby.response.ResponseConsumeItem;
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
	public class OpenPresentVipModule extends ModuleBase
	{
		public static const CLOSE_OPEN_PRESENT_VIP_VIEW:String = "close_Open_Present_Vip_View";
		
		override protected function createView():void
		{
			super.createView();
			baseView = new OpenPresentVipView();
			baseView.addEventListener(CLOSE_OPEN_PRESENT_VIP_VIEW, onCloseView);
		}
		
		private function onCloseView(e:Event):void
		{
			Manager.display.hideModule(ModuleID.OPEN_PRESENT_VIP);
		}
		
		override protected function preTransitionIn():void 
		{
			super.preTransitionIn();
			OpenPresentVipView(baseView).update(extraInfo);
		}
		override protected function transitionIn():void
		{
			super.transitionIn();
			Game.network.lobby.addEventListener(Server.SERVER_DATA, onLobbyServerData);
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
				case LobbyResponseType.CONSUME_ITEM: 
					onConsumeItemResponse(packet as ResponseConsumeItem);
					break;
			}
		}
		
		private function onConsumeItemResponse(packet:ResponseConsumeItem):void
		{
			OpenPresentVipView(baseView).resetButton();
			switch (packet.errorCode)
			{
				case 0: //success
					OpenPresentVipView(baseView).startAnimOpen(packet.indexes[0]);
					break;
				case 1: //fail
					break;
				case 2: //full inventory
					Manager.display.showMessage("Thùng đồ đã đầy ^^");
					break;
				case 3: //one empty slot
					Manager.display.showMessage("Cần 1 ô trống trong thùng đồ ^^");
					break;
			}
		}
	}

}