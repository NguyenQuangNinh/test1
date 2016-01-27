package game.ui.heroic.world_map 
{
	import flash.geom.Point;
	
	import core.Manager;
	import core.display.ModuleBase;
	import core.display.layer.Layer;
	import core.display.layer.LayerManager;
	import core.event.EventEx;
	
	import game.Game;
	import game.data.xml.DataType;
	import game.data.xml.MissionXML;
	import game.enum.ErrorCode;
	import game.net.IntRequestPacket;
	import game.net.IntResponsePacket;
	import game.net.RequestPacket;
	import game.net.ResponsePacket;
	import game.net.Server;
	import game.net.lobby.LobbyRequestType;
	import game.net.lobby.LobbyResponseType;
	import game.net.lobby.response.ResponseHeroicInfo;
	import game.ui.ModuleID;
	import game.ui.dialog.DialogID;
	import game.ui.dialog.dialogs.YesNo;
	import game.ui.heroic.HeroicEvent;
	
	/**
	 * ...
	 * @author MaiPTT
	 */
	public class HeroicMapModule extends ModuleBase 
	{
		private var campaigns	:Array = [];
		private var campaignID	:int = -1;
		
		public function HeroicMapModule() {
			
		}
		
		override protected function createView():void {
			baseView = new HeroicMapView();
			baseView.addEventListener(HeroicEvent.EVENT, onViewEventHdl);
		}
		
		override protected function preTransitionIn():void {
			super.preTransitionIn();
			Game.network.lobby.addEventListener(Server.SERVER_DATA, onResponseServerHdl);
			Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.GET_HEROIC_INFO));
		}
		
		override protected function transitionIn():void {
			super.transitionIn();
			Manager.display.showModule(ModuleID.HUD, new Point(), LayerManager.LAYER_HUD);
			Manager.display.showModule(ModuleID.TOP_BAR, new Point(), LayerManager.LAYER_TOP);
		}
		
		override protected function preTransitionOut():void {
			super.preTransitionOut();
			Game.network.lobby.removeEventListener(Server.SERVER_DATA, onResponseServerHdl);
		}


		override protected function onTransitionInComplete():void
		{
			super.onTransitionInComplete();
		}

		private function onResponseServerHdl(e:EventEx):void {
			var packet:ResponsePacket = e.data as ResponsePacket;
			switch(packet.type) {
				case LobbyResponseType.HEROIC_INFO:
					onResponseHeroicInfo(packet as ResponseHeroicInfo);
					break;
				case LobbyResponseType.HEROIC_BUY_PLAYING_TIMES:
					onResponseBuyPlayingTimesResult(IntResponsePacket(packet));
					break;
			}
		}
		
		private function onResponseBuyPlayingTimesResult(packet:IntResponsePacket):void {
			switch(packet.value) {
				case ErrorCode.SUCCESS:
					Manager.display.showMessage("Thêm lượt chơi thành công.");
					Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.GET_HEROIC_INFO));
					break;
					
				case 2:
					Manager.display.showMessage("Bạn không đủ Vàng để thêm lượt.");
					break;
					
				case 3:
					Manager.display.showMessage("Bạn đã vượt số lượng lượt được phép mua tối đa.");
					break;
			}
		}
		
		private function onResponseHeroicInfo(packet:ResponseHeroicInfo):void {
			campaigns = [];
			var campaignData:CampaignData;
			for each (var obj:Object in packet.infos) {
				if (obj.campaignID > 0) {
					campaignData = Game.database.gamedata.getHeroicConfig(obj.campaignID);
					if(campaignData)
					{
						campaignData.freePlayingTimes = obj.freePlayingTimes;
						campaignData.premiumPlayingTimes = obj.premiumPlayingTimes;
						campaignData.playingBought = obj.premiumBought;
						campaigns.push(campaignData);
					}
				}
			}
			
			HeroicMapView(baseView).setData(campaigns);
		}
		
		private function onViewEventHdl(e:EventEx):void {
			switch(e.data.type) {
				case HeroicEvent.ENTER_CAMPAIGN:
					onEnterNode(e.data.data as CampaignData);
					break;
			}
		}
		
		private function onEnterNode(data:CampaignData):void {
			if (data) {
				if (data.freePlayingTimes < data.freeMax) {
					checkEnterNode(data);
				} else if (data.playingBought > 0 && data.premiumPlayingTimes < data.premiumMax) {
					checkEnterNode(data);
				} else if (data.playingBought < data.premiumMax) {
					Manager.display.showDialog(DialogID.YES_NO, onExtendPlayingTimesHdl, null,
												{ title: "Thông báo",
												message: "Bạn đã hết lượt tham gia. Mua thêm với giá " + data.playingCost + " vàng?", option:YesNo.YES|YesNo.CLOSE|YesNo.NO, id:data.campaignID },
												Layer.BLOCK_BLACK);
				} else {
					Manager.display.showMessage("Bạn đã hết lượt chơi ở ải này.");
				}
			}
		}
		
		private function checkEnterNode(data:CampaignData):void {
			campaignID = data.campaignID;
			var groupMissionIDs:Array = data.missionIDs;
			var APRequired:int = -1;
			for each (var missionIDs:Array in groupMissionIDs) {
				for each (var tempMissionID:int in missionIDs) {
					var missionXML:MissionXML = Game.database.gamedata.getData(DataType.MISSION, tempMissionID) as MissionXML;
					if (missionXML) {
						if (missionXML.prevMissionID == -1) {
							APRequired = missionXML.aPRequirement;
							if (Game.database.userdata.actionPoint >= APRequired) {
								Manager.display.showDialog(DialogID.HEROIC_CREATE_ROOM, null, null,
														{content:data.name,
														campaignID:campaignID}, Layer.BLOCK_BLACK);
							} else {
								Manager.display.showDialog(DialogID.HEAL_AP, null, null, {}, Layer.BLOCK_BLACK);
							}
							return;
						}
					}
				}
			}
		}
		
		private function onExtendPlayingTimesHdl(data:Object):void {
			Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.HEROIC_BUY_PLAYING_TIMES, data.id));
		}

		//TUTORIAL

		public function showHintNode():void
		{
			if(baseView)
				HeroicMapView(baseView).showHintNode();
		}
	}
}