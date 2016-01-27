package game.ui.select_global_boss 
{
	import core.display.layer.Layer;
	import core.display.layer.LayerManager;
	import core.display.ModuleBase;
	import core.event.EventEx;
	import core.Manager;
	import core.util.Utility;

	import flash.events.Event;
	import flash.geom.Point;
	import game.data.xml.DataType;
	import game.data.xml.MissionXML;
	import game.enum.ErrorCode;
	import game.Game;
	import game.net.BooleanResponsePacket;
	import game.net.IntRequestPacket;
	import game.net.lobby.LobbyRequestType;
	import game.net.lobby.LobbyResponseType;
	import game.net.lobby.request.RequestBossMissionInfo;
	import game.net.lobby.response.ResponseGlobalBossMissionInfo;
	import game.net.lobby.response.ResponseSelectGlobalBoss;
	import game.net.RequestPacket;
	import game.net.ResponsePacket;
	import game.net.Server;
	import game.ui.dialog.DialogID;
	import game.ui.home.scene.CharacterManager;
	import game.ui.ModuleID;
	
	/**
	 * ...
	 * @author MaiPTT
	 */
	public class SelectGlobalBossModule extends ModuleBase 
	{
		public function SelectGlobalBossModule() {
			
		}
		
		override protected function createView():void {
			super.createView();
			baseView = new SelectGlobalBossView();
			baseView.addEventListener(SelectGlobalBossEvent.EVENT, viewHdl);
		}
		
		private function viewHdl(e:EventEx):void 
		{
			switch (e.data.type)
			{
				case SelectGlobalBossEvent.REQUEST_MISSION_INFO:
					onRequestMissionInfoHandler(e);
					break;
				case SelectGlobalBossEvent.VIEW_GIFT:
					SelectGlobalBossView(baseView).giftInfoPopup.updateInfo(e.data.bossType);
					SelectGlobalBossView(baseView).giftInfoPopup.fadeIn();
					break;
				case SelectGlobalBossEvent.VIEW_TOP:
					Manager.display.showModule(ModuleID.GLOBAL_BOSS_TOP, new Point(400, 105), LayerManager.LAYER_POPUP, "top_left", Layer.NONE, {missionID: e.data.missionID});
					break;
			}
		}
		
		override protected function onTransitionInComplete():void {
			super.onTransitionInComplete();
		}
		
		override protected function preTransitionIn():void {
			
			super.preTransitionIn();
			Game.network.lobby.addEventListener(Server.SERVER_DATA, onServerResponseDataHandler);
			Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.SELECT_GLOBAL_BOSS_INFO));
		}
		
		override protected function preTransitionOut():void {
			super.preTransitionOut();
			Game.network.lobby.removeEventListener(Server.SERVER_DATA, onServerResponseDataHandler);
		}
		
		private function onRequestMissionInfoHandler(e:EventEx):void {
			var missionID:int = e.data.missionID;
			Game.database.userdata.globalBossData.currentMissionID = missionID;
			Game.network.lobby.sendPacket(new RequestBossMissionInfo(LobbyRequestType.GLOBAL_BOSS_MISSION_INFO, missionID));
		}
		
		private function onServerResponseDataHandler(e:EventEx):void {
			var packetResponse:ResponsePacket = e.data as ResponsePacket;
			switch(packetResponse.type) {
				case LobbyResponseType.SELECT_GLOBAL_BOSS_INFO:
					onResponseInfo(packetResponse as ResponseSelectGlobalBoss);
					break;
					
				case LobbyResponseType.GLOBAL_BOSS_MISSION_INFO:
					onResponseMissionInfo(packetResponse as ResponseGlobalBossMissionInfo);
					break;
				case LobbyResponseType.CHECK_BOSS_PAYMENT_RESULT:
					onCheckBossPaymentResult(packetResponse as BooleanResponsePacket);
					break;
			}
		}

		private function onCheckBossPaymentResult(packet:BooleanResponsePacket):void
		{
			Utility.log("onCheckBossPaymentResult > " + packet.result);
			(SelectGlobalBossView)(baseView).paymentHandler(packet.result);
		}
		
		private function onResponseMissionInfo(packet:ResponseGlobalBossMissionInfo):void {
			Game.database.userdata.globalBossData.currentMissionStatus = packet.status;
			Game.database.userdata.globalBossData.buffPercent = packet.buffPercent;
			Game.database.userdata.globalBossData.autoPlay = packet.autoPlay;
			Game.database.userdata.globalBossData.autoRevive = packet.autoRevive;
			//Game.database.userdata.globalBossData.rewards = [];
			
			Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.GLOBAL_BOSS_NOTIFY_JOIN, Game.database.userdata.globalBossData.currentMissionID));
			
			Manager.display.to(ModuleID.GLOBAL_BOSS, false, { missionID: Game.database.userdata.globalBossData.currentMissionID});
			
			preTransitionOut();
		}
		
		private function onResponseInfo(packet:ResponseSelectGlobalBoss):void {
			switch(packet.result) {
				case ErrorCode.SUCCESS:
					updateView(packet);
					break;
					
				case 2:
					var context:Object = { };
					context.content = "<font size = '20'>Đã hết thời gian chiến đấu với boss Mật Đạo</font>";
					Manager.display.showDialog(DialogID.GLOBAL_BOSS_CONFIRM, null, null, context, Layer.BLOCK_BLACK);
					Manager.display.hideModule(ModuleID.SELECT_GLOBAL_BOSS);
					CharacterManager.instance.displayCharacters();
					break;
			}
		}
		
		private function updateView(packet:ResponseSelectGlobalBoss):void {
			var arr:Array = [];
			var arrStatus:Array = [];
			Game.database.userdata.globalBossData.missionIDs = [];
			
			for each (var obj:Object in packet.arrBoss) {
				var missionID:int = obj.missionID;
				var missionXML:MissionXML = Game.database.gamedata.getData(DataType.MISSION, missionID) as MissionXML;
				Game.database.userdata.globalBossData.missionIDs.push(missionID);
				arr.push(missionXML);
				arrStatus.push(obj.status);
			}
			
			(SelectGlobalBossView)(baseView).updateItems(arr, arrStatus);
		}
	}

}