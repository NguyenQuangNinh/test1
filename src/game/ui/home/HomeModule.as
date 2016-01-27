package game.ui.home
{

	import core.Manager;
	import core.display.ModuleBase;
	import core.display.ViewBase;
	import core.display.layer.Layer;
	import core.display.layer.LayerManager;
	import core.event.EventEx;
	import core.util.Utility;
	import game.ui.hud.gui.HUDButton;
	import game.ui.hud.gui.TuuLauChienButton;

	import flash.events.Event;
	import flash.geom.Point;

	import game.Game;
	import game.data.gamemode.ModeDataPVEHeroic;
	import game.data.model.UserData;
	import game.data.vo.campaign_sweep.SweepInfo;
	import game.data.vo.chat.ChatType;
	import game.data.xml.DataType;
	import game.data.xml.MissionXML;
	import game.data.xml.ModeConfigXML;
	import game.enum.GameConfigID;
	import game.enum.GameMode;
	import game.net.RequestPacket;
	import game.net.ResponsePacket;
	import game.net.Server;
	import game.net.lobby.LobbyRequestType;
	import game.net.lobby.LobbyResponseType;
	import game.net.lobby.request.RequestAcceptJoinRoom;
	import game.net.lobby.response.ResponsePVP1vs1AIState;
	import game.ui.ModuleID;
	import game.ui.chat.ChatView;
	import game.ui.dialog.DialogID;
	import game.ui.dialog.dialogs.SweepCampaignDialog;
	import game.ui.home.scene.CharacterManager;
	import game.ui.hud.HUDModule;

	//import game.enum.FlowActionID;
	//import game.ui.home.event.EventHome;

	/**
	 * ...
	 * @author anhtinh
	 */
	public class HomeModule extends ModuleBase
	{
		private var isShowTopBar:Boolean = false;

		private var _firstChecked:Boolean = false;

		public function HomeModule()
		{
			//relatedModuleIDs = [ModuleID.HUD];
		}

		override protected function createView():void
		{
			super.createView();
			baseView = new HomeView();
		}

		override protected function preTransitionIn():void
		{
			super.preTransitionIn();

			Game.network.lobby.addEventListener(Server.SERVER_DATA, onLobbyServerData);
			Game.database.userdata.addEventListener(UserData.UPDATE_CHARACTER_LIST, onDataUpdateHdl);
			Game.database.userdata.addEventListener(UserData.UPDATE_PLAYER_INFO, onDataUpdateHdl);

			Utility.log("Home module preTransitionIn");
			Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.GET_TUTORIAL_FINISHED_SCENE));
			Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.GET_PLAYER_INFO));
			Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.GET_ITEM_INVENTORY));
			Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.DAILY_TASK_INFO));
		}

		override protected function transitionIn():void
		{
			super.transitionIn();
			// Manager.display.showModule(ModuleID.TOP_BAR, new Point(0, 0), LayerManager.LAYER_TOP, "top_left", Layer.NONE);
		}

		override protected function onTransitionInComplete():void
		{
			super.onTransitionInComplete();

			if (Game.database.userdata.isWaitingLevelUpEffect)
			{
				Game.database.userdata.isWaitingLevelUpEffect = false;
				Manager.display.showModule(ModuleID.GAME_LEVEL_UP, new Point(0, 0), LayerManager.LAYER_TOP);
			}

			if (extraInfo && extraInfo.module == ModuleID.SHOP)
			{
				extraInfo = { };
				Manager.display.showModule(ModuleID.SHOP, new Point(0, 0), LayerManager.LAYER_POPUP);
			}

			if (Game.database.userdata.sweepingMissionID > 0)
			{
				var sweepTime:int = Game.database.gamedata.getConfigData(GameConfigID.CAMPAIGN_SWEEP_TIME) as int;
				var totalTime:int = sweepTime * Game.database.userdata.maxSweepTimes;
				var sweepInfo:SweepInfo = new SweepInfo();


				sweepInfo.missionXML = Game.database.gamedata.getData(DataType.MISSION, Game.database.userdata.sweepingMissionID) as MissionXML;
				sweepInfo.state = (Game.database.userdata.elapsedSweepingTime < totalTime) ? SweepCampaignDialog.SWEEPING : SweepCampaignDialog.FINISHED;

				Manager.display.showDialog(DialogID.QUICK_FINISH_CAMPAIGN, null, null, sweepInfo, Layer.BLOCK_BLACK);
			}

			var chat:ChatView = Manager.module.getModuleByID(ModuleID.CHAT).baseView as ChatView;
			if (chat != null)
			{
				chat.chatBoxMov.update(ChatType.CHAT_TYPE_ALL, ChatType.CHAT_TYPE_SERVER);
			}

			//check co qua Hoa Son Luan Kiem hay ko?
			Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.PVP1vs1AI_STATE));
		}

		private function onHUDModuleTransInComplete(e:Event):void
		{
			var hudModule:HUDModule = e.target as HUDModule;
			if (hudModule)
			{
				hudModule.removeEventListener(ViewBase.TRANSITION_IN_COMPLETE, onHUDModuleTransInComplete);
				if (_firstChecked || Game.database.userdata.attendanceChecked || !hudModule.getBtnByName("btnAttendance").visible)
				{
					hudModule.updateHUDButtonStatus(ModuleID.DAILY_TASK, true);
				}
				else
				{
					hudModule.updateHUDButtonStatus(ModuleID.ATTENDANCE, true);
				}
				_firstChecked = true;

			}
		}

		override protected function onTransitionOutComplete():void
		{
			Utility.log("HomeModule.onTransitionOutComplete ");
			super.onTransitionOutComplete();
			Game.network.lobby.removeEventListener(Server.SERVER_DATA, onLobbyServerData);
			Game.database.userdata.removeEventListener(UserData.UPDATE_CHARACTER_LIST, onDataUpdateHdl);
		}

		private function onDataUpdateHdl(e:Event):void
		{
			switch (e.type)
			{
				case UserData.UPDATE_PLAYER_INFO:
					this.updateNPCDisplay();
					break;
				case UserData.UPDATE_CHARACTER_LIST:
					CharacterManager.instance.updateCharatersOnHome();
					break;
			}

		}

		private function onLobbyServerData(e:EventEx):void
		{
			var packet:ResponsePacket = ResponsePacket(e.data);
			switch (packet.type)
			{
				case LobbyResponseType.PVP1vs1_AI_STATE:
					var modeXML:ModeConfigXML = Game.database.gamedata.getData(DataType.MODE_CONFIG, GameMode.PVP_1vs1_AI.ID) as ModeConfigXML;
					var packetState:ResponsePVP1vs1AIState = packet as ResponsePVP1vs1AIState;
					if (packetState)
					{
						var state:int = packetState.receivedRewardRankWeekly && packetState.receivedRewardRankDaily ? 0 : 1;
						(baseView as HomeView).updateChallengeState(state);
					}
					break;
				case LobbyResponseType.PLAYER_INFO:
					if (!Manager.module.moduleIsVisible(ModuleID.TOP_BAR)) Manager.display.showModule(ModuleID.TOP_BAR, new Point(0, 0), LayerManager.LAYER_TOP, "top_left", Layer.NONE);
					var hudModule:HUDModule = Manager.module.getModuleByID(ModuleID.HUD) as HUDModule;
					if (!hudModule.visible)
					{
						hudModule.clearSelected();
						hudModule.removeEventListener(ViewBase.TRANSITION_IN_COMPLETE, onHUDModuleTransInComplete);
						hudModule.addEventListener(ViewBase.TRANSITION_IN_COMPLETE, onHUDModuleTransInComplete);
						Manager.display.showModule(ModuleID.HUD, new Point(0, 0), LayerManager.LAYER_HUD, "top_left", Layer.NONE);
					}
					break;
			}
		}

		private function onAcceptHeroicInviteHdl(data:Object):void
		{
			var modeData:ModeDataPVEHeroic = Game.database.userdata.getModeData(GameMode.PVE_HEROIC) as ModeDataPVEHeroic;
			modeData.difficulty = data.hardMode;
			var requestPacket:RequestAcceptJoinRoom = new RequestAcceptJoinRoom(data.roomID, false);
			Game.network.lobby.sendPacket(requestPacket);
		}

		public function updateNPCDisplay():void
		{
			if (baseView)
			{
				HomeView(baseView).updateNPCDisplay();
			}
		}

		public function onSelectedModule(module:ModuleID):void
		{
			if (baseView && (baseView as HomeView).sceneLayer)
			{
				(baseView as HomeView).sceneLayer.onSelectedModule(module);
			}
		}
	}

}