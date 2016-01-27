package game.ui.soul_center
{
	import core.display.DisplayManager;
	import core.display.layer.Layer;
	import core.display.ModuleBase;
	import core.event.EventEx;
	import core.Manager;
	import core.util.Utility;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	import flash.utils.Dictionary;
	import game.data.model.Character;
	import game.data.model.Inventory;
	import game.data.model.item.SoulItem;
	import game.data.model.UserData;
	import game.data.xml.DataType;
	import game.data.xml.VIPConfigXML;
	import game.enum.DialogEventType;
	import game.enum.DragDropEvent;
	import game.enum.GameConfigID;
	import game.enum.InventoryMode;
	import game.enum.SlotUnlockType;
	import game.Game;
	import game.net.IntRequestPacket;
	import game.net.IntResponsePacket;
	import game.net.lobby.LobbyRequestType;
	import game.net.lobby.LobbyResponseType;
	import game.net.lobby.request.RequestEquipSoul;
	import game.net.lobby.request.RequestMergeSoul;
	import game.net.lobby.request.RequestSwapSoulInv;
	import game.net.lobby.request.RequestSwapSoulInvEquip;
	import game.net.lobby.request.RequestUpgradeSoul;
	import game.net.lobby.response.ResponseErrorCode;
	import game.net.lobby.response.ResponseSoulCraft;
	import game.net.lobby.response.ResponseSoulCraftAuto;
	import game.net.lobby.response.ResponseSoulInfo;
	import game.net.RequestPacket;
	import game.net.ResponsePacket;
	import game.net.Server;
	import game.ui.dialog.DialogID;
	import game.ui.dialog.dialogs.YesNo;
	import game.ui.home.scene.CharacterManager;
	import game.ui.hud.HUDModule;
	import game.ui.inventory.InventoryView;
	import game.ui.message.MessageID;
	import game.ui.ModuleID;
	import game.ui.soul_center.event.EventSoulCenter;
	import game.ui.soul_center.gui.NodeCell;
	import game.ui.soul_center.gui.SoulNode;
	import game.ui.soul_center.gui.SoulSlot;
	import game.ui.tooltip.TooltipEvent;
	import game.ui.tutorial.TutorialEvent;
	import game.utility.GameUtil;
	
	/**
	 * ...
	 * @author anhtinh
	 */
	public class SoulCenterModule extends ModuleBase
	{
		private var currentData:ResponseSoulInfo;
		
		private var _isAutoDivine:Boolean = false;
		private var _itemMergedIndex:int = -1;
		
		public function SoulCenterModule()
		{
			relatedModuleIDs = [ModuleID.INVENTORY_UNIT];
		}
		
		override protected function createView():void
		{
			super.createView();
			baseView = new SoulCenterView();
			
			baseView.addEventListener(EventSoulCenter.HIDE_POPUP, hideModuleHdl);
			
			baseView.addEventListener(EventSoulCenter.NORMAL_DIVINE, normalDivineHdl);
			baseView.addEventListener(EventSoulCenter.AUTO_DIVINE, autoDivineHdl);
			baseView.addEventListener(EventSoulCenter.STOP_AUTO_DIVINE, stopAutoDivineHdl);
			baseView.addEventListener(EventSoulCenter.COMPLETE_EFFECT_DIVINE, onCompleteEffectDivineHdl);
			
			baseView.addEventListener(EventSoulCenter.SELL_SOUL, sellSoulHdl);
			baseView.addEventListener(EventSoulCenter.LOCK_MERGE_SOUL, lockMergeSoulHdl);
			baseView.addEventListener(EventSoulCenter.SELL_FAST_SOUL, sellFastSoulHdl);
			baseView.addEventListener(EventSoulCenter.COLLECT_SOUL, collectSoulHdl);
			baseView.addEventListener(EventSoulCenter.COLLECT_FAST_SOUL, collectFastSoulHdl);
			baseView.addEventListener(EventSoulCenter.UPGRADE_SOUL, upgradeSoulHdl);
			
			baseView.addEventListener(EventSoulCenter.ACTION_MERGE_SOUL, onActionMergeHdl);
			
			baseView.addEventListener(EventSoulCenter.EQUIP_ATTACH_SOUL, equipSoulAttachHdl);
			baseView.addEventListener(EventSoulCenter.EQUIP_MERGE_SOUL, equipSoulMergeHdl);
			baseView.addEventListener(EventSoulCenter.SWAP_SOUL_INVENTORY, swapSoulInventoryHdl);
			baseView.addEventListener(EventSoulCenter.SWAP_SOUL_EQUIP_ATTACH, swapSoulEquipAttachHdl);
			baseView.addEventListener(EventSoulCenter.SWAP_SOUL_EQUIP_MERGE, swapSoulEquipMergeHdl);
			
			baseView.addEventListener(SoulSlot.SOUL_SLOT_DRAG, onDragHdl);
			baseView.addEventListener(NodeCell.NODE_CELL_DRAG, onNodeSlotDragHdl);
			//view.addEventListener(SoulNode.SOUL_NODE_DRAG, onSoulSlotDragHdl);
			
			baseView.addEventListener(SoulSlot.UNLOCK_SLOT, unlockSlotHdl);
		}

		public function showHintButton():void
		{
			if(baseView)
				SoulCenterView(baseView).showHintButton();
		}

		public function showHintTab(index:int):void
		{
			if(baseView)
				SoulCenterView(baseView).showHintTab(index);
		}

		public function showHintSlot():void
		{
			if(baseView)
				SoulCenterView(baseView).showHintSlot();
		}

		private function lockMergeSoulHdl(e:EventSoulCenter):void 
		{
			var soul:SoulItem = e.data as SoulItem;
			Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.LOCK_SOUL_INVENTORY, soul.index));
		}
		
		private function onCompleteEffectDivineHdl(e:EventSoulCenter):void 
		{
			if (_isAutoDivine) {
				autoDivineHdl();	
			}	
		}
		
		private function unlockSlotHdl(e:Event):void
		{
			var slotList:Array = Game.database.gamedata.getConfigData(70) as Array;
			var xuList:Array = Game.database.gamedata.getConfigData(71) as Array;
			var initCapacity:int = Game.database.gamedata.getConfigData(GameConfigID.INIT_SOUL_INVENTORY_SIZE) as int;
			;
			var addedSoul:int = Game.database.inventory.getSouls().length - initCapacity;
			
			var unlockIndex:int = 0
			for (var i:int = 0; i < slotList.length; i++)
			{
				addedSoul = addedSoul - slotList[i];
				
				if (addedSoul < 0)
				{
					unlockIndex = i;
					break;
				}
			}
			if (addedSoul >= 0)
			{
				Manager.display.showMessageID(35); // dat gioi han unlock
				return;
			}
			
			if (Game.database.userdata.xu < xuList[unlockIndex])
			{
				Manager.display.showMessageID(37); // khong du xu
				return;
			}
			
			Manager.display.showDialog(DialogID.YES_NO, function():void
				{
					
					Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.UNLOCK_SLOT, SlotUnlockType.SOUL));
				}, null, {type: DialogEventType.CONFIRM_UNLOCK_SOUL_SLOT, xu: xuList[unlockIndex], slot: slotList[unlockIndex]}, Layer.BLOCK_BLACK);
		
		}
		
		private function upgradeSoulHdl(e:EventSoulCenter):void
		{
			Utility.error("upgradeSoulHandler indexFrom : " + e.data["indexFrom"] + " --- indexTo : " + e.data["indexTo"]);
			
			Game.network.lobby.sendPacket(new RequestUpgradeSoul(e.data["indexFrom"], e.data["indexTo"]));
		}
		
		private function onActionMergeHdl(e:EventSoulCenter):void
		{
			//Utility.error("upgradeSoulHandler indexFrom : " + e.data["indexFrom"] + " --- indexTo : " + e.data["indexTo"]);
			
			//Game.network.lobby.sendPacket(new RequestUpgradeSoul(e.data["indexFrom"], e.data["indexTo"]));
			//var itemMergeIndex:int = e.data ? e.data.item : -1;
			_itemMergedIndex = e.data ? e.data.item : -1;
			var recipeArr:Array = e.data ? e.data.recipeArr : [];
			Game.network.lobby.sendPacket(new RequestMergeSoul(_itemMergedIndex, recipeArr));
		}
		
		private function swapSoulInventoryHdl(e:EventSoulCenter):void
		{
			Utility.error("swapSoulInvHandler indexFrom : " + e.data["indexFrom"] + " --- indexTo : " + e.data["indexTo"]);
			
			Game.network.lobby.sendPacket(new RequestSwapSoulInv(e.data["indexFrom"], e.data["indexTo"]));
		}
		
		private function swapSoulEquipAttachHdl(e:EventSoulCenter):void
		{
			
			Utility.error("swapSoulInvEquipHandler unitIndex : " + e.data["unitIndex"] + " --- indexFrom : " + e.data["indexFrom"] + " --- indexTo : " + e.data["indexTo"]);
			
			Game.network.lobby.sendPacket(new RequestSwapSoulInvEquip(e.data["unitIndex"], e.data["indexFrom"], e.data["indexTo"]));
		}
		
		private function swapSoulEquipMergeHdl(e:EventSoulCenter):void
		{
			
			//Utility.error("swapSoulInvEquipHandler unitIndex : " + e.data["unitIndex"] + " --- indexFrom : " + e.data["indexFrom"] + " --- indexTo : " + e.data["indexTo"]);
			
			//Game.network.lobby.sendPacket(new RequestSwapSoulInvEquip(e.data["unitIndex"], e.data["indexFrom"], e.data["indexTo"]));
		}
		
		private function equipSoulAttachHdl(e:EventSoulCenter):void
		{			
			Utility.error("equipSoulHandler unitIndex : " + e.data["unitIndex"] + " --- soulIndex : " + e.data["soulIndex"] + " --- slotIndex : " + e.data["slotIndex"]);					
			Game.network.lobby.sendPacket(new RequestEquipSoul(e.data["unitIndex"], e.data["soulIndex"], e.data["slotIndex"]));
		}
		
		private function equipSoulMergeHdl(e:EventSoulCenter):void
		{
			//Utility.error("equipSoulHandler unitIndex : " + e.data["unitIndex"] + " --- soulIndex : " + e.data["soulIndex"] + " --- slotIndex : " + e.data["slotIndex"]);
			
			//Game.network.lobby.sendPacket(new RequestEquipSoul(e.data["unitIndex"], e.data["soulIndex"], e.data["slotIndex"]));
		}
		
		private function onNodeSlotDragHdl(e:EventEx):void
		{
			//start drag and drog
			var obj:Object = e.data;
			
			if (!obj)
			{
				Utility.error("onNodeSlotDragHdl error by NULL info refernce");
				return;
			}
			var objDrag:DisplayObject = obj.target as DisplayObject;
			obj.type = DragDropEvent.FROM_NODE_OF_CHARACTER;
			Game.drag.start(objDrag, obj);		
		}
		
		/*private function onSoulSlotDragHdl(e:EventEx):void
		{
			//start drag and drog
			var obj:Object = e.data;
			
			if (!obj)
			{
				Utility.error("onSoulSlotDragHdl error by NULL info refernce");
				return;
			}
			var objDrag:DisplayObject = obj.target as DisplayObject;
			obj.type = DragDropEvent.FROM_MERGE_SOUL;
			Game.drag.start(objDrag, obj);		
		}*/
		
		private function onDragHdl(e:EventEx):void
		{
			//start drag and drog
			var obj:Object = e.data;
			
			if (!obj)
			{
				Utility.error("onSlotDragHdl error by NULL info refernce");
				return;
			}
			var objDrag:DisplayObject = obj.target as DisplayObject;
			obj.type = DragDropEvent.FROM_SOUL_INVENTORY;
			Game.drag.start(objDrag, obj);
		
		}
		
		override protected function onTransitionInComplete():void
		{
			super.onTransitionInComplete();
			Game.database.inventory.addEventListener(Inventory.UPDATE_SOUL, onUpdateSoul);
			Game.database.userdata.addEventListener(UserData.UPDATE_CHARACTER_INFO, onUpdateCharacterInfo);
			Game.database.userdata.addEventListener(UserData.UPDATE_PLAYER_INFO, onUpdatePlayerInfo);
			
			CharacterManager.instance.hideCharacters();
			
			SoulCenterView(baseView).soulInventoryUI.update();
		}
		
		private function onUpdatePlayerInfo(e:Event):void 
		{
			if (baseView != null) {
				SoulCenterView(baseView).updateExchangePoint();
			}
		}
		
		private function onUpdateCharacterInfo(e:EventEx):void
		{
			
			var charater:Character = e.data as Character;
			if (charater != null )
			{
				if(!charater.isMystical())
				SoulCenterView(baseView).attachSoulPanel.updateCharacter(charater);
			}
		}
		
		private function onChangeCharacter(e:EventEx):void
		{
			var charater:Character = e.data as Character;
			if (charater != null)
			{
				SoulCenterView(baseView).attachSoulPanel.updateCharacter(charater);
			}
		}
		
		override protected function onTransitionOutComplete():void
		{
			super.onTransitionOutComplete();
			Game.network.lobby.removeEventListener(Server.SERVER_DATA, onLobbyServerData);
			Game.database.inventory.removeEventListener(Inventory.UPDATE_SOUL, onUpdateSoul);
			Game.stage.removeEventListener(InventoryView.CHARACTER_SLOT_CLICK, onChangeCharacter);
			Game.database.userdata.removeEventListener(UserData.UPDATE_CHARACTER_INFO, onUpdateCharacterInfo);
			Game.database.userdata.removeEventListener(UserData.UPDATE_PLAYER_INFO, onUpdatePlayerInfo);
			CharacterManager.instance.displayCharacters();
			
			//stop auto divine
			stopAutoDivineHdl(null);
			SoulCenterView(baseView).soulInventoryUI.releaseMouse();
		}
		
		private function onUpdateSoul(e:Event):void
		{
			SoulCenterView(baseView).soulInventoryUI.update();
			SoulCenterView(baseView).mergeSoulPanel.resetUI();
			if (_itemMergedIndex) {
				var souls:Array = Game.database.inventory.getSouls();
				var soulItem:SoulItem = _itemMergedIndex < 0 || _itemMergedIndex > souls.length ? null : souls[_itemMergedIndex] as SoulItem;
				if (soulItem) {
					SoulCenterView(baseView).onSoulSlotDClickHdl(new EventEx(SoulSlot.SOUL_SLOT_DCLICK, soulItem));
				}
			}
		}
		
		private function autoDivineHdl(e:EventSoulCenter = null):void
		{
			var currentVip:int = Game.database.userdata.vip;
			var currentVipInfo:VIPConfigXML = Game.database.gamedata.getData(DataType.VIP, currentVip) as VIPConfigXML;
			var actionValid:Boolean = currentVipInfo ? currentVipInfo.soulCraftAuto : false;
			
			if (actionValid) {				
				if (this.currentData != null && this.currentData.totalDivine > 0) {
					if (SoulCenterView(baseView).soulPanel.divinePanel.invTempIsFull()) {
						//Day kho
						Manager.display.showMessageID(20);
						stopAutoDivineHdl(null);
					}else {
						Game.mouseEnable = false;
						Utility.log("autoDivineHandler");
						_isAutoDivine = true;
						SoulCenterView(baseView).activeAutoDivine(true);
						SoulCenterView(baseView).soulPanel.divinePanel.normalDivine();
						Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.SOUL_CRAFT));
					}
				}else {
					//Het so lan boi
					Manager.display.showMessageID(29);					
					stopAutoDivineHdl(null);
				}
			}else {
				var vipInfoDic:Dictionary = Game.database.gamedata.getTable(DataType.VIP);
				var nextValidExist:Boolean = false;
				for each(var vipXML:VIPConfigXML in vipInfoDic) {				
					if (vipXML.ID > currentVip && vipXML.soulCraftAuto) {
						nextValidExist = true;
						break;				
					}
				}				
				var actionValidNext:int = nextValidExist ? vipXML.ID : -1;
				var dialogData:Object = {};
				dialogData.title = "Thông báo";
				dialogData.message = "Chỉ có VIP " + actionValidNext.toString() + " mới được sử dụng chức năng này. Các hạ có muốn xem thông tin VIP không ?";
				dialogData.option = YesNo.YES | YesNo.CLOSE | YesNo.NO;
				Manager.display.showDialog(DialogID.YES_NO, onAcceptViewHdl, null, dialogData, Layer.BLOCK_BLACK);	
			}
		}
		
		private function onAcceptViewHdl(data:Object):void 
		{
			Manager.display.showPopup(ModuleID.DIALOG_VIP, Layer.BLOCK_BLACK);
		}
		
		private function stopAutoDivineHdl(e:EventSoulCenter):void {
			Utility.log("stop auto divine");
			SoulCenterView(baseView).activeAutoDivine(false);
			Game.mouseEnable = true;
			_isAutoDivine = false;
		}
		
		private function collectFastSoulHdl(e:EventSoulCenter):void
		{
			Utility.log("collectFastSoulHandler");
			var numEmptySlotRemain:int = Game.database.inventory.getNumEmptySoulSlotRemain();
			if (numEmptySlotRemain > 0)
				SoulCenterView(baseView).soulPanel.divinePanel.collectAllSoul(numEmptySlotRemain);
			else
				Manager.display.showMessageID(19);
		
		}
		
		private function sellSoulHdl(e:EventSoulCenter):void
		{
			Game.mouseEnable = false;
			Utility.log("sellSoulHandler soulIndex : " + int(e.data));
			SoulCenterView(baseView).soulPanel.divinePanel.removeSlot(int(e.data), true);
		
		}
		
		private function sellFastSoulHdl(e:EventSoulCenter):void
		{
			Utility.log("sellFastSoulHandler");
			SoulCenterView(baseView).soulPanel.divinePanel.sellAllBadSoul();
		}
		
		private function collectSoulHdl(e:EventSoulCenter):void
		{
			if (Game.database.inventory.isHaveEmptySoulSlot())
			{
				Utility.log("collectSoulHandler soulIndex : " + int(e.data));
				Game.mouseEnable = false;
				SoulCenterView(baseView).soulPanel.divinePanel.removeSlot(int(e.data));
			}
			else
			{
				Utility.log("Inventory is full");
				Manager.display.showMessageID(19);
			}
		
		}
		
		private function onLobbyServerData(e:EventEx):void
		{
			
			var packet:ResponsePacket = ResponsePacket(e.data);
			
			switch (packet.type)
			{
				case LobbyResponseType.GET_SOUL_INFO: 
					updateSoulInfo(packet as ResponseSoulInfo);
					break;
				case LobbyResponseType.SOUL_CRAFT: 
					onSoulCraftResponse(packet as ResponseSoulCraft);
					break;
				case LobbyResponseType.AUTO_SOUL_CRAFT: 
					onAutoSoulCraftResponse(packet as ResponseSoulCraftAuto);
					break;
				case LobbyResponseType.SELL_SOUL: 
					onSellSoulResponse(packet as IntResponsePacket);
					break;
				case LobbyResponseType.SELL_FAST_SOUL: 
					onSellFastSoulResponse(packet as IntResponsePacket);
					break;
				case LobbyResponseType.COLLECT_SOUL: 
					onCollectSoulResponse(packet as IntResponsePacket);
					break;
				case LobbyResponseType.COLLECT_FAST_SOUL: 
					onCollectFastSoulResponse(packet as IntResponsePacket);
					break;
				case LobbyResponseType.EQUIP_SOUL: 
					onEquipSoulResponse(packet as IntResponsePacket);
					break;
				case LobbyResponseType.UPGRADE_SOUL: 
					onUpgradeSoulResponse(packet as IntResponsePacket);
					break;
				case LobbyResponseType.SWAP_SOUL_INV: 
					onSwapSoulInvResponse(packet as IntResponsePacket);
					break;
				case LobbyResponseType.SWAP_SOUL_INV_EQUIP: 
					onSwapSoulInvEquipResponse(packet as IntResponsePacket);
					break;
				case LobbyResponseType.UNLOCK_SLOT: 
					onUnlockSlotResponse(packet as IntResponsePacket);
				case LobbyResponseType.BUY_ITEM_RESULT: 
					onBuyItemResponse(packet as IntResponsePacket);
					break;
				case LobbyResponseType.ERROR_CODE:
					var packetErrorCode:ResponseErrorCode = packet as ResponseErrorCode;
					switch(packetErrorCode.requestType) {
						case LobbyRequestType.LOCK_SOUL_INVENTORY:
							Utility.log("lock soul error code is: " + packetErrorCode.errorCode);
							break;
						case LobbyRequestType.MERGE_SOUL:
							Utility.log("merge soul error code is: " + packetErrorCode.errorCode);
							switch (packetErrorCode.errorCode)
							{
								case 0: 
									_itemMergedIndex = -1;
									Manager.display.showMessageID(MessageID.SUCCESS_MERGE_SOUL);
									break;
								case 3: 
									Manager.display.showMessageID(MessageID.UPGRADE_SOUL_FAIL_BY_MAX_LEVEL);
									break;
								
								default: 
									Manager.display.showMessageID(25);
							}
							break;
					}
					break;
			}
		}
		
		private function onBuyItemResponse(intResponsePacket:IntResponsePacket):void
		{
			Utility.log("onBuyItemResponse : " + intResponsePacket.value);
			switch (intResponsePacket.value)
			{
				case 0: //success
					Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.SOUL_INVENTORY));
					SoulCenterView(baseView).buyItemSuccess();
					break;
				case 1: //fail
					//Manager.display.showMessageID(36);
					//break;
				case 2: // fail xxx
					Manager.display.showMessage("Thao tác thất bại ^^");
					break;
				case 3: // full inventory
					Manager.display.showMessage("Thùng Mệnh Khí đã đầy ^^");
					break;
				case 4: // thieu payment
					Manager.display.showMessage("Không đủ điều kiện đổi vật phẩm ^^");
					break;
				case 5: // fail condition
					break;
				default: 
			}
		}
		
		private function onUnlockSlotResponse(intResponsePacket:IntResponsePacket):void
		{
			Utility.log("onUnlockSlotResponse : " + intResponsePacket.value);
			switch (intResponsePacket.value)
			{
				case 0: 
					Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.SOUL_INVENTORY));
					break;
				case 1: //fail
					Manager.display.showMessageID(36);
					break;
				case 2: // thieu xu
					Manager.display.showMessageID(37);
					break;
				
				default: 
			}
		}
		
		private function onUpgradeSoulResponse(intResponsePacket:IntResponsePacket):void
		{
			Game.mouseEnable = true;
			Utility.log("onUpgradeSoulResponse result : " + intResponsePacket.value);
			
			switch (intResponsePacket.value)
			{
				case 0: 
					Manager.display.showMessageID(24);
					break;
				case 3: 
					Manager.display.showMessageID(32);
					break;
				
				default: 
					Manager.display.showMessageID(25);
			}
		}
		
		private function onSwapSoulInvResponse(intResponsePacket:IntResponsePacket):void
		{
			Game.mouseEnable = true;
			Utility.log("onSwapSoulInvResponse result : " + intResponsePacket.value);
		}
		
		private function onSwapSoulInvEquipResponse(intResponsePacket:IntResponsePacket):void
		{
			Game.mouseEnable = true;
			Utility.log("onSwapSoulInvEquipResponse result : " + intResponsePacket.value);
		}
		
		private function onEquipSoulResponse(intResponsePacket:IntResponsePacket):void
		{
			Game.mouseEnable = true;
			Utility.log("onEquipSoulResponse result : " + intResponsePacket.value);
			switch(intResponsePacket.value) {
				case 0:
					Manager.display.showMessageID(MessageID.SUCCESS_EQUIP_SOUL);
					SoulCenterView(baseView).dispatchEvent(new EventEx(TutorialEvent.EVENT, {type: TutorialEvent.ATTACHED_SUCCESS_SOUL_CENTER}, true));
					break;
				case 1:
					
					break;
				case 2:
					var maxLimit:int = Game.database.gamedata.getConfigData(GameConfigID.MAX_SAME_SOUL_EQUIP_PER_CHARACTER) as int;
					Manager.display.showMessage("Không thể gắn quá " + maxLimit + " mệnh khí cùng loại trên cùng nhân vật");
					break;
			}
		}
		
		private function onAutoSoulCraftResponse(soulCraftAutoInfo:ResponseSoulCraftAuto):void
		{
			Game.mouseEnable = true;
			Utility.log("onAutoSoulCraftResponse result : " + soulCraftAutoInfo.result);
			switch (soulCraftAutoInfo.result)
			{
				case 0: //thanh cong
					// play auto craft
					Game.mouseEnable = false;
					SoulCenterView(baseView).soulPanel.divinePanel.playAutoCraft(soulCraftAutoInfo);
					break;
				case 1: //that bai : day kho hoac thieu bac
					Manager.display.showMessageID(20);
					break;
				default: 
			}
		}
		
		private function onSellFastSoulResponse(intResponsePacket:IntResponsePacket):void
		{
			Game.mouseEnable = true;
			Utility.log("onSellFastSoulResponse result : " + intResponsePacket.value);
		}
		
		private function onCollectFastSoulResponse(intResponsePacket:IntResponsePacket):void
		{
			Game.mouseEnable = true;
			Utility.log("onCollectFastSoulResponse result : " + intResponsePacket.value);
			switch (intResponsePacket.value)
			{
				case 0://success
					SoulCenterView(baseView).dispatchEvent(new EventEx(TutorialEvent.EVENT, {type: TutorialEvent.COLLECT_SOUL_CENTER}, true));
					break;
				case 2: //kho da day
					Manager.display.showMessageID(19);
					break;
				default: 
			}
		}
		
		private function onCollectSoulResponse(intResponsePacket:IntResponsePacket):void
		{
			Game.mouseEnable = true;
			
			Utility.log("onCollectSoulResponse result : " + intResponsePacket.value);
			switch (intResponsePacket.value)
			{
				case 0: 
					break;
				case 2: //kho da day
					Manager.display.showMessageID(19);
					break;
				default: 
			}
		}
		
		private function onSellSoulResponse(intResponsePacket:IntResponsePacket):void
		{
			Game.mouseEnable = true;
			
			Utility.log("onSellSoulResponse result : " + intResponsePacket.value);
			switch (intResponsePacket.value)
			{
				case 0: 
					break;
				default: 
			}
		}
		
		private function onSoulCraftResponse(responseSoulCraft:ResponseSoulCraft):void
		{
			Utility.log("onSoulCraftResponse result : " + responseSoulCraft.result);
			Utility.log("onSoulCraftResponse soulIndex : " + responseSoulCraft.soulIndex);
			var messageID:int = 0;
			switch (responseSoulCraft.result)
			{			
				case 2: //fail
					messageID = 31;
					break;
				case 3: //Khong du vang de boi tiep
					messageID = 28;
					break;
				case 4: //Het so lan boi
					messageID = 29;
					break;
				case 5: //Ko phai Vip
					messageID = 30;
					break;
				case 6: //full inventory
					messageID = 20;
					break;
			}
			
			if (messageID != 0) {				
				Manager.display.showMessageID(messageID);
				stopAutoDivineHdl(null);
			}			
		}
		
		private function normalDivineHdl(e:EventSoulCenter):void
		{			
			if (this.currentData != null && this.currentData.totalDivine > 0) {
				if (SoulCenterView(baseView).soulPanel.divinePanel.invTempIsFull()) {
					//Day kho
					Manager.display.showMessageID(20);
				}else {
					Utility.log("normalDivineHandler");
					Game.mouseEnable = false;
					Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.SOUL_CRAFT));
					SoulCenterView(baseView).soulPanel.divinePanel.normalDivine();
				}				
			}else {
				//Het so lan boi
				Manager.display.showMessageID(29);
			}
		}
		
		private function hideModuleHdl(e:EventSoulCenter):void
		{
			var hudModule:HUDModule = Manager.module.getModuleByID(ModuleID.HUD) as HUDModule;
			if (hudModule != null) {
				hudModule.updateHUDButtonStatus(ModuleID.SOUL_CENTER, false);
			}
		}
		
		/**
		 * update TEMP inventory
		 * @param	responseSoulInfo
		 */
		public function updateSoulInfo(responseSoulInfo:ResponseSoulInfo):void
		{
			Game.mouseEnable = true;
			this.currentData = responseSoulInfo;
			
			if (baseView != null)
				SoulCenterView(baseView).soulPanel.divinePanel.setData(this.currentData);
		}
		
		override protected function preTransitionIn():void
		{
			super.preTransitionIn();
			//Game.stage.addEventListener(InventoryView.CHARACTER_SLOT_CLICK, onChangeCharacter);
			Game.stage.addEventListener(InventoryView.CHARACTER_SLOT_CLICK, onChangeCharacter);
			Game.network.lobby.addEventListener(Server.SERVER_DATA, onLobbyServerData);
			
			Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.GET_SOUL_INFO));
			Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.SOUL_INVENTORY));
			
			inventory.x = -535 + 108;
			inventory.y = 0;
			SoulCenterView(baseView).attachSoulPanel.addChild(inventory);
			inventory.setMode(InventoryMode.SOUL_CENTER);
			inventory.transitionIn();
			
			if (baseView != null && this.currentData != null)
			{
				SoulCenterView(baseView).soulPanel.divinePanel.setData(this.currentData);
				SoulCenterView(baseView).resetUI();
			}
		}
		
		private function get inventory():InventoryView
		{
			return Manager.module.getModuleByID(ModuleID.INVENTORY_UNIT).baseView as InventoryView;
		}
	}

}