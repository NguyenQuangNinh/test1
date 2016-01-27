package game.ui.heal_ap 
{
	import core.display.ModuleBase;
	import core.event.EventEx;
	import core.Manager;
	import core.util.Utility;
	import flash.events.Event;
	import flash.utils.setTimeout;
	import game.data.model.UserData;
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
	public class HealApModule extends ModuleBase
	{
		
		public function HealApModule() 
		{
			
		}
		
		override protected function createView():void 
		{
			super.createView();
			baseView = new HealApView();
			
			baseView.addEventListener(HealApEvent.HEAL_AP, healApHdl);
			baseView.addEventListener(HealApEvent.CLOSE, closePopupHdl);
			
		}
		
		private function closePopupHdl(e:EventEx):void 
		{
			Manager.display.hideModule(ModuleID.HEAL_AP);
		}
		
		private function healApHdl(e:EventEx):void 
		{
			var amount : int = e.data as int;
			Utility.log("healApHdl : " + amount);
			Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.HEAL_AP, amount));
		}
		
		override protected function onTransitionInComplete():void 
		{
			super.onTransitionInComplete();
			Game.network.lobby.addEventListener(Server.SERVER_DATA, onLobbyServerData);
			Game.database.userdata.addEventListener(UserData.UPDATE_PLAYER_INFO, onUpdatePlayerInfo);
		}
		
		override protected function onTransitionOutComplete():void 
		{
			super.onTransitionOutComplete();
			Game.network.lobby.removeEventListener(Server.SERVER_DATA, onLobbyServerData);
			Game.database.userdata.removeEventListener(UserData.UPDATE_PLAYER_INFO, onUpdatePlayerInfo);
			
		}
		
		private function onUpdatePlayerInfo(e:Event):void 
		{
			HealApView(baseView).update();
		}
		
		private function onLobbyServerData(e:EventEx):void {
			var packet:ResponsePacket = ResponsePacket(e.data);
			switch(packet.type) {
				case LobbyResponseType.HEAL_AP:
					onHealApResponse(packet as IntResponsePacket);
					break;
				
			}
		}
		
		private function onHealApResponse(intResponsePacket:IntResponsePacket):void 
		{
			Utility.log("onHealApResponse : " + intResponsePacket.value);
			switch (intResponsePacket.value) 
			{
				case 0:		//thanh cong
					Manager.display.showMessageID(44);
					Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.GET_PLAYER_INFO));	
					setTimeout(hideModule, 500);
					break;
				case 1:		//that bai
					Manager.display.showMessageID(45);
					break;	
				case 2:		//Khong du xu
					Manager.display.showMessageID(46);
					break;	
				case 3:		//vuot qua gioi han trong ngay
					Manager.display.showMessageID(47);
					break;	
				case 4:		//vuot qua gioi han the luc
					Manager.display.showMessageID(48);
					break;	
					
				default:
			}
		}
		
		private function hideModule():void {
			Manager.display.hideModule(ModuleID.HEAL_AP)
		}
		
		override protected function preTransitionIn():void {
			super.preTransitionIn();
			HealApView(baseView).update();
		}
	}

}