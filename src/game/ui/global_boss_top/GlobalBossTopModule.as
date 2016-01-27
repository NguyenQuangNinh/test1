package game.ui.global_boss_top 
{
	import core.display.ModuleBase;
	import core.event.EventEx;
	import flash.events.Event;
	import game.Game;
	import game.net.IntRequestPacket;
	import game.net.IntResponsePacket;
	import game.net.lobby.LobbyRequestType;
	import game.net.lobby.LobbyResponseType;
	import game.net.lobby.response.ResponseGlobalBossTopDmg;
	import game.net.ResponsePacket;
	import game.net.Server;
	/**
	 * ...
	 * @author vu anh
	 */
	public class GlobalBossTopModule extends ModuleBase
	{
		
		public function GlobalBossTopModule() 
		{
			
		}
		
		override protected function createView():void 
		{
			super.createView();
			baseView = new GlobalBossTopView();
			baseView.addEventListener(GlobalBossTopEvent.EVENT, viewHdl);
		}
		
		private function viewHdl(e:EventEx):void 
		{
			switch (e.data.type)
			{
				case GlobalBossTopEvent.CLOSE_BTN_CLICK:
					this.hide();
					break;
			}
		}
		
		override protected function preTransitionIn():void 
		{
			if (extraInfo && extraInfo.isHideBg) 
			{
				GlobalBossTopView(baseView).bg.visible = false;
				GlobalBossTopView(baseView).closeBtn.visible = false;
			}
			else 
			{
				GlobalBossTopView(baseView).bg.visible = true;
				GlobalBossTopView(baseView).closeBtn.visible = true;
			}
			super.preTransitionIn();
			Game.network.lobby.addEventListener(Server.SERVER_DATA, onServerDataResponseHandler);
			Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.GLOBAL_BOSS_TOP_DMG, extraInfo.missionID as int));
		}
		
		override protected function preTransitionOut():void {
			super.preTransitionOut();
			Game.network.lobby.removeEventListener(Server.SERVER_DATA, onServerDataResponseHandler);
		}
		
		private function onServerDataResponseHandler(e:EventEx):void 
		{
			var packet:ResponsePacket = e.data as ResponsePacket;
			switch(packet.type) 
			{
				case LobbyResponseType.GLOBAL_BOSS_TOP_DMG:
					onResponseTopDmg(packet as ResponseGlobalBossTopDmg);
					break;
			}
			
		}
	
		private function onResponseTopDmg(packet:ResponseGlobalBossTopDmg):void 
		{
			(baseView as GlobalBossTopView).updateInfo(packet);
		}
	}
}