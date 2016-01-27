package game.ui.vip_promotion
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
	import game.net.lobby.response.ResponseVIPPromotionPlayerInfo;
	import game.ui.ModuleID;
	import game.ui.hud.HUDModule;

	/**
	 * ...
	 * @author
	 */
	public class VIPPromotionModule extends ModuleBase
	{

		public function VIPPromotionModule()
		{

		}

		private function get view():VIPPromotionView
		{
			return baseView as VIPPromotionView;
		}

		override protected function createView():void
		{
			baseView = new VIPPromotionView();
			baseView.addEventListener("close", closeHandler);
			baseView.addEventListener(VIPPromotionView.BUY, buyHandler);

		}

		private function buyHandler(event:EventEx):void
		{
			Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.REQUEST_BUY_VIP_PROMOTION, event.data as int));
		}

		override protected function preTransitionIn():void
		{
			super.preTransitionIn();
		}

		override protected function onTransitionInComplete():void
		{
			super.onTransitionInComplete();
			Game.network.lobby.addEventListener(Server.SERVER_DATA, onLobbyServerData);
			Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.REQUEST_VIP_PROMOTION_PLAYER_INFO));
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
				case LobbyResponseType.VIP_PROMOTION_PLAYER_INFO_RESULT:
					onPlayerInfoRs(packet as ResponseVIPPromotionPlayerInfo);
					break;
				case LobbyResponseType.VIP_PROMOTION_BUY_RESULT:
					onBuyResult(packet as IntResponsePacket);
					break;
			}
		}

		private function onBuyResult(packet:IntResponsePacket):void
		{
			Utility.log("onBuyResult:" + packet.value);
			switch (packet.value)
			{
			    case 0://success
				    Manager.display.showMessage("Mua thành công.");
				    Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.GET_PLAYER_INFO_ATTRIBUTE, PlayerAttributeID.XU.ID));
				    Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.GET_PLAYER_INFO_ATTRIBUTE, PlayerAttributeID.GOLD.ID));
				    Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.REQUEST_VIP_PROMOTION_PLAYER_INFO));
				    break;
			    case 1://fail

			        break;
			    case 2://not enough money
					Manager.display.showMessageID(141);
			        break;
			}
		}

		private function onPlayerInfoRs(packet:ResponseVIPPromotionPlayerInfo):void
		{
			Utility.log("onPlayerInfoRs:" + packet.errorCode);
			switch (packet.errorCode)
			{
			    case 0://success
				    view.updateInfo(packet);
			        break;
			    case 1://fail
			            
			        break;
			    case 2://not enough money
				    Manager.display.showMessageID(141);
				    break;
			}
		}

		private function closeHandler(e:Event):void
		{
			var hudModule:HUDModule = Manager.module.getModuleByID(ModuleID.HUD) as HUDModule;
			if (hudModule != null)
			{
				hudModule.updateHUDButtonStatus(ModuleID.VIP_PROMOTION, false);
			}
		}
	}

}