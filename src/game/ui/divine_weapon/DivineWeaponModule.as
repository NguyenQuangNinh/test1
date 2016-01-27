/**
 * Created by dinhhq on 1/5/2015.
 */
package game.ui.divine_weapon {
import core.Manager;
import core.display.ModuleBase;
import core.display.layer.Layer;
import core.display.layer.LayerManager;
import core.event.EventEx;
import core.util.Enum;
import core.util.Utility;

import flash.events.Event;
import flash.geom.Point;
import flash.utils.setTimeout;

import game.Game;
import game.data.model.Character;
import game.data.model.Inventory;
import game.data.model.item.DivineWeaponItem;
import game.enum.DialogEventType;
import game.enum.Element;
import game.enum.InventoryMode;
import game.enum.ItemType;
import game.enum.PlayerAttributeID;
import game.enum.ShopID;
import game.enum.SlotUnlockType;
import game.net.IntRequestPacket;
import game.net.IntResponsePacket;
import game.net.RequestPacket;
import game.net.ResponsePacket;
import game.net.Server;
import game.net.lobby.LobbyRequestType;
import game.net.lobby.LobbyResponseType;
import game.net.lobby.request.RequestDivineWeaponArrayPacket;
import game.net.lobby.request.RequestDivineWeaponEquipItem;
import game.net.lobby.request.RequestDivineWeaponUnequipItem;
import game.net.lobby.response.ResponseErrorCode;
import game.ui.ModuleID;
import game.ui.dialog.DialogID;
import game.ui.dialog.dialogs.YesNo;
import game.ui.divine_weapon.gui.DivineWeaponItemSlot;
import game.ui.divine_weapon.gui.panels.DivineWeaponSubPanelUpgradeStar;
import game.ui.hud.HUDModule;
import game.ui.inventory.InventoryView;

public class DivineWeaponModule extends ModuleBase
{
    private var isAutoBuyMaterial:Boolean = false;
    private var _baseViewRef:DivineWeaponView;

    public function DivineWeaponModule() {
        relatedModuleIDs = [ModuleID.INVENTORY_UNIT];
    }

    override protected function createView():void {
        super.createView();
        baseView = new DivineWeaponView();
        _baseViewRef = baseView as DivineWeaponView;
        _baseViewRef.addEventListener(DivineWeaponEvent.HIDE_DIVINE_WEAPON_UI, onHideDivineWeaponUI);
        _baseViewRef.addEventListener(DivineWeaponEvent.AUTO_BUY_MATERIAL_CHANGE_STATE, onAutoBuyStateChanged);
        _baseViewRef.addEventListener(DivineWeaponEvent.CLICK_BUTTON_UPGRADE_WEAPON_ATTRIB, onClickBtnUpgradeAttrib);
        _baseViewRef.addEventListener(DivineWeaponEvent.CLICK_BUTTON_EQUIP_WEAPON, onClickBtnEquipWeapon);
        _baseViewRef.addEventListener(DivineWeaponEvent.CLICK_BUTTON_UNEQUIP_WEAPON, onClickBtnUnequipWeapon);
        _baseViewRef.addEventListener(DivineWeaponEvent.RESET_CHARACTER_SLOT, onResetCharacterSlot);
        _baseViewRef.addEventListener(DivineWeaponEvent.CLICK_BUTTON_LOCK_WEAPON, onClickBtnLockWeapon);
        _baseViewRef.addEventListener(DivineWeaponEvent.DIVINE_WEAPON_LOCK_ITEM, onLockItemRequest);
        _baseViewRef.addEventListener(DivineWeaponEvent.DIVINE_WEAPON_DESTROY_ITEM, onDestroyItemRequest);
        _baseViewRef.addEventListener(DivineWeaponSubPanelUpgradeStar.CLICK_BUTTON_KEEP_LUCK, onClickBtnKeepLuckUpStar);
        _baseViewRef.addEventListener(DivineWeaponSubPanelUpgradeStar.CLICK_BUTTON_UPGRADE_STAR, onClickBtnUpgradeStar);
        _baseViewRef.addEventListener(DivineWeaponItemSlot.DW_UNLOCK_SLOT, onUnlockSlotHandler);
    }

    private function onUnlockSlotHandler(event:Event):void {
        var slotList:Array = Game.database.gamedata.getConfigData(289) as Array;
        var xuList:Array = Game.database.gamedata.getConfigData(285) as Array;
        var initCapacity:int = 25;
        ;
        var addedSlot:int = Game.database.inventory.getDWItems().length - initCapacity;

        var unlockIndex:int = 0
        for (var i:int = 0; i < slotList.length; i++)
        {
            addedSlot = addedSlot - slotList[i];

            if (addedSlot < 0)
            {
                unlockIndex = i;
                break;
            }
        }
        if (addedSlot >= 0)
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
            Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.UNLOCK_SLOT, SlotUnlockType.DIVINE_WEAPON));
            Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.DIVINE_WEAPON_INVENTORY));
        }, null, {type: DialogEventType.CONFIRM_UNLOCK_DW_INVENTORY, xu: xuList[unlockIndex], slot: slotList[unlockIndex]}, Layer.BLOCK_BLACK);
    }

    private function onClickBtnUpgradeStar(event:Event):void {
        Game.network.lobby.sendPacket(new RequestDivineWeaponArrayPacket(LobbyRequestType.DIVINE_WEAPON_UPGRADE_STAR,
                [_baseViewRef.currentSelectedDWItem.slotIndex, isAutoBuyMaterial]));
        Game.network.lobby.getPlayerAttribute(PlayerAttributeID.GOLD);
        Game.network.lobby.getPlayerAttribute(PlayerAttributeID.XU);
    }

    private function onClickBtnKeepLuckUpStar(event:Event):void {
        var quantity:int = Game.database.inventory.getItemsByType(ItemType.KEEP_LUCK).length;
        var list:Array = Game.database.gamedata.getAllItems(ItemType.KEEP_LUCK);

        if(list.length > 0)
        {
            if(quantity > 0)
            {
                Manager.display.showDialog(DialogID.YES_NO, onAcceptKeepLuckHdl, null, {title: "THÔNG BÁO", message: "Bạn có muốn sử dụng vật phẩm " + list[0].name + " để giữ chúc phúc?", option: YesNo.YES | YesNo.NO});
            }
            else
            {
                Manager.display.showMessage("Không đủ vật phẩm " + list[0].name);
                setTimeout(Manager.display.showModule, 1200, ModuleID.SHOP_ITEM, new Point(0, 0), LayerManager.LAYER_POPUP, "top_left", Layer.BLOCK_BLACK, ShopID.ITEM.ID);
            }
        }
    }

    private function onAcceptKeepLuckHdl(data:Object):void
    {
        Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.DIVINE_WEAPON_LOCK_LUCKY_POINT, _baseViewRef.currentSelectedDWItem.slotIndex));
        trace("Keep luck on dw item " + _baseViewRef.currentSelectedDWItem.slotIndex);
    }

    private function onDestroyItemRequest(event:EventEx):void {
        var dwItem:DivineWeaponItem = event.data as DivineWeaponItem;
        Manager.display.showDialog(DialogID.YES_NO, onAcceptDestroyItemHdl, null,
                {title: "THÔNG BÁO", message: "Bạn có muốn xóa vật phẩm " + dwItem.dwXML.name + " (cấp " + dwItem.dwXML.level + ")?", dwItem: dwItem,option: YesNo.YES | YesNo.NO});
    }

    private function onAcceptDestroyItemHdl(data:Object):void{
        var dwItem:DivineWeaponItem = data.dwItem;
        Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.DIVINE_WEAPON_DESTROY_ITEM, dwItem.slotIndex));
        trace(dwItem.slotIndex + "    " + dwItem.dwXML.name);
    }

    private function onLockItemRequest(event:EventEx):void {
        var dwItem:DivineWeaponItem = event.data as DivineWeaponItem;
        Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.DIVINE_WEAPON_LOCK_ITEM, dwItem.slotIndex));
        trace(dwItem.slotIndex + "    " +dwItem.dwXML.name);
    }

    private function onClickBtnUnequipWeapon(event:EventEx):void {
        if (inventory.getCurrentCharacterSelected() >= 0){
            Game.network.lobby.sendPacket(new RequestDivineWeaponUnequipItem(inventory.getCurrentCharacterSelected()));
        }
    }

    private function onClickBtnLockWeapon(event:EventEx):void {

    }

    private function onResetCharacterSlot(event:EventEx):void {
        _baseViewRef.weaponInventoryUI.updateFilterByElement();
        inventory.selectSlot(-1);
    }

    private function onClickBtnEquipWeapon(event:EventEx):void {
        var currentDWItem:DivineWeaponItem = _baseViewRef.currentSelectedDWItem;
        if (currentDWItem == null){
            Manager.display.showMessageID(1039);
            return
        }
        if (currentDWItem.bIsEquiped){
            Manager.display.showMessageID(1037);
            return
        }
        if (inventory.getCurrentCharacterSelected() >= 0){
            trace(inventory.getCurrentCharacterSelected())
            trace(_baseViewRef.currentSelectedDWItem.slotIndex)
            Game.network.lobby.sendPacket(new RequestDivineWeaponEquipItem(inventory.getCurrentCharacterSelected(), _baseViewRef.currentSelectedDWItem.slotIndex));
        }
    }

    private function onClickBtnUpgradeAttrib(event:EventEx):void {
        trace("button upgrade attrib on clicked")
        trace("attrib index " + _baseViewRef.currentSelectedAttrib.index)
        trace("weapon index " + _baseViewRef.currentSelectedDWItem.slotIndex)
        if (_baseViewRef.currentSelectedAttrib.dwParentItem == _baseViewRef.currentSelectedDWItem){
            trace("du lieu dong bo")
            Game.network.lobby.sendPacket(new RequestDivineWeaponArrayPacket(LobbyRequestType.DIVINE_WEAPON_UPGRADE_ATTRIB,
                                        [_baseViewRef.currentSelectedDWItem.slotIndex, _baseViewRef.currentSelectedAttrib.index]));
            Game.network.lobby.getPlayerAttribute(PlayerAttributeID.GOLD);
        }else Utility.log("du lieu khong dong bo");
    }

    private function onAutoBuyStateChanged(event:EventEx):void {
        isAutoBuyMaterial = event.data.Checked;
    }

    private function onHideDivineWeaponUI(e:EventEx):void
    {
        var hudModule:HUDModule = Manager.module.getModuleByID(ModuleID.HUD) as HUDModule;
        if (hudModule != null)
        {
            hudModule.updateHUDButtonStatus(ModuleID.DIVINE_WEAPON, false);
        }
    }

    override protected function preTransitionIn():void {
        super.preTransitionIn();
        _baseViewRef.pnlWeaponEquip.addChild(inventory);
        inventory.setMode(InventoryMode.DIVINE_WEAPON);
        inventory.x = (-inventory.width)+10;
        inventory.y = -3;
        inventory.transitionIn();
        Game.stage.addEventListener(InventoryView.CHARACTER_SLOT_CLICK, onChangeCharacter);
        Game.database.inventory.addEventListener(Inventory.UPDATE_DIVINE_WEAPON, onUpdateDivineWeapon);
        Game.database.inventory.addEventListener(Inventory.UPDATE_ITEM, onUpdateInventoryItems);
        Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.DIVINE_WEAPON_INVENTORY));
        Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.GET_ITEM_INVENTORY));
        Game.network.lobby.addEventListener(Server.SERVER_DATA, onLobbyServerData);
    }

    private function onLobbyServerData(event:EventEx):void {
        var packet:ResponsePacket = ResponsePacket(event.data);
        switch (packet.type){
            case LobbyResponseType.DIVINE_WEAPON_EQUIP_ITEM:
                onEquipItemResult(packet as IntResponsePacket);
                break;
            case LobbyResponseType.DIVINE_WEAPON_UNEQUIP_ITEM:
                onUnequipItemResult(packet as IntResponsePacket);
                break;
            case LobbyResponseType.DIVINE_WEAPON_LOCK_ITEM:
                onLockItemResult(packet as IntResponsePacket);
                break
            case LobbyResponseType.DIVINE_WEAPON_DESTROY_ITEM:
                onDestroyItemResult(packet as IntResponsePacket);
                break;
            case LobbyResponseType.DIVINE_WEAPON_UPGRADE_ATTRIB:
                onUpgradeAttribResult(packet as IntResponsePacket);
                break;
            case LobbyResponseType.DIVINE_WEAPON_LOCK_LUCKY_POINT:
                onLockLuckyPointResult(packet as IntResponsePacket);
                break;
            case LobbyResponseType.DIVINE_WEAPON_UPGRADE_STAR:
                onUpgradeStarResult(packet as IntResponsePacket);
                break;
            case LobbyResponseType.ERROR_CODE:
                var packetErrorCode:ResponseErrorCode = packet as ResponseErrorCode;

        }
    }

    private function onUpgradeStarResult(intResponsePacket:IntResponsePacket):void {
        Utility.log("DivineWeapon onUpgradeStarResult result : " + intResponsePacket.value);
        switch (intResponsePacket.value){
            case 0:
                _baseViewRef.iUpdateStarProgress = 2;
                break;
            case 3:
                Manager.display.showMessageID(1044);//item not found
                break;
            case 5:
                Manager.display.showMessageID(1045);//không đủ nguyên liệu
                break;
            case 6:
                Manager.display.showMessageID(152);//không đủ vàng
                break;
            case 7:
                Manager.display.showMessageID(1048);//không thấy nguyên liệu trong cửa hàng
                break;
            case 9:
                Manager.display.showMessageID(1049);//thuộc tính chưa đủ cấp
                break;
        }
    }

    private function onLockLuckyPointResult(intResponsePacket:IntResponsePacket):void {
        Utility.log("DivineWeapon onLockLuckyPointResult result : " + intResponsePacket.value);
        switch (intResponsePacket.value){
            case 0:
                _baseViewRef.pnlWeaponUpgrade.subPnlStarUpgrade.lockLuckyPointSucceed();
                Manager.display.showMessageID(1050);
                break;
            case 3: //item not found
                break;
        }
    }

    private function onUpgradeAttribResult(intResponsePacket:IntResponsePacket):void {
        Utility.log("DivineWeapon onUpgradeAttribResult result : " + intResponsePacket.value);
        switch (intResponsePacket.value){
            case 0:
                _baseViewRef.iUpdateAttribProgress = 2;
                trace("attrib lv: " + _baseViewRef.currentSelectedAttrib.attributeLevel)
                trace("weapon lv: " + _baseViewRef.currentSelectedDWItem.dwXML.level)
                break;
            case 3:
                Manager.display.showMessageID(1044);
                break;
            case 5:
                Manager.display.showMessageID(1045);
                break;
            case 6:
                Manager.display.showMessageID(1046);
                break;
            case 7:
                Manager.display.showMessageID(1047);
                break;
        }
    }

    private function onDestroyItemResult(intResponsePacket:IntResponsePacket):void {
        Utility.log("DivineWeapon onDestroyItemResult result : " + intResponsePacket.value);
        //switch
    }

    private function onLockItemResult(intResponsePacket:IntResponsePacket):void {
        Utility.log("DivineWeapon onLockItemResult result : " + intResponsePacket.value);
    }

    private function onUnequipItemResult(intResponsePacket:IntResponsePacket):void {
        Utility.log("DivineWeapon onUnequipItemResult result : " + intResponsePacket.value);
        switch (intResponsePacket.value){
            case 0:
                Manager.display.showMessageID(1041);
                break;
            case 1:
                Manager.display.showMessageID(1042);
                break
        }
    }

    private function onEquipItemResult(intResponsePacket:IntResponsePacket):void {
        Utility.log("DivineWeapon onEquipDWItemResponse result : " + intResponsePacket.value);
        switch (intResponsePacket.value){
            case 0:
                Manager.display.showMessageID(1038);
                break;
            case 1:
                Manager.display.showMessageID(1040);
                break
            case 4:
                Manager.display.showMessageID(1037);
                break;
            case 5:
                Manager.display.showMessageID(1043);
                break;
        }
    }


    override protected function onTransitionInComplete():void {
        super.onTransitionInComplete();
        _baseViewRef.weaponInventoryUI.update();
        _baseViewRef.weaponInventoryUI.updateFilterByElement();
    }

    private function onUpdateDivineWeapon(event:Event):void {
        trace("on update divine weapon inventory")
        _baseViewRef.weaponInventoryUI.update();
        _baseViewRef.weaponInventoryUI.updateFilterByElement();
        _baseViewRef.inventoriesUpdated();
    }

    private function onUpdateInventoryItems(event:Event):void {
        trace("on update item inventory")
        _baseViewRef.inventoriesUpdated();
    }

    override protected function preTransitionOut():void {
        super.preTransitionOut();
        _baseViewRef.resetView();
        if (Game.stage.hasEventListener(InventoryView.CHARACTER_SLOT_CLICK))
            Game.stage.removeEventListener(InventoryView.CHARACTER_SLOT_CLICK, onChangeCharacter);
    }

    override protected function onTransitionOutComplete():void {
        super.onTransitionOutComplete();
        Game.network.lobby.removeEventListener(Server.SERVER_DATA, onLobbyServerData);
        Game.database.inventory.removeEventListener(Inventory.UPDATE_DIVINE_WEAPON, onUpdateDivineWeapon);
        Game.database.inventory.removeEventListener(Inventory.UPDATE_ITEM, onUpdateInventoryItems);
        Game.network.lobby.removeEventListener(Server.SERVER_DATA, onLobbyServerData);
    }

    private function get inventory():InventoryView
    {
        return Manager.module.getModuleByID(ModuleID.INVENTORY_UNIT).baseView as InventoryView;
    }

    private function onChangeCharacter(e:EventEx):void{
        if (inventory.getCurrentCharacterSelected() < 0){
            return
        }
        var character:Character = e.data as Character;
        if (character != null && !character.isMystical() && character.level >= 60){
            _baseViewRef.updateCharacter(character);
            _baseViewRef.weaponInventoryUI.updateFilterByElement(Enum.getEnum(Element, character.element) as Element);
            trace("has divine weapon???? " + character.hasDivineWeapon())
            trace("equiped divine weapon index: " + character.divineWeaponEquiped);
        }
    }
}
}
