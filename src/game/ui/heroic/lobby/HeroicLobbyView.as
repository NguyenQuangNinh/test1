package game.ui.heroic.lobby
{

	import com.greensock.TimelineLite;
	import com.greensock.TweenMax;

	import core.Manager;
	import core.display.ViewBase;
	import core.display.animation.Animator;
	import core.display.layer.Layer;
	import core.display.layer.LayerManager;
	import core.event.EventEx;
	import core.util.FontUtil;
	import core.util.TextFieldUtil;
	import core.util.Utility;

	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;

	import game.Game;
	import game.data.gamemode.ModeDataPVEHeroic;
	import game.data.model.Character;
	import game.data.vo.chat.ChatType;
	import game.data.vo.lobby.LobbyInfo;
	import game.data.vo.lobby.LobbyPlayerInfo;
	import game.data.xml.DataType;
	import game.data.xml.FormationTypeXML;
	import game.enum.Direction;
	import game.enum.FlowActionEnum;
	import game.enum.Font;
	import game.enum.FormationType;
	import game.enum.GameMode;
	import game.enum.InventoryMode;
	import game.net.BoolRequestPacket;
	import game.net.RequestPacket;
	import game.net.lobby.LobbyRequestType;
	import game.net.lobby.request.RequestChangeHeroicRoomFormation;
	import game.net.lobby.request.RequestSaveFormation;
	import game.ui.ModuleID;
	import game.ui.chat.ChatModule;
	import game.ui.chat.ChatView;
	import game.ui.components.CheckBox;
	import game.ui.dialog.DialogID;
	import game.ui.heroic.HeroicEvent;
	import game.ui.heroic.world_map.CampaignData;
	import game.ui.inventory.InventoryModule;
	import game.ui.inventory.InventoryView;
	import game.ui.tooltip.TooltipEvent;
	import game.ui.tooltip.TooltipID;
	import game.ui.tutorial.TutorialEvent;
	import game.utility.TimerEx;
	import game.utility.UtilityUI;

	/**
	 * ...
	 * @author MaiPTT
	 */
	public class HeroicLobbyView extends ViewBase
	{
		private static const MAX_CHARACTERS_PER_PLAYER:int = 2;
		private static const MAX_CHARACTERS:int = 6;

		public function HeroicLobbyView()
		{
			players = [];
			formationSlots = [];
			nodes = [];
			initUI();
			initHandlers();
		}

		public var formationContainer:MovieClip;
		public var inventoryViewContainer:MovieClip;
		public var nodeContainer:MovieClip;
		public var nodeListContainer:MovieClip;
		public var btnBack:SimpleButton;
		public var txtName:TextField;

		private var formationSlots:Array;
		private var players:Array;
		private var nodes:Array;
		private var inventoryModule:InventoryModule;
		private var autoStartTimerID:int = -1;
		private var timeWait:int;

		public function get isHost():Boolean
		{
			return modeData.isHost;
		}

		public function get modeData():ModeDataPVEHeroic
		{
			return Game.database.userdata.getModeData(GameMode.PVE_HEROIC) as ModeDataPVEHeroic;
		}

		private function get autoStart():CheckBox
		{
			return formationContainer.autoStart as CheckBox;
		}

		private function get txtFormationName():TextField
		{
			return formationContainer.txtFormationName;
		}

		private function get txtFormationTypeLevel():TextField
		{
			return formationContainer.txtFormationTypeLevel;
		}

		private function get btnInventory():SimpleButton
		{
			return formationContainer.btnInventory;
		}

		private function get btnFormationType():SimpleButton
		{
			return formationContainer.btnFormationType;
		}

		private function get btnInviteFriend():SimpleButton
		{
			return formationContainer.btnInviteFriend;
		}

		private function get btnBroadcastGlobal():SimpleButton
		{
			return formationContainer.btnBroadcastGlobal;
		}

		private function get countDownTf():TextField
		{
			return formationContainer.countDownTf;
		}

		private function get isFullRoom():Boolean
		{
			var modeData:ModeDataPVEHeroic = ModeDataPVEHeroic(Game.database.userdata.getModeData(GameMode.PVE_HEROIC));
			var playersInRoom:int = modeData.getPlayers().length;
			var maxPlayers:int = MAX_CHARACTERS / MAX_CHARACTERS_PER_PLAYER;

			return (playersInRoom == maxPlayers)
		}

		override public function transitionIn():void
		{
			super.transitionIn();
			Manager.display.showModule(ModuleID.HUD, new Point(), LayerManager.LAYER_HUD);
			TweenMax.to(formationContainer, 0.5, { x: 320 });
			if (!inventoryModule)
			{
				inventoryModule = Manager.module.getModuleByID(ModuleID.INVENTORY_UNIT) as InventoryModule;
			}
			inventoryViewContainer.visible = false;
		}

		override protected function transitionInComplete():void
		{
			super.transitionInComplete();
			var caveID:int = ModeDataPVEHeroic(Game.database.userdata.getModeData(GameMode.PVE_HEROIC)).caveID;
			var data:CampaignData = Game.database.gamedata.getHeroicConfig(caveID);
			if (data)
			{
				txtName.text = data.name;
			}

			var chat:ChatView = Manager.module.getModuleByID(ModuleID.CHAT).baseView as ChatView;
			if (chat != null)
			{
				chat.chatBoxMov.update(ChatType.CHAT_TYPE_ROOM, ChatType.CHAT_TYPE_ROOM);
			}
		}

		public function update():void
		{
			updateFormation();
			updateFormationType();
			updateNodes();
			if (isHost)
			{
				btnFormationType.visible = true;
				autoStart.visible = true;
			}
			else
			{
				btnFormationType.visible = false;
				autoStart.visible = false;
			}

			if (modeData.autoStart && isFullRoom)
			{
				startCountDown();
			}
			else
			{
				stopCountDown();
			}
		}

		public function changeRoomFormation(dragObj:Object, targetRect:Rectangle):void
		{
			var index:int = 0;
			var result:Boolean = false;
			for each (var formationSlot:LobbyFormationSlot in formationSlots)
			{
				if (formationSlot && formationSlot.boundingBox)
				{
					if (Utility.math.checkOverlap(formationSlot.boundingBox, targetRect))
					{
						result = true;
						break;
					}
				}
				index++;
			}

			if (result)
			{
				var formationIndex:Array = ModeDataPVEHeroic(Game.database.userdata.getModeData(GameMode.PVE_HEROIC)).formationIndex;
				var fromIndex:int = dragObj.data as int;
				var toIndex:int = index;
				var temp:int = formationIndex[fromIndex];
				formationIndex[fromIndex] = formationIndex[toIndex];
				formationIndex[toIndex] = temp;
				var requestPacket:RequestChangeHeroicRoomFormation = new RequestChangeHeroicRoomFormation(formationIndex);
				Game.network.lobby.sendPacket(requestPacket);
			}
		}

		public function setAutoStart(value:Boolean):void
		{
			autoStart.setChecked(value);
		}

		private function updateFormationType():void
		{
			var modeData:ModeDataPVEHeroic = Game.database.userdata.getModeData(GameMode.PVE_HEROIC) as ModeDataPVEHeroic;
			var formationTypeXML:FormationTypeXML = Game.database.gamedata.getData(DataType.FORMATION_TYPE, modeData.formationTypeID) as FormationTypeXML;
			if (formationTypeXML)
			{
				txtFormationName.text = formationTypeXML.name;
				txtFormationTypeLevel.text = "Cấp: " + modeData.formationTypeLevel.toString();
			}
			else
			{
				txtFormationName.text = "Chưa chọn trận hình";
				txtFormationTypeLevel.text = "";
			}
		}

		private function updateFormation():void
		{
			players = ModeDataPVEHeroic(Game.database.userdata.getModeData(GameMode.PVE_HEROIC)).getPlayers();
			var formation:Array = ModeDataPVEHeroic(Game.database.userdata.getModeData(GameMode.PVE_HEROIC)).formationIndex;
			var playerIndex:int;
			var player:LobbyPlayerInfo;
			var data:Character;
			var characterAnim:Animator;
			for (var i:int = 0; i < MAX_CHARACTERS; ++i)
			{
				var formationSlot:LobbyFormationSlot = formationSlots[i];
				var formationIndex:int = formation[i];
				if (formationIndex > -1)
				{
					playerIndex = int(formationIndex / MAX_CHARACTERS_PER_PLAYER);
					for each(player in players)
					{
						if (player.index == playerIndex)
						{
							formationSlot.setData(player, (formationIndex % MAX_CHARACTERS_PER_PLAYER), i, new Point(formationContainer.x, formationContainer.y));
							break;
						}
					}
				}
				else
				{
					formationSlot.setData(null, -1, -1, new Point(formationContainer.x, formationContainer.y));
				}
			}
		}

		private function updateNodes():void
		{
			var caveID:int = ModeDataPVEHeroic(Game.database.userdata.getCurrentModeData()).caveID;
			var difficulty:int = ModeDataPVEHeroic(Game.database.userdata.getCurrentModeData()).difficulty;
			var caveData:CampaignData = Game.database.gamedata.getHeroicConfig(caveID);
			if (caveData)
			{
				var missionIDs:Array = caveData.missionIDs[difficulty];
				for each (var node:HeroicNode in nodes)
				{
					if (node.parent)
					{
						node.parent.removeChild(node);
					}
					node.reset();
					Manager.pool.push(node, HeroicNode);
					node = null;
				}
				nodes.splice(0);

				var nextStep:int = ModeDataPVEHeroic(Game.database.userdata.getCurrentModeData()).campaignStep;
				var nodeIndex:int = Math.floor(nodeContainer.numChildren / (missionIDs.length - 1));
				for (var i:int = 0; i < missionIDs.length; i++)
				{
					node = Manager.pool.pop(HeroicNode) as HeroicNode;
					node.setData(missionIDs[i]);
					if (i < nextStep)
					{
						node.setNodeEnable(false);
					}
					else if (i == nextStep)
					{
						node.isNextNode(true);
					}
					node.x = nodeContainer.x + nodeContainer.getChildAt(nodeIndex * i).x;
					node.y = nodeContainer.y + nodeContainer.getChildAt(nodeIndex * i).y;
					nodeListContainer.addChild(node);
					nodes.push(node);
				}

				if (nextStep == missionIDs.length)
				{
					Manager.display.showDialog(DialogID.GLOBAL_BOSS_CONFIRM, onDialogConfirmHdl, null,
							{content: "Chúc mừng bạn đã hoàn thành ải " + caveData.name + ". Nhấn Đồng Ý để tiếp tục." }, Layer.BLOCK_BLACK);
				}
			}
		}

		private function onDialogConfirmHdl(data:Object):void
		{
			Game.flow.doAction(FlowActionEnum.LEAVE_GAME);
		}

		private function initUI():void
		{
			btnBack = UtilityUI.getComponent(UtilityUI.BACK_BTN) as SimpleButton;
			var btnBackPos:Point = UtilityUI.getComponentPosition(UtilityUI.BACK_BTN) as Point;
			btnBack.x = btnBackPos.x;
			btnBack.y = btnBackPos.y;
			addChild(btnBack);

			FontUtil.setFont(txtFormationTypeLevel, Font.ARIAL, true);
			FontUtil.setFont(txtName, Font.ARIAL, true);
			FontUtil.setFont(txtFormationName, Font.ARIAL, true);
			FontUtil.setFont(countDownTf, Font.ARIAL, true);

			for (var i:int = 0; i < MAX_CHARACTERS; i++)
			{
				var formationSlot:LobbyFormationSlot = new LobbyFormationSlot();
				formationSlot.addEventListener(MouseEvent.DOUBLE_CLICK, slot_onDoubleClicked);
				formationSlot.addEventListener(LobbyFormationSlot.INSERT_CHARACTER, onShowInventoryView);
				formationSlot.x = 100 * i;
				formationContainer.addChild(formationSlot);
				formationSlots.push(formationSlot);
			}

			var label:TextField = TextFieldUtil.createTextfield(Font.ARIAL, 14, 209, 23, 0, true);
			label.text = "Tự động bắt đầu khi tổ đội đầy";

			autoStart.visible = false;
			autoStart.setChecked(true);
			autoStart.setLabel(label);
			autoStart.addEventListener(CheckBox.CHANGED, autoStart_changedHandler);
		}

		private function initHandlers():void
		{
			btnInviteFriend.addEventListener(MouseEvent.CLICK, onMouseClickHdl);
			btnBroadcastGlobal.addEventListener(MouseEvent.CLICK, onMouseClickHdl);
			btnInventory.addEventListener(MouseEvent.CLICK, onMouseClickHdl);
			btnBack.addEventListener(MouseEvent.CLICK, onMouseClickHdl);
			btnFormationType.addEventListener(MouseEvent.CLICK, onMouseClickHdl);
			btnFormationType.addEventListener(MouseEvent.ROLL_OVER, onMouseOverHdl);
			btnFormationType.addEventListener(MouseEvent.ROLL_OUT, onMouseOutHdl);
			addEventListener(LobbyFormationSlot.LOBBY_FORMATION_DRAG, onChangeFormationHdl);
		}

		private function broadcastGlobal():void
		{
			var modeData:ModeDataPVEHeroic = ModeDataPVEHeroic(Game.database.userdata.getModeData(GameMode.PVE_HEROIC));
			var campaignData:CampaignData = Game.database.gamedata.getHeroicConfig(modeData.caveID);
			var name:String = campaignData.name;
			var difficulty:String;

			switch (modeData.difficulty)
			{
				case 0:
					difficulty = "Dễ";
					break;
				case 1:
					difficulty = "Thường";
					break;
				case 2:
					difficulty = "Khó";
					break;
			}

			var playersInRoom:int = modeData.getPlayers().length;
			var maxPlayers:int = MAX_CHARACTERS / MAX_CHARACTERS_PER_PLAYER;
			var totalMissions:int = campaignData.missionIDs[modeData.difficulty].length;
			var currentStep:int = modeData.campaignStep + 1;
			var lobbyInfo:LobbyInfo = data as LobbyInfo;

			var nameString:String = "<font color='#ea971b'>[" + name + "]</font>";
			var difficultyStr:String = "<font color='#ea971b'>[" + difficulty + "]</font>";
			var membersStr:String = "<font color='#FFFFFF'>[Thành viên " + playersInRoom + "/" + maxPlayers + "]</font>";
			var joinLink:String = '[<a href="event:inviteHeroic,' + lobbyInfo.id + "," + campaignData.campaignID + '"><font color="#00FF00"><u><b>Tham gia ngay</b></u></font></a>]';
			var missionStr:String = "<font color='#FF0000'>[Ải " + currentStep + "/" + totalMissions + "]</font>: Đang chiêu mộ Đại Hiệp - " + joinLink;

			var message:String = nameString + "-" + difficultyStr + "-" + membersStr + "-" + missionStr;

			var chatModule:ChatModule = Manager.module.getModuleByID(ModuleID.CHAT) as ChatModule;

			if (chatModule)
			{
				chatModule.sendChatGlobal(message);
			}
		}

		private function updateFormationContainerPosition():void
		{
			var timeLine:TimelineLite = new TimelineLite();

			if (!inventoryViewContainer.numChildren)
			{
				Manager.display.showModule(ModuleID.INVENTORY_UNIT, new Point(0, 0));
				if (inventoryModule.baseView)
				{
					InventoryView(inventoryModule.baseView).setMode(InventoryMode.HEROIC_MODE);
					inventoryViewContainer.addChild(inventoryModule.baseView);
				}
				else
				{
					inventoryModule.addEventListener(ViewBase.TRANSITION_IN_COMPLETE, onInventoryViewTransInComplete);
				}
			}
			else
			{
				inventoryViewContainer.getChildAt(0).x = 0;
				inventoryViewContainer.getChildAt(0).y = 0;
			}

			if (!inventoryViewContainer.visible)
			{
				inventoryViewContainer.visible = true;
				inventoryViewContainer.y = -Game.HEIGHT;
				timeLine.insertMultiple([new TweenMax(formationContainer, 0.5, { x: 475 }),
					new TweenMax(inventoryViewContainer, 0.5, { y: 104, onComplete: onUpdateFormationBoundingBox, onCompleteParams: [true] })]);
			}
			else
			{
				inventoryViewContainer.y = 105;
				timeLine.insertMultiple([new TweenMax(formationContainer, 0.5, { x: 320 }),
					new TweenMax(inventoryViewContainer, 0.5, { y: -Game.HEIGHT, onComplete: onUpdateFormationBoundingBox, onCompleteParams: [false] })]);
			}
		}

		private function onUpdateFormationBoundingBox(value:Boolean):void
		{
			for each (var formationSlot:LobbyFormationSlot in formationSlots)
			{
				if (formationSlot)
				{
					formationSlot.updateBoundingBoxPos(new Point(formationContainer.x, formationContainer.y));
				}
			}
			inventoryViewContainer.visible = value;
		}

		private function stopCountDown():void
		{
			TimerEx.stopTimer(autoStartTimerID);
			autoStartTimerID = -1;
			countDownTf.visible = false;
		}

		private function startCountDown():void
		{
			var modeData:ModeDataPVEHeroic = ModeDataPVEHeroic(Game.database.userdata.getModeData(GameMode.PVE_HEROIC));
			timeWait = (modeData.campaignStep > 0) ? 10 : 30;

			TimerEx.stopTimer(autoStartTimerID);
			autoStartTimerID = TimerEx.startTimer(1000, timeWait, updateTimer, finishCountDown);
			countDownTf.visible = true;
		}

		private function updateTimer():void
		{
			countDownTf.text = "Trận đấu sẽ bắt đầu trong: " + Utility.math.formatTime("M-S", --timeWait);
		}

		private function finishCountDown():void
		{
			var modeData:ModeDataPVEHeroic = ModeDataPVEHeroic(Game.database.userdata.getModeData(GameMode.PVE_HEROIC));
			var campaignData:CampaignData = Game.database.gamedata.getHeroicConfig(modeData.caveID);
			var missionIDs:Array = campaignData.missionIDs[modeData.difficulty];

			if (missionIDs && missionIDs[modeData.campaignStep] && isHost)
			{
				modeData.missionID = missionIDs[modeData.campaignStep];
				dispatchEvent(new EventEx(HeroicEvent.EVENT, { type: HeroicEvent.START_GAME, missionID: modeData.missionID }, true));
			}
		}

		protected function slot_onDoubleClicked(event:MouseEvent):void
		{
			var slot:LobbyFormationSlot = event.currentTarget as LobbyFormationSlot;
			var player:LobbyPlayerInfo = slot.getData();
			if (player != null)
			{
				var slotIndex:int = formationSlots.indexOf(slot);
				var modeData:ModeDataPVEHeroic = Game.database.userdata.getModeData(GameMode.PVE_HEROIC) as ModeDataPVEHeroic;
				var playerIndex:int = -1;
				var players:Array = modeData.getPlayers();
				for (var i:int = 0; i < players.length; ++i)
				{
					player = players[i];
					if (player != null && player.id == Game.database.userdata.userID)
					{
						playerIndex = player.index;
						break;
					}
				}
				if (int(modeData.formationIndex[slotIndex] / FormationType.HEROIC.maxCharacter) == playerIndex)
				{
					if (modeData.formationIndex[slotIndex] % FormationType.HEROIC.maxCharacter != 0)
					{
						var formation:Array = Game.database.userdata.getFormation(FormationType.HEROIC);
						formation[modeData.formationIndex[slotIndex] % FormationType.HEROIC.maxCharacter] = -1;
						Game.network.lobby.sendPacket(new RequestSaveFormation(FormationType.HEROIC.ID, formation));
						Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.NOTIFY_JOIN_ROOM_READY));
					}
					else
					{
						Manager.display.showMessage("Đại Hiệp " + Game.database.userdata.playerName + " cần phải tham chiến, không được do dự.");
					}
				}
			}
		}

		private function onShowInventoryView(e:Event):void
		{
			var timeLine:TimelineLite = new TimelineLite();

			if (!inventoryViewContainer.numChildren)
			{
				Manager.display.showModule(ModuleID.INVENTORY_UNIT, new Point(0, 0));
				if (inventoryModule.baseView)
				{
					InventoryView(inventoryModule.baseView).setMode(InventoryMode.HEROIC_MODE);
					inventoryViewContainer.addChild(inventoryModule.baseView);
				}
				else
				{
					inventoryModule.addEventListener(ViewBase.TRANSITION_IN_COMPLETE, onInventoryViewTransInComplete);
				}
			}
			else
			{
				inventoryViewContainer.getChildAt(0).x = 0;
				inventoryViewContainer.getChildAt(0).y = 0;
			}

			if (!inventoryViewContainer.visible)
			{
				inventoryViewContainer.visible = true;
				inventoryViewContainer.y = -Game.HEIGHT;
				timeLine.insertMultiple([new TweenMax(formationContainer, 0.5, { x: 475 }),
					new TweenMax(inventoryViewContainer, 0.5, { y: 104, onComplete: onUpdateFormationBoundingBox, onCompleteParams: [true] })]);
			}

			dispatchEvent(new EventEx(TutorialEvent.EVENT, {type: TutorialEvent.INSERT_CHAR_HEROIC_ROOM}, true));
		}

		private function onChangeFormationHdl(e:EventEx):void
		{
			var objDrag:Object = e.data as Object;
			Game.drag.start(objDrag.target, objDrag);
		}

		private function onMouseClickHdl(e:MouseEvent):void
		{
			switch (e.target)
			{
				case btnBack:
					//Game.database.userdata.getCurrentModeData().backModuleID = ModuleID.HEROIC_MAP;
					Game.flow.doAction(FlowActionEnum.LEAVE_GAME);
					break;

				case btnInviteFriend:
					Manager.display.showModule(ModuleID.INVITE_PLAYER, new Point(0, 0), LayerManager.LAYER_POPUP,
							"top_left", Layer.BLOCK_BLACK, {moduleID: ModuleID.HEROIC_LOBBY});
					break;

				case btnFormationType:
					//formationTypeView.visible = true;
					Manager.display.showModule(ModuleID.FORMATION_TYPE, new Point(), LayerManager.LAYER_POPUP, "top_left", Layer.BLOCK_BLACK);
					break;

				case btnInventory:
					dispatchEvent(new EventEx(TutorialEvent.EVENT, {type: TutorialEvent.CLICK_INVENTORY_BTN_HEROIC_ROOM}, true));
					updateFormationContainerPosition();
					break;

				case btnBroadcastGlobal:
					broadcastGlobal();
					break;
			}
		}

		private function onInventoryViewTransInComplete(e:Event):void
		{
			if (inventoryModule.baseView)
			{
				inventoryModule.removeEventListener(ViewBase.TRANSITION_IN_COMPLETE, onInventoryViewTransInComplete);
				InventoryView(inventoryModule.baseView).setMode(InventoryMode.HEROIC_MODE);
				inventoryViewContainer.addChild(inventoryModule.baseView);
			}
		}

		private function onMouseOverHdl(e:MouseEvent):void
		{
			switch (e.target)
			{
				case btnFormationType:
					dispatchEvent(new EventEx(TooltipEvent.SHOW_TOOLTIP, { type: TooltipID.SIMPLE, value: "Click để xem trận hình đang được kích hoạt" }, true));
					break;
			}
		}

		private function onMouseOutHdl(e:MouseEvent):void
		{
			dispatchEvent(new EventEx(TooltipEvent.HIDE_TOOLTIP, {}, true));
		}

		private function autoStart_changedHandler(event:Event):void
		{
			if (autoStart.isChecked() && isFullRoom)
			{
				startCountDown();
			}
			else
			{
				stopCountDown();
			}

			if (isHost) Game.network.lobby.sendPacket(new BoolRequestPacket(LobbyRequestType.HEROIC_AUTO_START, autoStart.isChecked()));
		}

		//TUTORIAL

		public function showHintButton(content:String):void
		{
			Game.hint.showHint(btnInventory, Direction.DOWN, btnInventory.x + btnInventory.width/2, btnInventory.y, content);
		}

		public function showHintNode():void
		{
			for (var i:int = 0; i < nodes.length; i++)
			{
				var node:HeroicNode = nodes[i];
				if(node.enabled)
				{
					Game.hint.showHint(node, Direction.LEFT, node.x + node.width - 133, node.y + node.height/2 - 53, "Bắt đầu");
					return;
				}
			}
		}

		public function introButton():void
		{
			switch(Game.hint.currTarget)
			{
				case btnInventory:
					Game.hint.showHint(btnInviteFriend, Direction.DOWN, btnInviteFriend.x + btnInviteFriend.width/2, btnInviteFriend.y, "Nhờ hảo hữu giúp đỡ");
					break;
				case btnInviteFriend:
					Game.hint.showHint(btnFormationType, Direction.DOWN, btnFormationType.x + btnFormationType.width/2, btnFormationType.y, "Điều chỉnh trận hình phù hợp với đồng đội");
					break;
				case btnFormationType:
					Game.hint.showHint(btnBroadcastGlobal, Direction.DOWN, btnBroadcastGlobal.x + btnBroadcastGlobal.width/2, btnBroadcastGlobal.y, "Chiêu mộ người chơi khác giúp đỡ ");
					break;
				case btnBroadcastGlobal:
					dispatchEvent(new EventEx(TutorialEvent.EVENT, {type: TutorialEvent.INTRO_BTN_COMPLETE}, true));
					break;
				default :
					Game.hint.showHint(btnInventory, Direction.DOWN, btnInventory.x + btnInventory.width/2, btnInventory.y, "Bổ sung thêm đồng đội");
					break;

			}
		}
	}

}