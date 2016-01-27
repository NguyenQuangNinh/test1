package game.ui.shop 
{
	import com.greensock.easing.Back;
	import com.greensock.TweenMax;
	import core.display.layer.Layer;
	import core.event.EventEx;
	import core.Manager;
	import core.util.Enum;
	import core.util.FontUtil;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.Dictionary;
	import game.data.model.Character;
	import game.data.model.item.ItemFactory;
	import game.data.model.shop.ShopItem;
	import game.data.xml.ExtensionItemXML;
	import game.data.xml.ShopXML;
	import game.enum.CharacterRarity;
	import game.enum.Font;
	import game.enum.ItemType;
	import game.enum.PaymentType;
	import game.Game;
	import game.ui.components.ItemSlot;
	import game.ui.dialog.DialogID;
	import game.ui.dialog.dialogs.ShopHeroesConfirmDialog;
	import game.ui.dialog.dialogs.YesNo;
	import game.utility.UtilityUI;
	
	/**
	 * ...
	 * @author MaiPTT
	 */
	public class ShopHeroes extends MovieClip 
	{	
		public static const LEGENDARY	:int = 0;
		
		private static const MAX_CHARACTERS_PER_PAGE	:int = 5;
		
		public var itemsContainer	:MovieClip;
		public var btnFight			:MovieClip;
		public var btnInvite		:MovieClip;
		public var btnExtend		:MovieClip;
		public var txtPrice			:TextField;
		public var movPaymentType	:MovieClip;
		public var movMask			:MovieClip;
		public var btnNext			:SimpleButton;
		public var btnPrev			:SimpleButton;
		public var movInfo			:ShopHeroesInfo;
		public var btnHero			:MovieClip;
		public var btnBlueChar		:MovieClip;
		public var btnRedChar		:MovieClip;
		public var btnPurpleChar	:MovieClip;
		public var txtDescription	:TextField;
		
		private var _shopItems		:Array;
		private var items			:Array;
		private var maxPages		:int;
		private var currentPage		:int;
		private var currentCharacterID	:int;
		private var currentTab			:int;
		private var mapping				:Dictionary;
		private var glowFilter			:GlowFilter;
		private var mappingKeys			:Array;
		
		public function ShopHeroes() {
			_shopItems = [];
			initUI();
			initHandlers();
			
			currentCharacterID = -1;
		}
		
		private function initHandlers():void {
			btnNext.addEventListener(MouseEvent.CLICK, onBtnClickHdl);
			btnPrev.addEventListener(MouseEvent.CLICK, onBtnClickHdl);
			btnFight.addEventListener(MouseEvent.CLICK, onBtnClickHdl);
			btnInvite.addEventListener(MouseEvent.CLICK, onBtnClickHdl);
			btnExtend.addEventListener(MouseEvent.CLICK, onBtnClickHdl);
			btnHero.addEventListener(MouseEvent.CLICK, onBtnClickHdl);
			btnBlueChar.addEventListener(MouseEvent.CLICK, onBtnClickHdl);
			btnRedChar.addEventListener(MouseEvent.CLICK, onBtnClickHdl);
			btnPurpleChar.addEventListener(MouseEvent.CLICK, onBtnClickHdl);
		}
		
		private function initUI():void {
			btnFight.buttonMode = true;
			btnInvite.buttonMode = true;
			btnExtend.buttonMode = true;
			itemsContainer.mask = movMask;
			btnFight.visible = false;
			btnInvite.visible = false;
			btnExtend.visible = false;
			
			btnHero.buttonMode = true;
			btnBlueChar.buttonMode = true;
			btnRedChar.buttonMode = true;
			btnPurpleChar.buttonMode = true;
			
			FontUtil.setFont(txtPrice, Font.ARIAL, true);
			FontUtil.setFont(txtDescription, Font.ARIAL);
			txtDescription.autoSize = TextFieldAutoSize.CENTER;
			
			mapping = new Dictionary();
			mapping[LEGENDARY] = btnHero;
			mapping[CharacterRarity.BLUE.ID] = btnBlueChar;
			mapping[CharacterRarity.RED.ID] = btnRedChar;
			mapping[CharacterRarity.PURPLE.ID] = btnPurpleChar;
			
			mappingKeys = [LEGENDARY, CharacterRarity.BLUE.ID
						, CharacterRarity.RED.ID, CharacterRarity.PURPLE.ID];
			glowFilter = new GlowFilter(0xfff600, 0.74, 17, 17, 2, BitmapFilterQuality.MEDIUM);
			
			var itemSlot:ItemSlot = new ItemSlot();
			itemSlot.setConfigInfo(ItemFactory.buildItemConfig(ItemType.HONOR, -1), "", false);
			itemSlot.setScaleItemSlot(0.5);
			movPaymentType.addChild(itemSlot);
		}
		
		private function setTabSelected(value:int):void {
			if (currentTab != value) {
				if (mapping[currentTab] as MovieClip) {
					MovieClip(mapping[currentTab]).filters = [];
				}
				
				currentTab = value;
				if (mapping[value] as MovieClip) {
					MovieClip(mapping[currentTab]).filters = [glowFilter];
					switch(value) {
						case CharacterRarity.BLUE.ID:
						case CharacterRarity.RED.ID:
						case CharacterRarity.PURPLE.ID:
							txtDescription.text = "Dùng Uy Danh để chiêu mộ.\n"
												+ "Đồng hành vĩnh viễn cùng Đại Hiệp";
							break;
							
						case LEGENDARY:
							txtDescription.text = "Tỷ thí thành công có thể dùng Uy Danh để chiêu mộ Đại Hiệp.\n"
												+ "Đồng hành với Đại Hiệp trong: 7 ngày.";
							break;
					}
				}
				
				updateShopItems();
			}
		}
		
		private function onBtnClickHdl(e:MouseEvent):void {
			switch(e.target) {
				case btnNext:
					if (currentPage < maxPages) {
						setCurrentPage(currentPage + 1);
					} 
					break;
					
				case btnPrev:
					if (currentPage > 0) {
						setCurrentPage(currentPage - 1);
					}
					break;
					
				case btnFight:
					processFight();
					break;
					
				case btnInvite:
					processInvite();
					break;
					
				case btnExtend:
					processExtend();
					break;
					
				case btnHero:
					setTabSelected(LEGENDARY);
					break;
					
				case btnBlueChar:
					setTabSelected(CharacterRarity.BLUE.ID);
					break;
					
				case btnRedChar:
					setTabSelected(CharacterRarity.RED.ID);
					break;
					
				case btnPurpleChar:
					setTabSelected(CharacterRarity.PURPLE.ID);
					break;
			}
		}
		
		private function processExtend():void {
			for each (var shopHeroesItem:ShopHeroesItem in _shopItems) {
				if (shopHeroesItem && shopHeroesItem.isSelected) {
					var dialogData:Object = { };
					var extensionXMLs:Array = Game.database.gamedata.getExtensionByItemID(shopHeroesItem.shopItemData.shopXML.type, shopHeroesItem.shopItemData.shopXML.itemID);
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
					dialogData.characterID = shopHeroesItem.shopItemData.shopXML.itemID;
					dialogData.message = "Chọn thời gian để mời đại hiệp về lại";
					dialogData.processType = ShopHeroesConfirmDialog.EXTEND;
					Manager.display.showDialog(DialogID.SHOP_HEROES, null, null, dialogData, Layer.BLOCK_BLACK);
					break;
				}
			}
		}
		
		private function onExtendCharacterRecruitment(data:Object):void {
			dispatchEvent(new EventEx(ShopEvent.SHOP_EVENT, { type:ShopEvent.EXTEND,
																	  characterID: data.characterID}, true ));
		}
		
		private function processInvite():void {
			for each (var shopHeroesItem:ShopHeroesItem in _shopItems) {
				if (shopHeroesItem && shopHeroesItem.isSelected) {
					var dialogData:Object = { };
					var shopXMLs:Array = Game.database.gamedata.getShopItemsByItemID(shopHeroesItem.shopItemData.shopXML.type, shopHeroesItem.shopItemData.shopXML.itemID);
					var objs:Array = [];
					for each (var shopXML:ShopXML in shopXMLs) {
						if (shopXML) {
							var obj:Object = new Object();
							obj.ID = shopXML.ID;	
							obj.expirationTime = shopXML.expirationTime;
							var paymentType:PaymentType = shopXML.paymentType;
							if (paymentType) {
								obj.itemType = Enum.getEnum(ItemType, paymentType.itemType) as ItemType;
							} else {
								obj.itemType = ItemType.NONE;
							}
							obj.itemID = shopXML.itemID;
							obj.price = shopXML.price;
							objs.push(obj);
						}
					}
					dialogData.objs = objs;
					dialogData.message = "Chọn thời gian để chiêu mộ đại hiệp";
					dialogData.processType = ShopHeroesConfirmDialog.BUY;
					Manager.display.showDialog(DialogID.SHOP_HEROES, null, null, dialogData, Layer.BLOCK_BLACK);
					break;
				}
			}
		}
		
		private function processFight():void {
			for each (var shopHeroesItem:ShopHeroesItem in _shopItems) {
				if (shopHeroesItem && shopHeroesItem.isSelected) {
					dispatchEvent(new EventEx(ShopEvent.SHOP_EVENT, { type:ShopEvent.ENTER_MISSION,
																	  missionID:shopHeroesItem.shopItemData.missionID }, true ));
				}
			}
		}
		
		private function setCurrentPage(value:int):void {
			var delta:int = value - currentPage;
			currentPage = value;
			TweenMax.to(itemsContainer, 0.5, { x:(itemsContainer.x - delta * movMask.width), ease:Back.easeOut} );
			if (value == maxPages) {
				UtilityUI.enableDisplayObj(false, btnNext, MouseEvent.CLICK, onBtnClickHdl);
				UtilityUI.enableDisplayObj(true, btnPrev, MouseEvent.CLICK, onBtnClickHdl);
			} 
			if (value == 0) {
				UtilityUI.enableDisplayObj(true, btnNext, MouseEvent.CLICK, onBtnClickHdl);
				UtilityUI.enableDisplayObj(false, btnPrev, MouseEvent.CLICK, onBtnClickHdl);
			}
		}
		
		private function setBtnEnable(btn:MovieClip, value:Boolean, levelRequired:int):void {
			btn.isEnable = value;
			if (value) {
				btn.gotoAndStop(1);
				btn.txtLevel.text = "";
				btn.buttonMode = true;
				if (!btn.hasEventListener(MouseEvent.CLICK)) {
					btn.addEventListener(MouseEvent.CLICK, onBtnClickHdl);
				}
			} else {
				btn.gotoAndStop(2);
				btn.txtLevel.text = "Cấp " + levelRequired;
				btn.buttonMode = false;
				if (btn.hasEventListener(MouseEvent.CLICK)) {
					btn.removeEventListener(MouseEvent.CLICK, onBtnClickHdl);
				}
			}
			
			FontUtil.setFont(btn.txtLevel, Font.ARIAL);
		}
		
		public function get shopItems():Array {
			return _shopItems;
		}
		
		public function set selectedItemID(id:int):void {
			currentCharacterID = id;
			for each (var shopHeroesItem:ShopHeroesItem in _shopItems) {
				if (shopHeroesItem) {
					if (shopHeroesItem.characterID == id) {
						shopHeroesItem.isSelected = true;
						if (shopHeroesItem.shopItemData) {
							btnInvite.visible = false;
							btnFight.visible = false;
							btnExtend.visible = false;
							txtPrice.visible = false;
							movPaymentType.visible = false;
							switch(shopHeroesItem.shopItemData.status) {
								case ShopItem.BUYABLE:
									btnInvite.visible = true;
									//txtPrice.visible = true;
									//movPaymentType.visible = true;
									txtPrice.text = shopHeroesItem.shopItemData.shopXML.price.toString();
									movPaymentType.x = txtPrice.x + (txtPrice.width - txtPrice.textWidth) / 2 + txtPrice.textWidth;
									break;
									
								case ShopItem.ALREADY_BOUGHT:
									if (shopHeroesItem.isExpired()) {
										btnExtend.visible = true;
										//txtPrice.visible = true;
										//movPaymentType.visible = true;
										txtPrice.text = shopHeroesItem.shopItemData.getExtendPrice().toString();
										movPaymentType.x = txtPrice.x + (txtPrice.width - txtPrice.textWidth) / 2 + txtPrice.textWidth;
									}
									break;
									
								case ShopItem.LOCKED:
									break;
									
								case ShopItem.NOT_BUYABLE:
									btnFight.visible = true;
									break;
							}
						}
						
					} else {
						shopHeroesItem.isSelected = false;
					}
				}
			}
		}
		
		public function update():void {
			selectedItemID = currentCharacterID;
		}
		
		public function transitionOut():void {
			setTabSelected( -1);
		}
		
		public function transitionIn():void {
			selectedItemID = -1;
			var levelRequired:Array = Game.database.gamedata.getConfigData(127);
			if (levelRequired) {
				var i:int = 0;
				for each (var level:int in levelRequired) {
					if (Game.database.userdata.level >= level) {
						setBtnEnable(mapping[mappingKeys[i]], true, level);
					} else {
						setBtnEnable(mapping[mappingKeys[i]], false, level);
					}
					i++;
				}
			}
			
			currentTab = -1;
		}
		
		public function setCurrentTab(value:int):void {
			currentTab = value;
		}
		
		public function updateMovInfo(value:Character):void {
			movInfo.visible = true;
			movInfo.setCharacter(value);
		}
		
		public function set shopItems(value:Array):void	{
			items = value;
			for each (var key:int in mappingKeys) {
				if (mapping[key] && mapping[key].isEnable) {
					setTabSelected(key);
					break;
				}
			}
		}
		
		public function updateShopItems():void {
			movInfo.visible = false;
			btnInvite.visible = false;
			btnFight.visible = false;
			btnExtend.visible = false;
			txtPrice.visible = false;
			movPaymentType.visible = false;
			
			for each (var shopHeroesItem:ShopHeroesItem in _shopItems) {
				if (shopHeroesItem) {
					itemsContainer.removeChild(shopHeroesItem);
					shopHeroesItem.destroy();
					shopHeroesItem = null;
				}
			}
			_shopItems.splice(0);
			arrID = [];
			if (items) {
				var shopItem:ShopItem;
				var i:int = 0;
				for each (shopItem in items) {
					if (shopItem) {
						if (shopItem.item is Character) {
							if ((currentTab == LEGENDARY && Character(shopItem.item).isLegendary() && checkDulicate(shopItem.item))
								|| ((Character(shopItem.item).xmlData.quality[0] == currentTab)) &&
									! Character(shopItem.item).isLegendary()){
								shopHeroesItem = new ShopHeroesItem();
								shopHeroesItem.shopItemData = shopItem;
								shopHeroesItem.x = 150 + i * 200;
								shopHeroesItem.y = 150;
								_shopItems.push(shopHeroesItem);
								itemsContainer.addChild(shopHeroesItem);
								i++;
							}
						}
					} else {
						_shopItems.push(null);
					}
				}
				maxPages = (Math.ceil(_shopItems.length / MAX_CHARACTERS_PER_PAGE) - 1);
				if (maxPages > 0) {
					btnNext.visible = true;
					btnPrev.visible = true;
				} else {
					btnNext.visible = false;
					btnPrev.visible = false;
				}
				setCurrentPage(0);
				
			}
		}
		
		private var arrID:Array;
		private function checkDulicate(character:Character):Boolean 
		{
			if (arrID.indexOf(character.ID) == -1)
			{
				arrID.push(character.ID);
				return true;
			}
			return false;
		}
		
	}

}