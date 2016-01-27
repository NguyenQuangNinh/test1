package game.ui.inventoryitem
{
	import core.Manager;
	import core.display.ModuleBase;
	import core.display.layer.Layer;
	import core.event.EventEx;
	import core.util.Utility;
	import game.net.lobby.response.ResponseErrorCode;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import game.Game;
	import game.data.model.Inventory;
	import game.data.model.UserData;
	import game.enum.DialogEventType;
	import game.enum.DragDropEvent;
	import game.enum.ErrorCode;
	import game.enum.GameConfigID;
	import game.enum.SlotUnlockType;
	import game.net.IntRequestPacket;
	import game.net.IntResponsePacket;
	import game.net.RequestPacket;
	import game.net.ResponsePacket;
	import game.net.Server;
	import game.net.lobby.LobbyRequestType;
	import game.net.lobby.LobbyResponseType;
	import game.net.lobby.response.ResponseConsumeItem;
	import game.ui.ModuleID;
	import game.ui.dialog.DialogID;
	import game.ui.home.scene.CharacterManager;
	import game.ui.hud.HUDModule;
	import game.ui.inventoryitem.gui.ItemCell;
	
	/**
	 * ...
	 * @author anhtinh
	 */
	public class InventoryItemModule extends ModuleBase
	{
		
		public function InventoryItemModule()
		{
		
		}
		
		override protected function createView():void
		{
			super.createView();
			baseView = new InventoryItemView();
			baseView.addEventListener(InventoryItemEvent.HIDE_INVENTORY, onHideInventory);
			baseView.addEventListener(InventoryItemEvent.UNLOCK_SLOT, unlockSlotHandler);
			baseView.addEventListener(ItemCell.ITEM_SLOT_DRAG, onDragHdl);
		}
		
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
			obj.type = DragDropEvent.FROM_INVENTORY_ITEM;
			Game.drag.start(objDrag, obj);
		
		}
		
		private function unlockSlotHandler(e:EventEx):void
		{
			var slotList:Array = Game.database.gamedata.getConfigData(GameConfigID.UNLOCK_SLOT_ITEM_BLOCKS) as Array;
			var xuList:Array = Game.database.gamedata.getConfigData(GameConfigID.UNLOCK_SLOT_ITEM_COSTS) as Array;
			var initCapacity:int = Game.database.gamedata.getConfigData(GameConfigID.INIT_ITEM_INVENTORY_SIZE) as int;
			var addedSoul:int = Game.database.inventory.getAllItems().length - initCapacity;
			
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
					
					Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.UNLOCK_SLOT, SlotUnlockType.ITEM));
				}, null, {type: DialogEventType.CONFIRM_UNLOCK_INVENTORY_SLOT, xu: xuList[unlockIndex], slot: slotList[unlockIndex]}, Layer.BLOCK_BLACK);
		
		}
		
		override protected function onTransitionInComplete():void
		{
			super.onTransitionInComplete();
			Game.network.lobby.addEventListener(Server.SERVER_DATA, onLobbyServerData);
			Game.database.inventory.addEventListener(Inventory.UPDATE_ITEM, onInventoryItemUpdate);
			Game.database.userdata.addEventListener(UserData.UPDATE_PLAYER_INFO, onUpdatePlayerInfo);
			CharacterManager.instance.hideCharacters();
			
			Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.GET_ITEM_INVENTORY));
		}
		
		private function onUpdatePlayerInfo(e:Event):void
		{
			InventoryItemView(baseView).updateView();
		}
		
		private function onInventoryItemUpdate(e:Event):void
		{
			InventoryItemView(baseView).updateInventoryItemView();
			InventoryItemView(baseView).updateView();
		}
		
		override protected function onTransitionOutComplete():void
		{
			super.onTransitionOutComplete();
			Game.network.lobby.removeEventListener(Server.SERVER_DATA, onLobbyServerData);
			Game.database.inventory.removeEventListener(Inventory.UPDATE_ITEM, onInventoryItemUpdate);
			Game.database.userdata.removeEventListener(UserData.UPDATE_PLAYER_INFO, onUpdatePlayerInfo);
			CharacterManager.instance.displayCharacters();
		}
		
		private function onLobbyServerData(e:EventEx):void
		{
			var packet:ResponsePacket = ResponsePacket(e.data);
			switch (packet.type)
			{
				case LobbyResponseType.SELL_ITEM_INVENTORY: 
					onSellItemResponse(packet as IntResponsePacket);
					break;
				case LobbyResponseType.UNLOCK_SLOT: 
					onUnlockSlotResponse(packet as IntResponsePacket);
					break;
				case LobbyResponseType.CONSUME_ITEM: 
					onConsumeItemResponse(packet as ResponseConsumeItem);
					break;
				case LobbyResponseType.ERROR_CODE: 
					onErrorCode(packet as ResponseErrorCode);
					break;
			
			}
		}
		
		private function onErrorCode(packet:ResponseErrorCode):void
		{
			switch (packet.requestType)
			{
				case LobbyRequestType.SORT_ITEM_INVENTORY: 
					onSortItemResultResult(packet.errorCode);
					break;
				case LobbyRequestType.SWAP_ITEM_INVENTORY: 
					onSwapItemResultResult(packet.errorCode);
					break;
			}
		}
		
		private function onSortItemResultResult(errorCode:int):void
		{
			switch (errorCode)
			{
				case 0: //success
					//Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.GET_ITEM_INVENTORY));
					break;
				case 1: //fail
					
					break;
			}
		}
		
		private function onSwapItemResultResult(errorCode:int):void
		{
			switch (errorCode)
			{
				case 0: //success
					//Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.GET_ITEM_INVENTORY));
					break;
				case 1: //fail
					
					break;
			}
		}
		
		private function onConsumeItemResponse(packet:ResponseConsumeItem):void
		{
			Utility.log("onConsumeItemResponse : " + packet.errorCode);
			switch (packet.errorCode)
			{
				case ErrorCode.SUCCESS: //success
						if(packet.indexes.length > 0)
						{
							Manager.display.showMessage("Mở rương thành công ^^");
							InventoryItemView(baseView).playAnimOpenItem();
						}
						else
						{
							InventoryItemView(baseView).playAnimUnpackChest(packet.useSuccessQuantity);
							if(packet.quantity != packet.useSuccessQuantity)
							{
								Manager.display.showMessage("Chỉ có thể mở được " + packet.useSuccessQuantity + " vật phẩm.");
							}
						}
					Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.GET_PLAYER_INFO));
					break;
				case ErrorCode.FAIL: //fail
					break;
				case 2: //Full Inventory
					Manager.display.showMessageID(15);
					break;
				case 3: //Can co it nhat 1 slot trong
					Manager.display.showMessage("Cần có ít nhất 1 ô trống.");
					break;
				case 4: //Khong du so luong item
					Manager.display.showMessage("Không đủ số lượng vật phẩm");
					break;
				case 5: //qua so lan su dung
					Manager.display.showMessage("Đã quá số lần sử dụng");
					break;
				case 5: //Config sai
					Manager.display.showMessage("Dữ liệu nhập sai.");
					break;
			}
		}
		
		private function onUnlockSlotResponse(intResponsePacket:IntResponsePacket):void
		{
			Utility.log("onUnlockSlotResponse : " + intResponsePacket.value);
			switch (intResponsePacket.value)
			{
				case 0: 
					Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.GET_ITEM_INVENTORY));
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
		
		private function onSellItemResponse(intResponsePacket:IntResponsePacket):void
		{
			
			switch (intResponsePacket.value)
			{
				case 0: 
					Manager.display.showMessage("Xóa Item thành công ^^");
					break;
			}
		}
		
		private function onHideInventory(e:EventEx):void
		{
			var hudModule:HUDModule = Manager.module.getModuleByID(ModuleID.HUD) as HUDModule;
			if (hudModule != null)
			{
				hudModule.updateHUDButtonStatus(ModuleID.INVENTORY_ITEM, false);
			}
		}
	}

}