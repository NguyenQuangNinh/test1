package game
{
	import com.adobe.crypto.MD5;
    import com.adobe.utils.StringUtil;
    import com.greensock.plugins.ColorMatrixFilterPlugin;
	import com.greensock.plugins.ColorTransformPlugin;
	import com.greensock.plugins.TweenPlugin;
	import components.KeyUtils;
	import components.StageManager;
	import core.service.ServiceVLCBBase;
	import game.data.vo.flashvar.FlashVar;
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.external.ExternalInterface;
	import flash.geom.Transform;
	
	import core.Manager;
	import core.event.EventEx;
	import core.util.Utility;
	
	import game.data.model.ServerAddress;
	import game.data.model.UserData;
	import game.net.ResponsePacket;
	import game.net.Server;
	import game.net.lobby.LobbyResponseType;
	import game.net.lobby.request.RequestLoginPacket;
	import game.net.lobby.response.ResponseLogin;
	import game.ui.ModuleID;
	import game.ui.components.LostFocus;
	import game.ui.create_character.CreateCharacterModule;
	import game.ui.create_character.CreateCharacterView;
	
	/**
	 * ...
	 * @author TrungLNM
	 */
	[SWF(frameRate="60",width="1260",height="650")]
	
	public class Main extends Sprite
	{
		public static const GAME_READY:String = "game_ready";
		public static const UPDATE_PROGRESS:String = "update_progress";
		
		private var nextModule:ModuleID;
		private var initialized:Boolean;
		private var newUser:Boolean;
		private var lostFocus:LostFocus;
		
		public function Main()
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			initialized = false;
			newUser = false;
		}
		
		private function onAddedToStage(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			if (initialized == false)
			{
				init(stage, root.loaderInfo.parameters);
			}
		}
		
		public function init(stage:Stage, parameters:Object, extraInfo:Object = null):void
		{
			StageManager.getInstance().initStage(stage);
			TweenPlugin.activate([ColorTransformPlugin, ColorMatrixFilterPlugin]);
			if (ExternalInterface.available == false)
			{
				//parameters.user = "maibo02";
				//parameters.user = "ninhvngG42";
				//parameters.user = "longmm";
				//parameters.user = "longmm2";
				//parameters.user = "longmm3";
				//parameters.user = "longmm4";
				//parameters.user = "longmm5";
				
				//parameters.user = "longmm1";
				//parameters.user = "longmm10";
				//parameters.user = "longmm11";
				//parameters.user = "yuu1";
				//parameters.user = "yuu5";
				//parameters.user = "longmm16";
				//parameters.user = "longmm17";
				parameters.user = "longmm4";
				//parameters.user = "longmm27";
				//parameters.user = "longmm28";
				//parameters.user = "longmm21";
				
				parameters.userID = "40857858";
				parameters.src = "longmm2";
				parameters.mode = "1";
				parameters.pid = "vlbd";
				parameters.time = "1311748361";
				parameters.rand = "1464632665";
				parameters.server = "1";
				parameters.channel = "local";
				parameters.rooturl = "";
				parameters.version = "1.1.0";
				parameters.config = "config.xml?version=" + parameters.version;
				parameters.key = MD5.hash(parameters.user +parameters.pid + parameters.server + parameters.time + "MCAyeY3asdj34lkKLas329Fcsxj1YO7");
			}
		
			//init manager
			Manager.initialize(stage, Game.WIDTH, Game.HEIGHT, parameters.rooturl, parameters.version);
			Game.initialize(stage, extraInfo ? extraInfo : parameters);
			Game.database.flashVar.parse(parameters);
			Game.database.userdata.accountName = Game.database.flashVar.user;
			
			Game.database.gamedata.addEventListener(Event.COMPLETE, onGameDataLoadingComplete);
			Game.network.lobby.addEventListener(Server.SERVER_CONNECTED, onLobbyServerConnected);
			Game.network.lobby.addEventListener(Server.SERVER_DATA, onLobbyServerData);
			
			Manager.display.getStage().addEventListener(Event.ACTIVATE, stage_onActivate);
			Manager.display.getStage().addEventListener(Event.DEACTIVATE, stage_onDeactivate);
			Game.database.gamedata.initTracing();
			// performance hack
			Manager.pool.push(new Transform(this));
			
			Game.so6Tracker.track(5, "load font & ui lib");
			Manager.resource.load(["./resource/fonts/vi_styles.font", "./resource/ui/ui_lib.swf"], onLoadFontComplete, onLoadFontProgress);
			
			initialized = true;
			
			/*nextModule = ModuleID.TEST;
			start();*/
		
		/*GameUtil.initFpsTextField();
		   GameUtil.fpsTextfield.x = 150;
		   GameUtil.fpsTextfield.y = 100;
		   stage.addChild(GameUtil.fpsTextfield);
		 Manager.time.addFPSTf(GameUtil.fpsTextfield);*/
		}
		
		private function onLoadFontProgress(percent:Number):void 
		{
			var t:String = "Đang tải thư viện (" + int(percent * 100) + "%)";
			dispatchEvent(new EventEx(UPDATE_PROGRESS, t));
		}
		
		protected function stage_onActivate(event:Event):void
		{
			if (lostFocus && lostFocus.parent == Manager.display.getContainer())
			{
				Manager.display.getContainer().removeChild(lostFocus);
			}
		}
		
		protected function stage_onDeactivate(event:Event):void
		{
			if (lostFocus)
			{
				Manager.display.getContainer().addChild(lostFocus);
			}
		}
		
		public function start():void
		{
			Game.so6Tracker.track(10, "show preloader...");
			Manager.display.to(nextModule);
			/*if (nextModule == ModuleID.PRELOADER)
			{
				PreloaderModule(Manager.module.getModuleByID(ModuleID.PRELOADER)).load();
			}*/
			dispatchEvent(new Event(GAME_READY));
			KeyUtils.init(stage);
            if (!ExternalInterface.available || Boolean(int(StringUtil.trim(stage.getChildAt(0).loaderInfo.parameters.mode))))
            {
                DebuggerUtil.getInstance().init(this.stage);
            }
		}
		
		private function onLoadFontComplete():void
		{
			
			Game.so6Tracker.track(6, "load game data");
			lostFocus = new LostFocus();
			Game.database.gamedata.addEventListener(UPDATE_PROGRESS, function(e:EventEx):void { dispatchEvent(e)} );
			trace("start load game data!");
			Game.database.gamedata.load();
			Game.hint.init();
		}
		
		protected function onGameDataLoadingComplete(event:Event):void
		{
			Game.so6Tracker.track(7, "connect to lobby");
			dispatchEvent(new EventEx(Main.UPDATE_PROGRESS, "Kết nối với máy chủ..."));
			
			var lobbyAddress:ServerAddress = Game.database.gamedata.externalConfig.lobbyAddress;
			Utility.log("connect to lobby server: " + lobbyAddress.toString());
			Game.network.lobby.connect(lobbyAddress.ip, lobbyAddress.port);
			
			Game.logService = new ServiceVLCBBase(Game.database.gamedata.serviceConfig.logService);
			//Game.logService.requestTracking("0_0", "test cho VLCB"); test
		}
		
		protected function onLobbyServerConnected(event:Event):void
		{
			Game.so6Tracker.track(8, "start login");
			var userdata:UserData = Game.database.userdata;
			Utility.log("login with accountName=" + userdata.accountName);
			
			var flashVar:FlashVar = Game.database.flashVar;
			Game.network.lobby.sendPacket(new RequestLoginPacket(userdata.accountName, "", 0, 0, flashVar.pid, flashVar.time, flashVar.key, parseInt(flashVar.server), flashVar.channel));
			Utility.log("server id: " + parseInt(flashVar.server));
		}
		
		private function onLobbyServerData(e:EventEx):void
		{
			var packet:ResponsePacket = ResponsePacket(e.data);
			switch (packet.type)
			{
				case LobbyResponseType.LOGIN: 
					onLogin(packet as ResponseLogin);
					break;
			}
		}
		
		private function onLogin(packet:ResponseLogin):void
		{
			Game.so6Tracker.track(9, "received login result");
			Utility.log("login result: " + packet.errorCode);
			Game.database.userdata.isFirstTutorial = false;
			switch (packet.errorCode)
			{
				case 0: 
					//login success
					Game.database.userdata.userID = packet.userID;
					if (newUser)
					{
						Manager.tutorial.playNextTutorial();
						Manager.display.to(ModuleID.PRELOADER);
					}
					else
					{
						nextModule = ModuleID.PRELOADER;
						Manager.module.load(nextModule, onNextModuleLoaded, onLoadModuleProgress);
					}
					break;
				case 1: 
					//login fail by normal error					
					break;
				case 2: 
					//login fail by wrong id
					break;
				case 3: 
					//login fail by full-player
					break;
				case 4: 
					//login fail by null-player
					break;
				case 5: 
					//login fail by existed role name
					//Manager.display.showMessage(MessageID.REGISTER_EXISTED_ROLE_NAME);
					var module:CreateCharacterModule = Manager.module.getModuleByID(ModuleID.CREATE_CHARACTER) as CreateCharacterModule;
					(module.baseView as CreateCharacterView).checkNameResult = true;
					break;
				case 6: 
					//login fail by not existed account name 
					newUser = true;
					Game.database.userdata.isFirstTutorial = true;
					nextModule = ModuleID.PRELOADER;
					Manager.module.load(nextModule, onNextModuleLoaded, onLoadModuleProgress);
					break;
			}
		}
		
		private function onLoadModuleProgress(percent:Number):void 
		{
			var t:String = "Khởi tạo bản đồ (" + int(percent * 100) + "%)";
			dispatchEvent(new EventEx(UPDATE_PROGRESS, t));
		}
		
		private function onNextModuleLoaded():void
		{
			start();
		}
	}
}