package game.ui.charge_event
{
	import core.display.ModuleBase;
	import core.event.EventEx;
	import core.Manager;
	import flash.events.Event;
	import game.Game;
	import game.net.IntResponsePacket;
	import game.net.lobby.LobbyRequestType;
	import game.net.lobby.LobbyResponseType;
	import game.net.lobby.response.ResponseGetConsumeEventInfo;
	import game.net.lobby.response.ResponseGetPaymentEventInfo;
	import game.net.RequestPacket;
	import game.net.ResponsePacket;
	import game.net.Server;
	import game.ui.hud.HUDModule;
	import game.ui.ModuleID;
	
	/**
	 * ...
	 * @author chuongth2
	 */
	public class ChargeEventModule extends ModuleBase
	{
		public static const CLOSE_CHARGE_EVENT_VIEW:String = "close_Charge_Event_View";
		
		override protected function createView():void
		{
			super.createView();
			baseView = new ChargeEventView();
			baseView.addEventListener(CLOSE_CHARGE_EVENT_VIEW, onCloseChargeView);
		}
		
		private function onCloseChargeView(e:Event):void
		{
			var hudModule:HUDModule = Manager.module.getModuleByID(ModuleID.HUD) as HUDModule;
			if (hudModule != null)
			{
				hudModule.updateHUDButtonStatus(ModuleID.CHARGE_EVENT, false);
			}
		}
		
		override protected function transitionIn():void
		{
			super.transitionIn();
			Game.network.lobby.addEventListener(Server.SERVER_DATA, onLobbyServerData);
			Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.GET_PAYMENT_EVENT_INFO));
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
				case LobbyResponseType.GET_PAYMENT_EVENT_INFO: 
					onGetPaymentEventInfo(packet as ResponseGetPaymentEventInfo);
					break;
				case LobbyResponseType.RECEIVE_PAYMENT_EVENT_REWARD: 
					onReceivePaymentEventReward(packet as IntResponsePacket);
					break;
			
			}
		}
		
		private function onGetPaymentEventInfo(responseGetPaymentEventInfo:ResponseGetPaymentEventInfo):void 
		{
			ChargeEventView(baseView).update(responseGetPaymentEventInfo);
		}
		
	
		private function onReceivePaymentEventReward(intResponsePacket:IntResponsePacket):void
		{
			switch (intResponsePacket.value)
			{
				case 0: //success
					Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.GET_PAYMENT_EVENT_INFO));
					Manager.display.showMessage("Nhận thành công^^");
					break;
				case 1: //fail
					break;
				case 2: //full inventory
					Manager.display.showMessage("Thùng đồ đã đầy ^^");
					break;
				case 3: //ko du dieu kien nhan
					break;
				case 4: //da nhan roi
					Manager.display.showMessage("Đã nhận rồi ^^");
					break;
				case 5: //da het thoi gian nhan thuong
					Manager.display.showMessage("Đã hết thời gian nhận thưởng ^^");
					break;
			}
		}
	}

}