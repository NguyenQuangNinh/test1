package game.ui.character_enhancement.character_evolution 
{
	import com.greensock.TweenLite;

	import core.display.layer.LayerManager;

	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.utils.Dictionary;
	import flash.utils.setTimeout;
	
	import core.Manager;
	import core.display.BitmapEx;
	import core.display.animation.Animator;
	import core.display.layer.Layer;
	import core.event.EventEx;
	import core.util.FontUtil;
	import core.util.TextFieldUtil;
	import core.util.Utility;
	
	import game.Game;
	import game.data.model.Character;
	import game.data.model.UIData;
	import game.data.model.UserData;
	import game.data.vo.item.ItemInfo;
	import game.data.xml.DataType;
	import game.data.xml.ShopXML;
	import game.data.xml.UnitClassXML;
	import game.data.xml.item.ItemXML;
	import game.enum.ErrorCode;
	import game.enum.FlowActionEnum;
	import game.enum.Font;
	import game.enum.GameConfigID;
	import game.enum.ItemType;
	import game.enum.PaymentType;
	import game.enum.PlayerAttributeID;
	import game.enum.ShopID;
	import game.net.IntRequestPacket;
	import game.net.IntResponsePacket;
	import game.net.RequestPacket;
	import game.net.lobby.LobbyRequestType;
	import game.net.lobby.LobbyResponseType;
	import game.net.lobby.request.RequestCharacterEvolution;
	import game.net.lobby.request.RequestUpClass;
	import game.net.lobby.response.ResponseErrorCode;
	import game.ui.ModuleID;
	import game.ui.character_enhancement.CharacterLevelDetail;
	import game.ui.character_enhancement.TabContent;
	import game.ui.components.CheckBox;
	import game.ui.components.ProgressBar;
	import game.ui.components.RuningNumberTf;
	import game.ui.components.characterslot.CharacterSlotAnimation;
	import game.ui.dialog.DialogID;
	import game.ui.dialog.DialogModule;
	import game.ui.dialog.dialogs.YesNo;
	import game.ui.ingame.DamageText;
	import game.ui.message.MessageID;
	import game.ui.tooltip.TooltipEvent;
	import game.ui.tooltip.TooltipID;
	import game.ui.tutorial.TutorialEvent;
	
	/**
	 * ...
	 * @author MaiPTT
	 */
	public class CharacterEvolution extends TabContent 
	{
		private static const EFFECT_SUCCESS:int = 0;
		private static const EFFECT_FAILED:int = 1;
		
		public var btnEvolution		:SimpleButton;
		public var txtCost			:TextField;
		public var txtQuantity		:TextField;
		public var itemIconContainer:MovieClip;
		public var movCurrency		:MovieClip;
		public var effectMov		:MovieClip;
		public var movAdditionRate	:ProgressBar;
		public var keepLuckBtn:SimpleButton;
		public var txtRequired:TextField;
		public var luckyPointTf:TextField;
		public var quickbuyCheckbox:CheckBox;
		public var txtItemPrice:TextField;
		public var dummyCharacter:MovieClip;
		public var characterContainer:MovieClip;
		public var levelDetail:CharacterLevelDetail;
		
		private var mainCharacter:Character;
		private var cloneCharacter:Character;
		private var _additionValue	:int;
		private var itemIcon:BitmapEx;
		private var characterSlot:CharacterSlotAnimation;
		private var effectAnim:Animator;
		private var itemDescriptionTooltip:String;
		private var _container:MovieClip;
		
		private static const MAX_ACCUMULATE_CONCURRENT:int = 3;
		
		private var runingNumberTf:RuningNumberTf;		
		//private var _effectChange:Animator;
		private var _targetPoint:int;
		
		public function CharacterEvolution() {
			txtRequired.mouseEnabled = false;
			itemIcon = new BitmapEx();
			itemIcon.addEventListener(BitmapEx.LOADED, function():void {
				itemIcon.x = -itemIcon.width / 2;
				itemIcon.y = -itemIcon.height / 2;
			});
			itemIconContainer.addChild(itemIcon);
			itemIconContainer.addEventListener(MouseEvent.MOUSE_OVER, itemIcon_onMouseOver);
			itemIconContainer.addEventListener(MouseEvent.MOUSE_OUT, itemIcon_onMouseOut);
			movAdditionRate.progressTf.visible = false;
			characterSlot = new CharacterSlotAnimation();
			characterSlot.mouseChildren = false;
			characterSlot.doubleClickEnabled = true;
			characterSlot.addEventListener(MouseEvent.DOUBLE_CLICK, characterSlot_onDBClicked);
			characterContainer.addChild(characterSlot);
			effectAnim = new Animator();
			effectAnim.addEventListener(Event.COMPLETE, effectAnimCompleteHDL);
			effectAnim.load("resource/anim/ui/hieuung_thangcap.banim");
			effectAnim.stop();
			characterContainer.addChild(effectAnim);
			
			quickbuyCheckbox.setChecked(false);
			
			itemDescriptionTooltip = "-  Dùng để thăng cấp sao của nhân vật.\n-  Có thể tìm được trong tính năng Dã Tẩu, Mật Đạo , Quà may mắn hoặc mua trong Cửa Hàng.\n-  Đánh vào dấu Tự Mua để tự động mua vật phẩm.";
			
			FontUtil.setFont(txtCost, Font.ARIAL, true);
			FontUtil.setFont(txtQuantity, Font.ARIAL);
			FontUtil.setFont(txtRequired, Font.ARIAL);
			FontUtil.setFont(txtItemPrice, Font.ARIAL);
			
			_container = new MovieClip();
			_container.x = luckyPointTf.x + luckyPointTf.width - 10;
			_container.y = luckyPointTf.y + 25;
			addChild(_container);
			
			//maskMov.visible = false;
			
			runingNumberTf = new RuningNumberTf(luckyPointTf);
			FontUtil.setFont(luckyPointTf, Font.ARIAL, true);
			
			/*_effectChange = new Animator();
			_effectChange.load("resource/anim/ui/hieuung_lucchien.banim");
			_effectChange.setCacheEnabled(false);
			_effectChange.x = movAdditionRate.x + luckyPointTf.width;
			_effectChange.y = movAdditionRate.y + luckyPointTf.height / 2;
			_effectChange.visible = false;
			_effectChange.addEventListener(Event.COMPLETE, onPlayEffectCompletedHdl);
			addChild(_effectChange);*/
			
			initHandlers();
			_additionValue = -1;
			
		}
		
		/*private function onPlayEffectCompletedHdl(e:Event):void
		{
			_effectChange.visible = false;					
		}*/
		
		private function setBattlePoint(oldPoint:int, newPoint:int):void
		{
			runingNumberTf.value = oldPoint;
			_targetPoint = newPoint;
			//_effectChange.visible = true;
			//_effectChange.play(0, 1);
			
			var delta:int = mainCharacter.currentLuckyPoint - runingNumberTf.value;
			Utility.log( "numChildren : " + _container.numChildren );
			if (_container.numChildren > MAX_ACCUMULATE_CONCURRENT) {
				Utility.log("remove children at index 0");
				_container.removeChildAt(0);
			}
			var txt:TextField = TextFieldUtil.createTextfield(Font.ARIAL, 32, 200, 50, 0x66FF00);
			FontUtil.setFont(txt, Font.ARIAL, true);
			var glowFilter:GlowFilter = new GlowFilter(0x660000, 1, 3, 3, 10);
			txt.filters = [glowFilter];
			txt.text = "+" + delta;
			_container.addChild(txt);		
			
			//maskMov.alpha = 0.5;
			//maskMov.visible = true;
			effectMov.alpha = 0.5;
			effectMov.visible = true;
			TweenLite.to(effectMov, 0.5, { alpha: 1, onComplete:removeFilter } );			
			TweenLite.to(runingNumberTf, 0.25, {value: _targetPoint});
			TweenLite.to(txt, 1, { y: txt.y - 50, alpha:0.7, onComplete: onPlayEffectLuckyPointHdl} );
			
		}
		
		private function removeFilter():void 
		{
			effectMov.visible = false;
		}
		
		protected function itemIcon_onMouseOver(event:MouseEvent):void
		{
			dispatchEvent(new EventEx(TooltipEvent.SHOW_TOOLTIP, { type:TooltipID.SIMPLE, value: itemDescriptionTooltip }, true));
		}
		
		protected function itemIcon_onMouseOut(event:MouseEvent):void
		{
			dispatchEvent(new EventEx(TooltipEvent.HIDE_TOOLTIP, null, true));
		}
		
		protected function effectAnimCompleteHDL(event:Event):void
		{
			switch(effectAnim.getCurrentAnimation())
			{
				case EFFECT_SUCCESS:
					//Manager.display.showMessageID(MessageID.UP_STAR_SUCCESS);
					dispatchEvent(new EventEx(TutorialEvent.EVENT, { type:TutorialEvent.EVOLUTION_SUCCESS }, true));
					break;
				case EFFECT_FAILED:
					//Manager.display.showMessageID(MessageID.UP_STAR_FAIL);										
					break;
			}
		}			
		
		protected function characterSlot_onDBClicked(event:MouseEvent):void
		{
			Game.uiData.setMainCharacterID(-1);
		}
		
		override protected function onActivate():void
		{
			Game.uiData.addEventListener(UIData.MAIN_CHARACTER_CHANGED, onMainCharacterChanged);
			Game.database.userdata.addEventListener(UserData.UPDATE_CHARACTER_LIST, onDataUpdateHdl);
			Game.network.lobby.registerPacketHandler(LobbyResponseType.ERROR_CODE, onErrorCode);
			Game.network.lobby.registerPacketHandler(LobbyResponseType.LEVEL_UP_CLASS, onChangeClassResult);
			Game.network.lobby.registerPacketHandler(LobbyResponseType.KEEP_LUCK_RESULT, onKeepLuckResult);
			var itemID:int = Game.database.gamedata.getConfigData(GameConfigID.UP_STAR_ITEM_ID);
			if(itemIcon.bitmapData == null)
			{
				var xmlData:ItemXML = Game.database.gamedata.getData(DataType.ITEM, itemID) as ItemXML;
				if(xmlData != null)	itemIcon.load(xmlData.iconURL);
			}
			update();
			super.onActivate();
		}

		override protected function onDeactivate():void
		{
			Game.uiData.reset();
			Game.uiData.removeEventListener(UIData.MAIN_CHARACTER_CHANGED, onMainCharacterChanged);
			Game.database.userdata.removeEventListener(UserData.UPDATE_CHARACTER_LIST, onDataUpdateHdl);
			Game.network.lobby.unregisterPacketHandler(LobbyResponseType.ERROR_CODE, onErrorCode);
			Game.network.lobby.unregisterPacketHandler(LobbyResponseType.LEVEL_UP_CLASS, onChangeClassResult);
			Game.network.lobby.unregisterPacketHandler(LobbyResponseType.KEEP_LUCK_RESULT, onKeepLuckResult);
			super.onDeactivate();
		}

		private function onDataUpdateHdl(event:Event):void
		{
			var character:Character = Game.database.userdata.getCharacter(Game.uiData.getMainCharacterID());
			if(character != mainCharacter)
			{
				mainCharacter.removeEventListener(Character.XML_ID_CHANGED, onXMLIDChanged);
				mainCharacter.removeEventListener(Character.CURRENT_STAR_CHANGED, onCurrentStarChanged);
				mainCharacter.removeEventListener(Character.LUCKY_POINT_CHANGED, onLuckyPointChanged);

				mainCharacter = character;

				mainCharacter.addEventListener(Character.XML_ID_CHANGED, onXMLIDChanged);
				mainCharacter.addEventListener(Character.CURRENT_STAR_CHANGED, onCurrentStarChanged);
				mainCharacter.addEventListener(Character.LUCKY_POINT_CHANGED, onLuckyPointChanged);
				keepLuckBtn.visible = !mainCharacter.isKeepLuck;
			}
		}

		private function initHandlers():void {
			btnEvolution.addEventListener(MouseEvent.CLICK, btnEvolution_onClicked);
			keepLuckBtn.addEventListener(MouseEvent.CLICK, keepLuckBtn_clickHandler);
			keepLuckBtn.addEventListener(MouseEvent.ROLL_OVER, keepLuckBtn_rollOverHandler);
			keepLuckBtn.addEventListener(MouseEvent.ROLL_OUT, keepLuckBtn_rollOutHandler);
		}
		
		private function onChangeClassResult(packet:IntResponsePacket):void
		{
			Utility.log("character class upgrade, errorCode=" + packet.value);
			switch(packet.value)
			{
				case ErrorCode.SUCCESS:
					Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.GET_CHARACTER_INFO, Game.uiData.getMainCharacterID()));
					break;
			}
		}

		private function onKeepLuckResult(packet:IntResponsePacket):void
		{
			Utility.log("onKeepLuckResult > " + packet.value);
			switch(packet.value)
			{
				case ErrorCode.SUCCESS:
					Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.GET_ITEM_INVENTORY));
					Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.GET_CHARACTERS));
					Manager.display.showMessageID(150);
					break;
				case ErrorCode.FAIL:
					Manager.display.showMessageID(151);
					break;
				case 2: //not enough money
					Game.flow.doAction(FlowActionEnum.PURCHASE_RESOURCE, PaymentType.XU_NORMAL.ID);
					break;
				case 3: //item not exist
					Manager.display.showMessageID(153);
					break;
				case 4: //already activated
					Manager.display.showMessageID(154);
					break;
			}
		}

		private function onErrorCode(packet:ResponseErrorCode):void
		{
			switch(packet.requestType)
			{
				case LobbyRequestType.LEVEL_UP_STAR:
					onEvolutionResult(packet.errorCode);
					break;
			}
		}
		
		private function onEvolutionResult(errorCode:int):void
		{
			Utility.log("character evolution, errorCode=" + errorCode);
			switch(errorCode)
			{
				case ErrorCode.SUCCESS:
					Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.GET_CHARACTER_INFO, Game.uiData.getMainCharacterID()));
					Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.GET_PLAYER_INFO_ATTRIBUTE, PlayerAttributeID.GOLD.ID));
					effectAnim.play(EFFECT_SUCCESS, 1);
					break;
				case ErrorCode.UP_STAR_BAD_LUCK:
					Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.GET_CHARACTER_INFO, Game.uiData.getMainCharacterID()));
					Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.GET_PLAYER_INFO_ATTRIBUTE, PlayerAttributeID.GOLD.ID));
					effectAnim.play(EFFECT_FAILED, 1);
					break;
				case ErrorCode.UP_STAR_NOT_ENOUGH_GOLD:
					Manager.display.showMessageID(MessageID.NOT_ENOUGH_GOLD);
					break;
				case ErrorCode.UP_STAR_NOT_ENOUGH_ITEMS:
					Manager.display.showMessageID(MessageID.UP_STAR_NOT_ENOUGH_ITEMS);
					dispatchEvent(new EventEx(TutorialEvent.EVENT, { type:TutorialEvent.UP_STAR_NOT_ENOUGH_ITEMS }, true));
					break;
				case ErrorCode.UP_STAR_NOT_ENOUGH_XU:
					Manager.display.showMessageID(MessageID.NOT_ENOUGH_XU);
					break;
			}
		}
		
		protected function btnEvolution_onClicked(event:MouseEvent):void
		{
			var character:Character = Game.database.userdata.getCharacter(Game.uiData.getMainCharacterID());
			if(character != null)
			{
				if(character.isEvolvable())
				{
					var quantity:int = getCurrentItemQuantity();
					var required:int = getRequiredItemQuantity();
					var shortage:int = required - quantity;
					if(shortage > 0)
					{
						if(quickbuyCheckbox.isChecked())
						{
							onQuickBuy(null);
						}
						else
						{
							var dialogData:Object = {};
							var item:ItemInfo = new ItemInfo();
							item.type = ItemType.XU;
							item.quantity = getQuickBuyCost();
							dialogData.resourceItem = item;
							item = new ItemInfo();
							item.type = ItemType.BROKEN_SCROLL;
							item.id = Game.database.gamedata.getConfigData(GameConfigID.UP_STAR_ITEM_ID);
							dialogData.item = item;
							Manager.display.showDialog(DialogID.QUICK_BUY_ITEM, onQuickBuy, null, dialogData);
						}
					}
					else
					{
						var packet:RequestCharacterEvolution = new RequestCharacterEvolution();
						packet.characterID = character.ID;
						packet.quickBuy = false;
						Game.network.lobby.sendPacket(packet);
					}
				}
				else
				{
					Manager.display.showMessage("Cao thủ phải hoàn thành 12 tầng công lực mới có thể nâng cấp");
				}
			}
		}
		
		private function onQuickBuy(data:Object):void
		{
			var packet:RequestCharacterEvolution = new RequestCharacterEvolution();
			packet.characterID = mainCharacter.ID;
			packet.quickBuy = true;
			Game.network.lobby.sendPacket(packet);
			Game.network.lobby.getPlayerAttribute(PlayerAttributeID.XU);
			quickbuyCheckbox.setChecked(true);
		}
		
		private function getCurrentItemQuantity():int
		{
			var itemID:int = Game.database.gamedata.getConfigData(GameConfigID.UP_STAR_ITEM_ID);
			return Game.database.inventory.getItemQuantity(ItemType.BROKEN_SCROLL, itemID);
		}
		
		private function getRequiredItemQuantity():int
		{
			var required:int = 0;
			if(mainCharacter != null)
			{
				var config:Array = Game.database.gamedata.getConfigData(GameConfigID.UP_STAR_ITEMS_REQUIREMENT);
				required = config[mainCharacter.currentStar + 1];
			}
			return required; 
		}
		
		private function getQuickBuyCost():int
		{
			var quantity:int = getCurrentItemQuantity();
			var required:int = getRequiredItemQuantity();
			var shortage:int = required - quantity;
			var cost:int = 0;
			if(shortage > 0)
			{
				var shopXML:ShopXML = Game.database.gamedata.getShopItem(ShopID.ITEM, ItemType.BROKEN_SCROLL, Game.database.gamedata.getConfigData(GameConfigID.UP_STAR_ITEM_ID));
				cost = shortage * shopXML.price;
			}
			return cost;
		}
		
		protected function onMainCharacterChanged(event:Event):void
		{
			if(Game.uiData.getMainCharacterID() == -1)
			{
				if(mainCharacter != null)
				{
					mainCharacter.removeEventListener(Character.XML_ID_CHANGED, onXMLIDChanged);
					mainCharacter.removeEventListener(Character.CURRENT_STAR_CHANGED, onCurrentStarChanged);
					mainCharacter.removeEventListener(Character.LUCKY_POINT_CHANGED, onLuckyPointChanged);
					mainCharacter = null;
					cloneCharacter = null;
					keepLuckBtn.visible = true;
				}
			}
			else
			{
				mainCharacter = Game.database.userdata.getCharacter(Game.uiData.getMainCharacterID());
				mainCharacter.addEventListener(Character.XML_ID_CHANGED, onXMLIDChanged);
				mainCharacter.addEventListener(Character.CURRENT_STAR_CHANGED, onCurrentStarChanged);
				mainCharacter.addEventListener(Character.LUCKY_POINT_CHANGED, onLuckyPointChanged);
				cloneCharacter = mainCharacter.clone();
				checkClassPromotion();
				keepLuckBtn.visible = !mainCharacter.isKeepLuck;
			}
			update();
		}
		
		private function update():void
		{
			if(mainCharacter != null)
			{
				Utility.log( "CharacterEvolution.update" );
				dummyCharacter.visible = false;
				characterSlot.visible = true;
				characterSlot.setData(mainCharacter);
				levelDetail.visible = true;
				levelDetail.setData(mainCharacter);
				var costs:Array = Game.database.gamedata.getConfigData(GameConfigID.COST_UP_CLASS);
				var nextStar:int = mainCharacter.currentStar + 1;
				txtCost.text = costs[nextStar]!=null? Utility.formatNumber(costs[nextStar]) : "";
				movAdditionRate.setPercent(mainCharacter.currentLuckyPoint / mainCharacter.maxLuckyPoint);
				luckyPointTf.text = mainCharacter.currentLuckyPoint.toString();
				movCurrency.visible = true;
				movCurrency.x = txtCost.x + ((txtCost.width - txtCost.textWidth) / 2) - movCurrency.width;
				updateItem();
			}
			else
			{
				dummyCharacter.visible = true;
				characterSlot.visible = false;
				levelDetail.visible = false;
				txtCost.text = "";
				movAdditionRate.setPercent(0);
				luckyPointTf.text = "0";
				movCurrency.visible = false;
				txtRequired.text = "";
				txtQuantity.text = "";
				txtItemPrice.text = "";
				effectMov.visible = false;
			}
		}
		
		private function updateItem():void
		{
			var quantity:int = getCurrentItemQuantity();
			var required:int = getRequiredItemQuantity();
			var shortage:int = required - quantity;
			txtRequired.text = "x" + required;
			txtQuantity.text = "Đang có: " + quantity;
			if(shortage > 0)
			{
				var shopXML:ShopXML = Game.database.gamedata.getShopItem(ShopID.ITEM, ItemType.BROKEN_SCROLL, Game.database.gamedata.getConfigData(GameConfigID.UP_STAR_ITEM_ID));
				if(shopXML != null) txtItemPrice.text = "(" + (shopXML.price * shortage) + " vàng)";
				else txtItemPrice.text = "#Error";
			}
			else
			{
				txtItemPrice.text = "";
			}
		}
		
		protected function onLuckyPointChanged(event:Event):void
		{
			if(mainCharacter != null)
			{
				Utility.log( "CharacterEvolution.onLuckyPointChanged > event : " + event );
				movAdditionRate.setPercent(mainCharacter.currentLuckyPoint / mainCharacter.maxLuckyPoint);										
				setBattlePoint(parseInt(luckyPointTf.text), mainCharacter.currentLuckyPoint);
				updateItem();
			}
		}
		
		private function onPlayEffectLuckyPointHdl():void {
			Utility.log("remove children at effect complete");
			if(_container.numChildren)
				_container.removeChildAt(0);
		}
		
		private function checkClassPromotion():Boolean
		{
			var result:Boolean = false;
			if(mainCharacter != null)
			{
				var unitClassXML:UnitClassXML = Game.database.gamedata.getData(DataType.UNITCLASS, mainCharacter.xmlData.characterClass) as UnitClassXML;
				if(unitClassXML != null && mainCharacter.currentStar == unitClassXML.maxStars)
				{
					if(mainCharacter.xmlData.nextIDs.length > 1)
					{
						Utility.log("show class selection dialog");
						(DialogModule)(Manager.module.getModuleByID(ModuleID.DIALOG))
						.showDialog(DialogID.SELECT_CLASS, null, null, mainCharacter, Layer.BLOCK_BLACK);
						result = true;
					}
					else
					{
						if(mainCharacter.xmlData.nextIDs[0] > 0)
						{
							Utility.log("request up class");
							var packet:RequestUpClass = new RequestUpClass();
							packet.slotIndex = mainCharacter.ID;
							packet.nextID = mainCharacter.xmlData.nextIDs[0];
							Game.network.lobby.sendPacket(packet);
							result = true;
						}
					}
				}
			}
			return result;
		}
		
		protected function onCurrentStarChanged(event:Event):void
		{
			update();
			if(checkClassPromotion() == false)
			{
				showUpgradeInfoDialog();
			}
		}
		
		private function showUpgradeInfoDialog():void
		{
			var dialogData:Object = {};
			dialogData.oldCharacter = cloneCharacter;
			dialogData.newCharacter = mainCharacter;
			Manager.display.showDialog(DialogID.UPGRADE_INFO, onCloseUpgradeInfoDialog, null, dialogData);
			dispatchEvent(new EventEx(TutorialEvent.EVENT, { type:TutorialEvent.CLOSE_UP_STAR_DIALOG }, true));
		}
		
		private function onCloseUpgradeInfoDialog(data:Object):void
		{
			update();
			cloneCharacter.cloneInfo(mainCharacter);
		}
		
		protected function onXMLIDChanged(event:Event):void
		{
			Utility.log("show evolution dialog");
			var character:Character = event.target as Character;
			Manager.display.showDialog(DialogID.UP_STAR, onCloseEvolutionDialog, null, character, Layer.BLOCK_BLACK);
			dispatchEvent(new EventEx(TutorialEvent.EVENT, { type:TutorialEvent.CHARACTER_UP_CLASS }, true));
		}
		
		private function onCloseEvolutionDialog(data:Object):void
		{
			showUpgradeInfoDialog();
		}
		
		public function setAdditionRatePercent(value:Number):void {
			movAdditionRate.setPercent(value);
		}
		
		public function setAdditionRateProgress(currentValue:Number, maxValue:Number):void {
			movAdditionRate.setProgress(currentValue, maxValue);
		}

		private function keepLuckBtn_clickHandler(event:MouseEvent):void
		{
			var character:Character = Game.database.userdata.getCharacter(Game.uiData.getMainCharacterID());
			if(character != null)
			{
				var quantity:int = Game.database.inventory.getItemsByType(ItemType.KEEP_LUCK).length;
				var list:Array = Game.database.gamedata.getAllItems(ItemType.KEEP_LUCK);

				if(list.length > 0)
				{
					if(quantity > 0)
					{
						Manager.display.showDialog(DialogID.YES_NO, onAcceptShareHdl, null, {title: "THÔNG BÁO", message: "Bạn có muốn sử dụng vật phẩm " + list[0].name + " để giữ chúc phúc?", charID:character.ID, option: YesNo.YES | YesNo.NO});
					}
					else
					{
						Manager.display.showMessage("Không đủ vật phẩm " + list[0].name);
						setTimeout(Manager.display.showModule, 1200, ModuleID.SHOP_ITEM, new Point(0, 0), LayerManager.LAYER_POPUP, "top_left", Layer.BLOCK_BLACK, ShopID.ITEM.ID);
					}
				}
			}
			else
			{
				Manager.display.showMessage("Chưa chọn nhân vật cần Thăng Cấp");
			}
		}

		private function onAcceptShareHdl(data:Object):void
		{
			Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.CHAR_EVOLUTION_KEEP_LUCK, data.charID));
		}

		private function keepLuckBtn_rollOverHandler(event:MouseEvent):void
		{
			dispatchEvent(new EventEx(TooltipEvent.SHOW_TOOLTIP, { type: TooltipID.SIMPLE,
																	value:"Giữ chúc phúc khi qua ngày"}, true));
		}

		private function keepLuckBtn_rollOutHandler(event:MouseEvent):void
		{
			dispatchEvent(new EventEx(TooltipEvent.HIDE_TOOLTIP, null, true));
		}
	}

}