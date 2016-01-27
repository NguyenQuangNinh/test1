package game.ui.heal_hp 
{
	import core.display.ModuleBase;
	import core.event.EventEx;
	import core.Manager;
	import core.util.Utility;
	import flash.events.Event;
	import flash.utils.setTimeout;
	import game.Game;
	import game.net.IntRequestPacket;
	import game.net.IntResponsePacket;
	import game.net.lobby.LobbyRequestType;
	import game.net.lobby.LobbyResponseType;
	import game.net.RequestPacket;
	import game.net.ResponsePacket;
	import game.net.Server;
	import game.ui.ModuleID;
	/**
	 * ...
	 * @author anhtinh
	 */
	public class HealHpModule extends ModuleBase
	{
		
		public function HealHpModule() 
		{
			
		}
		
		override protected function createView():void 
		{
			super.createView();
			baseView = new HealHpView();
			
			baseView.addEventListener(HealHpEvent.HEAL_HP, healHpHdl);
			baseView.addEventListener(HealHpEvent.CLOSE, closePopupHdl);
			baseView.addEventListener(HealHpEvent.SHOW_TOOLTIP, showTooltipHdl);
			baseView.addEventListener(HealHpEvent.HIDE_TOOLTIP, hideTooltipHdl);
			
		}
		
		private function showTooltipHdl(e:EventEx):void 
		{
			HealHpView(baseView).setTooltip(e.data as int)
		}
		
		private function hideTooltipHdl(e:EventEx):void 
		{
			HealHpView(baseView).hideTooltip();
		}
		
		private function closePopupHdl(e:Event):void 
		{
			Manager.display.hideModule(ModuleID.HEAL_HP);
		}
		
		private function healHpHdl(e:EventEx):void 
		{
			var index : int = e.data as int;
			Utility.log("healHpHdl : " + index);
			Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.HEAL_HP, index));
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
		
		private function onLobbyServerData(e:EventEx):void {
			var packet:ResponsePacket = ResponsePacket(e.data);
			switch(packet.type) {
				case LobbyResponseType.HEAL_HP:
					onHealHpResponse(packet as IntResponsePacket);
					break;
				
			}
		}
		
		private function onHealHpResponse(intResponsePacket:IntResponsePacket):void 
		{
			Utility.log("onHealHpResponse : " + intResponsePacket.value);
			switch (intResponsePacket.value) 
			{
				case 0:
					Manager.display.showMessageID(38);
					Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.GET_PLAYER_INFO));	
					setTimeout(hideModule, 500);
					break;
				case 1:
					Manager.display.showMessageID(39);
					break;	
				case 2:
					Manager.display.showMessageID(40);
					break;	
				case 3:
					Manager.display.showMessageID(41);
					break;	
					
				default:
			}
		}
		
		private function hideModule():void {
			Manager.display.hideModule(ModuleID.HEAL_HP);
		}
	}

}