package game.ui.heroic.lobby 
{
	import flash.geom.Point;
	
	import core.Manager;
	import core.display.ModuleBase;
	import core.display.layer.LayerManager;
	import core.event.EventEx;
	
	import game.Game;
	import game.data.gamemode.ModeDataPVEHeroic;
	import game.enum.ErrorCode;
	import game.enum.FlowActionEnum;
	import game.enum.FormationType;
	import game.enum.GameMode;
	import game.net.IntRequestPacket;
	import game.net.IntResponsePacket;
	import game.net.RequestPacket;
	import game.net.ResponsePacket;
	import game.net.Server;
	import game.net.lobby.LobbyRequestType;
	import game.net.lobby.LobbyResponseType;
	import game.net.lobby.request.RequestSaveFormation;
	import game.ui.ModuleID;
	import game.ui.heroic.HeroicEvent;
	import game.ui.heroic.world_map.CampaignData;
	import game.ui.tutorial.TutorialEvent;

	/**
	 * ...
	 * @author MaiPTT
	 */
	public class HeroicLobbyModule extends ModuleBase 
	{
		private var campaignID:int = -1;
		
		public function HeroicLobbyModule() {
		}
		
		override protected function createView():void {
			baseView = new HeroicLobbyView();
			baseView.addEventListener(HeroicEvent.EVENT, onViewEventHdl);
		}
		
		override protected function transitionIn():void {
			super.transitionIn();
			Manager.display.showModule(ModuleID.TOP_BAR, new Point(), LayerManager.LAYER_TOP);
			Manager.display.showModule(ModuleID.HUD, new Point(), LayerManager.LAYER_HUD);
			Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.NOTIFY_JOIN_ROOM_READY));
		}
		
		override protected function preTransitionIn():void {
			super.preTransitionIn();
			Game.network.lobby.addEventListener(Server.SERVER_DATA, onResponseServerDataHdl);
			//Game.flow.addEventListener(FlowManager.ACTION_COMPLETED, onFlowEventHdl);
		}
		
		override protected function preTransitionOut():void {
			super.preTransitionOut();
			Game.network.lobby.removeEventListener(Server.SERVER_DATA, onResponseServerDataHdl);
			//Game.flow.removeEventListener(FlowManager.ACTION_COMPLETED, onFlowEventHdl);
		}
		
		public function resetFormation():void {
			var heroicFormation:Array = Game.database.userdata.getFormation(FormationType.HEROIC);
			for(var i:int = 1; i < FormationType.HEROIC.maxCharacter; ++i)
			{
				heroicFormation[i] = -1;
			}
			Game.network.lobby.sendPacket(new RequestSaveFormation(FormationType.HEROIC.ID, heroicFormation));
		}
		
		/*private function onFlowEventHdl(e:EventEx):void {
			switch(e.data.type) {
				case FlowActionEnum.UPDATE_HEROIC_FORMATION:
					HeroicLobbyView(view).update();
					break;
					
				case FlowActionEnum.START_LOBBY_SUCCESS:
					Game.flow.doAction(FlowActionEnum.START_LOADING_RESOURCE);
					break;
					
				case FlowActionEnum.LEAVE_LOBBY_SUCCESS:
					Manager.display.to(ModuleID.HEROIC_MAP);
					break;
			}
		}*/
		
		private function onViewEventHdl(e:EventEx):void {
			switch(e.data.type) {
				case HeroicEvent.ENTER_MAP:
					if (campaignID > 0) {
						var campaignData:CampaignData = Game.database.gamedata.getHeroicConfig(campaignID);
						//Manager.display.to(ModuleID.HEROIC_NODE, false, {missionIDs: campaignData.missionIDs, campaignID:campaignID});	
					}
					//Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.ENTER_PVE_HEROIC, campaignID));
					break;
					
				case HeroicEvent.KICK:
					Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.KICK_LOBBY_PLAYER_SLOT, e.data.id));
					break;
					
				case HeroicEvent.START_GAME:
					if (ModeDataPVEHeroic(Game.database.userdata.getModeData(GameMode.PVE_HEROIC)).isHost) {
						Game.flow.doAction(FlowActionEnum.START_LOBBY);
						Game.stage.dispatchEvent(new EventEx(TutorialEvent.EVENT, {type: TutorialEvent.START_GAME}, true));
					} else {
						Manager.display.showMessage("Chỉ có chủ phòng mới bắt đầu được.");
					}
					break;
			}
		}
		
		private function onResponseServerDataHdl(e:EventEx):void {
			var packet:ResponsePacket = e.data as ResponsePacket;
			switch(packet.type) {
					
				case LobbyResponseType.ENTER_PVE_HEROIC:
					onResponseEnterPVEHeroic(packet as IntResponsePacket);
					break;
					
				case LobbyResponseType.SAVE_FORMATION:
					Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.NOTIFY_JOIN_ROOM_READY));
					break;
					
				case LobbyResponseType.KICK_FROM_LOBBY:
					Manager.display.to(ModuleID.HOME);
					Manager.display.showMessage("Bạn đã bị đá ra khỏi phòng");
					break;
			}
		}
		
		private function onResponseEnterPVEHeroic(packet:IntResponsePacket):void	{
			switch(packet.value) {
				case ErrorCode.SUCCESS:
					if (campaignID > 0) {
						var campaignData:CampaignData = Game.database.gamedata.getHeroicConfig(campaignID);
						//Manager.display.to(ModuleID.HEROIC_NODE, false, {missionIDs: campaignData.missionIDs, campaignID:campaignID});	
					}
					break;
				//xu ly them error code khi ko start dc Anh Hung Ai
			}
		}

		public function showHintButton(content:String = ""):void
		{
			if(HeroicLobbyView(baseView))
				HeroicLobbyView(baseView).showHintButton(content);
		}

		public function showHintNode():void
		{
			if(HeroicLobbyView(baseView))
				HeroicLobbyView(baseView).showHintNode();
		}

		public function introButton():void
		{
			if(HeroicLobbyView(baseView))
				HeroicLobbyView(baseView).introButton();
		}
	}

}