package game.ui.global_boss 
{
	import com.greensock.easing.Back;
	import com.greensock.TweenMax;
	import core.display.animation.Animator;
	import core.display.layer.Layer;
	import core.display.ViewBase;
	import core.event.EventEx;
	import core.Manager;
	import core.util.FontUtil;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.setTimeout;
	import flash.utils.Timer;
	import game.data.model.GlobalBossData;
	import game.data.model.ModeConfigGlobalBoss;
	import game.data.model.UserData;
	import game.data.xml.CharacterXML;
	import game.data.xml.DataType;
	import game.data.xml.MissionXML;
	import game.enum.Font;
	import game.enum.ItemType;
	import game.enum.Sex;
	import game.Game;
	import game.ui.dialog.DialogID;
	import game.ui.home.scene.CharacterManager;
	import game.ui.ModuleID;
	import game.ui.tooltip.TooltipEvent;
	import game.ui.tooltip.TooltipID;
	import game.utility.UtilityUI;
	
	
	/**
	 * ...
	 * @author MaiPTT
	 */
	public class GlobalBossView extends ViewBase 
	{
		private static const REQUEST_BOSS_HP_DURATION	:int = 10;
		private static const TEXT_GREEN					:int = 0x00ff00;
		private static const TEXT_YELLOW				:int = 0xffff00;
		private static const GLOW_GREEN					:int = 0x003300;
		private static const GLOW_YELLOW				:int = 0x663300;
		
		public var btnBack			:SimpleButton;
		public var btnFight			:MovieClip;
		public var btnBuffGold		:MovieClip;
		public var btnBuffSilver	:MovieClip;
		public var btnTop			:MovieClip;
		public var btnAuto			:MovieClip;
		public var btnRevive		:MovieClip;
		public var movTopList		:MovieClip;
		public var movBossHPMask	:MovieClip;
		public var movBossHP		:MovieClip;
		public var movPlayersScene	:MovieClip;
		public var movPlayersName	:MovieClip;
		public var reviveRightNow	:MovieClip;
		public var txtBossName		:TextField;
		public var txtReviveCountdown	:TextField;
		public var txtBossHP		:TextField;
		public var txtGoldBuff		:TextField;
		public var txtXuBuff		:TextField;
		public var xuTf		:TextField;
		public var goldTf		:TextField;

		private var modeConfig		:ModeConfigGlobalBoss;
		private var missionID		:int;
		private var timer			:Timer;
		private var glowFilter		:GlowFilter;
		private var textFormat		:TextFormat;
		private var textGlow		:GlowFilter;
		private var bossAnim		:Animator;
		private var isAutoPlay		:Boolean;
		private var playersList		:Array;
		private var playersName		:Array;
		private var topList			:Array;
		private var triggerShowTopMov	:Boolean;
		
		public function GlobalBossView() {
			timer = new Timer(0, 1);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerCompleteHandler);
			timer.stop();
			
			missionID = -1;
			playersList = [];
			playersName = [];
			
			initUI();
			initHandlers();
		}
		
		private function initUI():void {
			glowFilter = new GlowFilter(0xffff00, 1, 8, 8, 2);
			
			btnFight.buttonMode = true;
			btnBuffGold.buttonMode = true;
			btnBuffSilver.buttonMode = true;
			btnTop.buttonMode = true;
			btnAuto.buttonMode = true;
			btnRevive.buttonMode = true;
			btnRevive.visible = false;
			reviveRightNow.buttonMode = true;
			reviveRightNow.visible = false;

			bossAnim = Manager.pool.pop(Animator) as Animator;
			bossAnim.reset();
			bossAnim.stop();
			bossAnim.addEventListener(Animator.LOADED, onBossAnimLoadedHandler);
			bossAnim.mouseEnabled = false;
			addChild(bossAnim);
			
			btnBack = UtilityUI.getComponent(UtilityUI.BACK_BTN) as SimpleButton;
			var btnClosePos:Point = UtilityUI.getComponentPosition(UtilityUI.BACK_BTN) as Point;
			btnBack.x = btnClosePos.x;
			btnBack.y = btnClosePos.y;
			addChild(btnBack);
			
			movPlayersScene.mouseChildren = false;
			movPlayersScene.mouseEnabled = false;
			
			movPlayersName.mouseChildren = false;
			movPlayersName.mouseEnabled = false;
			
			FontUtil.setFont(txtReviveCountdown, Font.ARIAL);
			FontUtil.setFont(txtBossHP, Font.ARIAL, true);
			FontUtil.setFont(txtXuBuff, Font.ARIAL);
			FontUtil.setFont(txtGoldBuff, Font.ARIAL);
			FontUtil.setFont(goldTf, Font.ARIAL, true);
			FontUtil.setFont(xuTf, Font.ARIAL, true);
			FontUtil.setFont(reviveRightNow.priceTf, Font.ARIAL, true);

			txtBossHP.mouseEnabled = false;
			txtReviveCountdown.visible = false;
			txtReviveCountdown.mouseEnabled = false;
			txtXuBuff.mouseEnabled = false;
			txtGoldBuff.mouseEnabled = false;
			goldTf.mouseEnabled = false;
			xuTf.mouseEnabled = false;

			movBossHP.mask = movBossHPMask;
			
			textFormat = new TextFormat("Arial", 10, TEXT_GREEN, true, null, null, null, null, TextFormatAlign.CENTER);
			textGlow = new GlowFilter(GLOW_GREEN, 1, 4, 4, 10);
			
			isAutoPlay = false;
		}
		
		private function initHandlers():void {
			btnBack.addEventListener(MouseEvent.CLICK, onBtnClickHandler);
			btnTop.addEventListener(MouseEvent.CLICK, onBtnClickHandler);
			btnBuffGold.addEventListener(MouseEvent.CLICK, onBtnClickHandler);
			btnBuffSilver.addEventListener(MouseEvent.CLICK, onBtnClickHandler);
			btnAuto.addEventListener(MouseEvent.CLICK, onBtnClickHandler);
			btnRevive.addEventListener(MouseEvent.CLICK, onBtnClickHandler);
			reviveRightNow.addEventListener(MouseEvent.CLICK, onBtnClickHandler);

			btnBuffGold.addEventListener(MouseEvent.ROLL_OVER, onBtnHoverHandler);
			btnBuffSilver.addEventListener(MouseEvent.ROLL_OVER, onBtnHoverHandler);
			btnTop.addEventListener(MouseEvent.ROLL_OVER, onBtnHoverHandler);
			btnRevive.addEventListener(MouseEvent.ROLL_OVER, onBtnHoverHandler);
			btnAuto.addEventListener(MouseEvent.ROLL_OVER, onBtnHoverHandler);

			btnBuffGold.addEventListener(MouseEvent.ROLL_OUT, onBtnOutHandler);
			btnBuffSilver.addEventListener(MouseEvent.ROLL_OUT, onBtnOutHandler);
			btnTop.addEventListener(MouseEvent.ROLL_OUT, onBtnOutHandler);
			btnRevive.addEventListener(MouseEvent.ROLL_OUT, onBtnOutHandler);
			btnAuto.addEventListener(MouseEvent.ROLL_OUT, onBtnOutHandler);
		}
		
		private function onTimerCompleteHandler(e:TimerEvent):void {
			dispatchEvent(new EventEx(GlobalBossEvent.EVENT, { type:GlobalBossEvent.GET_BOSS_HP, missionID:missionID }, true));
			timer.delay = REQUEST_BOSS_HP_DURATION * 1000;
			timer.start();
		}
		
		private function onBtnOutHandler(e:MouseEvent):void {
			var target:DisplayObject = e.target as DisplayObject;
			switch(e.target) {
				case btnAuto:
					if (!isAutoPlay) {
						target.filters = [];
					}
					break;
					
				case btnRevive:
					if (!Game.database.userdata.globalBossData.autoRevive) {
						target.filters = [];
					}
					break;
					
				default:
					target.filters = [];
					break;
			}
			dispatchEvent(new EventEx(TooltipEvent.HIDE_TOOLTIP, null, true));
		}
		
		private function onBtnHoverHandler(e:MouseEvent):void {
			var target:DisplayObject = e.target as DisplayObject;
			var description:String = "";
			switch(target) {
				case btnFight:
					target.filters = [glowFilter];
					break;
					
				case btnBuffGold:
					if (modeConfig) {
						description = "Tăng " + modeConfig.xuBuffPercent + "% tất cả các chỉ số bằng Vàng";	
					}
					target.filters = [glowFilter];
					break;
					
				case btnBuffSilver:
					if (modeConfig) {
						description = "Tăng " + modeConfig.goldBuffPercent + "% tất cả các chỉ số bằng Bạc";	
					}
					target.filters = [glowFilter];
					break;
					
				case btnTop:
					description = "Bảng xếp hạng";
					target.filters = [glowFilter];
					break;
					
				case btnAuto:
					description = "Tự động tấn công boss và sử dụng kỹ năng";	
					if (!isAutoPlay) {
						target.filters = [glowFilter];
					}
					break;
					
				case btnRevive:
					description = "Tự động hồi sinh sau khi chết";
					if (!Game.database.userdata.globalBossData.autoRevive) {
						target.filters = [glowFilter];	
					}
					break;
			}
			
			if (description.length) {
				dispatchEvent(new EventEx(TooltipEvent.SHOW_TOOLTIP, { type:TooltipID.SIMPLE, value:description }, true ));	
			}
		}
		
		private function onBtnClickHandler(e:MouseEvent):void {
			if (!modeConfig) return;
			var obj:Object;
			switch(e.target) {
				case btnBack:
					dispatchEvent(new EventEx(GlobalBossEvent.EVENT, { type:GlobalBossEvent.LEAVE, 
																missionID: missionID }, true));
					onBackToSelectBossHdl(null);
					break;
					
				case btnTop:
						dispatchEvent(new EventEx(GlobalBossEvent.EVENT, { type:GlobalBossEvent.GET_TOP_DMG, missionID:missionID } ));		
					break;
					
				case btnBuffGold:
					if (Game.database.userdata.globalBossData.currentXuBuff < Game.database.userdata.globalBossData.maxXuBuff) {
						obj = { };
						obj.content = "<font size = '20'>Tăng " + modeConfig.xuBuffPercent + "% tất cả các chỉ số </font>\n ";
						obj.txtPrice = "Giá: " + modeConfig.xuBuff;
						obj.paymentType = ItemType.XU.ID;
						Manager.display.showDialog(DialogID.GLOBAL_BOSS_YES_NO, onBuffGoldOKHandler, null, obj, Layer.BLOCK_BLACK);	
					} else {
						Manager.display.showMessage("Bạn đã buff tối đa");
					}
					break;
					
				case btnBuffSilver:
					if (Game.database.userdata.globalBossData.currentGoldBuff < Game.database.userdata.globalBossData.maxGoldBuff) {
						obj = { };
						obj.content = "<font size = '20'>Tăng " + modeConfig.goldBuffPercent + "% tất cả các chỉ số </font>\n ";
						obj.txtPrice = "Giá: " + modeConfig.goldBuff;
						obj.paymentType = ItemType.GOLD.ID;
						Manager.display.showDialog(DialogID.GLOBAL_BOSS_YES_NO, onBuffSilverOKHandler, null, obj, Layer.BLOCK_BLACK);	
					} else {
						Manager.display.showMessage("Bạn đã buff tối đa");
					}
					break;
					
				case btnRevive:
					obj = { };
					obj.content = "<font size = '20'>Kích hoạt tự động hồi sinh sau khi chết? (không giới hạn số lần)</font>\n ";
					obj.txtPrice = "Giá: " + modeConfig.xuAutoRevive;
					obj.paymentType = ItemType.XU.ID;
					Manager.display.showDialog(DialogID.GLOBAL_BOSS_YES_NO, onAutoReviveHandler, null, obj, Layer.BLOCK_BLACK);
					break;
					
				case btnFight:
					if (!Game.database.userdata.globalBossData.getIsReviveCountDown()) {
						startGame();	
					} else {
						var reviveCountdown:int = Game.database.userdata.globalBossData.getReviveCountDown();
						if (modeConfig && (reviveCountdown > 0)) {
							var content:String = "Bạn đã chết, đợi " + "<font color = '#ff0000'>" + "?" + " giây</font>.";
							var txtPrice:String = "Hồi sinh nhanh với giá: " + priceRevive;
							var paymentType:int = ItemType.XU.ID;
							Manager.display.showDialog(DialogID.GLOBAL_BOSS_REVIVE, onReviveOKHandler, null,
													{remainTime:reviveCountdown, txtPrice:txtPrice, paymentType:paymentType, content:content, timerCompleteFunc:function():void {
														Manager.display.hideDialog(DialogID.GLOBAL_BOSS_REVIVE);
													}}, Layer.BLOCK_BLACK);	
						}
					}
					break;
					
				case btnAuto:
					if (!isAutoPlay) {
						obj = { };
						obj.content = "<font size = '20'>Kích hoạt tự động tấn công boss và sử dụng kỹ năng? (không giới hạn số lần)\n</font>\n ";
						obj.txtPrice = "Giá: " + modeConfig.xuAutoPlay;
						obj.paymentType = ItemType.XU.ID;
						Manager.display.showDialog(DialogID.GLOBAL_BOSS_YES_NO, onAutoPlayHandler, null, obj, Layer.BLOCK_BLACK);	
					}
					break;

				case reviveRightNow:
					onReviveOKHandler(null);
					break;
			}
		}
		
		private function onAutoReviveHandler(data:Object):void {
			dispatchEvent(new EventEx(GlobalBossEvent.EVENT, { type: GlobalBossEvent.AUTO_REVIVE,
																missionID: missionID}, true));
		}
		
		private function onAutoPlayHandler(data:Object):void {
			dispatchEvent(new EventEx(GlobalBossEvent.EVENT, { type:GlobalBossEvent.AUTO_PLAY, missionID:missionID }, true));
		}
		
		private function onBackHandler(data:Object):void {
			dispatchEvent(new EventEx(GlobalBossEvent.EVENT, { type:GlobalBossEvent.LEAVE, 
																missionID: missionID }, true));
			Manager.display.to(ModuleID.HOME);
		}
		
		private function onReviveOKHandler(data:Object):void {
			dispatchEvent(new EventEx(GlobalBossEvent.EVENT, { type: GlobalBossEvent.REVIVE,
																missionID: missionID}, true));
		}
		
		private function onBuffSilverOKHandler(data:Object):void {
			dispatchEvent(new EventEx(GlobalBossEvent.EVENT, { type: GlobalBossEvent.BUFF_GOLD}, true));
		}
		
		private function onBuffGoldOKHandler(data:Object):void {
			dispatchEvent(new EventEx(GlobalBossEvent.EVENT, { type: GlobalBossEvent.BUFF_XU}, true));
		}
		
		private function onBossAnimLoadedHandler(e:Event):void {			
			bossAnim.play(0, 0);
			bossAnim.x = Game.WIDTH - Math.abs(bossAnim.width * 1 / 3);
			bossAnim.y = Game.HEIGHT * 0.8;
			bossAnim.scaleX = -1;
		}
		
		private function onAnimLoadedHdl(e:Event):void {
			var anim:Animator = e.target as Animator;
			if (anim) {
				anim.removeEventListener(Animator.LOADED, onAnimLoadedHdl);
				anim.play(0, 0);
				movPlayersScene.addChild(anim);
			}
		}
		
		private function showReviveDialog():void {
			var modeConfig:ModeConfigGlobalBoss = Game.database.gamedata.getGlobalBossConfig();
			if (Game.database.userdata.globalBossData.getIsReviveCountDown()
				&& !Game.database.userdata.globalBossData.autoRevive) {
					var content:String = "Bạn đã chết, đợi " + "?" + " giây.";
					var txtPrice:String = "Hồi sinh nhanh với giá: " + priceRevive;
					var paymentType:int = ItemType.XU.ID;
					Manager.display.showDialog(DialogID.GLOBAL_BOSS_REVIVE, onReviveOKHandler, null,
												{remainTime:Game.database.userdata.globalBossData.getReviveCountDown(), txtPrice:txtPrice, paymentType:paymentType, content:content, timerCompleteFunc:function():void {
													Manager.display.hideDialog(DialogID.GLOBAL_BOSS_REVIVE);
												}}, Layer.BLOCK_BLACK);
				}
		}
		
		override public function transitionIn():void 
		{
			super.transitionIn();
			dispatchEvent(new EventEx(GlobalBossEvent.EVENT, { type:GlobalBossEvent.GET_MY_DMG, missionID:missionID }, true));
			dispatchEvent(new EventEx(GlobalBossEvent.EVENT, { type:GlobalBossEvent.GET_BOSS_HP, missionID:missionID }, true));
			Game.database.userdata.addEventListener(UserData.GLOBAL_BOSS_BUFF_CHANGED, onBuffChanged);
			Game.database.userdata.addEventListener(UserData.XU_CHANGED, onMoneyChanged);
			Game.database.userdata.addEventListener(UserData.GOLD_CHANGED, onMoneyChanged);
			Game.database.userdata.globalBossData.addEventListener(GlobalBossData.REVIVE_COUNT_DOWN, onReviveCountDownHdl);
			onBuffChanged(null);
			
			timer.delay = REQUEST_BOSS_HP_DURATION * 1000;
			timer.start();

			goldTf.text = Game.database.userdata.getGold().toString();
			xuTf.text = Game.database.userdata.xu.toString();
		}

		override public function transitionOut():void
		{
			super.transitionOut();
			Game.database.userdata.removeEventListener(UserData.GLOBAL_BOSS_BUFF_CHANGED, onBuffChanged);
			Game.database.userdata.removeEventListener(UserData.XU_CHANGED, onMoneyChanged);
			Game.database.userdata.removeEventListener(UserData.GOLD_CHANGED, onMoneyChanged);
			Game.database.userdata.globalBossData.removeEventListener(GlobalBossData.REVIVE_COUNT_DOWN, onReviveCountDownHdl);
			CharacterManager.instance.displayCharacters();
			timer.stop();
			timer.delay = 0;
			
			txtReviveCountdown.visible = false;
			reviveRightNow.visible = false;

			for each (var anim:Animator in playersList) {
				anim.reset();
				Manager.pool.push(anim, Animator);
				
				//check if contains then remove child
				if (anim.parent) {
					anim.parent.removeChild(anim);
				}
			}
			
			for each (var txt:TextField in playersName) {
				Manager.pool.push(txt, TextField);
				if (txt.parent) {
					txt.parent.removeChild(txt);
				}
			}
			
			playersList.splice(0);
			playersName.splice(0);
		}
		
		public function showDialogTimesUp():void {
			var obj:Object = { };
			if (modeConfig) {
				var currentGold:int = int(Game.database.userdata.globalBossData.currentDmg * modeConfig.dmgToGoldRatio);	
			} else {
				currentGold = 0;
			}
			obj.content = "<font size = '20'>Đã hết thời gian giết boss.</font>\n ";
			obj.txtReward = "Bạn nhận được: " + currentGold;
			obj.paymentType = ItemType.GOLD.ID;
			Manager.display.showDialog(DialogID.GLOBAL_BOSS_CONFIRM, onBackToSelectBossHdl, null, obj, Layer.BLOCK_BLACK);
		}
		
		private function onBuffChanged(e:Event):void {
			txtGoldBuff.text = Game.database.userdata.globalBossData.currentGoldBuff 
							+ "/" + Game.database.userdata.globalBossData.maxGoldBuff;
			txtXuBuff.text = Game.database.userdata.globalBossData.currentXuBuff
							+ "/" + Game.database.userdata.globalBossData.maxXuBuff;
		}

		private function onMoneyChanged(event:Event):void
		{
			goldTf.text = Game.database.userdata.getGold().toString();
			xuTf.text = Game.database.userdata.xu.toString();
		}

		private function onBackToSelectBossHdl(data:Object):void {
			Manager.display.to(ModuleID.HOME);
		}
		
		private function onReviveCountDownHdl(e:Event):void {
			if (Game.database.userdata.globalBossData.getIsReviveCountDown()) {
				txtReviveCountdown.visible = true;
				txtReviveCountdown.text = "Thời gian chờ Hồi Sinh: " + Game.database.userdata.globalBossData.getReviveCountDown() + " giây";
				reviveRightNow.visible = true;
				reviveRightNow.priceTf.text = priceRevive;
			} else {
				txtReviveCountdown.visible = false;
				reviveRightNow.visible = false;
				if (Game.database.userdata.globalBossData.autoPlay) {
					setTimeout(startGame, 1000);
				}
			}
		}
		
		public function updateCurrentDmg():void 
		{
			if (!Game.database.userdata.globalBossData.getIsReviveCountDown()) {
				if (Game.database.userdata.globalBossData.autoPlay) {
					setTimeout(startGame, 1000);
				}
			} else {
				if (Game.database.userdata.globalBossData.autoRevive) {
					Game.database.userdata.globalBossData.setIsReviveCountDown(false);
				} else {
					showReviveDialog();
				}
			}
			autoPlayEnable(Game.database.userdata.globalBossData.autoPlay);
			btnRevive.filters = [];
			UtilityUI.enableDisplayObj(!Game.database.userdata.globalBossData.autoRevive, btnRevive, MouseEvent.CLICK, onBtnClickHandler);
		}
		
		public function autoRevive(value:Boolean):void {
			btnRevive.filters = [];
			UtilityUI.enableDisplayObj(!value, btnRevive, MouseEvent.CLICK, onBtnClickHandler);
			if (value) {
				Manager.display.hideDialog(DialogID.GLOBAL_BOSS_REVIVE);
				Game.database.userdata.globalBossData.setIsReviveCountDown(false);
			}
		}
		
		public function autoPlayEnable(value:Boolean):void {
			isAutoPlay = value;
			btnAuto.filters = [];
			UtilityUI.enableDisplayObj(!isAutoPlay, btnAuto, MouseEvent.CLICK, onBtnClickHandler);
			UtilityUI.enableDisplayObj(!isAutoPlay, btnFight, MouseEvent.CLICK, onBtnClickHandler);
			UtilityUI.enableDisplayObj(!isAutoPlay, btnFight, MouseEvent.MOUSE_OVER, onBtnHoverHandler);
			UtilityUI.enableDisplayObj(!isAutoPlay, btnFight, MouseEvent.MOUSE_OUT, onBtnOutHandler);
		}
		
		public function startGame():void {
			dispatchEvent(new EventEx(GlobalBossEvent.EVENT, { type: GlobalBossEvent.START_GAME,
																missionID: missionID }, true));
		}
		
		public function updateBossHPBar(currentHP:int, maxHP:int):void {
			txtBossHP.text = currentHP + "/" + maxHP;
			TweenMax.to(movBossHPMask, 0.3, { scaleX:(Number(currentHP / maxHP)) } );
		}
		
		public function getMissionID():int {
			return missionID;
		}
		
		public function setMissionID(value:int):void {
			missionID = value;
			var missionXML:MissionXML = Game.database.gamedata.getData(DataType.MISSION, value) as MissionXML;
			var characterXML:CharacterXML;
			if (missionXML) {
				for each (var wave:Array in missionXML.waves) {
					for each (var characterID:int in wave) {
						characterXML = Game.database.gamedata.getData(DataType.CHARACTER, characterID) as CharacterXML;
						if (characterXML) {
							txtBossName.text = characterXML.getName();
							bossAnim.load(characterXML.animURLs[Sex.FEMALE]);
							return;
						}
					}
				}
			}
		}
		
		public function setModeConfig(value:ModeConfigGlobalBoss):void {
			if (modeConfig == null) {
				modeConfig = value;
			}
		}
		
		public function updatePlayersList(arr:Array):void {
			var xmlID:int;
			var characterXML:CharacterXML;
			var anim:Animator;
			var txt:TextField;
			for each (var info:Object in arr) {
				xmlID = info.xmlID;
				characterXML = Game.database.gamedata.getData(DataType.CHARACTER, xmlID) as CharacterXML;
				if (characterXML) {
					anim = Manager.pool.pop(Animator) as Animator;
					anim.reset();
					anim.stop();
					anim.addEventListener(Animator.LOADED, onAnimLoadedHdl);
					anim.load(characterXML.animURLs[info.sex]);
					anim.x = Math.floor(Math.random() * (Game.WIDTH / 2));
					anim.y = Math.floor(Game.HEIGHT * 0.7 + Math.random() * (Game.HEIGHT * 0.3));
					playersList.push(anim);
					
					txt = Manager.pool.pop(TextField) as TextField;
					if (info.ID == Game.database.userdata.userID) {
						textFormat.color = TEXT_YELLOW;
						textGlow.color = GLOW_YELLOW;
					} else {
						textFormat.color = TEXT_GREEN;
						textGlow.color = GLOW_GREEN;
					}
					txt.defaultTextFormat = textFormat;
					txt.filters = [textGlow];
					txt.text = info.name;
					txt.y = anim.y - 100;
					txt.x = anim.x - 60;
					movPlayersName.addChild(txt);
					playersName.push(txt);
				}
			}
		}

		private function get priceRevive():int
		{
			var index:int = Game.database.userdata.numOfRespawnBoss + 1;
			return (index >= modeConfig.xuRevive.length) ? modeConfig.xuRevive[modeConfig.xuRevive.length - 1] : modeConfig.xuRevive[index];
		}
	}

}