package game.ui.hud
{
	import core.display.layer.LayerManager;
	import core.Manager;
	import core.display.ViewBase;
	import core.display.animation.Animator;
	import core.event.EventEx;
	import core.sound.SoundManager;
	import core.util.MathUtil;
	import core.util.Utility;

	import game.ui.hud.gui.DiceButton;

	import game.ui.hud.gui.ExpressButton;

	import game.ui.hud.gui.DivineWeaponButton;
	import game.ui.hud.gui.MysticBoxButton;
	import game.ui.hud.gui.ReduceEffectButton;
	import game.ui.hud.gui.ShopDiscountButton;
	import game.ui.hud.gui.TuuLauChienButton;
	import game.ui.hud.gui.KungfuTrainButton;

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.net.SharedObject;
	import flash.utils.Dictionary;
	import flash.utils.Timer;

	import game.Game;
	import game.data.xml.DataType;
	import game.data.xml.FeatureXML;
	import game.data.xml.SoundXML;
	import game.enum.Direction;
	import game.enum.FocusSignalType;
	import game.enum.GameConfigID;
	import game.enum.QuestMainState;
	import game.enum.SoundID;
	import game.ui.ModuleID;
	import game.ui.components.FocusSignal;
	import game.ui.hud.gui.ActivityButton;
	import game.ui.hud.gui.AttendanceButton;
	import game.ui.hud.gui.ChangeFormationButton;
	import game.ui.hud.gui.ChangeRecipeButton;
	import game.ui.hud.gui.ChargeEventButton;
	import game.ui.hud.gui.ConsumeEventButton;
	import game.ui.hud.gui.DailyTaskButton;
	import game.ui.hud.gui.EventsHotButton;
	import game.ui.hud.gui.FriendBtn;
	import game.ui.hud.gui.GiftOnlineButton;
	import game.ui.hud.gui.GuildButton;
	import game.ui.hud.gui.HUDButton;
	import game.ui.hud.gui.InventoryButton;
	import game.ui.hud.gui.InviteButton;
	import game.ui.hud.gui.LuckyGiftBtn;
	import game.ui.hud.gui.MailBtn;
	import game.ui.hud.gui.MetalFurnaceBtn;
	import game.ui.hud.gui.PowerTransferButton;
	import game.ui.hud.gui.PresentButton;
	import game.ui.hud.gui.QuestDailyButton;
	import game.ui.hud.gui.QuestMainButton;
	import game.ui.hud.gui.QuestTransportButton;
	import game.ui.hud.gui.ShopItemButton;
	import game.ui.hud.gui.SoulButton;
	import game.ui.hud.gui.SoundButton;
	import game.ui.hud.gui.TreasureButton;
	import game.ui.hud.gui.VIPPromotionButton;
	import game.ui.hud.gui.WikiButton;
	import game.ui.hud.gui.WorldMapButton;
	import game.ui.quest_daily.QuestDailyModule;
	import game.ui.tooltip.TooltipEvent;
	import game.ui.tooltip.TooltipID;
	import game.ui.tutorial.TutorialEvent;
	import game.utility.UtilityUI;

	/**
	 * ...
	 * @author anhtinh
	 */
	public class HUDView extends ViewBase
	{
		public static const REQUEST_HUD_VIEW:String = "requestHUDView";

		private static const TOP:String = "TOP";
		private static const TOP1:String = "TOP1";
		private static const RIGHT:String = "RIGHT";
		private static const BOTTOM:String = "BOTTOM";
		private static const LEFT:String = "LEFT";

		private static const TOP_BTN_WIDTH:int = 20;
		private static const RIGHT_BTN_HEIGHT:int = 15;
		private static const LEFT_BTN_HEIGHT:int = 5;
		private static const BOTTOM_BTN_WIDTH:int = 5;

		private static const BEGIN_BOTTOM_BTN_X:int = 1200;
		private static const BEGIN_RIGHT_BTN_Y:int = 90;
		private static const BEGIN_TOP_BTN_X:int = 1250;
		private static const BEGIN_LEFT_BTN_Y:int = 80 + 50 + 10;

		public function HUDView()
		{
			//init button sound
			_soundBtn = UtilityUI.getComponent(UtilityUI.SOUND_BTN) as SoundButton;
			if (_soundBtn)
			{
				_soundBtn.addEventListener(MouseEvent.ROLL_OUT, onRollOut);
				_soundBtn.addEventListener(MouseEvent.ROLL_OVER, onRollOver);
				_soundBtn.addEventListener(SoundButton.SOUND_TOOGLE, onSoundToogleHdl);
			}
			else
			{
				Utility.log("can not create sound button");
			}

			_inviteBtn = UtilityUI.getComponent(UtilityUI.INVITE_BTN) as InviteButton;
			if (_inviteBtn)
			{
				_inviteBtn.addEventListener(MouseEvent.ROLL_OUT, onRollOut);
				_inviteBtn.addEventListener(MouseEvent.ROLL_OVER, onRollOver);
				_inviteBtn.addEventListener(InviteButton.INVITE_TOOGLE, onInviteToogleHdl);
			}
			else
			{
				Utility.log("can not create _inviteBtn");
			}

			reduceEffectBtn.addEventListener(ReduceEffectButton.REDUCE_EFFECT_TOOGLE, onReduceEffectToogleHdl);

			buttons = [];

			btnsDict[TOP] = [];
			btnsDict[TOP1] = [];
			btnsDict[RIGHT] = [];
			btnsDict[BOTTOM] = [];
			btnsDict[LEFT] = [];

			var featureXMLs:Dictionary = Game.database.gamedata.getTable(DataType.FEATURE);
			for each (var featureXML:FeatureXML in featureXMLs)
			{
				if (featureXML.type == FeatureXML.HUD_BUTTON)
				{
					var btn:HUDButton = getBtnInstanceByName(featureXML.instanceName);
					if (btn != null)
					{
						btn._nPositionIndex = featureXML.positionIndex;
						buttons.push(btn);
						btn.visible = false;
						switch (featureXML.group)
						{
							case TOP:
								(btnsDict[TOP]).push(btn);
								break;
							case TOP1:
								(btnsDict[TOP1]).push(btn);
								break;
							case RIGHT:
								(btnsDict[RIGHT]).push(btn);
								break;
							case BOTTOM:
								(btnsDict[BOTTOM]).push(btn);
								break;
							case LEFT:
								(btnsDict[LEFT]).push(btn);
								break;
							default:
						}
					}
				}
			}

			(btnsDict[TOP]).sortOn("_nPositionIndex", Array.NUMERIC);
			(btnsDict[TOP1]).sortOn("_nPositionIndex", Array.NUMERIC);
			(btnsDict[RIGHT]).sortOn("_nPositionIndex", Array.NUMERIC);
			(btnsDict[BOTTOM]).sortOn("_nPositionIndex", Array.NUMERIC);
			(btnsDict[LEFT]).sortOn("_nPositionIndex", Array.NUMERIC);

			initEvent();
			_timer = new Timer(1000);
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE, onUpdateTimerHdl);

			_effectQuestMain = new Animator();
			_effectQuestMain.visible = false;
			_effectQuestMain.load("resource/anim/ui/fx_motinhnang.banim");
			_effectQuestMain.addEventListener(Animator.LOADED, onAnimLoadedHdl);

			worldMapBtn.addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			worldMapBtn.addEventListener(MouseEvent.ROLL_OUT, onRollOut);
			//arenaBtn.addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			//arenaBtn.addEventListener(MouseEvent.ROLL_OUT, onRollOut);
			metalFurnaceBtn.addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			metalFurnaceBtn.addEventListener(MouseEvent.ROLL_OUT, onRollOut);
			inventoryBtn.addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			inventoryBtn.addEventListener(MouseEvent.ROLL_OUT, onRollOut);
			changeFormationBtn.addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			changeFormationBtn.addEventListener(MouseEvent.ROLL_OUT, onRollOut);
			powerTransferBtn.addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			powerTransferBtn.addEventListener(MouseEvent.ROLL_OUT, onRollOut);
			soulBtn.addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			soulBtn.addEventListener(MouseEvent.ROLL_OUT, onRollOut);
			questTransportBtn.addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			questTransportBtn.addEventListener(MouseEvent.ROLL_OUT, onRollOut);
			questDailyBtn.addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			questDailyBtn.addEventListener(MouseEvent.ROLL_OUT, onRollOut);
			shopItemBtn.addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			shopItemBtn.addEventListener(MouseEvent.ROLL_OUT, onRollOut);
			questMainBtn.addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			questMainBtn.addEventListener(MouseEvent.ROLL_OUT, onRollOut);
			luckyGiftBtn.addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			luckyGiftBtn.addEventListener(MouseEvent.ROLL_OUT, onRollOut);
			mailBtn.addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			mailBtn.addEventListener(MouseEvent.ROLL_OUT, onRollOut);
			_soundBtn.addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			_soundBtn.addEventListener(MouseEvent.ROLL_OUT, onRollOut);
			_inviteBtn.addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			_inviteBtn.addEventListener(MouseEvent.ROLL_OUT, onRollOut);
			presentBtn.addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			presentBtn.addEventListener(MouseEvent.ROLL_OUT, onRollOut);
			friendBtn.addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			friendBtn.addEventListener(MouseEvent.ROLL_OUT, onRollOut);
			guildBtn.addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			guildBtn.addEventListener(MouseEvent.ROLL_OUT, onRollOut);
			eventsHotBtn.addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			eventsHotBtn.addEventListener(MouseEvent.ROLL_OUT, onRollOut);
			treasureBtn.addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			treasureBtn.addEventListener(MouseEvent.ROLL_OUT, onRollOut);
			activityBtn.addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			activityBtn.addEventListener(MouseEvent.ROLL_OUT, onRollOut);
			changeRecipeBtn.addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			changeRecipeBtn.addEventListener(MouseEvent.ROLL_OUT, onRollOut);
			consumeEventBtn.addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			consumeEventBtn.addEventListener(MouseEvent.ROLL_OUT, onRollOut);
			chargeEventBtn.addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			chargeEventBtn.addEventListener(MouseEvent.ROLL_OUT, onRollOut);
			giftOnlineBtn.addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			giftOnlineBtn.addEventListener(MouseEvent.ROLL_OUT, onRollOut);
			btnDailyTask.addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			btnDailyTask.addEventListener(MouseEvent.ROLL_OUT, onRollOut);
			btnAttendance.addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			btnAttendance.addEventListener(MouseEvent.ROLL_OUT, onRollOut);
			tuuLauChienBtn.addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			tuuLauChienBtn.addEventListener(MouseEvent.ROLL_OUT, onRollOut);
			wikiBtn.addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			wikiBtn.addEventListener(MouseEvent.ROLL_OUT, onRollOut);
			mysticBoxBtn.addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			mysticBoxBtn.addEventListener(MouseEvent.ROLL_OUT, onRollOut);
			expressBtn.addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			expressBtn.addEventListener(MouseEvent.ROLL_OUT, onRollOut);
			diceBtn.addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			diceBtn.addEventListener(MouseEvent.ROLL_OUT, onRollOut);
			shopDiscountBtn.addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			shopDiscountBtn.addEventListener(MouseEvent.ROLL_OUT, onRollOut);
			vipPromotionBtn.addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			vipPromotionBtn.addEventListener(MouseEvent.ROLL_OUT, onRollOut);
			reduceEffectBtn.addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			reduceEffectBtn.addEventListener(MouseEvent.ROLL_OUT, onRollOut);
			divineWeaponBtn.addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			divineWeaponBtn.addEventListener(MouseEvent.ROLL_OUT, onRollOut);
			var id:int = SoundID.randomOutgameMusicID();
			var soundXML:SoundXML = Game.database.gamedata.getData(DataType.SOUND, id) as SoundXML;
			if (Game.database.gamedata.localSO.data.isSoundOn == "true")
			{
				SoundManager.addOrPlaySound(id.toString(), soundXML.src, 999, true);
			}
			if (Game.database.gamedata.localSO.data.isSoundOn == "false")
			{
				SoundManager.stopAllSound();
				_soundBtn.onToggle();
			}
		}

		public var worldMapBtn:WorldMapButton;
		public var metalFurnaceBtn:MetalFurnaceBtn;
		//public var arenaBtn:ArenaButton;
		public var inventoryBtn:InventoryButton;
		public var changeFormationBtn:ChangeFormationButton;
		public var powerTransferBtn:PowerTransferButton;
		public var soulBtn:SoulButton;
		//public var formationTypeBtn:FormationTypeButton;
		public var questTransportBtn:QuestTransportButton;
		public var questDailyBtn:QuestDailyButton;
		public var shopItemBtn:ShopItemButton;
		public var questMainBtn:QuestMainButton;
		public var luckyGiftBtn:LuckyGiftBtn;
		public var mailBtn:MailBtn;
		public var presentBtn:PresentButton;
		public var friendBtn:FriendBtn;
		public var guildBtn:GuildButton;
		public var eventsHotBtn:EventsHotButton;
		public var treasureBtn:TreasureButton;
		public var activityBtn:ActivityButton;
		public var changeRecipeBtn:ChangeRecipeButton;
		public var consumeEventBtn:ConsumeEventButton;
		public var chargeEventBtn:ChargeEventButton;
		public var giftOnlineBtn:GiftOnlineButton;
		public var btnDailyTask:DailyTaskButton;
		public var tuuLauChienBtn:TuuLauChienButton;
		public var btnAttendance:AttendanceButton;
		public var trainBtn :KungfuTrainButton;
		public var wikiBtn :WikiButton;
		public var expressBtn :ExpressButton;
		public var diceBtn :DiceButton;
		public var shopDiscountBtn :ShopDiscountButton;
		public var vipPromotionBtn :VIPPromotionButton;
		public var mysticBoxBtn :MysticBoxButton;
		public var reduceEffectBtn :ReduceEffectButton;
		private var btnsDict:Dictionary = new Dictionary();
		private var buttons:Array;
		private var _soundBtn:SoundButton;
		private var _inviteBtn:InviteButton;
		private var _effectQuestMain:Animator;
		private var _timer:Timer;
		private var _remainCount:int;
		private var _focusableArr:Array = [questTransportBtn, shopItemBtn, questMainBtn, mailBtn, giftOnlineBtn, presentBtn, btnAttendance, questDailyBtn]
		public var targetBtn:HUDButton;
		public var divineWeaponBtn:DivineWeaponButton;

		override protected function transitionInComplete():void
		{
			super.transitionInComplete();
			onSoundToogleHdl();
		}

		public function getBtnInstanceByName(instanceName:String):HUDButton
		{
			try
			{
				if(instanceName == "") return null;
				var btn:HUDButton = this[instanceName];
			}
			catch (err:Error)
			{
				Utility.error("### ERROR : " + "Property " + instanceName + " in feature.xml not found on game.iu.hud.HUDView, may be config wrong name.");
			}
			return btn;
		}

		public function setButtonNotify(btnName:String, val:Boolean, jsonData:Object):void
		{
			var btn:HUDButton = getBtnInstanceByName(btnName);

			if (btn != null)
			{
				btn.setNotify(val, jsonData);
			}
		}

		/**
		 * Hien mui ten goi y
		 * @param btnName HUDButton
		 */
		public function showHint(btnName:String, content:String = ""):void
		{
			var btn:HUDButton = getBtnInstanceByName(btnName);

			if (btn != null)
			{
				var x:Number;
				var y:Number;

				if((btnsDict[TOP]).indexOf(btn) != -1)
				{
					x = btn.x + btn.width/2;
					y = btn.y + btn.height;
					Game.hint.showHint(btn, Direction.UP, x, y, content);
				}
				else if((btnsDict[TOP1]).indexOf(btn) != -1)
				{
					x = btn.x + btn.width/2;
					y = btn.y + btn.height;
					Game.hint.showHint(btn, Direction.UP, x, y, content);
				}
				else if((btnsDict[BOTTOM]).indexOf(btn) != -1)
				{
					x = btn.x + btn.width/2;
					y = btn.y;
					Game.hint.showHint(btn, Direction.DOWN, x, y, content);
				}
				else if((btnsDict[LEFT]).indexOf(btn) != -1)
				{
					x = btn.x + btn.width;
					y = btn.y + btn.height/2;
					Game.hint.showHint(btn, Direction.LEFT, x, y, content);
				}
				else if((btnsDict[RIGHT]).indexOf(btn) != -1)
				{
					x = btn.x;
					y = btn.y + btn.height/2;
					Game.hint.showHint(btn, Direction.RIGHT, x, y, content);
				}
			}
		}

		public function getHUDButton(moduleID:ModuleID):HUDButton
		{
			// hide previous HUD module
			var tBtn:HUDButton;
			switch (moduleID)
			{
				//case ModuleID.ARENA:
				//targetBtn = arenaBtn;
				//break;
				case ModuleID.INVENTORY_ITEM:
					tBtn = inventoryBtn;
					break;
				case ModuleID.QUEST_TRANSPORT:
					tBtn = questTransportBtn;
					break;
				case ModuleID.SOUL_CENTER:
					tBtn = soulBtn;
					break;
				case ModuleID.WORLD_MAP:
					tBtn = worldMapBtn;
					break;
				//case ModuleID.FORMATION_TYPE:
				//targetBtn = formationTypeBtn;
				//break;
				case ModuleID.CHANGE_FORMATION:
					tBtn = changeFormationBtn;
					break;
				case ModuleID.FORMATION:
					tBtn = changeFormationBtn;
					break;
				case ModuleID.CHARACTER_ENHANCEMENT:
					tBtn = powerTransferBtn;
					break;
				case ModuleID.QUEST_MAIN:
					tBtn = questMainBtn;
					break;
				case ModuleID.QUEST_DAILY:
					tBtn = questDailyBtn;
					break;
				case ModuleID.METAL_FURNACE:
					tBtn = metalFurnaceBtn;
					break;
				case ModuleID.LUCKY_GIFT:
					tBtn = luckyGiftBtn;
					break;
				case ModuleID.MAIL_BOX:
					tBtn = mailBtn;
					break;
				case ModuleID.PRESENT:
					tBtn = presentBtn;
					break;
				case ModuleID.FRIEND:
					tBtn = friendBtn;
					break;
				case ModuleID.GUILD:
					tBtn = guildBtn;
					break;
				case ModuleID.ACTIVITY:
					tBtn = activityBtn;
					break;
				case ModuleID.EVENTS_HOT:
					tBtn = eventsHotBtn;
					break;
				case ModuleID.TREASURE:
					tBtn = treasureBtn;
					break;
				case ModuleID.CHANGE_RECIPE:
					tBtn = changeRecipeBtn;
					break;
				case ModuleID.CONSUME_EVENT:
					tBtn = consumeEventBtn;
					break;
				case ModuleID.CHARGE_EVENT:
					tBtn = chargeEventBtn;
					break;
				case ModuleID.SHOP_ITEM:
					tBtn = shopItemBtn;
					break;
				case ModuleID.GIFT_ONLINE:
					tBtn = giftOnlineBtn;
					break;
				case ModuleID.DAILY_TASK:
					if (btnDailyTask.visible)
					{
						tBtn = btnDailyTask;
					}
					break;
				case ModuleID.ATTENDANCE:
					tBtn = btnAttendance;
					break; 
				case ModuleID.TUULAUCHIEN:
					tBtn = tuuLauChienBtn;
					break;
					
				case ModuleID.KUNGFU_TRAIN:
					tBtn = trainBtn;
					break;

				case ModuleID.WIKI:
					tBtn = wikiBtn;
					break;
				case ModuleID.MYSTIC_BOX:
					tBtn = mysticBoxBtn;
					break;
				case ModuleID.EXPRESS:
					tBtn = expressBtn;
					break;
				case ModuleID.DICE:
					tBtn = diceBtn;
					break;
				case ModuleID.SHOP_DISCOUNT:
					tBtn = shopDiscountBtn;
					break;
				case ModuleID.VIP_PROMOTION:
					tBtn = vipPromotionBtn;
					break;
				case ModuleID.DIVINE_WEAPON:
					tBtn = divineWeaponBtn;
					break;
			}
			
			return tBtn;
		}

		public function updateQuestMainState(state:int):void
		{
			FocusSignal.removeAllFocus(questMainBtn);
			//var point:Point = new Point( questMainBtn.width, 10);
			Game.database.userdata.quests.push("");
			switch (state)
			{
				case QuestMainState.STATE_NEWS_QUEST:
					//FocusSignal.showFocus(FocusSignalType.SIGNAL_NEW.ID, questMainBtn, true, point);
					FocusSignal.showFocus(FocusSignalType.SIGNAL_NEW.ID, questMainBtn, true);

					break;
				case QuestMainState.STATE_FINISH:
					//show effect cho
					//_effectQuestMain.visible = true;
					//_effectQuestMain.play(0, 1);
					//FocusSignal.showFocus(FocusSignalType.SIGNAL_COMPLETE.ID, questMainBtn, true, point);
					FocusSignal.showFocus(FocusSignalType.SIGNAL_COMPLETE.ID, questMainBtn, true);
					break;
				case QuestMainState.STATE_NO_QUEST:
					Game.database.userdata.quests = [];
					break;
			}
			updateDisplay();
		}

		public function updateQuestTransportState(state:int, remainQuest:int, elapseTimeToNextRandom:int):void
		{
			var state:int = state;
			//Utility.log("receive quest state with errorCode: " + state);
			//invisible all icon
			//4 icon: countMov // timeMov // completeMov // newMov
			(questTransportBtn["countMov"] as MovieClip).visible = false;
			(questTransportBtn["timeMov"] as MovieClip).visible = false;
			(questTransportBtn["completedMov"] as MovieClip).visible = false;
			FocusSignal.removeAllFocus(questTransportBtn);
			var point:Point = new Point(questTransportBtn.width, 0);
			switch (state)
			{
				case 0:
					//error
					questTransportBtn.numTf.text = "";
					break;
				case 1:
					//has quest but has no completed
					questTransportBtn.numTf.text = remainQuest.toString();
					//FocusSignal.showFocus(FocusSignalType.SIGNAL_NEW.ID, questTransportBtn, true, point);
					//FocusSignal.showFocus(FocusSignalType.SIGNAL_NEW.ID, questTransportBtn, true);
					(questTransportBtn["countMov"] as MovieClip).visible = true;
					break;
				case 2:
					//waiting for the next random
					_remainCount = elapseTimeToNextRandom;
					(questTransportBtn["timeMov"] as MovieClip).visible = true;
					_timer.start();
					break;
				case 3:
					//out of quests in day
					questTransportBtn.numTf.text = "";
					(questTransportBtn["completedMov"] as MovieClip).visible = true;
					break;
				case 4:
					//has quest completed but not confirm
					questTransportBtn.numTf.text = remainQuest.toString();
					//FocusSignal.showFocus(FocusSignalType.SIGNAL_COMPLETE.ID, questTransportBtn, true, point);
					FocusSignal.showFocus(FocusSignalType.SIGNAL_COMPLETE.ID, questTransportBtn, true);
					(questTransportBtn["countMov"] as MovieClip).visible = true;
					break;
			}
		}

		public function updateQuestDailyState(state:int):void
		{
			var currentLevel:int = Game.database.userdata.level;
			var featureXML:FeatureXML = Game.database.gamedata.getData(DataType.FEATURE, HUDButtonID.QUEST_DAILY.ID) as FeatureXML;
			var available:Boolean = currentLevel >= featureXML.levelRequirement;
			if (available)
			{
				FocusSignal.removeAllFocus(questDailyBtn);
				var point:Point = new Point(questDailyBtn.width / 2, -questDailyBtn.height / 2);
				switch (state)
				{
					case QuestMainState.STATE_NEWS_QUEST:
						//FocusSignal.showFocus(FocusSignalType.SIGNAL_NEW.ID, dailyQuestBtn, true, point);
						//FocusSignal.showFocus(FocusSignalType.SIGNAL_NEW.ID, dailyQuestBtn.getIconNPC(), true);
						break;
					case QuestMainState.STATE_FINISH:
						//FocusSignal.showFocus(FocusSignalType.SIGNAL_COMPLETE.ID, dailyQuestBtn, true, point);
						FocusSignal.showFocus(FocusSignalType.SIGNAL_COMPLETE.ID, questDailyBtn, true);
						if(!Manager.display.checkVisible(ModuleID.QUEST_DAILY) && Manager.tutorial.isPlayingTutorial)
						{
							showHint(HUDButtonID.QUEST_DAILY.name, "Nhận thưởng nhiệm vụ");
						}
						break;

				}
			}
		}

		public function updateShopItemState(state:int):void
		{
			switch (state)
			{
				case 1:	//has new item bought
					FocusSignal.showFocus(FocusSignalType.SIGNAL_COMPLETE.ID, shopItemBtn, true);
					break;
				case 0:	//normal
				default:
					FocusSignal.removeAllFocus(shopItemBtn);
					break;
			}
		}

		public function getPositionBtnByName(btnName:String):Point
		{
			var btn:HUDButton = getBtnInstanceByName(btnName);
			if (btn)
			{
				return new Point(btn.x, btn.y);
			}
			return new Point();
		}

		/*public function clearSelected():void {
		 for (var i:int = 0; i < buttons.length; i++)
		 {
		 (buttons[i] as HUDButton).isSelected = false;
		 }
		 }*/

		public function setVisibleButtonHUD(arrBtnName:Array, val:Boolean):void
		{
			for each (var btnName:String in arrBtnName)
			{
				var btn:HUDButton = getBtnInstanceByName(btnName);
				if (btn)
				{
					btn.visible = val;
				}
			}
		}

		public function updateDisplay():void
		{
			for each (var button:HUDButton in buttons)
			{
				if (button != null)
				{
					button.visible = false;
					var buttonID:HUDButtonID = button.getID();
					if (buttonID != null)
					{
						if (buttonID.getModuleIDs().indexOf(Manager.display.getCurrentModule()) > -1)
						{
							var featureXML:FeatureXML = Game.database.gamedata.getData(DataType.FEATURE, buttonID.ID) as FeatureXML;
							if (featureXML != null && Game.database.userdata.level >= featureXML.levelRequirement)
							{
								button.checkVisible();
							}
						}
					}
				}
			}

			updateButtonPositions();
		}

		public function getSoundButton():HUDButton
		{
			return _soundBtn;
		}

		//public function updateQuestTransportState(packet:ResponseQuestTransportState):void

		private function initEvent():void
		{
			for (var i:int = 0; i < buttons.length; i++)
			{
				buttons[i].addEventListener(MouseEvent.CLICK, onBtnClickHdl);
			}
		}

		private function updateButtonPositions():void
		{
			if (_inviteBtn)
			{
				_inviteBtn.x = 5;
				_inviteBtn.y = BEGIN_LEFT_BTN_Y - 37;
				addChild(_inviteBtn);
			}

			//update position for sound
			if (_soundBtn)
			{
				_soundBtn.x = 5;
				_soundBtn.y = _inviteBtn.y - 32;
				addChild(_soundBtn);
			}

			if (reduceEffectBtn)
			{
				reduceEffectBtn.x = _soundBtn.x + _soundBtn.width;
				reduceEffectBtn.y = _soundBtn.y;
			}

			var pos:int = BEGIN_TOP_BTN_X;
			for each (var topBtn:HUDButton in btnsDict[TOP])
			{
				if (topBtn.visible)
				{
					topBtn.x = pos - (TOP_BTN_WIDTH + topBtn.getBounds(this).width > 75 ? 75 : topBtn.getBounds(this).width);
					pos = topBtn.x;
					topBtn.y = 5;
				}
				//Utility.log("topBtn pos " + topBtn.getID().ID + " is: " + topBtn.x + " // " + topBtn.y);
			}

			pos = BEGIN_TOP_BTN_X - 80;
			for each (var top1Btn:HUDButton in btnsDict[TOP1])
			{
				if (top1Btn.visible)
				{
					top1Btn.x = pos - (TOP_BTN_WIDTH + top1Btn.getBounds(this).width > 75 ? 75 : top1Btn.getBounds(this).width);
					pos = top1Btn.x;
					top1Btn.y = 97;
				}
				//Utility.log("topBtn pos " + topBtn.getID().ID + " is: " + topBtn.x + " // " + topBtn.y);
			}

			pos = 0;
			for each (var rightBtn:HUDButton in btnsDict[RIGHT])
			{
				if (rightBtn.visible)
				{
					var iconX:int = 0;
					var iconY:int = 0;
					var featureXML:FeatureXML = Game.database.gamedata.getData(DataType.FEATURE, rightBtn.getID().ID) as FeatureXML;
					if (featureXML)
					{
						//iconX = featureXML.posX;
						//iconY = featureXML.posY;
					}
					rightBtn.x = 1191 + iconX;
					rightBtn.y = BEGIN_RIGHT_BTN_Y + pos + iconY;
					pos += RIGHT_BTN_HEIGHT + rightBtn.height;
				}
				//Utility.log("rightBtn pos " + rightBtn.getID().ID + " is: " + rightBtn.x + " // " + rightBtn.y);
			}

			pos = 0;
			for each (var leftBtn:HUDButton in btnsDict[LEFT])
			{
				if (leftBtn.visible)
				{
					leftBtn.y = BEGIN_LEFT_BTN_Y + pos;
					pos += LEFT_BTN_HEIGHT + (leftBtn is MailBtn ? 34 : 70);// .height;
					leftBtn.x = 5;
				}
				//Utility.log("leftBtn pos " + leftBtn.getID().ID + " is: " + leftBtn.x + " // " + leftBtn.y);
			}

			pos = BEGIN_BOTTOM_BTN_X;
			for each (var bottomBtn:HUDButton in btnsDict[BOTTOM])
			{
				if (bottomBtn.visible)
				{
					if (bottomBtn == questTransportBtn)
					{
						bottomBtn.x = pos - (BOTTOM_BTN_WIDTH + bottomBtn.width / 2);
					}
					else
					{
						bottomBtn.x = pos - (BOTTOM_BTN_WIDTH + bottomBtn.width);
					}
					pos = bottomBtn.x;
					bottomBtn.y = 592;
				}
				//Utility.log("bottomBtn pos " + bottomBtn.getID().ID + " is: " + bottomBtn.x + " // " + bottomBtn.y);
			}
		}

		private function onSoundToogleHdl(e:Event = null):void
		{

			var id:int = SoundID.randomOutgameMusicID();
			var soundXML:SoundXML = Game.database.gamedata.getData(DataType.SOUND, id) as SoundXML;
			if (_soundBtn)
			{
				if (_soundBtn.isSelected)
				{
					SoundManager.addOrPlaySound(id.toString(), soundXML.src, 999, true);
					SharedObject.getLocal(Game.database.gamedata.clientCookiesURL).data.isSoundOn = "true";
					SharedObject.getLocal(Game.database.gamedata.clientCookiesURL).flush();
				}
				else
				{
					SoundManager.stopAllSound();
					SharedObject.getLocal(Game.database.gamedata.clientCookiesURL).data.isSoundOn = "false";
					SharedObject.getLocal(Game.database.gamedata.clientCookiesURL).flush();
				}
			}
		}

		private function onInviteToogleHdl(e:Event = null):void
		{
			if (_inviteBtn)
			{
				Game.database.gamedata.enableReceiveInvitation = _inviteBtn.isSelected;
			}
		}

		private function onReduceEffectToogleHdl(e:Event = null):void
		{
			if (reduceEffectBtn)
			{
				Game.database.gamedata.enableReduceEffect = reduceEffectBtn.isSelected;
			}
		}

		private function onRollOut(e:MouseEvent):void
		{
			switch (e.target)
			{
				case worldMapBtn:
				//case arenaBtn:
				case metalFurnaceBtn:
				case inventoryBtn:
				case changeFormationBtn:
				case powerTransferBtn:
				case soulBtn:
				case questTransportBtn:
				case questDailyBtn:
				case shopItemBtn:
				case questMainBtn:
				case luckyGiftBtn:
				case mailBtn:
				case _soundBtn:
				case _inviteBtn:
				case presentBtn:
				case friendBtn:
				case guildBtn:
				case eventsHotBtn:
				case treasureBtn:
				case activityBtn:
				case changeRecipeBtn:
				case consumeEventBtn:
				case chargeEventBtn:
				case giftOnlineBtn:
				case btnDailyTask:
				case btnAttendance:
				case tuuLauChienBtn:
				case wikiBtn:
				case divineWeaponBtn:
				case mysticBoxBtn:
				case expressBtn:
				case diceBtn:
				case shopDiscountBtn:
				case vipPromotionBtn:
				case reduceEffectBtn:
					dispatchEvent(new EventEx(TooltipEvent.HIDE_TOOLTIP, null, true));
					break;

				default:
			}
		}

		private function onRollOver(e:MouseEvent):void
		{
			switch (e.target)
			{
				case worldMapBtn:
					dispatchEvent(new EventEx(TooltipEvent.SHOW_TOOLTIP, { type: TooltipID.SIMPLE,
						value                                                  : "Vào Sơn Hà Đồ để diệt quái."}, true));
					break;
				//case arenaBtn:
				//dispatchEvent(new EventEx(TooltipEvent.SHOW_TOOLTIP, { type: TooltipID.SIMPLE,
				//value: "Danh Chấn Võ Lâm, gồm 3 chế độ: Luyện Tập, Tam Hùng Kỳ Hiệp và Võ Lâm Minh Chủ."}, true));
				//break;
				case metalFurnaceBtn:
					dispatchEvent(new EventEx(TooltipEvent.SHOW_TOOLTIP, { type: TooltipID.SIMPLE,
						value                                                  : "Lò Luyện Kim: Đổi vàng ra bạc."}, true));
					break;
				case inventoryBtn:
					dispatchEvent(new EventEx(TooltipEvent.SHOW_TOOLTIP, { type: TooltipID.SIMPLE,
						value                                                  : "Thùng Đồ: chứa tất cả các vật phẩm."}, true));
					break;
				case changeFormationBtn:
					dispatchEvent(new EventEx(TooltipEvent.SHOW_TOOLTIP, { type: TooltipID.SIMPLE,
						value                                                  : "Đội Hình: thay đổi, xem thông tin nhân vật."}, true));
					break;
				case powerTransferBtn:
					dispatchEvent(new EventEx(TooltipEvent.SHOW_TOOLTIP, { type: TooltipID.SIMPLE,
						value                                                  : "Luyện Công: thăng cấp nhân vật và kỹ năng nhân vật."}, true));
					break;
				case soulBtn:
					dispatchEvent(new EventEx(TooltipEvent.SHOW_TOOLTIP, { type: TooltipID.SIMPLE,
						value                                                  : "Bói Mệnh Khí"}, true));
					break;
				case questTransportBtn:
					dispatchEvent(new EventEx(TooltipEvent.SHOW_TOOLTIP, { type: TooltipID.SIMPLE,
						value                                                  : "Nhiệm Vụ Đưa Thư"}, true));
					break;
				case questDailyBtn:
					dispatchEvent(new EventEx(TooltipEvent.SHOW_TOOLTIP, { type: TooltipID.SIMPLE,
						value                                                  : "Dã Tẩu: hoàn thành nhiệm vụ dã tẩu để được phần thưởng và điểm tích lũy nhiệm vụ.\nTích lũy điểm nhiệm vụ để nhận nhiều đạo cụ quý."}, true));
					break;
				case shopItemBtn:
					dispatchEvent(new EventEx(TooltipEvent.SHOW_TOOLTIP, { type: TooltipID.SIMPLE,
						value                                                  : "Cửa Hàng Vật Phẩm"}, true));
					break;
				case questMainBtn:
					dispatchEvent(new EventEx(TooltipEvent.SHOW_TOOLTIP, { type: TooltipID.SIMPLE,
						value                                                  : "Nhiệm Vụ Chính Tuyến"}, true));
					break;
				case luckyGiftBtn:
				{
					var nXuConsumeNeed:int = Game.database.gamedata.getConfigData(GameConfigID.CONSUME_XU_NEED_CHANGE_LUCKY_GIFT_TIME) as int;
					dispatchEvent(new EventEx(TooltipEvent.SHOW_TOOLTIP, { type: TooltipID.SIMPLE,
						value                                                  : "Quà May Mắn: Cứ sử dụng " + nXuConsumeNeed + " Vàng ở tính năng bất kì sẽ được 1 lần quay quà may mắn."}, true));
				}
					break;
				case mailBtn:
					dispatchEvent(new EventEx(TooltipEvent.SHOW_TOOLTIP, { type: TooltipID.SIMPLE,
						value                                                  : "Hộp Thư"}, true));
					break;
				case _soundBtn:
					dispatchEvent(new EventEx(TooltipEvent.SHOW_TOOLTIP, { type: TooltipID.SIMPLE,
						value                                                  : "Tắt / Mở Âm Thanh"}, true));
					break;
				case _inviteBtn:
					dispatchEvent(new EventEx(TooltipEvent.SHOW_TOOLTIP, { type: TooltipID.SIMPLE,
						value                                                  : "Chặn lời mời từ bạn"}, true));
					break;
				case presentBtn:
					dispatchEvent(new EventEx(TooltipEvent.SHOW_TOOLTIP, { type: TooltipID.SIMPLE,
						value                                                  : "Quà Đặc Biệt: thưởng TOP, lên cấp, VIP."}, true));
					break;
				case friendBtn:
					dispatchEvent(new EventEx(TooltipEvent.SHOW_TOOLTIP, { type: TooltipID.SIMPLE,
						value                                                  : "Hảo Hữu"}, true));
					break;
				case guildBtn:
					dispatchEvent(new EventEx(TooltipEvent.SHOW_TOOLTIP, { type: TooltipID.SIMPLE,
						value                                                  : "Bang Hội"}, true));
					break;
				case activityBtn:
					dispatchEvent(new EventEx(TooltipEvent.SHOW_TOOLTIP, { type: TooltipID.SIMPLE,
						value                                                  : "Điểm hoạt động"}, true));
					break;
				case eventsHotBtn:
					dispatchEvent(new EventEx(TooltipEvent.SHOW_TOOLTIP, { type: TooltipID.SIMPLE,
						value                                                  : "Sự kiện nổi bật"}, true));
					break;
				case treasureBtn:
					dispatchEvent(new EventEx(TooltipEvent.SHOW_TOOLTIP, { type: TooltipID.SIMPLE,
						value                                                  : "Đào Kho Báu"}, true));
					break;
				case changeRecipeBtn:
					dispatchEvent(new EventEx(TooltipEvent.SHOW_TOOLTIP, { type: TooltipID.SIMPLE,
						value                                                  : "Đổi Bí Kíp: bí kíp trận hình và kỹ năng"}, true));
					break;
				case consumeEventBtn:
					dispatchEvent(new EventEx(TooltipEvent.SHOW_TOOLTIP, { type: TooltipID.SIMPLE,
						value                                                  : "Tiêu Xu Tích Lũy"}, true));
					break;
				case chargeEventBtn:
					dispatchEvent(new EventEx(TooltipEvent.SHOW_TOOLTIP, { type: TooltipID.SIMPLE,
						value                                                  : "Nạp Xu Nhận Quà"}, true));
					break;
				case giftOnlineBtn:
					dispatchEvent(new EventEx(TooltipEvent.SHOW_TOOLTIP, { type: TooltipID.SIMPLE,
						value                                                  : "Nhận Thưởng Online"}, true));
					break;

				case btnDailyTask:
					dispatchEvent(new EventEx(TooltipEvent.SHOW_TOOLTIP, { type: TooltipID.SIMPLE,
						value                                                  : "Hoạt Động Hằng Ngày"}, true));
					break;

				case btnAttendance:
					dispatchEvent(new EventEx(TooltipEvent.SHOW_TOOLTIP, { type: TooltipID.SIMPLE,
						value                                                  : "Điểm Danh Để Nhận Nhiều Phần Thưởng Giá Trị"}, true));
					break;
				
				case tuuLauChienBtn:
					dispatchEvent(new EventEx(TooltipEvent.SHOW_TOOLTIP, { type: TooltipID.SIMPLE,
						value                                                  : "Tài nguyên chiến"}, true));
					break;
					
				case trainBtn:
					dispatchEvent(new EventEx(TooltipEvent.SHOW_TOOLTIP, { type: TooltipID.SIMPLE,
						value                                                  : "Chỉ điểm võ công"}, true));
					break;

				case wikiBtn:
					dispatchEvent(new EventEx(TooltipEvent.SHOW_TOOLTIP, { type: TooltipID.SIMPLE,
						value                                                  : "Cẩm nang"}, true));
					break;

				case mysticBoxBtn:
					dispatchEvent(new EventEx(TooltipEvent.SHOW_TOOLTIP, { type: TooltipID.SIMPLE,
						value                                                  : "Hộp Quà Thần Bí"}, true));
					break;
				case expressBtn:
					dispatchEvent(new EventEx(TooltipEvent.SHOW_TOOLTIP, { type: TooltipID.SIMPLE,
						value                                                  : "Vận Tiêu"}, true));
					break;
				case diceBtn:
					dispatchEvent(new EventEx(TooltipEvent.SHOW_TOOLTIP, { type: TooltipID.SIMPLE,
						value                                                  : "May Mắn Đầu Năm"}, true));
					break;
				case shopDiscountBtn:
					dispatchEvent(new EventEx(TooltipEvent.SHOW_TOOLTIP, { type: TooltipID.SIMPLE,
						value                                                  : "Lì xì đầu năm"}, true));
					break;
				case vipPromotionBtn:
					dispatchEvent(new EventEx(TooltipEvent.SHOW_TOOLTIP, { type: TooltipID.SIMPLE,
						value                                                  : "Trả Lễ VIP"}, true));
					break;
				case reduceEffectBtn:
					dispatchEvent(new EventEx(TooltipEvent.SHOW_TOOLTIP, { type: TooltipID.SIMPLE,
						value                                                  : "Giảm hiệu ứng"}, true));
					break;
				case divineWeaponBtn:
					dispatchEvent(new EventEx(TooltipEvent.SHOW_TOOLTIP, { type: TooltipID.SIMPLE,
						value                                                  : "Bảo Bối Thần Binh"}, true));
					break;

				default:
			}

		}

		private function onAnimLoadedHdl(e:Event):void
		{
			_effectQuestMain.x = questMainBtn.x + questMainBtn.width / 2;
			_effectQuestMain.y = questMainBtn.y + questMainBtn.height / 2;
			//_effectQuestMain.play(0, 0);
			addChild(_effectQuestMain);
		}

		private function onUpdateTimerHdl(e:TimerEvent):void
		{
			_remainCount = _remainCount > 0 ? _remainCount - 1 : 0;
			questTransportBtn.numTf.text = Utility.math.formatTime("M-S", _remainCount);

			if (_remainCount == 0)
			{
				_timer.stop();
			}

		}

		private function onBtnClickHdl(e:MouseEvent):void
		{

			//if (targetBtn && targetBtn != e.currentTarget) targetBtn.isSelected = false;
			
			targetBtn = e.currentTarget as HUDButton;
			if (targetBtn == null)
			{
				return;
			}
			
			for (var i:int = 0; i < buttons.length; i++)
			{
				if (buttons[i] != targetBtn)
				{
					buttons[i].isSelected = false;
				}
			}

			switch (targetBtn)
			{
				case powerTransferBtn:
				{
					dispatchEvent(new EventEx(TutorialEvent.EVENT, {type: TutorialEvent.POWER_TRANSFER}, true));
					dispatchEvent(new EventEx(REQUEST_HUD_VIEW, ModuleID.CHARACTER_ENHANCEMENT, true));
				}
					break;
				case changeFormationBtn:
				{
					dispatchEvent(new EventEx(TutorialEvent.EVENT, {type: TutorialEvent.CHANGE_FORMATION}, true));
					dispatchEvent(new EventEx(REQUEST_HUD_VIEW, ModuleID.FORMATION, true));
				}
					break;
				case questTransportBtn:
				{
					dispatchEvent(new EventEx(TutorialEvent.EVENT, {type: TutorialEvent.OPEN_TRANSPORT}, true));
					dispatchEvent(new EventEx(REQUEST_HUD_VIEW, ModuleID.QUEST_TRANSPORT, true));
				}
					break;
				case worldMapBtn:
				{
					dispatchEvent(new EventEx(TutorialEvent.EVENT, {type: TutorialEvent.WORLD_CAMPAIGN_CLICK}, true));
					dispatchEvent(new EventEx(REQUEST_HUD_VIEW, ModuleID.WORLD_MAP, true));
				}
					break;
				case inventoryBtn:
				{
					dispatchEvent(new EventEx(REQUEST_HUD_VIEW, ModuleID.INVENTORY_ITEM, true));
				}
					break;
				case soulBtn:
				{
					dispatchEvent(new EventEx(TutorialEvent.EVENT, {type: TutorialEvent.OPEN_SOUL_CENTER}, true));
					dispatchEvent(new EventEx(REQUEST_HUD_VIEW, ModuleID.SOUL_CENTER, true));
				}
					break;
				//case arenaBtn:
				//{
				//dispatchEvent(new EventEx(REQUEST_HUD_VIEW, ModuleID.ARENA, true));
				//}
				//break;
				case questMainBtn:
				{
					dispatchEvent(new EventEx(TutorialEvent.EVENT, {type: TutorialEvent.OPEN_MAIN_QUEST}, true));
					dispatchEvent(new EventEx(REQUEST_HUD_VIEW, ModuleID.QUEST_MAIN, true));
				}
					break;
				case questDailyBtn:
				{
					//if (checkUnlockNPC(HUDButtonID.DAILY_QUEST.ID))
					//Manager.display.showModule(ModuleID.QUEST_DAILY, new Point(0, 0), LayerManager.LAYER_POPUP, "top_left", Layer.BLOCK_BLACK);
					dispatchEvent(new EventEx(TutorialEvent.EVENT, {type: TutorialEvent.OPEN_DAILY_QUEST}, true));
					dispatchEvent(new EventEx(REQUEST_HUD_VIEW, ModuleID.QUEST_DAILY, true));
				}
					break;

				case metalFurnaceBtn:
				{
					dispatchEvent(new EventEx(REQUEST_HUD_VIEW, ModuleID.METAL_FURNACE, true));
				}
					break;
				case luckyGiftBtn:
				{
					dispatchEvent(new EventEx(REQUEST_HUD_VIEW, ModuleID.LUCKY_GIFT, true));
				}
					break;
				case mailBtn:
				{
					mailBtn.setNotify(false, null);
					dispatchEvent(new EventEx(REQUEST_HUD_VIEW, ModuleID.MAIL_BOX, true));
				}
					break;
				case presentBtn:
				{
					presentBtn.setNotify(false, null);
					dispatchEvent(new EventEx(REQUEST_HUD_VIEW, ModuleID.PRESENT, true));
				}
					break;
				case friendBtn:
				{
					friendBtn.setNotify(false, null);
					dispatchEvent(new EventEx(REQUEST_HUD_VIEW, ModuleID.FRIEND, true));
				}
					break;
				case guildBtn:
				{
					dispatchEvent(new EventEx(REQUEST_HUD_VIEW, ModuleID.GUILD, true));
				}
					break;
				case activityBtn:
				{
					activityBtn.setNotify(false, null);
					dispatchEvent(new EventEx(REQUEST_HUD_VIEW, ModuleID.ACTIVITY, true));
				}
					break;
				case eventsHotBtn:
				{
					dispatchEvent(new EventEx(REQUEST_HUD_VIEW, ModuleID.EVENTS_HOT, true));
				}
					break;
				case treasureBtn:
				{
					dispatchEvent(new EventEx(REQUEST_HUD_VIEW, ModuleID.TREASURE, true));
				}
					break;
				case changeRecipeBtn:
				{
					this.dispatchEvent(new EventEx(REQUEST_HUD_VIEW, ModuleID.CHANGE_RECIPE, true));
				}
					break;
				case consumeEventBtn:
				{
					this.dispatchEvent(new EventEx(REQUEST_HUD_VIEW, ModuleID.CONSUME_EVENT, true));
				}
					break;
				case chargeEventBtn:
				{
					this.dispatchEvent(new EventEx(REQUEST_HUD_VIEW, ModuleID.CHARGE_EVENT, true));
				}
					break;
				case shopItemBtn:
				{
					updateShopItemState(0);
					this.dispatchEvent(new EventEx(REQUEST_HUD_VIEW, ModuleID.SHOP_ITEM, true));
				}
					break;
				case giftOnlineBtn:
				{
					this.dispatchEvent(new EventEx(REQUEST_HUD_VIEW, ModuleID.GIFT_ONLINE, true));
				}
					break;
				/*	case btnChat:
				 {
				 var chatModule:ChatModule = Manager.module.getModuleByID(ModuleID.CHAT) as ChatModule;
				 if (chatModule) {
				 if (Manager.display.checkVisible(ModuleID.CHAT)) {
				 if (chatModule.view) {
				 if (ChatView(chatModule.view).isMinimize == false) {
				 ChatView(chatModule.view).isMinimize = true;
				 break;
				case divineWeaponBtn:
					dispatchEvent(new EventEx(REQUEST_HUD_VIEW, ModuleID.DIVINE_WEAPON, true));
					break;
				 }
				 }
				 Manager.display.hideModule(ModuleID.CHAT);
				 } else {
				 Manager.display.showModule(ModuleID.CHAT, new Point(15, 450), LayerManager.LAYER_HUD, "top_left", Layer.NONE);
				 }
				 }
				 }
				 break;*/

				case btnDailyTask:
					dispatchEvent(new EventEx(TutorialEvent.EVENT, {type: TutorialEvent.OPEN_DAILY_TASK}, true));
					dispatchEvent(new EventEx(REQUEST_HUD_VIEW, ModuleID.DAILY_TASK, true));
					break;

				case btnAttendance:
					dispatchEvent(new EventEx(REQUEST_HUD_VIEW, ModuleID.ATTENDANCE, true));
					break;
					
				case tuuLauChienBtn:
					dispatchEvent(new EventEx(REQUEST_HUD_VIEW, ModuleID.TUULAUCHIEN, true));
					break;
				case trainBtn:
					dispatchEvent(new EventEx(REQUEST_HUD_VIEW, ModuleID.KUNGFU_TRAIN, true));
					break;
				case wikiBtn:
					dispatchEvent(new EventEx(REQUEST_HUD_VIEW, ModuleID.WIKI, true));
					break;
				case mysticBoxBtn:
					dispatchEvent(new EventEx(REQUEST_HUD_VIEW, ModuleID.MYSTIC_BOX, true));
					break;
				case expressBtn:
					dispatchEvent(new EventEx(REQUEST_HUD_VIEW, ModuleID.EXPRESS, true));
					break;
				case diceBtn:
					dispatchEvent(new EventEx(REQUEST_HUD_VIEW, ModuleID.DICE, true));
					break;
				case shopDiscountBtn:
					shopDiscountBtn.setNotify(false, null);
					dispatchEvent(new EventEx(REQUEST_HUD_VIEW, ModuleID.SHOP_DISCOUNT, true));
					break;
				case vipPromotionBtn:
					dispatchEvent(new EventEx(REQUEST_HUD_VIEW, ModuleID.VIP_PROMOTION, true));
					break;
				case divineWeaponBtn:
					dispatchEvent(new EventEx(REQUEST_HUD_VIEW, ModuleID.DIVINE_WEAPON, true));
					break;
			}
		
		}
		
		override public function transitionIn():void
		{
			var btns:Array = btnsDict[TOP];
			for (var i:int = 0; i < btns.length; i++) 
			{
				Manager.layer.addToLayer(btns[i], LayerManager.LAYER_HUD_TOP);
			}

			btns = btnsDict[TOP1];
			for (i = 0; i < btns.length; i++)
			{
				Manager.layer.addToLayer(btns[i], LayerManager.LAYER_HUD_TOP);
			}
			
			super.transitionIn();
		}
		
		override public function renderAnim():void
		{
			renderChildAnim(btnsDict[TOP][0].parent);
		}
		
		override public function transitionOut():void
		{
			var btns:Array = btnsDict[TOP];
			for (var i:int = 0; i < btns.length; i++) 
			{
				addChild(btns[i]);
			}

			btns = btnsDict[TOP1];
			for (i = 0; i < btns.length; i++)
			{
				addChild(btns[i]);
			}
			super.transitionOut();
		}
		
	}

}