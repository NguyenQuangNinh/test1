package game.data.model
{
	import core.event.EventEx;
	import core.Manager;
	import core.util.Utility;

import game.data.model.item.DivineWeaponItem;
import game.data.xml.item.SoulXML;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import game.Game;
	import game.data.model.item.Item;
	import game.data.model.item.SoulItem;
	import game.enum.ItemType;
	import game.net.ResponsePacket;
	import game.net.Server;
	import game.net.lobby.LobbyResponseType;
import game.net.lobby.response.ResponseDivineWeaponInventory;
import game.net.lobby.response.ResponseItemInventory;
	import game.net.lobby.response.ResponseSoulInventory;
	
	/**
	 * ...
	 * @author anhtinh
	 */
	public class Inventory extends EventDispatcher
	{
		public static const UPDATE_ITEM:String = "updateItem";
		public static const UPDATE_SOUL:String = "updateSoul";
        public static const UPDATE_DIVINE_WEAPON:String = "updateDWInventory"
		
		private var items:Array;
		private var souls:Array;
        private var dwItems:Array;
		
		public function Inventory()
		{
			items = [];
			souls = [];
            dwItems = [];
			Game.network.lobby.addEventListener(Server.SERVER_DATA, onLobbyServerData);
		}
		
		private function onLobbyServerData(e:EventEx):void
		{
			var packet:ResponsePacket = e.data as ResponsePacket;
			switch (packet.type)
			{
				
				case LobbyResponseType.SOUL_INVENTORY: 
					onSoulInventoryResponse(packet as ResponseSoulInventory);
					break;
			    case LobbyResponseType.DIVINE_WEAPON_INVENTORY:
                    onDivineInventoryResponse(packet as ResponseDivineWeaponInventory);
                    break;
			}
		}

        private function onDivineInventoryResponse(responseDivineWeaponInventory:ResponseDivineWeaponInventory):void {
            this.dwItems = responseDivineWeaponInventory.divineWeapons;
            this.dispatchEvent(new Event(UPDATE_DIVINE_WEAPON));
        }
		
		private function onSoulInventoryResponse(responseSoulInventory:ResponseSoulInventory):void
		{
			updateSouls(responseSoulInventory.souls);
		
		}
		
		private function onUpdateItemResponse(responseInventoryInfo:ResponseItemInventory):void
		{
			updateItems(responseInventoryInfo.items);
		}
		
		public function updateItems(items:Array):void
		{
			this.items = items;
			this.dispatchEvent(new Event(UPDATE_ITEM));
		}
		
		public function updateSouls(souls:Array):void
		{
			this.souls = souls;
			this.dispatchEvent(new Event(UPDATE_SOUL));
		}
		
		public function getSouls():Array
		{
			return this.souls;
		}
		
		public function getFirstSlotSoulEmpty():SoulItem
		{
			
			for (var i:int = 0; i < this.souls.length; i++)
			{
				if (SoulItem(souls[i]).soulXML.ID == 0 && SoulItem(souls[i]).soulXML.type == ItemType.EMPTY_SLOT)
				{
					return SoulItem(souls[i]);
				}
			}
			return null;
		}
		
		public function isHaveEmptySoulSlot():Boolean
		{
			
			for (var i:int = 0; i < this.souls.length; i++)
			{
				if (SoulItem(souls[i]).soulXML.ID == 0 && SoulItem(souls[i]).soulXML.type == ItemType.EMPTY_SLOT)
				{
					return true;
				}
			}
			return false;
		
		}
		
		public function getNumEmptySoulSlotRemain():int
		{
			var result:int = 0;
			for (var i:int = 0; i < this.souls.length; i++)
			{
				if (SoulItem(souls[i]).soulXML.ID == 0 && SoulItem(souls[i]).soulXML.type == ItemType.EMPTY_SLOT)
				{
					result++;
				}
			}
			return result;
		}
		
		public function addSoul(soul:SoulItem):void
		{
			if (souls != null)
				this.souls.push(soul);
		
		}
		
		public function addItem(item:Item):void
		{
			if (item != null)
				this.items.push(item);
		
		}
		
		public function getItemsByFilter(filterType:int):Array
		{
			
			var itemsResult:Array = [];
			
			for each (var item:Item in this.items)
			{
				if (item && item.itemXML && item.itemXML.filterType == filterType)
					itemsResult.push(item);
			}
			
			return itemsResult;
		}
		
		public function getItemsByTypeAndID(type:ItemType, id:int):Array
		{
			
			var itemsResult:Array = [];
			
			for each (var item:Item in this.items)
			{
				if (item && item.itemXML && item.itemXML.type == type && item.itemXML.ID == id)
					itemsResult.push(item);
			}
			
			return itemsResult;
		}
		
		public function getItemsByType(type:ItemType):Array
		{
			
			var itemsResult:Array = [];
			
			for each (var item:Item in this.items)
			{
				if (item && item.itemXML && item.itemXML.type == type)
					itemsResult.push(item);
			}
			
			return itemsResult;
		}
		
		
		
		public function getAllItems():Array
		{
			return items;
		}

		public function getItemByIndex(index:int):Item
		{
			for (var i:int = 0; i < items.length; i++)
			{
				var item:Item = items[i] as Item;
				if(item.index == index) return item;
			}

			return null;
		}

		public function getItemsNotContainNull():Array
		{
			var itemsResult:Array = [];
			
			for each (var item:Item in this.items)
			{
				if (item && item.itemXML)
					itemsResult.push(item);
			}
			return itemsResult;
		}
		
		public function getAllItemsExceptType(type:ItemType):Array
		{
			
			var itemsResult:Array = [];
			
			for each (var item:Item in this.items)
			{
				if (item && item.itemXML && item.itemXML.type != type)
					itemsResult.push(item);
			}
			
			return itemsResult;
		
		}
		
		public function getItemQuantity(itemType:ItemType, itemID:int):int
		{
			var quantity:int = 0;
			var i:int;
			var length:int;
			var item:Item;
			for (i = 0, length = items.length; i < length; ++i)
			{
				item = items[i];
				if (item && item.itemXML && item.itemXML.type == itemType && item.itemXML.ID == itemID)
				{
					quantity += item.quantity;
				}
			}
			return quantity;
		}
		
		public function getItemsByArrayType(types:Array):Array
		{
			var itemsResult:Array = [];
			for each (var type:ItemType in types)
			{
				if (type)
				{
					for each (var item:Item in this.items)
					{
						if (item && item.itemXML && item.itemXML.type == type)
							itemsResult.push(item);
					}
				}
			}
			return itemsResult;
		}
		
		
		
		public function getSoulsAvailableByNumber(number:int, checkBadSoul:Boolean = true):Object {
			var result:Array = [];
			number = number < souls.length ? number : souls.length;
			var hasRare:Boolean = false;			
			var nextAvailable:int = 0;
			for (var i:int = 0; i < number; i++) {
				var index:int = getSoulIndexAvailable(nextAvailable);
				Utility.log("available index is " + index);
				var soul:SoulItem = index != -1 ? souls[index] as SoulItem : null;
				if (soul && !soul.locked && !soul.usedInMerge) {
					nextAvailable = index + 1;
					hasRare ||= soul.soulXML.isRare;
					result.push(soul);
				}
			}					
			Utility.log("num souls available is " + result.length);
			return { rare: hasRare, data: result };
		}
		
		private function getSoulIndexAvailable(startFrom:int):int {			
			var result:int = -1;
			
			if (startFrom >= 0 && startFrom < souls.length) {				
				for (var i:int = startFrom; i < souls.length; i++) {
					var soul:SoulItem = souls[i] as SoulItem;
					if (soul.soulXML.type != ItemType.EMPTY_SLOT && !soul.locked && !soul.usedInMerge) {
						result = i;
						break;
					}
				}
			}
				
			return result;
		}

        /*
        * divine weapon
        */
        public function getDWItems():Array{
            return dwItems;
        }

        public function getDWItemByIndex(index:int):DivineWeaponItem{
            if (index < 0 || index > dwItems.length){
                Utility.log("getDWItemByIndex index is out of bound : " + index);
                return null;
            }
            return dwItems[index];
        }

	}

}