package game.net.lobby.response 
{
import flash.utils.ByteArray;

import game.Game;
import game.data.model.item.DivineWeaponItem;
import game.data.model.item.ItemFactory;
import game.enum.GameConfigID;
import game.enum.ItemType;
import game.net.ResponsePacket;
import game.ui.divine_weapon.DivineWeaponAttribute;

/**
	 * ...
	 * @author dinhhq
	 */
	public class ResponseDivineWeaponInventory extends ResponsePacket
	{
		
		public var divineWeapons:Array;
		
		override public function decode(data:ByteArray):void
		{
            var error:int = data.readInt();//error code
            var numOfDWItems:int = data.readInt();
            divineWeapons = createEmptySlotsInventory(numOfDWItems);
            var arrMaxLuckyPoint:Array = Game.database.gamedata.getConfigData(GameConfigID.DIVINE_WEAPON_MAX_LUCKY_POINT);
            for (var i:int = 0; i < numOfDWItems; i++){
                var slotIndex:int = data.readInt();
                if (slotIndex >= 0){
                    var id:int = data.readInt();
                    var dwItem:DivineWeaponItem;
                    dwItem = ItemFactory.createItem(ItemType.DIVINE_WEAPON, id, DivineWeaponItem) as DivineWeaponItem;
                    dwItem.slotIndex = slotIndex;
                    dwItem.bIsLocked = data.readBoolean();
                    dwItem.bIsEquiped = data.readBoolean();
                    dwItem.nUpStarLuckyPoint = data.readInt();
                    dwItem.maxLuckyPoint = arrMaxLuckyPoint[dwItem.dwXML.level];
                    dwItem.bIsKeepLuck = data.readBoolean();
                    //read weapon attributes
                    for (var j:int = 0; j < dwItem.dwXML.numbOfAttributes; j++) {
                        var nAttribID:int = data.readInt();
                        var nAttribLevel:int = data.readInt();
                        var bAttribIsLocked:Boolean = data.readBoolean();
                        var attrib:DivineWeaponAttribute = new DivineWeaponAttribute(dwItem, nAttribID, nAttribLevel);
                        attrib.isLocked = bAttribIsLocked;
                        dwItem.insertAttrib(attrib);
                    }
                    divineWeapons[slotIndex] = dwItem;
                }else
                {
                    break;
                }
            }
		}

        private function createEmptySlotsInventory(numOfItems:int):Array{
            var arrReturn:Array = [];
            for (var i:int = 0; i < numOfItems; i++){
                arrReturn.push(ItemFactory.createItem(ItemType.EMPTY_SLOT, 0, DivineWeaponItem) as DivineWeaponItem);
            }
            return arrReturn;
        }
		
	}

}