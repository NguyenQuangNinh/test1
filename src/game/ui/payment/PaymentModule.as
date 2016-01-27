package game.ui.payment
{
	import core.display.layer.Layer;
	import core.display.ModuleBase;
	import core.event.EventEx;
	import core.Manager;
	import core.util.Utility;
	import flash.events.Event;
	import game.data.model.UserData;
	import game.Game;
	import game.net.IntResponsePacket;
	import game.net.lobby.LobbyRequestType;
	import game.net.lobby.LobbyResponseType;
	import game.net.lobby.response.ResponseRequestATMPayment;
	import game.net.lobby.response.ResponseRequestLuckyGift;
	import game.net.RequestPacket;
	import game.net.ResponsePacket;
	import game.net.Server;
	import game.ui.dialog.DialogID;
	import game.ui.dialog.dialogs.YesNo;
	import game.ui.hud.HUDModule;
	import game.ui.ModuleID;
	
	/**
	 * ...
	 * @author chuongth2
	 */
	public class PaymentModule extends ModuleBase
	{
		
		public static const CLOSE_PAYMENT_VIEW:String = "close_Payment_View";
		
		public function PaymentModule()
		{
		
		}
		
		override protected function createView():void
		{
			super.createView();
			baseView = new PaymentView();
			baseView.addEventListener(CLOSE_PAYMENT_VIEW, closePaymentHandler);
		}
		
		private function closePaymentHandler(e:Event):void
		{
			Manager.display.hideModule(ModuleID.PAYMENT);
		}
		
		override protected function preTransitionIn():void
		{
			super.preTransitionIn();
		}
		
		override protected function onTransitionInComplete():void
		{
			super.onTransitionInComplete();
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
				case LobbyResponseType.FIRST_CHARGE_REWARD_RESULT: 
					onFirstChargeResponse(packet as IntResponsePacket);
					break;
			
			}
			if (baseView)
				PaymentView(baseView).update();
		}
		
		private function onFirstChargeResponse(packet:IntResponsePacket):void 
		{
			Manager.display.hideWaitting();
			switch (packet.value)
			{
				case 0: //success
				{
					Manager.display.showMessage("Nhân thưởng lần đầu nạp tiền thành công ^^");
					Game.database.userdata.nFirstChargeState = 3; 
					if (baseView)
						PaymentView(baseView).showEffectFirstChargeCompleted();
					break;
				}
				case 1: 
				{
					Manager.display.showMessage("Nhân thưởng lần đầu nạp tiền thất bại T_T");
					break;
				}
				case 2: 
				{
					Manager.display.showMessage("Chưa nạp tiền.");
					break;
				}
				case 3: 
				{
					Manager.display.showMessage("Đã nhận thưởng.");
					break;
				}case 4: 
				{
					Manager.display.showMessage("Thùng đồ đã đầy.");
					break;
				}
			}
		}
	}

}