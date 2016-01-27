package game.ui.shop 
{
	import core.Manager;
	import core.display.ModuleBase;
	import core.event.EventEx;
	import flash.utils.Dictionary;
	import game.data.vo.lobby.LobbyInfo;
	
	import flash.events.Event;
	
	import game.Game;
	import game.data.model.Character;
	import game.data.model.UserData;
	import game.data.model.shop.ShopItem;
	import game.data.xml.DataType;
	import game.data.xml.ShopXML;
	import game.enum.ErrorCode;
	import game.enum.FlowActionEnum;
	import game.enum.GameMode;
	import game.flow.FlowManager;
	import game.net.IntRequestPacket;
	import game.net.IntResponsePacket;
	import game.net.RequestPacket;
	import game.net.ResponsePacket;
	import game.net.Server;
	import game.net.lobby.LobbyRequestType;
	import game.net.lobby.LobbyResponseType;
	import game.net.lobby.request.RequestShopBuySingleItem;
	import game.net.lobby.response.ResponseShopHeroes;
	import game.ui.ModuleID;
	import game.ui.home.scene.CharacterManager;
	import game.ui.message.MessageID;
	
	/**
	 * ...
	 * @author MaiPTT
	 */
	public class ShopModule extends ModuleBase 
	{		
		private var _character		:Character;
		
		public function ShopModule() {
		}

		override protected function createView():void {
			baseView = new ShopView();
			baseView.addEventListener(ShopEvent.SHOP_EVENT, onShopEventHdl);
		}
		
		override protected function transitionOut():void {
			super.transitionOut();
			Game.database.userdata.removeEventListener(UserData.UPDATE_CHARACTER_INFO, onUpdateCharacterInfoHdl);
			Game.network.lobby.removeEventListener(Server.SERVER_DATA, onLobbyResponseHdl);
			CharacterManager.instance.displayCharacters();
		}
		
		override protected function transitionIn():void {
			super.transitionIn();
			Game.database.userdata.addEventListener(UserData.UPDATE_CHARACTER_INFO, onUpdateCharacterInfoHdl);
			Game.network.lobby.addEventListener(Server.SERVER_DATA, onLobbyResponseHdl);
			Manager.display.hideModule(ModuleID.HUD);
			Manager.display.hideModule(ModuleID.DAILY_TASK);
			CharacterManager.instance.hideCharacters();
		}
		
		override protected function onTransitionInComplete():void {
			super.onTransitionInComplete();
			Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.GET_SHOP_HEROES));
		}
		
		private function onUpdateCharacterInfoHdl(e:EventEx):void {
			(ShopView)(baseView).movShopHeroes.updateMovInfo(e.data as Character);
		}
		
		private function onShopEventHdl(e:EventEx):void {
			if (!e.data) return;
			switch(e.data.type) {
				case ShopEvent.REQUEST_CHARACTER_INFO:
					_character = e.data.value as Character;
					if (_character) {
						(ShopView)(baseView).movShopHeroes.selectedItemID = _character.xmlData.ID;
						Game.database.userdata.selectedCharacter = _character;
						for each (var value:Character in Game.database.userdata.characters) {
							if (value && value.xmlID == _character.ID) {
								Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.GET_CHARACTER_INFO, value.ID));
								return;
							}
						}
						Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.CHARACTER_INFO_BY_UNIT_ID, _character.xmlData.ID));	
					}
					break;
					
				case ShopEvent.ENTER_MISSION:
					var lobbyInfo:LobbyInfo = new LobbyInfo();
					lobbyInfo.mode = GameMode.PVE_SHOP_WARRIOR;
					lobbyInfo.missionID = e.data.missionID;
					lobbyInfo.backModule = ModuleID.SHOP;
					Game.flow.doAction(FlowActionEnum.CREATE_BASIC_LOBBY, lobbyInfo);					
					break;
					
				case ShopEvent.BUY_CHARACTER:
					var requestPacket:RequestShopBuySingleItem = new RequestShopBuySingleItem();
					requestPacket.shopItemID = e.data.shopItemID;
					requestPacket.itemQuantity = 1;
					Game.network.lobby.sendPacket(requestPacket);
					break;
					
				case ShopEvent.EXTEND:
					Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.EXTEND_RECRUITMENT_SHOP_HEROES, e.data.characterID));
					break;
			}
		}
		
		private function onLobbyResponseHdl(e:EventEx):void {
			var responsePacket:ResponsePacket = e.data as ResponsePacket;
			switch(responsePacket.type) {
				case LobbyResponseType.SHOP_HEROES_RESPONSE:
					onResponseShopHeroes(e.data as ResponseShopHeroes);
					/*showShopHeroes([1, 2, 3, 4, 5, 6, 7], [1, 1, 1, 0, 0, 0, 0], [10000, 10000, 10000, 10000, 10000, 10000, 10000],
									[1,2,3,4,5,6,7]);*/
					break;
					
				case LobbyResponseType.BUY_ITEM_RESULT:
					var intResponsePacket:IntResponsePacket = e.data as IntResponsePacket;
					processBuyHeroResult(intResponsePacket.value);
					break;
					
				case LobbyResponseType.EXTEND_RECRUITMENT:
					onResponseExtendRecruitment(IntResponsePacket(responsePacket).value);
					break;
			}
		}
		
		private function onResponseExtendRecruitment(value:int):void {
			switch(value) {
				case 0:
					Manager.display.showMessage("Gia hạn thành công");
					ShopView(baseView).movShopHeroes.setCurrentTab( -1);
					Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.GET_SHOP_HEROES));
					break;
					
				case 6:
					Manager.display.showMessage("Không đủ Uy Danh");
					break;
			}
		}
		
		private function onResponseShopHeroes(packet:ResponseShopHeroes):void {
			showShopHeroes(packet.shopItemIDs, packet.shopCurrItemIDs,
						   packet.statuses,
						   packet.expiredTime,
						   packet.missionIDs);
		}
		
		private function processBuyHeroResult(value:int):void {
			switch(value) {
				case ErrorCode.SUCCESS:
					Manager.display.showMessageID(MessageID.SHOP_HEROES_BUY_SUCCESS);
					ShopView(baseView).movShopHeroes.setCurrentTab( -1);
					Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.GET_SHOP_HEROES));
					break;
					
				case ErrorCode.FAIL:
					Manager.display.showMessageID(MessageID.SHOP_HEROES_BUY_FAIL);
					break;
					
				case 3:
					Manager.display.showMessage("Số nhân vật của bạn đã đạt mức tối đa.");
					break;
					
				case 4:
					Manager.display.showMessage("Không đủ uy danh để thuê đại hiệp");
					break;
					
				case 8:
					Manager.display.showMessage("Chưa đủ cấp để thuê đại hiệp");
					break;
			}
		}
		
		private function showShopHeroes(shopItemIDs:Array, shopCurrItemIDs:Array, statuses:Array, expiredTime:Array, missionIDs:Array):void {
			var arr:Array = [];
			var shopItem:ShopItem;
			var lockedObj:Object = { };
			var hasLockedObj:Boolean = false;
			var lockedObjLevel:int = 0;
			if (shopItemIDs && statuses && expiredTime && missionIDs) {
				var length:int = Math.min(shopItemIDs.length, statuses.length, expiredTime.length, missionIDs.length);
				for (var i:int = 0; i < length; i++) {
					if (statuses[i] == ShopItem.LOCKED) {
						hasLockedObj = true;
						var shopXML:ShopXML = Game.database.gamedata.getData(DataType.SHOP, shopItemIDs[i]) as ShopXML;
						if (shopXML) {
							if (lockedObjLevel) {
								if (lockedObjLevel <= shopXML.levelRequire) {
									
								} else {
									lockedObjLevel = Math.min(lockedObjLevel, shopXML.levelRequire);	
									lockedObj.id = shopItemIDs[i];
									lockedObj.status = statuses[i];
									lockedObj.expiredTime = expiredTime[i];
									lockedObj.missionID = missionIDs[i];
								}
							} else {
								lockedObjLevel = shopXML.levelRequire;
							}
						}
					} else if (statuses[i] != ShopItem.LOCKED) {
						var shop1XML:ShopXML = Game.database.gamedata.getData(DataType.SHOP, shopItemIDs[i]) as ShopXML;
						shop1XML = shop1XML.clone();
						shop1XML.itemID = shopCurrItemIDs[i];
						shopItem = new ShopItem(shop1XML);
						if (shopItem && shopItem.item) {
							shopItem.status = statuses[i];
							if (shopItem.item is Character) {
								Character(shopItem.item).expiredTime = expiredTime[i];
							}
							shopItem.missionID = missionIDs[i];
							arr.push(shopItem);	
						}
					}
				}
				
				if (hasLockedObj) {
					shopItem = new ShopItem(Game.database.gamedata.getData(DataType.SHOP, lockedObj.id) as ShopXML);
					if (shopItem) {
						shopItem.status = lockedObj.status;
						if (shopItem.item && shopItem.item is Character) {
							Character(shopItem.item).expiredTime = lockedObj.expiredTime;
						}
						shopItem.missionID = lockedObj.missionID;
					}
					arr.push(shopItem);	
				}
			}
			if (baseView) {
				(ShopView)(baseView).movShopHeroes.shopItems = arr;
				(ShopView)(baseView).movShopHeroes.update();
			}
		}
	}

}