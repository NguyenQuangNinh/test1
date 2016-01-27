package game.ui.top_bar
{
	import core.display.layer.Layer;
	import core.display.layer.LayerManager;
	import core.display.ModuleBase;
	import core.event.EventEx;
	import core.Manager;
	import core.util.Utility;
	import flash.events.Event;
	import flash.geom.Point;
	import game.data.model.UserData;
	import game.Game;
	import game.net.lobby.LobbyRequestType;
	import game.net.lobby.LobbyResponseType;
	import game.net.RequestPacket;
	import game.net.ResponsePacket;
	import game.net.Server;
	import game.net.lobby.response.ResponseRequestATMPayment;
	import game.ui.ModuleID;
	import game.ui.dialog.DialogID;
	import game.ui.dialog.dialogs.YesNo;

	/**
	 * ...
	 * @author anhtinh
	 */
	public class TopBarModule extends ModuleBase
	{
		
		public function TopBarModule()
		{
		
		}
		
		override protected function createView():void
		{
			super.createView();
			baseView = new TopBarView();
		
		}
		
		override protected function preTransitionIn():void
		{
			
			super.preTransitionIn();
		
		}
		
		override protected function onTransitionInComplete():void
		{
			super.onTransitionInComplete();
			Game.database.userdata.addEventListener(UserData.UPDATE_PLAYER_INFO, onUpdatePlayerInfo);
			Game.database.userdata.addEventListener(UserData.GAME_LEVEL_UP, onUpdatePlayerInfo);
			Game.network.lobby.addEventListener(Server.SERVER_DATA, onLobbyServerData);
			
			baseView.addEventListener(TopBarEvent.ADD_HP_POTION, requestAddHpPotionHdl);
			baseView.addEventListener(TopBarEvent.ADD_ACTION_POINT, requestAddActionPointHdl);
		}
		
		override protected function onTransitionOutComplete():void
		{
			super.onTransitionOutComplete();
			Game.database.userdata.removeEventListener(UserData.UPDATE_PLAYER_INFO, onUpdatePlayerInfo);
			Game.network.lobby.removeEventListener(Server.SERVER_DATA, onLobbyServerData);
			Game.database.userdata.removeEventListener(UserData.GAME_LEVEL_UP, onUpdatePlayerInfo);
			
			baseView.removeEventListener(TopBarEvent.ADD_HP_POTION, requestAddHpPotionHdl);
			baseView.removeEventListener(TopBarEvent.ADD_ACTION_POINT, requestAddActionPointHdl);
		
		}
		
		private function onLobbyServerData(e:EventEx):void
		{
			var packet:ResponsePacket = ResponsePacket(e.data);
			switch (packet.type)
			{
				case LobbyResponseType.REQUEST_ATM_PAYMENT_RESULT:
					onRequestATMPaymentResponse(packet as ResponseRequestATMPayment);
					break;
			}
		
		}

		private function onRequestATMPaymentResponse(packet:ResponseRequestATMPayment):void
		{
			if (packet && Game.database.userdata.level > 10)
			{
				var dialogData:Object = {};
				dialogData.title = "Nạp vàng";
				dialogData.message = (packet.nAddXuBonus > 0) ? "Bạn vừa nạp " + packet.nAddXu + " vàng và được thưởng " + packet.nAddXuBonus + " vàng vào tài khoản" : "Bạn vừa nạp " + packet.nAddXu + " vàng vào tài khoản";
				dialogData.option = YesNo.YES;
				Manager.display.showDialog(DialogID.YES_NO, null, null, dialogData, Layer.BLOCK_BLACK);
			}
		}

		private function requestAddHpPotionHdl(e:Event):void
		{
			Manager.display.closeAllPopup();
			Manager.display.showModule(ModuleID.HEAL_HP, new Point(0, 0), LayerManager.LAYER_POPUP, "top_left", Layer.BLOCK_BLACK);
		}
		
		private function requestAddActionPointHdl(e:Event):void
		{
			Manager.display.closeAllPopup();
			Manager.display.showModule(ModuleID.HEAL_AP, new Point(0, 0), LayerManager.LAYER_POPUP, "top_left", Layer.BLOCK_BLACK);
		}
		
		private function onUpdatePlayerInfo(e:Event):void
		{
			if (baseView != null)
			{
				TopBarView(baseView).update();
			}
		}
	
	}

}