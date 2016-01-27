package game.ui.inventory 
{
	import components.event.BaseEvent;
	import components.scroll.VerScroll;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;

	import game.enum.Direction;
	import game.enum.PaymentType;
	import game.net.lobby.response.ResponseLockResult;
	import game.ui.dialog.dialogs.ShopHeroesConfirmDialog;
	import game.utility.UtilityUI;
	
	import core.Manager;
	import core.display.ViewBase;
	import core.display.layer.Layer;
	import core.display.layer.LayerManager;
	import core.event.EventEx;
	import core.util.Enum;
	import core.util.FontUtil;
	import core.util.Utility;
	
	import game.Game;
	import game.data.model.Character;
	import game.data.model.UIData;
	import game.data.model.UserData;
	import game.data.model.item.SoulItem;
	import game.data.xml.DataType;
	import game.data.xml.ExtensionItemXML;
	import game.data.xml.UnitClassXML;
	import game.enum.DragDropEvent;
	import game.enum.Element;
	import game.enum.ErrorCode;
	import game.enum.FlowActionEnum;
	import game.enum.Font;
	import game.enum.FormationType;
	import game.enum.GameConfigID;
	import game.enum.InventoryMode;
	import game.enum.ItemType;
	import game.enum.SlotUnlockType;
	import game.enum.UnitType;
	import game.net.IntRequestPacket;
	import game.net.IntResponsePacket;
	import game.net.RequestPacket;
	import game.net.ResponsePacket;
	import game.net.Server;
	import game.net.lobby.LobbyRequestType;
	import game.net.lobby.LobbyResponseType;
	import game.net.lobby.request.RequestSaveFormation;
	import game.net.lobby.response.ResponseErrorCode;
	import game.ui.ModuleID;
	import game.ui.character_enhancement.CharacterEnhancementView;
	import game.ui.components.CharacterSlot;
	import game.ui.components.ScrollBar;
	import game.ui.dialog.DialogID;
	import game.ui.dialog.dialogs.YesNo;
	import game.ui.inventory.filter.Filter;
	import game.ui.inventory.filter.FilterType;
	import game.ui.inventory.filter.Operator;
	import game.ui.message.MessageID;
	import game.ui.tooltip.TooltipEvent;
	import game.ui.tutorial.TutorialEvent;
	import game.utility.ElementUtil;
	
	/**
	 * ...
	 * @author MaiPTT
	 */
	public class InventoryView extends ViewBase 
	{		
		public static const ARR_FILTER_BY_STAR_IN_RANGE	:Array = [ 0, 3, 6, 9, 12, 15];
		public static const NOT_FILTER	:int = 100;
		public static const FILTER_BY_CLASS	:int = 101;
		public static const FILTER_BY_STAR	:int = 102;
		static public const CHARACTER_SLOT_CLICK:String = "InventoryCharacterSlotClick";
		static public const CHARACTER_SLOT_DCLICK:String = "InventoryCharacterSlotDClick";
		private static const DOUBLE_CLICK_ARROW:String = "game.ui.inventory.doubleClickArrow";
		private static const SINGLE_CLICK_ARROW:String = "game.ui.inventory.singleClickArrow";
		
		private static const MAX_SLOTS_PER_ROW		:int = 3;
		private static const MAX_SLOTS_PER_COLUMN	:int = 3;

		public var btnFilterClass		:SimpleButton;
		public var btnFilterStar		:SimpleButton;
		
		public var scrollbar			:MovieClip;
		public var scroller				:VerScroll;
		public var contentMovie			:MovieClip;
		public var maskMovie			:MovieClip;
		
		public var movFilterClass		:MovieClip;
		public var movFilterStar		:MovieClip;
		public var txtClassFilter		:TextField;
		public var txtStarFilter		:TextField;
		public var txtNumSlots			:TextField;

		private var movDbClickArrow		:MovieClip;
		private var movClickArrow		:MovieClip;
		private var _filterClasses		:Array;
		private var _filterClassNames	:Array;
		private var _filterClassMovs	:Array;
		private var _filterStarMovs		:Array;
		private var _characterSlots		:Array;
		private var _currentSelectCharacterID	:int;
		private var currentFilters		:Array;
		private var removingFilters:Array;
		private var greyoutFilters:Array;
		private var _mode				:int;
		private var tutorialArrowPosY	:int;
		private var classFilter:int = -1;
		private var starFilter:int = -1;
		
		public function InventoryView() {
			init();
		}
		
		override public function transitionIn():void
		{
			super.transitionIn();
			
			Game.uiData.addEventListener(UIData.MAIN_CHARACTER_CHANGED, onUIDataChanged);
			Game.uiData.addEventListener(UIData.DATA_CHANGED, onUIDataChanged);
			Game.uiData.addEventListener(UIData.MATERIAL_CHARACTERS_CHANGED, onUIDataChanged);
			Game.network.lobby.addEventListener(Server.SERVER_DATA, onLobbyDataReceived);
			Game.database.userdata.addEventListener(UserData.UPDATE_CHARACTER_LIST, onUpdateCharacterList);
			Game.database.userdata.addEventListener(UserData.INVENTORY_INFO, onUpdateInventoryInfo);
			Game.database.userdata.addEventListener(UserData.UPDATE_CHARACTER_INFO, onUpdateCharacterInfo);
			if (stage) {
				stage.addEventListener(MouseEvent.CLICK, stage_onClicked);	
			}
			setClassFilter(-1);
			setStarFilter(-1);
			
			Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.GET_CHARACTERS));
			
			scroller.reset();
		}
		
		protected function stage_onClicked(event:MouseEvent):void
		{
			movFilterClass.visible = false;
			movFilterStar.visible = false;
		}
		
		override public function transitionOut():void
		{
			Game.uiData.removeEventListener(UIData.MAIN_CHARACTER_CHANGED, onUIDataChanged);
			Game.uiData.removeEventListener(UIData.DATA_CHANGED, onUIDataChanged);
			Game.uiData.removeEventListener(UIData.MATERIAL_CHARACTERS_CHANGED, onUIDataChanged);
			Game.network.lobby.removeEventListener(Server.SERVER_DATA, onLobbyDataReceived);
			Game.database.userdata.removeEventListener(UserData.UPDATE_CHARACTER_LIST, onUpdateCharacterList);
			Game.database.userdata.removeEventListener(UserData.INVENTORY_INFO, onUpdateInventoryInfo);
			Game.database.userdata.removeEventListener(UserData.UPDATE_CHARACTER_INFO, onUpdateCharacterInfo);
			if(stage != null)
			{
				stage.removeEventListener(MouseEvent.CLICK, stage_onClicked);
			}
			movFilterClass.visible = false;
			movFilterStar.visible = false;
			
			for each (var filterItem:FilterItemMov in _filterClassMovs) {
				if (filterItem) {
					filterItem.isSelect = false;
				}
			}
			
			for each (filterItem in _filterStarMovs) {
				if (filterItem) {
					filterItem.isSelect = false;
				}
			}
			super.transitionOut();
		}
		
		protected function onUpdateCharacterInfo(event:EventEx):void
		{
			var updateCharacter:Character = event.data as Character;
			if(updateCharacter != null)
			{
				for each(var slot:CharacterSlot in _characterSlots)
				{
					if(slot != null)
					{
						var character:Character = slot.getData();
						if(character != null && character.ID == updateCharacter.ID)
						{
							slot.setData(updateCharacter);
							break;
						}
					}
				}
			}
		}
		
		protected function onUpdateInventoryInfo(event:Event):void
		{
			updateCharacterList();
		}
		
		protected function onUpdateCharacterList(event:Event):void
		{
			Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.GET_INVENTORY_SLOT_INFO));
		}
		
		protected function onLobbyDataReceived(event:EventEx):void
		{
			var packet:ResponsePacket = event.data as ResponsePacket;
			switch(packet.type)
			{
				case LobbyResponseType.UNLOCK_SLOT:
					onUnlockSlotResult(IntResponsePacket(packet).value);
					break;
				case LobbyResponseType.LOCK_CHAR:
					onLockCharResult(packet as ResponseLockResult);
					break;
				case LobbyResponseType.UNLOCK_CHAR:
					onUnlockCharResult(packet as ResponseLockResult);
					break;
				case LobbyResponseType.EXTEND_RECRUITMENT:
					onExtendRecruitmentResult(IntResponsePacket(packet).value);
					break;
				case LobbyResponseType.ERROR_CODE:
					onErrorCode(packet as ResponseErrorCode);
					break;
			}
		}

		private function onUnlockCharResult(packet:ResponseLockResult):void
		{
			Utility.log("onUnlockCharResult: " + packet.errorCode);
			switch(packet.errorCode)
			{
				case 0://success
					var slot:CharacterSlot = getSlotByIndex(packet.index);
					if(slot)
					{
						slot.isLock = false;
					}
					break;
				case 1: // fail
					Manager.display.showMessageID(140);
					break;
				case 2: // khong ton tai
					Manager.display.showMessageID(145);
					break;
			}
		}

		private function onLockCharResult(packet:ResponseLockResult):void
		{
			Utility.log("onLockCharResult: " + packet.errorCode);
			switch(packet.errorCode)
			{
				case 0://success
					var slot:CharacterSlot = getSlotByIndex(packet.index);
					if(slot)
					{
						slot.isLock = true;
					}
					break;
				case 1: // fail
					Manager.display.showMessageID(140);
					break;
				case 2: // khong ton tai
					Manager.display.showMessageID(145);
					break;
			}
		}

		private function getSlotByIndex(index:int): CharacterSlot
		{
			for each (var characterSlot:CharacterSlot in _characterSlots) {
				if (characterSlot.getData() && characterSlot.getData().ID == index) {
					return characterSlot;
				}
			}
			return null;
		}

		private function onErrorCode(packet:ResponseErrorCode):void
		{
			switch(packet.requestType)
			{
				case LobbyRequestType.REMOVE_CHARACTER:
					onRemoveCharacterResult(packet.errorCode);
					break;
			}
		}
		
		private function onRemoveCharacterResult(errorCode:int):void
		{
			Utility.log("remove character, errorCode=" + errorCode);
			switch(errorCode)
			{
				case ErrorCode.SUCCESS:
					Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.GET_CHARACTERS));
					break;
			}
		}
		
		private function onExtendRecruitmentResult(result:int):void
		{
			Utility.log("extend recruitment result=" + result);
			switch(result)
			{
				case ErrorCode.SUCCESS:
					Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.GET_CHARACTERS));
					break;
				case 6:
					Manager.display.showMessage("Không đủ uy danh");
					break;
			}
		}
		
		private function onUnlockSlotResult(result:int):void
		{
			Utility.log("unlock slot result=" + result);
			switch(result)
			{
				case ErrorCode.SUCCESS:
					CharacterSlot(_characterSlots[_characterSlots.length - 1]).setStatus(CharacterSlot.EMPTY);
					Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.GET_INVENTORY_SLOT_INFO));
					break;
				case ErrorCode.UNLOCK_SLOT_NOT_ENOUGH_GOLD:
					Manager.display.showMessageID(MessageID.NOT_ENOUGH_GOLD);
					break;
			}
		}
		
		protected function onUIDataChanged(event:Event):void
		{
			//Utility.log("receive event change");
			if(_mode != InventoryMode.SOUL_CENTER) updateCharacterList();
		}
		
		private function updateFilters():void
		{
			removingFilters.splice(0);
			if(classFilter > -1)
			{
				removingFilters.push(new Filter(FilterType.CLASS, classFilter, Operator.EQUALS));
			}
			if(starFilter > -1)
			{
				removingFilters.push(new Filter(FilterType.STAR, starFilter * 3, Operator.GREATER));
				removingFilters.push( new Filter(FilterType.STAR, (starFilter + 1) * 3, Operator.LESS_OR_EQUALS));
			}
			
			greyoutFilters.splice(0);
			var mainCharacterID:int = Game.uiData.getMainCharacterID();
			switch(_mode)
			{
				case InventoryMode.LEVEL_UP_EVOLUTION:
				{
					greyoutFilters.push(new Filter(FilterType.UP_STAR, true, Operator.EQUALS));
					if(mainCharacterID > -1) greyoutFilters.push(new Filter(FilterType.CHARACTER_ID, Game.uiData.getMainCharacterID(), Operator.NOT_EQUALS));
					break;
				}
				case InventoryMode.LEVEL_UP_ENHANCEMENT:
				{
					if(mainCharacterID > -1) // occupied
					{
						greyoutFilters.push(new Filter(FilterType.CHARACTER_ID, mainCharacterID, Operator.NOT_EQUALS));
						greyoutFilters.push(new Filter(FilterType.IN_FORMATION, true, Operator.NOT_EQUALS));
						var mainCharacter:Character = Game.database.userdata.getCharacter(mainCharacterID);
						if(mainCharacter != null)
						{
							greyoutFilters.push(new Filter(FilterType.ELEMENT, ElementUtil.overComingElement(mainCharacter.element), Operator.NOT_EQUALS));
						}
						greyoutFilters.push(new Filter(FilterType.LEGENDARY, false, Operator.EQUALS));
					}
					else // empty
					{
						greyoutFilters.push(new Filter(FilterType.MYSTICAL, false, Operator.EQUALS));
					}
					
					var materialCharacterIDs:Array = Game.uiData.getMaterialCharacterIDs();
					for each(var ID:int in materialCharacterIDs)
					{
						if(ID > -1)	greyoutFilters.push(new Filter(FilterType.CHARACTER_ID, ID, Operator.NOT_EQUALS));
					}
					break;
				}
				case InventoryMode.QUEST_TRANSPORT:
					var displayCharacters:Array = Game.database.userdata.characters;
					var filter:Array = Game.database.userdata.questTransportFilterID;					
					
					for each(var character:Character in displayCharacters) {
						if(filter.indexOf(character.ID) == -1 && !character.isInQuestTransport)
							greyoutFilters.push(new Filter(FilterType.CHARACTER_ID, character.ID, Operator.NOT_EQUALS));						
					}	
					
					break;
				case InventoryMode.DIVINE_WEAPON:
					greyoutFilters.push(new Filter(FilterType.MYSTICAL, false, Operator.EQUALS));
					greyoutFilters.push(new Filter(FilterType.LEVEL, 61, Operator.GREATER_OR_EQUALS));
					break;
				case InventoryMode.SOUL_CENTER:
				case InventoryMode.UPGRADE_SKILL_MODE:
				case InventoryMode.CHANGE_FORMATION_MODE:
				case InventoryMode.CHANGE_FORMATION_CHALLENGE:
					greyoutFilters.push(new Filter(FilterType.MYSTICAL, false, Operator.EQUALS));					
					break;
			}
		}
		
		private function init(e:Event = null):void 	{
			_characterSlots = [];
			
			_filterClasses = [];
			_filterClassNames = [];
			_filterClassMovs = [];
			_filterStarMovs = [];
			
			_currentSelectCharacterID = -1;
			
			currentFilters = [];
			removingFilters = [];
			greyoutFilters = [];

			initUI();
			initFilterByStarMovs();
			initFilterByClass();
			initHandlers();
			
			scroller = new VerScroll(maskMovie, contentMovie, scrollbar);
			
			try {
				var classDef:Class = getDefinitionByName(DOUBLE_CLICK_ARROW) as Class;
			} catch (err:Error) {
				return;
			}
			movDbClickArrow = new classDef() as MovieClip;
			
			try {
				classDef = getDefinitionByName(SINGLE_CLICK_ARROW) as Class;
			} catch (err:Error) {
				return;
			}
			movClickArrow = new classDef() as MovieClip;
		}
		
		private function onContentMovChangedPos(e:BaseEvent):void {
			var contentY:Number = e.data as Number;
			movDbClickArrow.y = tutorialArrowPosY + contentY;
			if (movDbClickArrow.y < 106) {
				movDbClickArrow.visible = false;
			} else {
				movDbClickArrow.visible = true;
			}
			
			movClickArrow.y = tutorialArrowPosY + contentY;
			if (movClickArrow.y < 106) {
				movClickArrow.visible = false;
			} else {
				movClickArrow.visible = true;
			}
		}
		
		private function initUI():void {
			FontUtil.setFont(txtStarFilter, Font.ARIAL);
			FontUtil.setFont(txtClassFilter, Font.ARIAL);
			FontUtil.setFont(txtNumSlots, Font.ARIAL, true);
			
			txtClassFilter.mouseEnabled = false;
			txtStarFilter.mouseEnabled = false;
			movFilterClass.visible = false;
			movFilterStar.visible = false;
		}
		
		private function initHandlers():void {
			btnFilterClass.addEventListener(MouseEvent.CLICK, onBtnClickHdl);
			btnFilterStar.addEventListener(MouseEvent.CLICK, onBtnClickHdl);
			addEventListener(CharacterSlot.CHARACTER_SLOT_CLICK, onSlotClickHdl);
			addEventListener(CharacterSlot.CHARACTER_SLOT_DCLICK, onSlotDbClickHdl);
			addEventListener(CharacterSlot.CHARACTER_SLOT_DRAG, onSlotDragHdl);
			addEventListener(CharacterSlot.EVOLUTION, characterSlot_onEvolution);
			addEventListener(CharacterSlot.REMOVE, characterSlot_onRemove);
			addEventListener(CharacterSlot.SHOW_INFO, characterSlot_onShowInfo);
			addEventListener(CharacterSlot.LOCK, characterSlot_onLock);
			addEventListener(CharacterSlot.UNLOCK, characterSlot_onUnLock);
		}

		private function characterSlot_onUnLock(event:Event):void
		{
			var characterSlot:CharacterSlot = event.target as CharacterSlot;
			var character:Character = characterSlot.getData();
			if(character != null)
			{
				Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.INVENTORY_UNLOCK_CHARACTER, character.ID));
			}
		}

		private function characterSlot_onLock(event:Event):void
		{
			var characterSlot:CharacterSlot = event.target as CharacterSlot;
			var character:Character = characterSlot.getData();
			if(character != null)
			{
				Game.network.lobby.sendPacket(new IntRequestPacket( LobbyRequestType.INVENTORY_LOCK_CHARACTER, character.ID));
			}
		}
		
		protected function characterSlot_onShowInfo(event:Event):void
		{
			var characterSlot:CharacterSlot = event.target as CharacterSlot;
			var character:Character = characterSlot.getData();
			if(character != null)
			{
				Manager.display.showModule(ModuleID.CHARACTER_INFO, new Point(342, 82), LayerManager.LAYER_POPUP, "top_left", Layer.BLOCK_BLACK);
				selectSlot(character.ID);
				Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.GET_CHARACTER_INFO, character.ID));
			}
		}
		
		protected function characterSlot_onRemove(event:Event):void
		{
			var characterSlot:CharacterSlot = event.target as CharacterSlot;
			var character:Character = characterSlot.getData();
			if (character != null)
			{
				if(character.hasSoulEquiped)
				{
					Manager.display.showMessage("Không thể xóa nhân vật đang gắn mệnh khí");
				} else if (!character.isRemovable()) {
					if (character.isMainCharacter) {
						Manager.display.showMessage("Không thể xóa nhân vật chính");
					} else if (character.isInMainFormation) {
						Manager.display.showMessage("Không thể xóa nhân vật trong Đội Hình");
					} else if (character.isInChallengeFormation) {
						Manager.display.showMessage("Không thể xóa nhân vật trong Đội Hình Khiêu Chiến");
					} else if (character.isInQuestTransport) {
						Manager.display.showMessage("Không thể xóa nhân vật đang tham gia Đưa Thư");
					} else if (character.isLock) {
						Manager.display.showMessage("Không thể xóa nhân vật đang khóa");
					}
				}
				else if(character.isRemovable())
				{
					var dialogData:Object = {};
					dialogData.message = "Các hạ có muốn xóa cao thủ: " 
										+ "<font color = '" + UtilityUI.getTxtColor(character.rarity, character.isMainCharacter, character.isLegendary()) 
										+ "'>" + character.name + "</font>" + " (" + character.level + " tầng công lực) không?";
					dialogData.character = character;
					dialogData.option = YesNo.YES | YesNo.NO;
					Manager.display.showDialog(DialogID.YES_NO, onConfirmRemoveCharacter, null, dialogData);
				}
			}
		}
		
		private function onConfirmRemoveCharacter(data:Object):void
		{
			var character:Character = data.character as Character;
			if(character != null)
			{
				Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.REMOVE_CHARACTER, character.ID));
			}
		}
		
		protected function characterSlot_onEvolution(event:Event):void
		{
			var characterSlot:CharacterSlot = event.target as CharacterSlot;
			var character:Character = characterSlot.getData();
			if(character != null && character.isEvolvable())
			{
				if(Manager.display.checkVisible(ModuleID.CHARACTER_ENHANCEMENT))
				{
					var view:CharacterEnhancementView = Manager.module.getModuleByID(ModuleID.CHARACTER_ENHANCEMENT).baseView as CharacterEnhancementView;
					if(view != null) view.evolveCharacter(character);
				}
			}
		}
		
		private function onExtendCharacterRecruitment(data:Object):void
		{
			var character:Character = data.character;
			if(character != null)
			{
				Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.EXTEND_RECRUITMENT, character.ID));
			}
		}
		
		private function onUnlockSlots(data:Object):void
		{
			Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.UNLOCK_SLOT, SlotUnlockType.UNIT));
		}
		
		private function onSlotClickHdl(e:EventEx):void {
			var slot:CharacterSlot = e.target as CharacterSlot;
			if(slot.getStatus() == CharacterSlot.LOCKED)
			{
				var defaultNumSlots:int = Game.database.gamedata.getConfigData(GameConfigID.DEFAULT_NUM_CHARACTER_SLOTS);
				var numUnlockedSlots:int = Game.database.userdata.characterMaxSlot - defaultNumSlots;
				var unlockSlotBlocks:Array = Game.database.gamedata.getConfigData(GameConfigID.UNLOCK_SLOT_UNIT_BLOCKS);
				var unlockSlotCosts:Array = Game.database.gamedata.getConfigData(GameConfigID.UNLOCK_SLOT_UNIT_COSTS);
				var nextIndex:int = 0;
				while(numUnlockedSlots > 0)
				{
					numUnlockedSlots -= unlockSlotBlocks[nextIndex];
					++nextIndex;
				}
				dialogData = {};
				dialogData.title = "Xác nhận";
				dialogData.message = "Các hạ có muốn mở " + unlockSlotBlocks[nextIndex] + " vị trí tiếp theo với " + unlockSlotCosts[nextIndex] + " xu không?";
				dialogData.option = YesNo.YES | YesNo.CLOSE;
				Manager.display.showDialog(DialogID.YES_NO, onUnlockSlots, null, dialogData, Layer.BLOCK_BLACK);
			}
			else
			{
				var character:Character = slot.getData();
				if(character != null)
				{
					if(character.isExpired())
					{
						var extensionItemXMLs:Dictionary = Game.database.gamedata.getTable(DataType.EXTENSION_ITEM);
						var price:int = 0;
						for each(var extensionItemXML:ExtensionItemXML in extensionItemXMLs)
						{
							if(extensionItemXML != null && extensionItemXML.itemType == ItemType.UNIT && extensionItemXML.itemID == character.xmlData.ID)
							{
								price = extensionItemXML.price;
								break;
							}
						}
						if(price > 0)
						{
							var dialogData:Object = { };
							var extensionXMLs:Array = Game.database.gamedata.getExtensionByItemID(ItemType.UNIT, character.xmlID);
							var objs:Array = [];
							for each (var extensionXML:ExtensionItemXML in extensionXMLs) {
								if (extensionXML) {
									var obj:Object = new Object();
									obj.ID = extensionXML.ID;
									obj.expirationTime = extensionXML.expirationTime;
									var paymentType:PaymentType = extensionXML.paymentType;
									if (paymentType) {
										obj.itemType = Enum.getEnum(ItemType, paymentType.itemType) as ItemType;
									} else {
										obj.itemType = ItemType.NONE;
									}
									obj.itemID = extensionXML.itemID;
									obj.price = extensionXML.price;
									objs.push(obj);
								}
							}
							dialogData.objs = objs;
							dialogData.characterID = character.xmlID;
							dialogData.processType = ShopHeroesConfirmDialog.EXTEND;
							dialogData.message = "Chọn thời gian để mời đại hiệp về lại";
							Manager.display.showDialog(DialogID.SHOP_HEROES, null, null, dialogData, Layer.BLOCK_BLACK);
						}
					}
					else
					{
						if(slot.isEnabled() == true)
						{
							switch(_mode) 
							{
								/*case InventoryMode.CHANGE_FORMATION_MODE:
									Manager.display.showModule(ModuleID.CHARACTER_INFO, new Point(342, 82), LayerManager.LAYER_POPUP, "top_left", Layer.BLOCK_BLACK);
									if (character) {
										selectSlot(character.ID);
										Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.GET_CHARACTER_INFO, character.ID));
									}
									break;*/
								
								/*case InventoryMode.SOUL_CENTER:
									if (character) {
										selectSlot(character.ID);
										Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.GET_CHARACTER_INFO, character.ID));
									}
									break;*/
							}
							dispatchEvent(new EventEx(TooltipEvent.HIDE_TOOLTIP, null, true));
						}
					}
				}
			}
		}
		
		private function onSlotDbClickHdl(e:EventEx):void {
			var slot:CharacterSlot = e.target as CharacterSlot;
			var character: Character = e.data as Character;
			switch(_mode) {
				case InventoryMode.LEVEL_UP_ENHANCEMENT:
					if (slot.getStatus() == CharacterSlot.OCCUPIED && slot.isEnabled()) {						
						if(Game.uiData.getMainCharacterID() == -1 && character.xmlData.type != UnitType.MASTER)
						{
							Game.uiData.setMainCharacterID(character.ID);
							dispatchEvent(new EventEx(TutorialEvent.EVENT, { type:TutorialEvent.LEVEL_UP_ENHANCEMENT }, true));
						}
						else
						{
							if(character.hasSoulEquiped)
							{
								Manager.display.showMessage("Không thể sử dụng nhân vật đang gắn mệnh khí để truyền công");
							}
							else if (slot.isLock)
							{
								Manager.display.showMessage("Không thể sử dụng nhân vật đang khóa để truyền công");
							}
							else if (character.isInMainFormation == false) {
								Game.uiData.addMaterialCharacterID(character.ID);
								dispatchEvent(new EventEx(TutorialEvent.EVENT, { type:TutorialEvent.ADD_ENHANCEMENT_MATERIAL, slotID:character.ID}, true));
							}
						}
					}
					break;
				
				case InventoryMode.LEVEL_UP_EVOLUTION:
					if (slot.getStatus() == CharacterSlot.OCCUPIED && slot.isEnabled()) {
						Game.uiData.setMainCharacterID(character.ID);
						dispatchEvent(new EventEx(TutorialEvent.EVENT, { type:TutorialEvent.LEVEL_UP_EVOLUTION}, true));
					}
					break;	
				case InventoryMode.CHANGE_FORMATION_MODE:
					if (character) {
						if (!character.isExpired()) {
							Game.flow.doAction(FlowActionEnum.INSERT_TO_FORMATION, {data: character, from: DragDropEvent.FROM_INVENTORY_UNIT, type: DragDropEvent.TYPE_CHANGE_FORMATION});	
						} else {
							Manager.display.showMessage(character.name + " đã chu du. Không chinh chiến được.");
						}
					}
					break;
				case InventoryMode.HEROIC_MODE:
					onHeroicLobbyCharDbClick(character);
					break;
				case InventoryMode.CHANGE_FORMATION_CHALLENGE:
					if (character) {
						if (!character.isExpired()) {
							Game.flow.doAction(FlowActionEnum.INSERT_TO_FORMATION, { data: character, from: DragDropEvent.FROM_INVENTORY_UNIT, type: DragDropEvent.TYPE_CHANGE_FORMATION_CHALLENGE } );
						} else {
							Manager.display.showMessage(character.name + " đã chu du. Không chinh chiến được.");
						}
					}
					break;
				case InventoryMode.UPGRADE_SKILL_MODE:
					if (character) {
						selectSlot(character.ID);
						Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.GET_CHARACTER_INFO, character.ID));
						Game.uiData.setCharacterSkillID(character.ID);
						dispatchEvent(new EventEx(TutorialEvent.EVENT, { type:TutorialEvent.SKILL_UPGRADE_CHAR_SELECTED, slotID:character.ID }, true));	
					}
					break;		
				case InventoryMode.SOUL_CENTER:
					if (character) {
						selectSlot(character.ID);
						Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.GET_CHARACTER_INFO, character.ID));
					}
					break;
				case InventoryMode.DIVINE_WEAPON:
					if (character) {
						selectSlot(character.ID);
						Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.GET_CHARACTER_INFO, character.ID));
					}
					break;
			}

			dispatchEvent(new EventEx(TutorialEvent.EVENT, { type:TutorialEvent.CHAR_INVENTORY_DCLICK, slotID:character.ID}, true));
		}
		
		private function onHeroicLobbyCharDbClick(character:Character):void {
			if(character != null)
			{
				if(character.isInQuestTransport)
				{
					Manager.display.showMessage(character.name + " đã tham gia Đưa Thư. Không chinh chiến được");
					return;
				}
				if(character.xmlData.type == UnitType.MASTER)
				{
					Manager.display.showMessage("Các cao nhân không thể tham chiến");
					return;
				}
				
				var heroicFormation:Array = Game.database.userdata.getFormation(FormationType.HEROIC);
				for(var i:int = 0; i < FormationType.HEROIC.maxCharacter; ++i)
				{
					if(heroicFormation[i] == -1)
					{
						heroicFormation[i] = character.ID;
						Game.network.lobby.sendPacket(new RequestSaveFormation(FormationType.HEROIC.ID, heroicFormation));
						Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.NOTIFY_JOIN_ROOM_READY));
						break;
					}
				}
			}
		}
		
		private function onSlotDragHdl(e:EventEx):void {
			var obj:Object = e.data;
			
			if (!obj) {
				Utility.error("onSlotDragHdl error by NULL info refernce");
				return;
			}
			
			var objDrag:DisplayObject;
			objDrag = obj.target as DisplayObject;
			objDrag.scaleX = objDrag.scaleY = 0.8;	
			
			switch(_mode) {
				case InventoryMode.LEVEL_UP_ENHANCEMENT:					
				case InventoryMode.LEVEL_UP_EVOLUTION:					
					obj.type = DragDropEvent.CHARACTER_LEVEL_UP;
					Game.drag.start(objDrag, obj);
					break;
				case InventoryMode.CHANGE_FORMATION_MODE:					
					obj.type = DragDropEvent.TYPE_CHANGE_FORMATION;
					Game.drag.start(objDrag, obj);
					break;
				case InventoryMode.QUEST_TRANSPORT:					
					obj.type = DragDropEvent.FROM_QUEST_TRANSPORT;
					Game.drag.start(objDrag, obj);
					break;
				case InventoryMode.CHANGE_FORMATION_CHALLENGE:
					obj.type = DragDropEvent.TYPE_CHANGE_FORMATION_CHALLENGE;
					Game.drag.start(objDrag, obj);
					break;
			}
		}
		
		private function initFilterByStarMovs():void {
			var filterItem:FilterItemMov;
			for (var i:int = 0; i < ARR_FILTER_BY_STAR_IN_RANGE.length; i++) {
				filterItem = new FilterItemMov(FILTER_BY_STAR);
				if (i == ARR_FILTER_BY_STAR_IN_RANGE.length - 1) {
					filterItem.filterValue = -1;
				} else {
					filterItem.filterValue = i;	
				}
				filterItem.y = 21 * i;
				filterItem.addEventListener(FilterItemMov.SELECTED, onSelectStarHdl);
				_filterStarMovs.push(filterItem);
				movFilterStar.addChild(filterItem);
			}
		}
		
		private function initFilterByClass():void
		{
			var filterItem:FilterItemMov;
			for (var i:int = 0; i < 7; i++) {
				filterItem = new FilterItemMov(InventoryView.FILTER_BY_CLASS);
				if (i == 6) {
					filterItem.filterValue = -1;
					filterItem.textContent = "Tất cả";
				} else {
					filterItem.filterValue = i;
					filterItem.textContent = Element(Enum.getEnum(Element, i)).elementName;
				}
				filterItem.y = 21 * i;
				filterItem.addEventListener(FilterItemMov.SELECTED, onSelectClassHdl);
				_filterClassMovs.push(filterItem);
				movFilterClass.addChild(filterItem);
			}
		}
		
		private function onSelectStarHdl(e:EventEx):void
		{
			setStarFilter(e.data as int);
			movFilterStar.visible = false;
			updateCharacterList();
			if (!scroller) {
				scroller = new VerScroll(maskMovie, contentMovie, scrollbar);
			} else {
				scroller.updateScroll(contentMovie.height + 20);
			}
		}
		
		private function onSelectClassHdl(e:EventEx):void
		{
			setClassFilter(e.data as int);
			movFilterClass.visible = false;
			updateCharacterList();
			if (!scroller) {
				scroller = new VerScroll(maskMovie, contentMovie, scrollbar);
			} else {
				scroller.updateScroll(contentMovie.height + 20);
			}
		}
		
		private function setClassFilter(value:int):void
		{
			classFilter = value;
			for each(var item:FilterItemMov in _filterClassMovs)
			{
				if(item.filterValue == classFilter)
				{
					item.isSelect = true;
					txtClassFilter.text = item.txtContent.text;
				}
				else
				{
					item.isSelect = false;
				}
			}
		}
		
		private function setStarFilter(value:int):void
		{
			starFilter = value;
			for each(var item:FilterItemMov in _filterStarMovs)
			{
				if(item.filterValue == starFilter)
				{
					item.isSelect = true;
					txtStarFilter.text = item.txtContent.text;
				}
				else
				{
					item.isSelect = false;
				}
			}
		}
		
		private function removeFilter(filters:Array, filterType:int):void
		{
			var filtersCopy:Array = filters.slice();
			var filterIndex:int;
			var filterTotal:int;
			var filter:Filter;
			for(filterIndex = 0, filterTotal = filtersCopy.length; filterIndex < filterTotal; ++filterIndex)
			{
				filter = filtersCopy[filterIndex];
				if(filter != null && filter.type == filterType)
				{
					filters.splice(filters.indexOf(filter), 1);
				}
			}
		}
		
		private function onBtnClickHdl(e:MouseEvent):void {
			switch(e.target) {
				case btnFilterClass:
					movFilterClass.visible = !movFilterClass.visible;
					movFilterStar.visible = false;
					break;
				case btnFilterStar:
					movFilterStar.visible = !movFilterStar.visible;
					movFilterClass.visible = false;
					break;
			}
			e.stopPropagation();
		}
		
		public function levelUpCharactersChanged(character:Character):void {
			switch(_mode) {
				case InventoryMode.LEVEL_UP_ENHANCEMENT:
					if (character) {
						//levelUpFilter(character.element);
					} else {
						//removeFilter(FilterType.CHARACTER_ID);
						//removeFilter(FilterType.LEGENDARY);
						//removeFilter(FilterType.IN_FORMATION);
						//removeFilter(FilterType.RECURSOR);
						
						var filter:Filter = new Filter(FilterType.MYSTICAL, UnitType.MASTER, Operator.NOT_EQUALS);
						currentFilters.push(filter);
						
						filter = new Filter(FilterType.CHARACTER_ID, -1, Operator.NOT_EQUALS);
						currentFilters.push(filter);
						
						filter = new Filter(FilterType.UP_STAR, 0, Operator.EQUALS);
						currentFilters.push(filter);
						
						updateCharacterList();
					}
					break;
					
				case InventoryMode.LEVEL_UP_EVOLUTION:
					//upStarFilter();
					break;
			}
		}
		
		public function selectSlot(characterSlotID:int):void {
			
			_currentSelectCharacterID = characterSlotID;
			var data:Character = null;
			for each (var characterSlot:CharacterSlot in _characterSlots) {
				if (characterSlot.getData() && characterSlot.getData().ID == characterSlotID) {
					characterSlot.isSelected = true;
					data = characterSlot.getData();
				} else {
					characterSlot.isSelected = false;
				}
			}
			
			/*if (!data) {
				characterSlot = _characterSlots[0];
				if (characterSlot) {
					characterSlot.isSelected = true;
					data = characterSlot.getData();	
					_currentSelectCharacterID = data.ID;
					Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.GET_CHARACTER_INFO, _currentSelectCharacterID));
				}
			}*/
			dispatchEvent(new EventEx(InventoryView.CHARACTER_SLOT_CLICK, data, true));
		}
		
		//tutorial
		public function showDbClickTutArrow(slotID:int):void {
			if (movDbClickArrow.parent) {
				movDbClickArrow.parent.removeChild(movDbClickArrow);
			}
			
			if (slotID == -1) {
				if (scrollbar.hasEventListener(VerScroll.VERSCROLL_CHANGE_POS)) {
					scrollbar.removeEventListener(VerScroll.VERSCROLL_CHANGE_POS, onContentMovChangedPos);
				}
			} else {
				if (!scrollbar.hasEventListener(VerScroll.VERSCROLL_CHANGE_POS)) {
					scrollbar.addEventListener(VerScroll.VERSCROLL_CHANGE_POS, onContentMovChangedPos);
				}
			}
			var container:Sprite = Manager.display.getContainer();
			var slot:CharacterSlot;
			for (var i:int = 0; i < _characterSlots.length; i++ ) {
				slot = _characterSlots[i];
				if (slot && (i == slotID)) {
					movDbClickArrow.x = slot.x + slot.width;
					if (stage) {
						tutorialArrowPosY = slot.y + slot.height / 2 + 106;
						movDbClickArrow.x = movDbClickArrow.x + 80;
						movDbClickArrow.y = tutorialArrowPosY;
						container.addChild(movDbClickArrow);
					} else {
						movDbClickArrow.y = tutorialArrowPosY;
						addChild(movDbClickArrow);	
					}
					return;
				}
			}
		}

		public function showDbClickTutArrowAt(index:int):void {
			if (movDbClickArrow.parent) {
				movDbClickArrow.parent.removeChild(movDbClickArrow);
			}

			if (index == -1) {
				if (scrollbar.hasEventListener(VerScroll.VERSCROLL_CHANGE_POS)) {
					scrollbar.removeEventListener(VerScroll.VERSCROLL_CHANGE_POS, onContentMovChangedPos);
				}
			} else {
				if (!scrollbar.hasEventListener(VerScroll.VERSCROLL_CHANGE_POS)) {
					scrollbar.addEventListener(VerScroll.VERSCROLL_CHANGE_POS, onContentMovChangedPos);
				}
			}
			var container:Sprite = Manager.display.getContainer();
			var slot:CharacterSlot =  _characterSlots[index];
			if (slot) {
				movDbClickArrow.x = slot.x + slot.width;
				if (stage) {
					tutorialArrowPosY = slot.y + slot.height / 2 + 106;
					movDbClickArrow.x = movDbClickArrow.x + 80;
					movDbClickArrow.y = tutorialArrowPosY;
					container.addChild(movDbClickArrow);
				} else {
					movDbClickArrow.y = tutorialArrowPosY;
					addChild(movDbClickArrow);
				}
				return;
			}
		}
		
		public function showSingleClickTutArrow(slotID:int):void {
			if (movClickArrow.parent) {
				movClickArrow.parent.removeChild(movClickArrow);
			}
			
			if (slotID == -1) {
				if (scrollbar.hasEventListener(ScrollBar.CONTENT_MOV_CHANGE_POS)) {
					scrollbar.removeEventListener(ScrollBar.CONTENT_MOV_CHANGE_POS, onContentMovChangedPos);
				}
			} else {
				if (!scrollbar.hasEventListener(ScrollBar.CONTENT_MOV_CHANGE_POS)) {
					scrollbar.addEventListener(ScrollBar.CONTENT_MOV_CHANGE_POS, onContentMovChangedPos);
				}
			}
			
			var slot:CharacterSlot;
			for (var i:int = 0; i < _characterSlots.length; i++ ) {
				slot = _characterSlots[i];
				if (slot && (i == slotID)) {
					movClickArrow.x = slot.x + slot.width;
					movClickArrow.y = tutorialArrowPosY;
					if (stage) {
						tutorialArrowPosY = slot.y + slot.height / 2 + 106;
						movClickArrow.x = movClickArrow.x + 80;
						movClickArrow.y = tutorialArrowPosY;
						stage.addChild(movClickArrow);	
					} else {
						addChild(movClickArrow);
					}
					return;
				}
			}
		}

		private function sortLevelUpEnhancement(input:Array):Array
		{
			var output:Array = [];
			var mainCharacterID:int = Game.uiData.getMainCharacterID();
			var mainCharacter:Character = Game.database.userdata.getCharacter(mainCharacterID);
			var i:int = 0;
			var character:Character;
			if(mainCharacter)
			{
				for (i = 0; i < input.length; i++)
				{
					character = input[i] as Character;
					if(character.isMystical() && character.element == ElementUtil.generatingElement(mainCharacter.element)) // Cao nhan tuong sinh
					{
						output.push(character);
					}
				}

				for (i = 0; i < input.length; i++)
				{
					character = input[i] as Character;
					if(character.isCommon() && !character.isInMainFormation && character.element == ElementUtil.generatingElement(mainCharacter.element)) // de tu tuong sinh
					{
						output.push(character);
					}
				}

				for (i = 0; i < input.length; i++)
				{
					character = input[i] as Character;

					if(character.isMystical() &&
							output.indexOf(character) == -1 &&
							character.element != ElementUtil.overComingElement(mainCharacter.element)) // Cao nhan khong tuong sinh va khong tuong khac
					{
						output.push(character);
					}
				}

				for (i = 0; i < input.length; i++)
				{
					character = input[i] as Character;

					if(character.isCommon() &&
							!character.isInMainFormation &&
							output.indexOf(character) == -1 &&
							character.element != ElementUtil.overComingElement(mainCharacter.element)) // De tu khong tuong sinh va khong tuong khac
					{
						output.push(character);
					}
				}

				for (i = 0; i < input.length; i++)
				{
					character = input[i] as Character;

					if(character.isMystical() &&
							output.indexOf(character) == -1) // Cao nhan tuong khac
					{
						output.push(character);
					}
				}

				for (i = 0; i < input.length; i++)
				{
					character = input[i] as Character;

					if(	output.indexOf(character) == -1) // Nhung nhan vat con lai
					{
						output.push(character);
					}
				}
			}
			else
			{
				output = input;
			}

			return output;
		}

		public function updateCharacterList():void
		{
			clearCharacterList();
			updateFilters();
			var displayCharacters:Array = filterCharacters(Game.database.userdata.characters, removingFilters);
			var normalCharacters:Array = filterCharacters(displayCharacters, greyoutFilters);
			var characterIndex:int;
			var characterTotal:int;
			var character:Character;
			var characterSlot:CharacterSlot;
			var index:int = -1;
			
			var showedCharacters:Array = displayCharacters;
			switch (_mode)
			{
				case InventoryMode.QUEST_TRANSPORT:
					showedCharacters = normalCharacters;
					characterTotal = normalCharacters.length + Game.database.userdata.getNumFreeSlots();
					break;
				case InventoryMode.LEVEL_UP_ENHANCEMENT:
					showedCharacters = sortLevelUpEnhancement(displayCharacters);
					characterTotal = showedCharacters.length + Game.database.userdata.getNumFreeSlots();
					break;
				default:
					showedCharacters = displayCharacters;
					characterTotal = displayCharacters.length + Game.database.userdata.getNumFreeSlots();
			}
			//showedCharacters = displayCharacters;
			//characterTotal = displayCharacters.length + Game.database.userdata.getNumFreeSlots();
			for (characterIndex = 0; characterIndex < characterTotal; ++characterIndex)
			{
				characterSlot = Manager.pool.pop(CharacterSlot) as CharacterSlot;
				characterSlot.reset();
				characterSlot.x = (characterIndex % MAX_SLOTS_PER_ROW) * 120;
				characterSlot.y = (Math.floor(characterIndex / MAX_SLOTS_PER_ROW)) * 130;
				contentMovie.addChild(characterSlot);
				
				if(characterIndex < showedCharacters.length)
				{
					characterSlot.setStatus(CharacterSlot.OCCUPIED);
				}
				else
				{
					characterSlot.setStatus(CharacterSlot.EMPTY);
				}
				
				character = showedCharacters[characterIndex];
				characterSlot.setData(character);
				
				if(character != null)
				{
					index = normalCharacters.indexOf(character);
					characterSlot.setEnabled(index > -1);
				}
				else
				{
					characterSlot.setEnabled(true);
				}
				_characterSlots.push(characterSlot);
			}
			var defaultNumSlots:int = Game.database.gamedata.getConfigData(GameConfigID.DEFAULT_NUM_CHARACTER_SLOTS);
			var slotUnlockBlocks:Array = Game.database.gamedata.getConfigData(GameConfigID.UNLOCK_SLOT_UNIT_BLOCKS);
			if(Game.database.userdata.characterMaxSlot < defaultNumSlots + slotUnlockBlocks.length)
			{
				characterSlot = Manager.pool.pop(CharacterSlot) as CharacterSlot;
				characterSlot.reset();
				characterSlot.x = (characterIndex % MAX_SLOTS_PER_ROW) * 120;
				characterSlot.y = (Math.floor(characterIndex / MAX_SLOTS_PER_ROW)) * 130;
				characterSlot.setStatus(CharacterSlot.LOCKED);
				characterSlot.setData(null);
				characterSlot.setEnabled(true);
				contentMovie.addChild(characterSlot);
				_characterSlots.push(characterSlot);
			}
			
			scroller.updateScroll();
			selectSlot(_currentSelectCharacterID);
			
			txtNumSlots.text = Game.database.userdata.characters.length + "/" + Game.database.userdata.characterMaxSlot;
			dispatchEvent(new EventEx(TutorialEvent.EVENT, {type: TutorialEvent.CHAR_LIST_INVENTORY_UPDATED}, true));
		}
		
		private function filterCharacters(inputCharacters:Array, filters:Array):Array
		{
			var outputCharacters:Array = [];
			var passed:Boolean;
			for each(var character:Character in inputCharacters)
			{
				passed = true;
				for each(var filter:Filter in filters)
				{
					if(filter != null)
					{
						switch(filter.type)
						{
							case FilterType.LEVEL:
								passed = filter.evaluate(character.level);
								break;
							case FilterType.CLASS:
								var unitClassXML:UnitClassXML = Game.database.gamedata.getData(DataType.UNITCLASS, character.xmlData.characterClass) as UnitClassXML;
								passed = filter.evaluate(unitClassXML.element);
								break;
							case FilterType.STAR:
								passed = filter.evaluate(character.maxStar);
								break;
							case FilterType.LEGENDARY:
								passed = filter.evaluate(character.isLegendary());
								break;
							case FilterType.IN_FORMATION:
								passed = filter.evaluate(character.isInMainFormation);
								if(passed) passed = filter.evaluate(character.isInQuestTransport);
								break;
							case FilterType.CHARACTER_ID:
								passed = filter.evaluate(character.ID);
								break;
							case FilterType.ELEMENT:
								passed = filter.evaluate(character.element);
								break;
							case FilterType.UP_STAR:
								passed = filter.evaluate(character.isEvolvable());
								break;
							case FilterType.MYSTICAL:
								passed = filter.evaluate(character.isMystical());
								break;
						}
					}
					if (passed == false) break;
				}
				if(passed) outputCharacters.push(character);
			}
			return outputCharacters;
		}
		
		/*private function upStarFilter():void {
			//removeFilter(FilterType.CHARACTER_ID);
			
			var filter:Filter = new Filter(FilterType.CHARACTER_ID, model.getEvolutionID(), Operator.NOT_EQUALS);
			currentFilters.push(filter);
			
			updateCharacterList();
		}*/
		
		/*private function levelUpFilter(element:int):void {
			//removeFilter(FilterType.CHARACTER_ID);
			//removeFilter(FilterType.IN_FORMATION);
			//removeFilter(FilterType.LEGENDARY);
			//removeFilter(FilterType.RECURSOR);
			
			var filter:Filter = new Filter(FilterType.CHARACTER_ID, model.getEnhancementInputID(), Operator.NOT_EQUALS);
			currentFilters.push(filter);
			
			for each (var id:int in model.getEnhancementMaterialIDs()) {
				if (id != -1) {
					filter = new Filter(FilterType.CHARACTER_ID, id, Operator.NOT_EQUALS);
					currentFilters.push(filter);
				}
			}
			
			filter = new Filter(FilterType.IN_FORMATION, 0, Operator.EQUALS);
			currentFilters.push(filter);
			
			filter = new Filter(FilterType.LEGENDARY, UnitType.LEGENDARY, Operator.NOT_EQUALS);
			currentFilters.push(filter);
			
			if (element != -1) {
				//removeFilter(FilterType.ELEMENT);
				filter = new Filter(FilterType.ELEMENT, element, Operator.GENERATING);
				currentFilters.push(filter);
			}
			
			updateCharacterList();
		}*/
		
		private function clearCharacterList():void
		{
			var i:int;
			var length:int;
			var characterSlot:CharacterSlot;
			for(i = 0, length = _characterSlots.length; i < length; ++i)
			{
				characterSlot = _characterSlots[i];
				if(characterSlot != null)
				{
					contentMovie.removeChild(characterSlot);
					characterSlot.reset();
					Manager.pool.push(characterSlot, CharacterSlot);
				}
			}
			_characterSlots.splice(0);
		}
		
		public function getCurrentCharacterSelected():int {
			return _currentSelectCharacterID;			
		}
		
		public function setMode(mode:int):void { 
			_mode = mode;
			updateCharacterList();
		}
		
		public function resetFilter():void {
			currentFilters = [];
			removingFilters = [];
			setClassFilter( -1);
			setStarFilter( -1);
			updateCharacterList();
			scroller.updateScroll();
		}

		//TUTORIAL
		public function showHintSlotByIndex(index:int):void
		{
			var slot:CharacterSlot = _characterSlots[index] as CharacterSlot;
			if(slot && !slot.isEmpty())
				Game.hint.showHint(slot, Direction.LEFT, slot.x + slot.width, slot.y + slot.height/2, "Click đúp để chọn");
		}

		public function showHintSlot():void
		{
			for (var i:int = 0; i < _characterSlots.length; i++)
			{
				var slot:CharacterSlot = _characterSlots[i];
				if(slot && !slot.isEmpty() && !slot.isInQuestTransport())
				{
					Game.hint.showHint(slot, Direction.LEFT, slot.x + slot.width, slot.y + slot.height/2, "Click đúp để chọn");
					return;
				}
			}

			Game.hint.hideHint();
		}

		private function getNotEmptySlot():CharacterSlot
		{
			for (var i:int = 0; i < _characterSlots.length; i++)
			{
				var slot:CharacterSlot = _characterSlots[i] as CharacterSlot;
				if(!slot.isEmpty())
				{
					return slot;
				}
			}

			return null;
		}

		public function get characterSlots():Array
		{
			return _characterSlots;
		}
	}

}