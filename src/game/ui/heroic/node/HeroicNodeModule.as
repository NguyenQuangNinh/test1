package game.ui.heroic.node 
{
	import flash.geom.Point;
	import game.net.RequestPacket;
	
	import core.Manager;
	import core.display.ModuleBase;
	import core.display.layer.Layer;
	import core.display.layer.LayerManager;
	import core.event.EventEx;
	
	import game.Game;
	import game.data.gamemode.ModeDataPVEHeroic;
	import game.data.vo.lobby.LobbyPlayerInfo;
	import game.enum.FlowActionEnum;
	import game.enum.GameMode;
	import game.flow.FlowManager;
	import game.net.IntRequestPacket;
	import game.net.IntResponsePacket;
	import game.net.ResponsePacket;
	import game.net.Server;
	import game.net.lobby.LobbyRequestType;
	import game.net.lobby.LobbyResponseType;
	import game.net.lobby.response.ResponseHeroicFinishMissions;
	import game.net.lobby.response.ResponseHeroicStartGameResult;
	import game.ui.ModuleID;
	import game.ui.dialog.DialogID;
	import game.ui.dialog.dialogs.YesNo;
	import game.ui.heroic.HeroicEvent;
	import game.ui.heroic.world_map.CampaignData;
	import game.ui.hud.HUDModule;
	
	/**
	 * ...
	 * @author MaiPTT
	 */
	public class HeroicNodeModule extends ModuleBase 
	{
		private var campaignID:int = -1;
		public function HeroicNodeModule() {
			
		}
		
		override protected function createView():void {
			baseView = new HeroicNodeView();
			baseView.addEventListener(HeroicEvent.EVENT, onViewEventHdl);
		}
		
		override protected function preTransitionIn():void {
			super.preTransitionIn();
			Game.network.lobby.addEventListener(Server.SERVER_DATA, onResponseServerHdl);
			Manager.display.showModule(ModuleID.HUD, new Point(0, 0), LayerManager.LAYER_HUD, "top_left", Layer.NONE);
			Manager.display.showModule(ModuleID.TOP_BAR, new Point(0, 0), LayerManager.LAYER_TOP,
							"top_left", Layer.NONE);
			HUDModule(modulesManager.getModuleByID(ModuleID.HUD)).setVisibleButtonHUD(["questMainBtn", "questTransportBtn", "worldMapBtn", "arenaBtn"], false);
		}
		
		override protected function onTransitionInComplete():void {
			super.onTransitionInComplete();
			if (extraInfo) {
				var modeData:ModeDataPVEHeroic = Game.database.userdata.getModeData(GameMode.PVE_HEROIC) as ModeDataPVEHeroic;
				if (extraInfo.missionIDs && extraInfo.missionIDs[modeData.difficulty]) {
					HeroicNodeView(baseView).updateNodeUI(extraInfo.missionIDs[modeData.difficulty] as Array);
				}
				campaignID = extraInfo.campaignID;
				var campaignData:CampaignData = Game.database.gamedata.getHeroicConfig(campaignID) as CampaignData;
				if (campaignData) {
					HeroicNodeView(baseView).setName(campaignData.name.toUpperCase());
				} else {
					HeroicNodeView(baseView).setName("");
				}
			}
			if (campaignID != -1) {
				Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.HEROIC_FINISH_MISSIONS, campaignID));
			}
			Game.flow.addEventListener(FlowManager.ACTION_COMPLETED, onFlowActionCompletedHdl);
		}
		
		override protected function onTransitionOutComplete():void {
			super.onTransitionOutComplete();
			Game.flow.removeEventListener(FlowManager.ACTION_COMPLETED, onFlowActionCompletedHdl);
			Game.network.lobby.removeEventListener(Server.SERVER_DATA, onResponseServerHdl);
		}
		
		private function onResponseServerHdl(e:EventEx):void {
			var responsePacket:ResponsePacket = e.data as ResponsePacket;
			switch(responsePacket.type) {
				case LobbyResponseType.HEROIC_FINISH_MISSIONS:
					onResponseHeroicFinishMissions(responsePacket as ResponseHeroicFinishMissions);
					break;
					
				case LobbyResponseType.START_HEROIC_RESULT:
					onResponseStartGameResult(responsePacket as ResponseHeroicStartGameResult);
					break;
					
				case LobbyResponseType.HEROIC_KICK:
					trace("kick result: " + IntResponsePacket(responsePacket).value);
					break;
					
				case LobbyResponseType.KICK_FROM_LOBBY:
					Manager.display.to(ModuleID.HOME);
					Manager.display.showMessage("Bạn đã bị đá ra khỏi phòng");
					break;
			}
		}
		
		private function onResponseStartGameResult(packet:ResponseHeroicStartGameResult):void {
			var obj:Object = { };
			switch(packet.errorCode) {
				case 0:
					ModeDataPVEHeroic(Game.database.userdata.getModeData(GameMode.PVE_HEROIC)).missionID = packet.missionID;
					break;
					
				case 4:
					obj.title = "Thông Báo";
					if (packet.playerID == Game.database.userdata.userID) {
						obj.message = "Bạn chưa hoàn thành map trước.";
					} else {
						obj.message = getPlayerNameByID(packet.playerID) + " chưa hoàn thành map trước.";
					}
					obj.option = YesNo.YES | YesNo.CLOSE;
					Manager.display.showDialog(DialogID.YES_NO, null, null, obj, Layer.BLOCK_BLACK);
					break;
					
				case 5:
					obj.title = "Thông Báo";
					if (packet.playerID == Game.database.userdata.userID) {
						Manager.display.showDialog(DialogID.HEAL_AP, null, null, {}, Layer.BLOCK_BLACK);
					} else {
						obj.message = getPlayerNameByID(packet.playerID) + " không đủ điểm Hoạt Động để tiếp tục.";
						obj.option = YesNo.YES | YesNo.CLOSE;
						Manager.display.showDialog(DialogID.YES_NO, null, null, obj, Layer.BLOCK_BLACK);
					}
					break;
					
				case 21:
					obj.title = "Thông Báo";
					if (packet.playerID == Game.database.userdata.userID) {
						obj.message = "Bạn đã vượt số lần chơi tối đa trong ngày.";
					} else {
						obj.message = getPlayerNameByID(packet.playerID) + " đã vượt số lần chơi tối đa trong ngày.";
					}
					obj.option = YesNo.YES | YesNo.CLOSE;
					Manager.display.showDialog(DialogID.YES_NO, null, null, obj, Layer.BLOCK_BLACK);
					break;
					
				case 22:
					obj.title = "Thông Báo";
					if (packet.playerID == Game.database.userdata.userID) {
						obj.message = "Bạn đã chơi map này rồi.";
					} else {
						obj.message = getPlayerNameByID(packet.playerID) + " đã chơi map này rồi.";
					}
					obj.option = YesNo.YES | YesNo.CLOSE;
					Manager.display.showDialog(DialogID.YES_NO, null, null, obj, Layer.BLOCK_BLACK);
					break;
			}
		}
		
		private function getPlayerNameByID(id:int):String {
			var players:Array = ModeDataPVEHeroic(Game.database.userdata.getModeData(GameMode.PVE_HEROIC)).getPlayers();
			if (players) {
				for each (var player:LobbyPlayerInfo in players) {
					if (player) {
						if (player.id == id) {
							return player.name;
						}
					}
				}
			}
			return "";
		}
		
		private function onResponseHeroicFinishMissions(packet:ResponseHeroicFinishMissions):void {
			var finishMissions:Array = packet.finishMissions;
			HeroicNodeView(baseView).updateStatus(finishMissions);
		}
		
		private function onFlowActionCompletedHdl(e:EventEx):void {
			switch(e.data.type) {
				case FlowActionEnum.CREATE_LOBBY_SUCCESS:
					Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.NOTIFY_JOIN_ROOM_READY));
					break;
				case FlowActionEnum.UPDATE_LOBBY_INFO_SUCCESS:
					Game.flow.doAction(FlowActionEnum.START_LOBBY);
					break;	
				case FlowActionEnum.START_LOBBY_SUCCESS:	
					//Game.flow.doAction(FlowActionEnum.START_LOADING_RESOURCE);
					break;
				//case FlowActionEnum.UPDATE_HEROIC_FORMATION:
				//	HeroicNodeView(baseView).updateFormation();
				//	break;
			}
		}
		
		private function onViewEventHdl(e:EventEx):void {
			switch(e.data.type) {
				case HeroicEvent.START_GAME:
					if (ModeDataPVEHeroic(Game.database.userdata.getModeData(GameMode.PVE_HEROIC)).isHost) {
						Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.HEROIC_START_GAME, e.data.missionID));	
					} else {
						Manager.display.showMessage("Chỉ có chủ phòng mới bắt đầu được.");
					}
					break;
			}
		}
	}

}