package game.ui.loading 
{
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import game.data.vo.lobby.LobbyInfo;
	import game.data.xml.GameConfig;
	import game.enum.FlowActionEnum;
	import game.enum.GameConfigID;
	import game.net.RequestPacket;
	import game.ui.dialog.DialogID;
	import game.ui.dialog.dialogs.YesNo;
	import game.ui.hud.HUDModule;
	import game.ui.ingame.replay.GameReplayManager;
	
	import core.Manager;
	import core.display.ModuleBase;
	import core.event.EventEx;
	import core.sound.SoundManager;
	import core.util.Utility;
	
	import game.Game;
	import game.data.gamemode.ModeData;
	import game.data.gamemode.ModeDataPvE;
	import game.data.model.Character;
	import game.data.model.ServerAddress;
	import game.data.vo.lobby.LobbyPlayerInfo;
	import game.data.vo.skill.Skill;
	import game.data.xml.BackgroundLayerXML;
	import game.data.xml.BackgroundXML;
	import game.data.xml.DataType;
	import game.data.xml.MissionXML;
	import game.data.xml.ModeConfigXML;
	import game.enum.GameMode;
	import game.enum.SkillType;
	import game.enum.WorldMode;
	import game.net.ByteResponsePacket;
	import game.net.IntRequestPacket;
	import game.net.ResponsePacket;
	import game.net.Server;
	import game.net.game.GameRequestType;
	import game.net.game.GameResponseType;
	import game.net.lobby.LobbyRequestType;
	import game.net.lobby.LobbyResponseType;
	import game.net.lobby.request.RequestLogLoadingAction;
	import game.net.lobby.response.ResponseUpdateLoadingPercent;
	import game.ui.ModuleID;
	import game.utility.GameUtil;
	import game.utility.TimerEx;

	/**
	 * ...
	 * @author bangnd2
	 */
	public class LoadingModule extends ModuleBase 
	{
		private var playerInitialized:Boolean;
		private var loadResourceComplete:Boolean;
		private var urls:Array = [];
			
		private static const PERCENT_UPDATE_INTERVAL:int = 5;
		private var _percentCurr:int = 0;
		private var _ready:Boolean = false;
		
		private var timerID:int = -1;
		private var totalTimeout:int = 0;
		
		public function LoadingModule() 
		{
			
		}

		private function startTimer():void {
			totalTimeout = Game.database.gamedata.getConfigData(GameConfigID.MAX_LOADING_TIME_OUT);
			TimerEx.stopTimer(timerID);
			timerID = TimerEx.startTimer(1000,totalTimeout, updateTimer, loadingTimeOut);
		}

		private function stopTimer(): void {
			TimerEx.stopTimer(timerID);
		}

		private function updateTimer():void
		{
			LoadingView(baseView).updateTimeout(totalTimeout--);
		}

		private function loadingTimeOut():void
		{
			Utility.log("time out loading after " + Game.database.gamedata.getConfigData(GameConfigID.MAX_LOADING_TIME_OUT) + " second");
			Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.LOADING_TIME_OUT));

			if (loadResourceComplete) {
				//auto trans to in game
				transToIngame();
			}else {
				//auto trans to home and notify --? loading fail
				Manager.display.showMessage("Vượt quá thời gian cho phép, quá trình tải thất bại");
				Manager.display.to(ModuleID.HOME);
			}
		}

		override protected function createView():void 
		{
			baseView = new LoadingView();
			baseView.addEventListener(Event.COMPLETE, onCompleteEffectHdl);
		}
		
		private function onCompleteEffectHdl(e:Event):void 
		{			
			switch(Game.database.userdata.getGameMode().worldMode)
			{
				case WorldMode.PVE:
					Utility.log( "LoadingModule.onCompleteEffectHdl > e : " + Game.database.userdata.getGameMode().worldMode.name );
					Manager.display.to(ModuleID.INGAME_PVE);
					break;
				case WorldMode.PVP:
					Utility.log( "LoadingModule.onCompleteEffectHdl > e : " + Game.database.userdata.getGameMode().worldMode.name );
					Manager.display.to(ModuleID.INGAME_PVP);
					break;
			}	

			stopTimer();
		}
		
		override protected function preTransitionIn():void 
		{		
			Manager.display.hideModule(ModuleID.TOP_BAR);
			
			_percentCurr = 0;
			playerInitialized = false;
			loadResourceComplete = false;
			_ready = false;
			
			LoadingView(baseView).initUI();
			
			Game.network.lobby.addEventListener(Server.SERVER_DATA, onLobbyServerData);
			Game.network.game.addEventListener(Server.SERVER_DATA, onGameServerData);
			Game.network.game.addEventListener(Server.SERVER_CONNECTED, onGameServerConnected);
			Game.network.game.addEventListener(Server.SERVER_CONNECTION_FAIL, onGameServerConnectionFail);
			Game.network.game.addEventListener(Server.SERVER_RETRY, onGameServerRetry);
				
			var timeOut:int = Game.database.gamedata.getConfigData(GameConfigID.MAX_LOADING_TIME_OUT)*1000;
			Utility.log( "preTransitionIn.timeOut : " + timeOut );

			var lobbyInfo:LobbyInfo = extraInfo as LobbyInfo;
			if (!GameReplayManager.getInstance().isReplaying)
			{	
				var address:ServerAddress = Game.database.userdata.gameServerAddress;
				Utility.log("connecting to game server...");
				Game.network.game.connect(address.ip, address.port);
			}
			SoundManager.stopAllSound();
		}
		
		private function onGameServerRetry(e:EventEx):void 
		{
			Manager.display.showMessage("Kết nối game server thất bại! Kết nối lại lần " + e.data);
		}
		
		override protected function onTransitionInComplete():void 
		{
			super.onTransitionInComplete();

			startTimer();

			if (GameReplayManager.getInstance().isReplaying)
			{
				var modeData:ModeData = Game.database.userdata.getCurrentModeData();
				if(modeData != null)
				{
					modeData.init();
				}
				switch(Game.database.userdata.getGameMode().worldMode)
				{
					case WorldMode.PVE:
						Manager.module.load(ModuleID.INGAME_PVE, onLoadIngameModuleComplete);
						break;
					case WorldMode.PVP:
						Manager.module.load(ModuleID.INGAME_PVP, onLoadIngameModuleComplete);
						break;
				}	
			}
		}
		
		override protected function onTransitionOutComplete():void 
		{
			super.onTransitionOutComplete();
			Game.network.lobby.removeEventListener(Server.SERVER_DATA, onLobbyServerData);
			Game.network.game.removeEventListener(Server.SERVER_DATA, onGameServerData);
			Game.network.game.removeEventListener(Server.SERVER_CONNECTED, onGameServerConnected);
			Game.network.game.removeEventListener(Server.SERVER_CONNECTION_FAIL, onGameServerConnectionFail);
			Game.network.game.removeEventListener(Server.SERVER_RETRY, onGameServerRetry);
		}
		
		private function onGameServerData(e:EventEx):void 
		{
			var packet:ResponsePacket = e.data as ResponsePacket;
			switch(packet.type)
			{
				case GameResponseType.INIT_PLAYER:
					onInitPlayerResult(packet as ByteResponsePacket);
					break;
			}
		}			
		
		private function onGameServerConnectionFail(e:Event):void 
		{
			Manager.display.showDialog(DialogID.YES_NO, onAcceptStopConnectHdl, null, {title: "THÔNG BÁO", message: "Kết nối game server thất bại! Hủy kết nối", option: YesNo.YES});
		}
		
		private function onAcceptStopConnectHdl(data:Object):void 
		{
			Game.database.userdata.getCurrentModeData().backModuleID = ModuleID.HOME;
			Game.flow.doAction(FlowActionEnum.LEAVE_GAME);
			HUDModule(Manager.module.getModuleByID(ModuleID.HUD)).closeSelectedModule();
		}
		
		private function onGameServerConnected(e:Event):void 
		{
			Utility.log("game server connected, init player...");
			Game.network.game.sendPacket(new IntRequestPacket(GameRequestType.INIT_PLAYER, Game.database.userdata.userID));
		}
		
		private function onLobbyServerData(e:EventEx):void 
		{
			var packet:ResponsePacket = e.data as ResponsePacket;
			switch(packet.type)
			{
				case LobbyResponseType.UPDATE_LOADING_PERCENT:
					var packetPercent:ResponseUpdateLoadingPercent = packet as ResponseUpdateLoadingPercent;
					LoadingView(baseView).updatePercent(packetPercent.percents);
					if (!_ready && checkValidTransition(packetPercent.percents) ) {
						transToIngame();
					}					
					break;
			}
		}
		
		private function transToIngame():void {
			Utility.log("send requet to server to notify game client ready");
			_ready = true;
			LoadingView(baseView).transitionToInGame();
		}

		private function onLoadIngameModuleComplete():void
		{
			//send request to log load action start for ingame
			var lobbyInfo:LobbyInfo = extraInfo as LobbyInfo;
			if (!GameReplayManager.getInstance().isReplaying) Game.network.lobby.sendPacket(new RequestLogLoadingAction(1, 2));
			
			Utility.log("load ingame resource...");	
			
			urls.splice(0);
			switch(Game.database.userdata.getGameMode().worldMode)
			{
				case WorldMode.PVE:
					loadPvEIngameResource();
					break;
				case WorldMode.PVP:
					loadPvPIngameResource();
					break;
			}
			
			urls.push("resource/anim/ui/ui_tancong.banim");
			urls.push("resource/anim/ui/skill_text.banim");
			urls.push("resource/anim/font/font_skill_name.banim");
			urls.push("resource/anim/font/font_text.banim");
			urls.push("resource/anim/ui/chien_thang.banim");
			urls.push("resource/anim/ui/that_bai.banim");
			urls.push("resource/anim/ui/choi_lai.banim");
			urls.push("resource/anim/ui/choi_tiep.banim");
			urls.push("resource/anim/ui/lenh_bai.banim");
			urls.push("resource/anim/ui/quay_lai.banim");
			urls.push("resource/image/item/item_bac.png");
			urls.push("resource/image/item/icon_exp.png");
			urls.push("resource/anim/font/font_item_name_do.banim");
			urls.push("resource/anim/font/font_item_name_tim.banim");
			urls.push("resource/anim/font/font_item_name_trang.banim");


			Manager.resource.load(urls, onLoadIngameResourceComplete, onLoadIngameResourceProgress);
		}
		
		private function loadPvEIngameResource():void
		{
			var url:String;
			var formation:Array = Game.database.userdata.formation;
			for (var i:int = 0; i < formation.length; ++i)
			{
				var character:Character = formation[i];
				if (character != null)
				{
					GameUtil.preloadCharacter(urls, character.xmlData.ID, character.sex);
					var skill:Skill = character.getEquipSkill(SkillType.ACTIVE);
					if(skill != null && skill.xmlData != null) GameUtil.preloadSkill(urls, skill.xmlData.ID);
					skill = character.getEquipSkill(SkillType.PASSIVE);
					if(skill != null && skill.xmlData != null) GameUtil.preloadSkill(urls, skill.xmlData.ID);
				}
			}
			
			var modeData:ModeDataPvE = Game.database.userdata.getCurrentModeData() as ModeDataPvE;
			var missionData:MissionXML = Game.database.gamedata.getData(DataType.MISSION, modeData.missionID) as MissionXML;
			if (missionData != null)
			{
				for (i = 0; i < missionData.waves.length; ++i)
				{
					var unitIDs:Array = missionData.waves[i];
					for (var j:int = 0; j < unitIDs.length; ++j)
					{
						GameUtil.preloadCharacter(urls, unitIDs[j], 0, true);
					}
				}
				addBackground(missionData.backgroundID);
			}
		}
		
		private function loadPvPIngameResource():void
		{
			for (var i:int = 0; i < Game.database.userdata.lobbyPlayers.length; ++i)
			{
				var player:LobbyPlayerInfo = Game.database.userdata.lobbyPlayers[i];
				for (var j:int = 0; j < player.characters.length; ++j)
				{
					var character:Character = player.characters[j];
					if(character != null && character.xmlData)
					{
						GameUtil.preloadCharacter(urls, character.xmlData.ID, character.sex);
						var skill:Skill = character.getEquipSkill(SkillType.ACTIVE);
						if(skill != null && skill.xmlData != null) GameUtil.preloadSkill(urls, skill.xmlData.ID);
						skill = character.getEquipSkill(SkillType.PASSIVE);
						if(skill != null && skill.xmlData != null) GameUtil.preloadSkill(urls, skill.xmlData.ID);
					}
				}
			}
			
			var gameMode:GameMode = Game.database.userdata.getGameMode();
			var modeConfigXML:ModeConfigXML = Game.database.gamedata.getData(DataType.MODE_CONFIG, gameMode.ID) as ModeConfigXML;
			if(modeConfigXML != null) addBackground(modeConfigXML.backGroundID);
		}			
		
		private function onLoadIngameResourceComplete():void 
		{
			//send request to log load action completed for ingame
			var lobbyInfo:LobbyInfo = extraInfo as LobbyInfo;
			if (!GameReplayManager.getInstance().isReplaying) Game.network.lobby.sendPacket(new RequestLogLoadingAction(2, 2));
			
			Utility.log("load resource complete");
			loadResourceComplete = true;
			_percentCurr = 100;
			
			if (!GameReplayManager.getInstance().isReplaying) Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.UPDATE_LOADING_PERCENT, _percentCurr));
			else 
			{
				transToIngame();
				GameReplayManager.getInstance().startPlay();
			}
		}
		
		private function onInitPlayerResult(packet:ByteResponsePacket):void
		{
			Utility.log("init player result: " + packet.value + " // " + _percentCurr);
			
			// do nothing in replaymode
			if (GameReplayManager.getInstance().isReplaying) return;
			
			var modeData:ModeData = Game.database.userdata.getCurrentModeData();
			if(modeData != null)
			{
				modeData.init();
			}
			switch(Game.database.userdata.getGameMode().worldMode)
			{
				case WorldMode.PVE:
					Manager.module.load(ModuleID.INGAME_PVE, onLoadIngameModuleComplete);
					break;
				case WorldMode.PVP:
					Manager.module.load(ModuleID.INGAME_PVP, onLoadIngameModuleComplete);
					break;
			}		
			
			if(packet.value == 0)
			{
				playerInitialized = true;
				Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.UPDATE_LOADING_PERCENT, _percentCurr));
			}
		}
		
		private function onLoadIngameResourceProgress(progress:Number):void
		{
			var percent:int = (0.1 + progress * 0.9) * 100;
			if (percent - _percentCurr >= PERCENT_UPDATE_INTERVAL /*|| percent == 100*/) {
				_percentCurr = percent;
				if (!GameReplayManager.getInstance().isReplaying) Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.UPDATE_LOADING_PERCENT, percent));
			}
		}
		
		private function checkValidTransition(data:Array):Boolean 
		{
			var result:Boolean = true;
			for (var i:int = 0; i < data.length; i++) {
				if (data[i].percent != 100) {
					result = false;
					break;
				}				
			}
			
			return result && playerInitialized && loadResourceComplete;
		}
		
		private function addBackground(ID:int):void
		{
			var backgroundXML:BackgroundXML = Game.database.gamedata.getData(DataType.BACKGROUND, ID) as BackgroundXML;
			if (backgroundXML != null)
			{
				for each (var layerID:int in backgroundXML.layerIDs)
				{
					var backgroundLayerXML:BackgroundLayerXML = Game.database.gamedata.getData(DataType.BACKGROUND_LAYER, layerID) as BackgroundLayerXML;
					if(backgroundLayerXML != null)
					{
						var url:String = backgroundLayerXML.url
						urls.push(url);
						if(backgroundLayerXML.useAlphaMask)
						{
							var ext:String = url.substring(url.lastIndexOf("."));
							var maskURL:String = url.replace(ext, "_mask" + ext);
							urls.push(maskURL);
						}
					}
				}
			}
		}
	}

}