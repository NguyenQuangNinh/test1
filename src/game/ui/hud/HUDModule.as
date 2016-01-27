package game.ui.hud
{
	import core.Manager;
	import core.display.DisplayManager;
	import core.display.ModuleBase;
	import core.display.layer.Layer;
	import core.display.layer.LayerManager;
	import core.enum.Align;
	import core.event.EventEx;
	import core.util.Enum;
	import core.util.Utility;

	import flash.utils.setTimeout;

	import game.data.xml.ShopXML;

	import flash.events.Event;
	import flash.geom.Point;

	import game.Game;
	import game.data.model.UserData;
	import game.data.xml.DataType;
	import game.data.xml.FeatureXML;
	import game.enum.GameConfigID;
	import game.enum.NotifyType;
	import game.enum.ShopID;
	import game.net.RequestPacket;
	import game.net.lobby.LobbyRequestType;
	import game.net.lobby.response.ResponseLobbyNotifyClient;
	import game.ui.ModuleID;
	import game.ui.home.HomeModule;
	import game.ui.home.HomeView;
	import game.ui.hud.gui.HUDButton;
	import game.ui.present.PresentModule;
	import game.ui.present.gui.PresentContainer;
	import game.ui.quest_daily.QuestDailyModule;
	import game.ui.quest_transport.ConfirmDialog;
	import game.ui.quest_transport.QuestTransportView;

	/**
	 * ...
	 * @author anhtinh
	 */
	public class HUDModule extends ModuleBase
	{
		public var view:HUDView;
		public function HUDModule()
		{

		}

		private var _moduleSelected:ModuleID;
		private var _firstChecked:Boolean = false;

		override protected function createView():void
		{
			super.createView();
			baseView = new HUDView();
			view = baseView as HUDView;
			baseView.addEventListener(HUDView.REQUEST_HUD_VIEW, requestViewHdl);

			// show discount
			var itemPacks:Array = Game.database.gamedata.getShopByShopID(ShopID.ITEM.ID);
			var maxDiscount:int = 0;
			for each (var itemPack:ShopXML in itemPacks)
			{
				if (maxDiscount < itemPack.discount) maxDiscount = itemPack.discount;
			}
			setDiscount(maxDiscount);
		}

		override protected function transitionIn():void
		{			
			super.transitionIn();
			Utility.log("HUDModule.transitionIn");
			
			Game.database.userdata.addEventListener(UserData.GAME_LEVEL_UP, onGameLevelUp);
			Game.database.userdata.addEventListener(UserData.LOBBY_NOTIFY_CLIENT, onLobbyNotifyClient);

			if (!_firstChecked)
			{
				_firstChecked = true;

				var currentLevel:int = Game.database.userdata.level;
				var transportXML:FeatureXML = Game.database.gamedata.getData(DataType.FEATURE, HUDButtonID.QUEST_TRANSPORT.ID) as FeatureXML;
				var mainXML:FeatureXML = Game.database.gamedata.getData(DataType.FEATURE, HUDButtonID.QUEST_MAIN.ID) as FeatureXML;
				var dailyXML:FeatureXML = Game.database.gamedata.getData(DataType.FEATURE, HUDButtonID.QUEST_DAILY.ID) as FeatureXML;

				if (transportXML && currentLevel >= transportXML.levelRequirement && !Game.database.userdata.checkNotify(NotifyType.NOTIFY_QUEST_TRANSPORTER.ID))
				{
					Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.QUEST_TRANSPORT_STATE));
				}

				if (mainXML && currentLevel >= mainXML.levelRequirement && !Game.database.userdata.checkNotify(NotifyType.NOTIFY_QUEST_MAIN.ID))
				{
					Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.QUEST_MAIN_STATE));
				}

				if (dailyXML && currentLevel >= dailyXML.levelRequirement && !Game.database.userdata.checkNotify(NotifyType.NOTIFY_QUEST_DAILY.ID))
				{
					Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.QUEST_DAILY_STATE));
				}
			}

			checkNotifyResponse();

			Manager.display.addEventListener(DisplayManager.CHANGE_SCREEN, onChangeScreen);
		}

		override protected function transitionOut():void
		{
			super.transitionOut();
			Utility.log("HUDModule.transitionOut");
			
			Game.database.userdata.removeEventListener(UserData.GAME_LEVEL_UP, onGameLevelUp);
			Game.database.userdata.removeEventListener(UserData.UPDATE_PLAYER_INFO, onUpdatePlayerInfo);
			Manager.display.removeEventListener(DisplayManager.CHANGE_SCREEN, onChangeScreen);
		}

		override protected function preTransitionIn():void
		{
			super.preTransitionIn();
			HUDView(baseView).updateDisplay();
			setTimeout(updateHUDButton, 500);

			//HUDView(view).checkFocus();
		}

		public function updateHUDButton():void
		{
			if (baseView)
			{
				HUDView(baseView).updateDisplay();
			}
		}

		public function closeSelectedModule():void
		{
			if (baseView && _moduleSelected)
			{
				hideModule(_moduleSelected);
			}
		}

		public function getBtnByName(btnName:String):HUDButton
		{
			if (baseView)
			{
				return HUDView(baseView).getBtnInstanceByName(btnName);
			}
			return null;
		}

		public function getPositionBtnByName(btnName:String):Point
		{
			if (baseView)
			{
				return HUDView(baseView).getPositionBtnByName(btnName);
			}
			return new Point();
		}

		public function setVisibleButtonHUD(arrBtnName:Array, val:Boolean):void
		{
			if (baseView)
			{
				HUDView(baseView).setVisibleButtonHUD(arrBtnName, val);
			}
		}

		public function clearSelected():void
		{
			if (baseView)
			{
				_moduleSelected = null;
			}
		}

		public function setButtonNotify(btnName:String, val:Boolean, jsonData:Object):void
		{
			if (baseView)
			{
				HUDView(baseView).setButtonNotify(btnName, val, jsonData);
			}
		}

		/*private function onLobbyServerData(e:EventEx):void
		 {
		 var packet:ResponsePacket = ResponsePacket(e.data);
		 switch (packet.type)
		 {

		 }
		 }*/

		public function showHint(hudBtn:HUDButtonID, content:String = ""):void
		{
			if (baseView)
			{
				HUDView(baseView).showHint(hudBtn.name, content);
			}
		}

		private function checkNotifyResponse():void
		{
			for each (var notify:NotifyType in Enum.getAll(NotifyType))
			{
				var obj:Object = Game.database.userdata.checkNotify(notify.ID);
				if (obj)
				{
					if (obj.byteData && obj.byteData.bytesAvailable > 0)
					{
						onLobbyNotifyClient(new EventEx(UserData.LOBBY_NOTIFY_CLIENT, obj));
					}
					else
					{
						Game.database.userdata.dismissNotify(notify.ID);
					}
				}
			}
		}

		public function getSelectedModule():ModuleID
		{
			return _moduleSelected;
		}

		private function requestViewHdl(e:EventEx):void
		{
			var targetBtn:HUDButton = HUDView(view).targetBtn;

			Manager.display.clearKeepedModule(this.id);

			if (e.data)
			{
				Manager.display.closeAllPopup();

				targetBtn.isSelected = !targetBtn.isSelected;

				if (!targetBtn.isSelected)
				{
					hideModule(e.data as ModuleID);
					_moduleSelected = null;
					return;
				}

				_moduleSelected = e.data as ModuleID;
				showModule(e.data as ModuleID);
			}
		}

		private function hideModule(moduleID:ModuleID):void
		{
			if (HUDView(baseView).getHUDButton(moduleID)) HUDView(baseView).getHUDButton(moduleID).isSelected = false;
			Manager.display.hideModule(moduleID);
		}

		private function showModule(moduleID:ModuleID, extraData:Object = null):void
		{
			if (HUDView(baseView).getHUDButton(moduleID)) HUDView(baseView).getHUDButton(moduleID).isSelected = true;
			switch (moduleID)
			{
				case ModuleID.WORLD_MAP:
					Manager.display.to(ModuleID.WORLD_MAP);
					break;
				case ModuleID.INVENTORY_ITEM:
					Manager.display.showModule(ModuleID.INVENTORY_ITEM, new Point(420, 130), LayerManager.LAYER_POPUP, "top_left", Layer.BLOCK_BLACK);
					break;
				case ModuleID.SOUL_CENTER:
					Manager.display.showModule(ModuleID.SOUL_CENTER, new Point(0, 0), LayerManager.LAYER_POPUP, "top_left", Layer.BLOCK_BLACK);
					break;
				case ModuleID.CHARACTER_ENHANCEMENT:
					Manager.display.showModule(ModuleID.INVENTORY_UNIT, new Point(80, 106), LayerManager.LAYER_POPUP, "top_left", Layer.BLOCK_BLACK, null, true);
					Manager.display.showModule(ModuleID.CHARACTER_ENHANCEMENT, new Point(), LayerManager.LAYER_POPUP, "top_left", Layer.NONE, extraInfo, true);
					extraInfo = null;
					break;
				case ModuleID.FORMATION:
					Manager.display.showModule(ModuleID.CHANGE_FORMATION, new Point(0, 0), LayerManager.LAYER_POPUP, "top_left", Layer.BLOCK_BLACK);
					break;
				//case ModuleID.FORMATION_TYPE:
				//Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.LIST_FORMATION_TYPE));
				//Manager.display.showModule(ModuleID.FORMATION_TYPE, new Point(0, 0), LayerManager.LAYER_POPUP, "top_left", Layer.BLOCK_BLACK);
				//break;
				//view.addEventListener(HUDView.REQUEST_HUD_VIEW, showUpgradeSkillHdl);
				case ModuleID.SHOP:
					Manager.display.showModule(ModuleID.SHOP, new Point(0, 0), LayerManager.LAYER_SCREEN);
					break;
				case ModuleID.QUEST_TRANSPORT:
					Manager.display.showModule(ModuleID.QUEST_TRANSPORT, new Point(100, 0), LayerManager.LAYER_POPUP, "top_left", Layer.BLOCK_BLACK);
					break;
				case ModuleID.QUEST_DAILY:
					Manager.display.showModule(ModuleID.QUEST_DAILY, new Point(0, 0), LayerManager.LAYER_POPUP, "top_left", Layer.BLOCK_BLACK);
					break;
				//case ModuleID.ARENA:
				//Manager.display.showModule(ModuleID.ARENA, new Point(0, 0), LayerManager.LAYER_POPUP, "top_left", Layer.BLOCK_BLACK);
				//break;
				case ModuleID.QUEST_MAIN:
					Manager.display.showModule(ModuleID.QUEST_MAIN, new Point(0, 0), LayerManager.LAYER_POPUP, "top_left", Layer.BLOCK_BLACK);
					break;
				case ModuleID.METAL_FURNACE:
					Manager.display.showModule(ModuleID.METAL_FURNACE, new Point(0, 0), LayerManager.LAYER_POPUP, "top_left", Layer.BLOCK_BLACK);
					break;
				case ModuleID.LUCKY_GIFT:
					Manager.display.showModule(ModuleID.LUCKY_GIFT, new Point(0, 0), LayerManager.LAYER_POPUP, "top_left", Layer.BLOCK_BLACK);
					break;
				case ModuleID.MAIL_BOX:
					Manager.display.showModule(ModuleID.MAIL_BOX, new Point(0, 0), LayerManager.LAYER_POPUP, "top_left", Layer.BLOCK_BLACK);
					break;
				case ModuleID.PRESENT:
					Manager.display.showModule(ModuleID.PRESENT, new Point(0, 0), LayerManager.LAYER_POPUP, "top_left", Layer.BLOCK_BLACK);
					break;
				case ModuleID.FRIEND:
					Manager.display.showModule(ModuleID.FRIEND, new Point(0, 0), LayerManager.LAYER_POPUP, "top_left", Layer.BLOCK_BLACK);
					break;
				case ModuleID.GUILD:
					Manager.display.showModule(ModuleID.GUILD, new Point(0, 0), LayerManager.LAYER_POPUP, "top_left", Layer.BLOCK_BLACK);
					break;
				case ModuleID.EVENTS_HOT:
					Manager.display.showModule(ModuleID.EVENTS_HOT, new Point(148, 96), LayerManager.LAYER_POPUP, Align.TOP_LEFT, Layer.BLOCK_BLACK);
					break;
				case ModuleID.TREASURE:
					Manager.display.showModule(ModuleID.TREASURE, new Point(0, 0), LayerManager.LAYER_POPUP, Align.TOP_LEFT, Layer.BLOCK_BLACK);
					break;
				case ModuleID.ACTIVITY:
					Manager.display.showModule(ModuleID.ACTIVITY, new Point(0, 0), LayerManager.LAYER_POPUP, "top_left", Layer.BLOCK_BLACK);
					break;
				case ModuleID.CHANGE_RECIPE:
					Manager.display.showModule(ModuleID.CHANGE_RECIPE, new Point(0, 0), LayerManager.LAYER_POPUP, "top_left", Layer.BLOCK_BLACK);
					break;
				case ModuleID.CONSUME_EVENT:
					Manager.display.showModule(ModuleID.CONSUME_EVENT, new Point(0, 0), LayerManager.LAYER_POPUP, "top_left", Layer.BLOCK_BLACK);
					break;
				case ModuleID.CHARGE_EVENT:
					Manager.display.showModule(ModuleID.CHARGE_EVENT, new Point(0, 0), LayerManager.LAYER_POPUP, "top_left", Layer.BLOCK_BLACK);
					break;
				case ModuleID.SHOP_ITEM:
					Manager.display.showModule(ModuleID.SHOP_ITEM, new Point(0, 0), LayerManager.LAYER_POPUP, "top_left", Layer.BLOCK_BLACK, ShopID.ITEM.ID);
					break;
				case ModuleID.GIFT_ONLINE:
					Manager.display.showModule(ModuleID.GIFT_ONLINE, new Point(0, 0), LayerManager.LAYER_POPUP, "top_left", Layer.BLOCK_BLACK);
					break;
				case ModuleID.DAILY_TASK:
					if (HUDView(baseView))
					{
						var posY:Number = HUDView(baseView).btnDailyTask.y + 20;
						if (posY > 240) posY = 200;
						Manager.display.showModule(ModuleID.DAILY_TASK, new Point(HUDView(baseView).btnDailyTask.x - 10,
										posY), LayerManager.LAYER_POPUP, "top_left");
					}
					break;
				case ModuleID.ATTENDANCE:
					Manager.display.showModule(ModuleID.ATTENDANCE, new Point(0, 0), LayerManager.LAYER_POPUP, "top_left", Layer.BLOCK_BLACK);
					break;
				case ModuleID.TUULAUCHIEN:
					Manager.display.to(ModuleID.TUULAUCHIEN);
					break;
				case ModuleID.KUNGFU_TRAIN:
					Manager.display.showModule(ModuleID.KUNGFU_TRAIN, new Point(0, 0), LayerManager.LAYER_HUD, "top_left", Layer.BLOCK_BLACK, extraData);
					break;
				case ModuleID.WIKI:
					Manager.display.showModule(ModuleID.WIKI, new Point(0, 0), LayerManager.LAYER_POPUP, "top_left", Layer.BLOCK_BLACK, extraData);
					break;
				case ModuleID.MYSTIC_BOX:
					Manager.display.showModule(ModuleID.MYSTIC_BOX, new Point(0, 0), LayerManager.LAYER_POPUP, "top_left", Layer.BLOCK_BLACK, extraData);
					break;
				case ModuleID.DICE:
					Manager.display.showModule(ModuleID.DICE, new Point(0, 0), LayerManager.LAYER_POPUP, "top_left", Layer.BLOCK_BLACK, extraData);
					break;
				case ModuleID.SHOP_DISCOUNT:
					Manager.display.showModule(ModuleID.SHOP_DISCOUNT, new Point(0, 0), LayerManager.LAYER_POPUP, "top_left", Layer.BLOCK_BLACK, extraData);
					break;
				case ModuleID.VIP_PROMOTION:
					Manager.display.showModule(ModuleID.VIP_PROMOTION, new Point(0, 0), LayerManager.LAYER_POPUP, "top_left", Layer.BLOCK_BLACK, extraData);
					break;
				case ModuleID.EXPRESS:
					Manager.display.to(ModuleID.EXPRESS);
					break;
				case ModuleID.DIVINE_WEAPON:
					Manager.display.showModule(ModuleID.DIVINE_WEAPON, new Point(125, 70), LayerManager.LAYER_POPUP, "top_left", Layer.BLOCK_BLACK);
					break;
			}
		}

		protected function onChangeScreen(event:Event):void
		{
			HUDView(baseView).updateDisplay();
		}

		private function onLobbyNotifyClient(e:EventEx):void
		{
			var packet:ResponseLobbyNotifyClient = e.data as ResponseLobbyNotifyClient;
			var checked:Boolean = false;
			if (packet)
			{
				switch (packet.notifyType)
				{
					case NotifyType.NOTIFY_ACTIVITY.ID:
					{
						this.setButtonNotify(HUDButtonID.ACTIVITY.name, true, null);
						break;
					}
					case NotifyType.NOTIFY_SHOP_DISCOUNT.ID:
					{
						this.setButtonNotify(HUDButtonID.SHOP_DISCOUNT.name, true, null);
						break;
					}
//					case NotifyType.NOTIFY_FRIEND.ID:
//					{
//						this.setButtonNotify(HUDButtonID.FRIEND.name, true, null);
//						break;
//					}
					case NotifyType.NOTIFY_NEW_MAIL.ID:
					{
						var nNewMail:int = packet.byteData.readInt();
						if (nNewMail > 0)
						{
							var jsonData:Object = {};
							jsonData.newmail = nNewMail;
							checked = true;
							this.setButtonNotify(HUDButtonID.MAIL.name, true, jsonData);
						}
					}
						break;
					case NotifyType.NOTIFY_REWARD_LEVEL.ID:
					{
						var nIsRewardLevel:int = packet.byteData.readInt();
						if (nIsRewardLevel == 1)
						{
							this.setButtonNotify(HUDButtonID.PRESENT.name, true, null);
							var presentModule:PresentModule = Manager.module.getModuleByID(ModuleID.PRESENT) as PresentModule;
							if (presentModule != null)
							{
								checked = true;
								presentModule.setButtonPresentNotify(PresentContainer.BTN_REWARD_LEVEL, true);
							}
						}
						break;
					}
					case NotifyType.NOTIFY_NEW_FORMATION_TYPE.ID:
					{
						var nIsNewFormationType:int = packet.byteData.readInt();
						if (nIsNewFormationType == 1)
						{
							checked = true;
							this.setButtonNotify(HUDButtonID.FORMATION_TYPE.name, true, null);
						}
					}
						break;
					case NotifyType.NOTIFY_NEW_VIP.ID:
					{
						var nNewVip:int = packet.byteData.readInt();
						if (nNewVip == 1 || nNewVip == 3 || nNewVip == 5)
						{
							this.setButtonNotify(HUDButtonID.PRESENT.name, true, null);
							presentModule = Manager.module.getModuleByID(ModuleID.PRESENT) as PresentModule;
							if (presentModule)
							{
								checked = true;
								switch (nNewVip)
								{
									case 1:
										presentModule.setButtonPresentNotify(PresentContainer.BTN_NGU_PHAI_DAI_DE_TU, true);
										break;
									case 3:
										presentModule.setButtonPresentNotify(PresentContainer.BTN_DE_TU_CHAN_TRUYEN, true);
										break;
									case 5:
										presentModule.setButtonPresentNotify(PresentContainer.BTN_CAO_THU_NGU_DAI_PHAI, true);
										break;
								}
							}
						}
					}
						break;
					case NotifyType.NOTIFY_QUEST_MAIN.ID:
					{
						checked = true;
						var mainState:int = packet.byteData.readInt();
						//Utility.log("quest main state receive notify is: " + mainState);
						HUDView(baseView).updateQuestMainState(mainState);
					}
						break;
					case NotifyType.NOTIFY_QUEST_TRANSPORTER.ID:
					{
						checked = true;
						var transportState:int = packet.byteData.readInt();
						var remainQuest:int = packet.byteData.readInt();
						var elapseTime:int = packet.byteData.readInt();
						HUDView(baseView).updateQuestTransportState(transportState, remainQuest, elapseTime);

						//Utility.log("quest transport state receive notify is: " + transportState);

						var transportView:QuestTransportView = Manager.module.getModuleByID(ModuleID.QUEST_TRANSPORT).baseView as QuestTransportView;
						if (transportView)
						{
							switch (transportState)
							{
								case 3: //out of quests in day
									Utility.log("transportState : out of quests in day ");
									var obj:Object = {};
									obj.type = ConfirmDialog.CONFIRM_FOR_ALL_COMPLETED;
									obj.index = -1;
									transportView.showConfirmDialog(obj);
									break;
								case 0: //error
								case 1: //has quest but has no completed
								case 4: //has quest completed but not confirm
									break;
								case 2: //waiting for the next random - con thoi gian cho => show pop up confirm price
									//show dialog to confirm use xuxu than chuong for skip time cout down to next missions
									obj = {};
									obj.type = ConfirmDialog.CONFIRM_FOR_REFRESH;
									obj.index = -1;
									var prices:Array = Game.database.gamedata.getConfigData(GameConfigID.QUEST_TRANSPORT_PRICE_REFRESH) as Array;
									var refreshTime:int = Game.database.userdata.nTransportRefresh + 1;
									obj.price = refreshTime < prices.length ? prices[refreshTime] : prices[prices.length - 1];

									obj.remain = elapseTime;
									Utility.log("price to refresh next random till " + obj.remain + " is " + obj.price);
									if (elapseTime > 0)
									{
										if (obj.price == 0)
										{
											// hide confirm price dialog
											transportView.showConfirmDialog(null);
											Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.QUEST_TRANSPORT_REFRESH));
										}
										else
										{
											transportView.showConfirmDialog(obj);
										}
									}

									break;
							}
						}
					}
						break;
					case NotifyType.NOTIFY_QUEST_DAILY.ID:
					{
						checked = true;
						var numCompleted:int = packet.byteData.readInt();
						var totalCompleted:int = packet.byteData.readInt();
						var timeRemain:int = packet.byteData.readInt();
						var scoreAccumulate:int = packet.byteData.readInt();
						var indexAccumulated:int = packet.byteData.readInt();
						var state:int = packet.byteData.readInt();
						//Utility.log("quest daily state receive notify is: " + state);
						HUDView(baseView).updateQuestDailyState(state);
						var questDailyModule:QuestDailyModule = Manager.module.getModuleByID(ModuleID.QUEST_DAILY) as QuestDailyModule;
						if (questDailyModule)
						{
							questDailyModule.updateState(numCompleted, totalCompleted, timeRemain, scoreAccumulate, indexAccumulated);
						}
					}
						break;
					case NotifyType.NOTIFY_CHANGE_RANK_PVP_AI.ID:
						var homeModule:HomeModule = Manager.module.getModuleByID(ModuleID.HOME) as HomeModule;
						if (homeModule && homeModule.baseView)
						{
							(homeModule.baseView as HomeView).updateChallengeState(2);
						}
						break;
					case NotifyType.NOTIFY_TUU_LAU_CHIEN.ID:
						//checked = true;
						this.setButtonNotify(HUDButtonID.TUULAUCHIEN.name, true, null);
						break;
					default:
						break;
					
				}
			}
			if (checked)
			{
				Game.database.userdata.dismissNotify(packet.notifyType);
			}
		}

		private function onUpdatePlayerInfo(e:Event):void
		{
			HUDView(baseView).luckyGiftBtn.updateMessage();
		}

		private function onGameLevelUp(e:Event):void
		{
			this.updateHUDButton();
		}

		public function setDiscount(discount:int):void
		{
			view.shopItemBtn.discountMov.visible = discount > 0;
			view.shopItemBtn.discountMov.tf.text = "- " + discount + "%";
		}

		public function updateHUDButtonStatus(moduleID:ModuleID, visible:Boolean, extraData:Object = null, isTransitionModule:Boolean = true):void
		{
			var btn:HUDButton = HUDView(baseView).getHUDButton(moduleID);
			if (!isTransitionModule)
			{
				btn.isSelected = visible;
				return;
			}
			if (visible)
			{
				_moduleSelected = moduleID;
				showModule(moduleID, extraData);
			}
			else
			{
				if (_moduleSelected == moduleID) _moduleSelected = null;
				hideModule(moduleID);
			}

		}

		public function showHUDModule(e:EventEx):void
		{
			if (_moduleSelected) hideModule(_moduleSelected);
			updateHUDButtonStatus(e.data as ModuleID, true);
		}
	}

}