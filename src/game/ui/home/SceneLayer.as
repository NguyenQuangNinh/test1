package game.ui.home
{
	import com.greensock.data.TweenMaxVars;
	import com.greensock.TweenMax;
	import core.event.EventEx;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import game.data.xml.ModeConfigXML;
	import game.enum.FocusSignalType;
	import game.enum.GameMode;
	import game.enum.QuestMainState;
	import game.ui.components.FocusSignal;
	import game.ui.home.scene.NPC;
	import game.ui.home.scene.ThreePhaseNPC;
	import game.ui.hud.HUDButtonID;
	import game.ui.tooltip.TooltipEvent;
	import game.ui.tooltip.TooltipID;
	
	import core.Manager;
	import core.display.BitmapEx;
	import core.display.layer.Layer;
	import core.display.layer.LayerManager;
	import core.util.Utility;
	
	import game.Game;
	import game.data.model.ModeConfigGlobalBoss;
	import game.data.model.shop.SecretMerchantShopConfig;
	import game.data.xml.DataType;
	import game.data.xml.FeatureXML;
	import game.data.xml.SecretMerchantEventXML;
	import game.ui.ModuleID;
	import game.ui.components.InteractiveAnim;
	import game.ui.dialog.DialogID;
	import game.ui.home.gui.CharacterLayer;
	import game.ui.home.scene.CharacterManager;
	import game.utility.Ticker;
	
	//import game.ui.home.event.EventHome;
	
	/**
	 * ...
	 * @author anhtinh
	 */
	public class SceneLayer extends Sprite
	{
		private static const BG_SLIDE_WIDTH:int = 1260;
		private static const BTN_NPC_BEGIN_X:int = 600;
		private static const BTN_NPC_Y:int = 370 + 65;
		private static const BTN_NPC_DELTA_X:int = 120 * 2;
		private static const NPC_DISTANCE_X:int = 800 / 2;
		private static const CLOUD_WIDTH:int = 1300;
		
		//public var bgFarLayer : MovieClip;
		//public var fenceLayer : MovieClip;
		public var bgFarLayer:Sprite = new Sprite();
		public var cloudLayer:Sprite = new Sprite();
		public var bgNear2Con:Sprite;
		public var bgNear1Con:Sprite;
		public var bgNearLayer:Sprite = new Sprite();
		public var btnLayer:Sprite = new Sprite();
		public var characterLayer:CharacterLayer = new CharacterLayer();
		public var fenceLayer:Sprite = new Sprite();
		
		private var rentCharacterBtn:ThreePhaseNPC;
		//private var dailyQuestBtn:InteractiveAnim;
		private var pvpRankingBtn:ThreePhaseNPC;
		private var worldBossBtn:NPC;
		private var heroicBtn:ThreePhaseNPC;
		private var challengeCenterBtn:ThreePhaseNPC;
		private var leaderBoardBtn:NPC;
		private var secretMerchantBtn:NPC;
		private var arenaBtn:ThreePhaseNPC;
		
		private var targetX:int = 0;
		private var cloudContainer:Sprite;
		private var clound1:BitmapEx;
		private var clound2:BitmapEx;
		private var desX:Number;
		private var velocity:Number = 7;
		
		private var btnNPCs:Array;
		
		private var totalBgSlice:int = 2;
		private var sliceWidth:int = Game.WIDTH;
		private var sliceLoaded:int = 0;
		private var dragon:BitmapEx;
		
		public function SceneLayer()
		{
			this.mouseEnabled = false;
			
			init();
			initEvent();
		}
		
		public function moveToX(xPos:int):void
		{
			desX = Utility.math.clamp(xPos, -Game.WIDTH, 0);
		}
		
		private function init():void
		{
			
			//setup layer
			this.addChild(bgFarLayer);
			this.addChild(bgNearLayer);
			this.addChild(cloudLayer);
			this.addChild(btnLayer);
			this.addChild(characterLayer);
			this.addChild(fenceLayer);
			fenceLayer.mouseEnabled = false;
			
			loadHomeAnim();
			initBtn();
			setUpCloudLayer();
			initConditionalFeatures();
		}
		
		private function initBtn():void
		{
			
			var glow:GlowFilter = new GlowFilter();
			glow.color = 0x000EFF;
			glow.strength = 10;
			glow.blurX = glow.blurY = 4;
			
			rentCharacterBtn = new ThreePhaseNPC();
			rentCharacterBtn.loadAnim("resource/anim/ui/icon_ghdh.banim");
			
			worldBossBtn = new NPC();
			worldBossBtn.loadAnim("resource/anim/ui/icon_matdao.banim");
			
			heroicBtn = new ThreePhaseNPC();
			heroicBtn.loadAnim("resource/anim/ui/icon_aha.banim");
			
			//dailyQuestBtn = new InteractiveAnim();
			//dailyQuestBtn.loadAnim("resource/anim/ui/icon_datau.banim");
			
			pvpRankingBtn = new ThreePhaseNPC();
			pvpRankingBtn.loadAnim("resource/anim/ui/icon_hoasonluankiem.banim");
			
			challengeCenterBtn = new ThreePhaseNPC();
			challengeCenterBtn.loadAnim("resource/anim/ui/icon_thapcaothu.banim");
			
			leaderBoardBtn = new NPC();
			leaderBoardBtn.loadAnim("resource/anim/ui/icon_bangvinhdanh.banim");
			
			arenaBtn = new ThreePhaseNPC();
			arenaBtn.loadAnim("resource/anim/ui/icon_danhchan.banim");
			
			secretMerchantBtn = new NPC();
			secretMerchantBtn.loadAnim("resource/anim/ui/icon_cao_nhan_than_bi.banim");
			secretMerchantBtn.enableMoving(true);
			
			btnNPCs = [];
			var featureXMLs:Dictionary = Game.database.gamedata.getTable(DataType.FEATURE);
			for each (var featureXML:FeatureXML in featureXMLs)
			{
				if (featureXML.type == FeatureXML.NPC_BUTTON)
				{
					var btnNpc:InteractiveAnim = this[featureXML.instanceName];
					if (btnNpc != null)
					{
						btnNpc.positionIndex = featureXML.positionIndex;
						btnNpc.setHitArea(new Rectangle(0, 0, 100, 110));
						
						btnNpc.x = featureXML.posX;
						btnNpc.y = featureXML.posY;
						btnNpc.visible = true;
						btnNpc.loadIcon(featureXML.url);
						
						btnNPCs.push(btnNpc);
					}
				}
			}
			btnNPCs.sortOn("positionIndex", Array.NUMERIC);
			
			this.btnLayer.addChild(pvpRankingBtn);
			this.btnLayer.addChild(worldBossBtn);
			this.btnLayer.addChild(rentCharacterBtn);
			//this.btnLayer.addChild(dailyQuestBtn);
			this.btnLayer.addChild(heroicBtn);
			this.btnLayer.addChild(challengeCenterBtn);
			this.btnLayer.addChild(leaderBoardBtn);
			this.btnLayer.addChild(arenaBtn);
			
			updateDisplayNPC();
		}
		
		public function updateDisplayNPC():void
		{
			var currentLevel:int = Game.database.userdata.level;
			var featureXMLs:Dictionary = Game.database.gamedata.getTable(DataType.FEATURE);
			for each (var featureXML:FeatureXML in featureXMLs)
			{
				if (featureXML.type == FeatureXML.NPC_BUTTON)
				{
					var btn:InteractiveAnim = this[featureXML.instanceName];
					if (btn != null)
					{
						btn.setVisibleIcon(currentLevel >= featureXML.levelRequirement);
					}
				}
			}
		/*for (var i:int = 0; i < btnNPCs.length; i++)
		   {
		   var obj:InteractiveAnim = btnNPCs[i];
		   if (obj != null)
		   {
		   obj.y = BTN_NPC_Y;
		   if (i < btnNPCs.length / 2)
		   obj.x = BTN_NPC_BEGIN_X + i * BTN_NPC_DELTA_X;
		   else
		   obj.x = BTN_NPC_BEGIN_X + i * BTN_NPC_DELTA_X + NPC_DISTANCE_X;
		
		   }
		 }*/
		}
		
		private function initConditionalFeatures():void
		{
			var gameModeConfig:ModeConfigGlobalBoss = Game.database.gamedata.getGlobalBossConfig();
			var globalBossConfig:Array = gameModeConfig.timeOpen.concat(gameModeConfig.timeClose);
			var secretMerchantShop:SecretMerchantEventXML = Game.database.gamedata.getData(DataType.SECRET_MERCHANT_EVENT, Game.database.userdata.secretMerchantEventID) as SecretMerchantEventXML;
			if (secretMerchantShop)
			{
				for each (var serverConfig:SecretMerchantShopConfig in secretMerchantShop.serverDatas)
				{
					if (serverConfig && serverConfig.serverID == parseInt(Game.database.flashVar.server))
					{
						var secretMerchantConfig:Array = serverConfig.openTime.concat(serverConfig.closeTime);
						break;
					}
				}
			}
			var configArr:Array;
			if (secretMerchantConfig) {
				configArr = globalBossConfig.concat(secretMerchantConfig);	
			} else {
				configArr = globalBossConfig;
			}
			configArr.sort(Array.NUMERIC);
			
			var arrCallbackFuncs:Array = [];
			var callbackFuncs:Array;
			var time:Number;
			var timeOpen:Number;
			var timeClose:Number;
			
			var logginDate:Date = new Date(Game.database.userdata.loginTime);
			trace("logginDate ============== " + logginDate.toString());
			var loginTimeInHour:Number = new Date(Game.database.userdata.loginTime).getHours();
			for (var j:int = 0; j < gameModeConfig.timeOpen.length; j++)
			{
				if (loginTimeInHour >= new Date(gameModeConfig.timeOpen[j]).getHours() && loginTimeInHour < new Date(gameModeConfig.timeClose[j]).getHours())
				{
					onGlobalBossOpen();
					break;
				}
			}
			for (var i:int = 0; i < configArr.length; i++)
			{
				callbackFuncs = [];
				var trigger:Boolean = false;
				for (j = 0; j < gameModeConfig.timeOpen.length; j++)
				{
					time = new Date(configArr[i]).getHours() * 24 * 60 * 60 * 1000;
					timeOpen = new Date(gameModeConfig.timeOpen[j]).getHours() * 24 * 60 * 60 * 1000;
					timeClose = new Date(gameModeConfig.timeClose[j]).getHours() * 24 * 60 * 60 * 1000;
					if (time >= timeOpen && time < timeClose)
					{
						trigger = true;
						break;
					}
				}
				trigger == true ? callbackFuncs.push(onGlobalBossOpen) : callbackFuncs.push(onGlobalBossNotReady);
				
				var trigger2:Boolean = false;
				if (serverConfig)
				{
					for (var k:int = 0; k < serverConfig.openTime.length; k++)
					{
						if (configArr[i] >= serverConfig.openTime[k] && configArr[i] < serverConfig.closeTime[k])
						{
							trigger2 = true;
							break;
						}
					}
				}
				trigger2 == true ? callbackFuncs.push(onSecretMerchantShopOpen) : callbackFuncs.push(onSecretMerchantShopNotReady);
				arrCallbackFuncs.push(callbackFuncs);
			}
			
			FeatureManager.getInstance().init(configArr, arrCallbackFuncs);
		}
		
		public function onTransitionIn():void
		{
			//updateDisplayNPC();
			//tweenCloud();
			targetX = 0;
			targetX = targetX - CLOUD_WIDTH;
			Ticker.getInstance().addEnterFrameFunction(update);
			Utility.log( "SceneLayer.onTransitionIn" );
			
			var modeXMLs:Dictionary = Game.database.gamedata.getTable(DataType.MODE_CONFIG);
			if (modeXMLs) {
				var state:int = 0;
				var timeNow:Date = new Date();
				timeNow.time = Game.database.userdata.timeNow;
				for each (var modeXML:ModeConfigXML in modeXMLs) {
					if (GameMode.PVP_2vs2_MM.ID == modeXML.ID || GameMode.PVP_3vs3_MM.ID == modeXML.ID || GameMode.PVP_1vs1_MM.ID == modeXML.ID)
					{
						for (var i:int = 0; i < modeXML.timeOpen.length; i++)
						{
							if (timeNow.hours>=modeXML.timeOpen[i] && timeNow.hours<modeXML.timeClose[i]) {
								state = 1;
								break;
							}
						}
						if (state == 1)
							break;
					}
				}
				updateArenaBtnState(state);
			}
			
			CharacterManager.instance.registerKeyEvents();
		}
		
		public function onTransitionOutComplete():void
		{
			cloudContainer.x = 0;
			clound1.x = 0;
			clound2.x = CLOUD_WIDTH;
			
			Ticker.getInstance().removeEnterFrameFunction(update);
			Utility.log( "SceneLayer.onTransitionOutComplete" );
			
			resetView();
			
			CharacterManager.instance.unregisterKeyEvents();
		}
		
		private function onSecretMerchantShopOpen():void
		{
			trace("onSecretMerchantShopOpen");
			if (secretMerchantBtn.parent != btnLayer)
			{
				secretMerchantBtn.x = Utility.math.random(CharacterManager.CHARACTER_AREA.x, CharacterManager.CHARACTER_AREA.x + Game.WIDTH);
				secretMerchantBtn.y = Utility.math.random(CharacterManager.CHARACTER_AREA.y, CharacterManager.CHARACTER_AREA.y + CharacterManager.CHARACTER_AREA.height);
				btnLayer.addChild(secretMerchantBtn);
			}
		}
		
		private function onSecretMerchantShopNotReady():void
		{
			trace("onSecretMerchantShopNotReady");
			if (secretMerchantBtn.parent == btnLayer)
			{
				btnLayer.removeChild(secretMerchantBtn);
			}
		}
		
		private function onGlobalBossNotReady():void
		{
			trace("onGlobalBossNotReady");
			Game.database.userdata.worldBossEnable = false;
		}
		
		private function onGlobalBossOpen():void
		{
			trace("onGlobalBossOpen");
			Game.database.userdata.worldBossEnable = true;
		}
		
		private function setUpCloudLayer():void
		{
			clound1 = new BitmapEx();
			clound1.load("resource/image/ui/may.png");
			
			clound2 = new BitmapEx();
			clound2.load("resource/image/ui/may.png");
			clound2.x = CLOUD_WIDTH;
			
			cloudContainer = new Sprite();
			cloudContainer.addChild(clound1);
			cloudContainer.addChild(clound2);
			
			cloudLayer.addChild(cloudContainer);		
		}
		
		private function update():void
		{
			cloudContainer.x -= 0.5;
			
			if (cloudContainer.x < targetX)
			{
				targetX = targetX - CLOUD_WIDTH;
				
				if (clound1.x < clound2.x)
				{
					clound1.x = clound2.x + CLOUD_WIDTH;
				}
				else
				{
					clound2.x = clound1.x + CLOUD_WIDTH;
				}
			}
			
			if (Math.abs(desX - this.x) >= velocity)
			{
				this.x += velocity * ((desX - this.x) / Math.abs(desX - this.x));
				bgNear2Con.x = - (BG_SLIDE_WIDTH - Game.WIDTH / 2) * 0.4 - this.x * 0.4;
				bgNear1Con.x = - (BG_SLIDE_WIDTH - Game.WIDTH / 2) * 0.2 - this.x * 0.2;
			}
		}
		
		private function loadHomeAnim():void
		{
			var bgDummy:BitmapEx = new BitmapEx();
			bgDummy.load("resource/image/ui/ui_home_mini.jpg");
			bgNearLayer.addChild(bgDummy);
			bgDummy.addEventListener(BitmapEx.LOADED, onDummyBGLoaded);
			
			bgNear2Con = new Sprite();
			bgNearLayer.addChild(bgNear2Con);
			bgNear2Con.x = - (BG_SLIDE_WIDTH - Game.WIDTH / 2) * 0.4;
			var bgbm:BitmapEx;
			for (var i:int = 0; i < totalBgSlice; i++) 
			{
				bgbm = new BitmapEx();
				bgbm.load("resource/image/ui/homebg/home2_" + (i+1) + ".jpg");
				bgbm.x = i * sliceWidth;
				bgNear2Con.addChild(bgbm);
				bgbm.addEventListener(BitmapEx.LOADED, onBGLoaded);
			}
			
			bgNear1Con = new Sprite();
			bgNearLayer.addChild(bgNear1Con);
			bgNear1Con.x = - (BG_SLIDE_WIDTH - Game.WIDTH / 2) * 0.2;
			for (i = 0; i < totalBgSlice; i++) 
			{
				bgbm = new BitmapEx();
				bgbm.load("resource/image/ui/homebg/home1_" + (i+1) + ".jpg", true);
				bgbm.x = i * sliceWidth;
				bgNear1Con.addChild(bgbm);
				bgbm.addEventListener(BitmapEx.LOADED, onBGLoaded);
			}
			
			for (i = 0; i < totalBgSlice; i++) 
			{
				bgbm = new BitmapEx();
				bgbm.load("resource/image/ui/homebg/home0_" + (i+1) + ".jpg", true);
				bgbm.x = i * sliceWidth;
				bgNearLayer.addChild(bgbm);
				bgbm.addEventListener(BitmapEx.LOADED, onBGLoaded);
			}
			
			dragon = new BitmapEx();
			dragon.load("resource/image/ui/homebg/dragon.png");
			dragon.x = 1072;
			dragon.y = 5;
			bgNearLayer.addChild(dragon);
			doDragonAnim();
			
			/*var bgNear3:BitmapEx = new BitmapEx();
			bgNear3.load("resource/image/ui/caygan.png");
			bgNear3.x = 40;
			bgNear3.y = 570;
			bgNearLayer.addChild(bgNear3);*/
		}
		
		private function doDragonAnim():void 
		{
			if (dragon.y == 5) TweenMax.to(dragon, 1, { y: dragon.y - 10,  onComplete: doDragonAnim} ); // scaleX: 0.95, scaleY: 0.95,
			else TweenMax.to(dragon, 1, { y: dragon.y + 10,  onComplete: doDragonAnim} ); // scaleX: 1, scaleY: 1,
		}
		
		private function onDummyBGLoaded(e:Event):void 
		{
			var bg:BitmapEx = e.target as BitmapEx;
			bg.removeEventListener(BitmapEx.LOADED, onDummyBGLoaded);
			bg.width = 2520;
			bg.height = 650;
		}
		
		private function onBGLoaded(e:Event):void 
		{
			var target:BitmapEx = e.target as BitmapEx;
			target.removeEventListener(BitmapEx.LOADED, onBGLoaded);
			sliceLoaded++;
			
			if (sliceLoaded == totalBgSlice * 3) {
				var bg:BitmapEx = bgNearLayer.getChildAt(0) as BitmapEx;
				if (bg.url == "resource/image/ui/ui_home_mini.jpg") 
				{
					bgNearLayer.removeChildAt(0);
					bg.destroy();
				}
			}
		}
		
		private function initEvent():void
		{
			rentCharacterBtn.addEventListener(MouseEvent.CLICK, onBtnClickHdl);
			pvpRankingBtn.addEventListener(MouseEvent.CLICK, onBtnClickHdl);
			worldBossBtn.addEventListener(MouseEvent.CLICK, onBtnClickHdl);
			heroicBtn.addEventListener(MouseEvent.CLICK, onBtnClickHdl);
			challengeCenterBtn.addEventListener(MouseEvent.CLICK, onBtnClickHdl);
			leaderBoardBtn.addEventListener(MouseEvent.CLICK, onBtnClickHdl);
			arenaBtn.addEventListener(MouseEvent.CLICK, onBtnClickHdl);
			secretMerchantBtn.addEventListener(MouseEvent.CLICK, onBtnClickHdl);
			
			rentCharacterBtn.addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			rentCharacterBtn.addEventListener(MouseEvent.ROLL_OUT, onRollOut);
			
			pvpRankingBtn.addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			pvpRankingBtn.addEventListener(MouseEvent.ROLL_OUT, onRollOut);
			
			worldBossBtn.addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			worldBossBtn.addEventListener(MouseEvent.ROLL_OUT, onRollOut);
			
			heroicBtn.addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			heroicBtn.addEventListener(MouseEvent.ROLL_OUT, onRollOut);
			
			challengeCenterBtn.addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			challengeCenterBtn.addEventListener(MouseEvent.ROLL_OUT, onRollOut);
			
			leaderBoardBtn.addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			leaderBoardBtn.addEventListener(MouseEvent.ROLL_OUT, onRollOut);
			
			arenaBtn.addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			arenaBtn.addEventListener(MouseEvent.ROLL_OUT, onRollOut);
			
			secretMerchantBtn.addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			secretMerchantBtn.addEventListener(MouseEvent.ROLL_OUT, onRollOut);
		}
		
		private function onRollOut(e:MouseEvent):void
		{
			switch (e.target)
			{
				case rentCharacterBtn:
				case pvpRankingBtn:
				case worldBossBtn:
				case heroicBtn:
				case challengeCenterBtn:
				case leaderBoardBtn:
				case arenaBtn:
				case secretMerchantBtn: 
					dispatchEvent(new EventEx(TooltipEvent.HIDE_TOOLTIP, null, true));
					break;
			}
		}
		
		private function onRollOver(e:MouseEvent):void
		{
			switch (e.target)
			{
				case rentCharacterBtn:
					dispatchEvent(new EventEx(TooltipEvent.SHOW_TOOLTIP, {type: TooltipID.SIMPLE, value: "Nơi khiêu chiến các vị đại hiệp thành danh trên giang hồ.\nSau khi khiêu chiên có thể sử dụng Uy Danh để chiêu mộ các vị đại hiệp."}, true));
					break;
				case pvpRankingBtn:
					dispatchEvent(new EventEx(TooltipEvent.SHOW_TOOLTIP, {type: TooltipID.SIMPLE, value: "Khiêu chiến cá nhân. Mỗi người đều có số lần khiêu chiến nhất định trong ngày.\nCác vị đại hiệp còn có thể tranh hạng trên bảng vinh danh."}, true));
					break;
				case worldBossBtn:
					dispatchEvent(new EventEx(TooltipEvent.SHOW_TOOLTIP, {type: TooltipID.SIMPLE, value: "Cùng người chơi khác khiêu chiến BOSS thế giới để nhận được bạc và nhiều đạo cụ quý hiếm khác."}, true));
					break;
				case heroicBtn:
					dispatchEvent(new EventEx(TooltipEvent.SHOW_TOOLTIP, {type: TooltipID.SIMPLE, value: "Cùng người chơi khác khiêu chiến các ải anh hùng nhận được nhiều đạo cụ quý.\nMỗi ngày đều có số lần khiêu chiến nhất định. "}, true));
					break;
				case challengeCenterBtn:
					dispatchEvent(new EventEx(TooltipEvent.SHOW_TOOLTIP, {type: TooltipID.SIMPLE, value: "Khiêu chiến tháp cao thủ nhận được nhiều đạo cụ quý. Mỗi ngày được khiêu chiến 1 lần.\nĐánh bại cao thủ mỗi tầng trong Tháp Cao Thủ có thể mở lối vào tầng tiếp theo."}, true));
					break;
				case leaderBoardBtn:
					dispatchEvent(new EventEx(TooltipEvent.SHOW_TOOLTIP, {type: TooltipID.SIMPLE, value: "Bảng xếp hạng cao thủ."}, true));
					break;
				case arenaBtn:
					dispatchEvent(new EventEx(TooltipEvent.SHOW_TOOLTIP, {type: TooltipID.SIMPLE, value: "Danh Chấn Võ Lâm, gồm 3 chế độ: Luyện Tập, Tam Hùng Kỳ Hiệp và Võ Lâm Minh Chủ."}, true));
					break;
				case secretMerchantBtn: 
					break;				
				default: 
					break;
			}
		}
		
		private function checkUnlockNPC(npcID:int):Boolean
		{
			var currentLevel:int = Game.database.userdata.level;
			var featureXML:FeatureXML = Game.database.gamedata.getData(DataType.FEATURE, npcID) as FeatureXML;
			if (featureXML)
			{
				if (currentLevel >= featureXML.levelRequirement)
					return true;
				else
					Manager.display.showMessage("Tính năng " + featureXML.name + " được mở ở cấp:" + featureXML.levelRequirement);
			}
			return false;
		}
		
		private function onBtnClickHdl(e:MouseEvent):void
		{
			switch (e.currentTarget)
			{
				case worldBossBtn: 
				{
					if (checkUnlockNPC(HUDButtonID.WORLD_BOSS.ID))
					{
						if (Game.database.userdata.worldBossEnable)
						{
							Manager.display.showModule(ModuleID.SELECT_GLOBAL_BOSS, new Point(0, 0), LayerManager.LAYER_POPUP, "top_left", Layer.BLOCK_BLACK);
							CharacterManager.instance.hideCharacters();
						}
						else
						{
							showGlobalBossDialog();
						}
					}
				}
					break;
				
				case pvpRankingBtn: 
				{
					if (checkUnlockNPC(HUDButtonID.PVP_RANKING.ID))
					{
						Manager.display.showModule(ModuleID.CHALLENGE, new Point(0, 0), LayerManager.LAYER_POPUP, "top_left", Layer.BLOCK_BLACK);
					}
				}
					break;
				
				case rentCharacterBtn: 
				{
					if (checkUnlockNPC(HUDButtonID.RENT_CHARACTER.ID))
					{
						Manager.display.showModule(ModuleID.SHOP, new Point(0, 0), LayerManager.LAYER_POPUP);
					}
				}
					break;
				
				case heroicBtn: 
				{
					if (checkUnlockNPC(HUDButtonID.HEROIC.ID))
					{
						Manager.display.to(ModuleID.HEROIC_MAP, false);
					}
				}
					break;
				case challengeCenterBtn: 
				{
					if (checkUnlockNPC(HUDButtonID.CHALLENGE_CENTER.ID))
					{
						Manager.display.showModule(ModuleID.CHALLENGE_CENTER, new Point(), LayerManager.LAYER_POPUP, "top_left", Layer.BLOCK_BLACK);
					}
				}
					break;
				case leaderBoardBtn: 
				{
					if (checkUnlockNPC(HUDButtonID.LEADER_BOARD.ID))
					{
						Manager.display.showModule(ModuleID.LEADER_BOARD, new Point(), LayerManager.LAYER_POPUP);
					}
				}
					break;
				case arenaBtn: 
				{
					if (checkUnlockNPC(HUDButtonID.ARENA.ID))
					{
						Manager.display.showModule(ModuleID.ARENA, new Point(0, 0), LayerManager.LAYER_POPUP, "top_left", Layer.BLOCK_BLACK);
					}
				}
					break;
				case secretMerchantBtn: 
				{
					if (checkUnlockNPC(HUDButtonID.SECRET_MERCHANT.ID))
					{
						Manager.display.showModule(ModuleID.SHOP_SECRET_MERCHANT, new Point(), LayerManager.LAYER_POPUP, "top_left", Layer.BLOCK_BLACK);
					}
				}
					break;
			}
		}
		
		private function showGlobalBossDialog():void
		{
			var obj:Object = {};
			var gameModeConfig:ModeConfigGlobalBoss = Game.database.gamedata.getGlobalBossConfig();
			var timeOpen:Array = gameModeConfig.timeOpen;
			var timeClose:Array = gameModeConfig.timeClose;
			var content:String = "Thời gian mở cửa Mật Đạo:";
			var length:int = Math.min(timeOpen.length, timeClose.length);
			for (var i:int = 0; i < length; i++)
			{
				content += "\n- " + new Date(timeOpen[i]).getHours() + "h đến " + new Date(timeClose[i]).getHours() + "h";
			}
			obj.content = content;
			Manager.display.showDialog(DialogID.GLOBAL_BOSS_CONFIRM, null, null, obj, Layer.BLOCK_BLACK);
		}
		
		private function resetView():void
		{
			this.x = 0;
			desX = 0;
			bgNear2Con.x = - (BG_SLIDE_WIDTH - Game.WIDTH / 2) * 0.4 - this.x * 0.4;
			bgNear1Con.x = - (BG_SLIDE_WIDTH - Game.WIDTH / 2) * 0.2 - this.x * 0.2;
		}
		
		public function onSelectedModule(module:ModuleID):void {					
			switch(module) {
				case ModuleID.CHALLENGE:
					pvpRankingBtn.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
					break;
				case ModuleID.HEROIC_MAP:
					heroicBtn.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
					break;
				case ModuleID.SHOP:
					//chieu mo dai hiep
					rentCharacterBtn.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
					break;
				case ModuleID.HEROIC_TOWER:
					challengeCenterBtn.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
					break;
				case ModuleID.SELECT_GLOBAL_BOSS:
					//mat dao
					worldBossBtn.dispatchEvent(new MouseEvent(MouseEvent.CLICK));					
					break;
				case ModuleID.ARENA:
					arenaBtn.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
					break;
			}
		}
		
		private function updateArenaBtnState(state:int):void
		{
			FocusSignal.removeAllFocus(arenaBtn.getIconNPC());
			switch (state)
			{
				case 0: 
					//binh thuong					
					break;
				case 1:
					//tới giờ thi đấu
					FocusSignal.showFocus(FocusSignalType.SIGNAL_NEW.ID, arenaBtn.getIconNPC(), true);
					break;
			}
		}
		
		public function updateChallengeState(state:int):void
		{
			FocusSignal.removeAllFocus(pvpRankingBtn.getIconNPC());
			switch (state)
			{
				case 0: 
					//khong co qua					
					break;
				case 1:
					//co qua
					FocusSignal.showFocus(FocusSignalType.SIGNAL_COMPLETE.ID, pvpRankingBtn.getIconNPC(), true);
					break;
				case 2:	
					//change rank --> mean down by attacked
					FocusSignal.showFocus(FocusSignalType.SIGNAL_RED_ALERT.ID, pvpRankingBtn.getIconNPC(), true);
					break;
			}
		}
	}

}