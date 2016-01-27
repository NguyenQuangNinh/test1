/**
 * Created by dinhhq on 1/5/2015.
 */
package game.ui.divine_weapon {
import core.display.ViewBase;
import core.event.EventEx;

import flash.display.SimpleButton;
import flash.events.MouseEvent;
import flash.geom.Point;

import game.Game;
import game.data.model.Character;
import game.data.model.item.DivineWeaponItem;
import game.ui.components.ToggleMov;
import game.ui.divine_weapon.gui.DivineWeaponInventoryUI;
import game.ui.divine_weapon.gui.DivineWeaponItemSlot;
import game.ui.divine_weapon.gui.DivineWeaponTabEquip;
import game.ui.divine_weapon.gui.DivineWeaponTabRefine;
import game.ui.divine_weapon.gui.DivineWeaponTabUpgrade;
import game.ui.divine_weapon.gui.DivineWeaponWeaponInfo;
import game.ui.divine_weapon.gui.panels.DivineWeaponPanelEquip;
import game.ui.divine_weapon.gui.panels.DivineWeaponPanelRefine;
import game.ui.divine_weapon.gui.panels.DivineWeaponPanelUpgrade;
import game.utility.UtilityUI;

public class DivineWeaponView extends ViewBase
{
    public var tabDivineWeaponEquip:DivineWeaponTabEquip;
    public var tabDivineWeaponUpgrade:DivineWeaponTabUpgrade;
    public var tabDivineWeaponRefine:DivineWeaponTabRefine;
    public var pnlWeaponEquip:DivineWeaponPanelEquip;
    public var pnlWeaponUpgrade:DivineWeaponPanelUpgrade;
    public var pnlWeaponRefine:DivineWeaponPanelRefine;
    public var weaponInventoryUI:DivineWeaponInventoryUI;
    private var _currentTab: ToggleMov;
    public var dwWeaponInfo:DivineWeaponWeaponInfo;
    public var currentSelectedDWItem:DivineWeaponItem;
    public var currentSelectedAttrib:DivineWeaponAttribute;
    private var closeBtn:SimpleButton;
    public var iUpdateAttribProgress:int = -1;
    public var iUpdateStarProgress:int = -1;

    public function DivineWeaponView() {
        this.addEventListener(DivineWeaponItemSlot.DW_SLOT_DBCLICK, onDWSlotDbClicked);
        this.addEventListener(DivineWeaponEvent.ACTIVE_ATTRIB_UPGRADE_PANEL, attribUpgradeHandler);
        this.addEventListener(DivineWeaponEvent.SELECT_ATTRIB_TO_UPGRADE, onSelectAttribToUpgrade);
        this.addEventListener(DivineWeaponEvent.ACTIVE_STAR_UPGRADE_PANEL, starUpgradeHandler);
        closeBtn = UtilityUI.getComponent(UtilityUI.CLOSE_BTN) as SimpleButton;
        if (closeBtn != null)
        {
            var point:Point = this.globalToLocal(new Point(1016,45));
            closeBtn.x = point.x;
            closeBtn.y = point.y;
            addChild(closeBtn);
            closeBtn.addEventListener(MouseEvent.CLICK, closeDivineWeaponHandler);
        }

        tabDivineWeaponEquip.addEventListener(MouseEvent.CLICK, tabClickedHandler);
        tabDivineWeaponUpgrade.addEventListener(MouseEvent.CLICK, tabClickedHandler);
        tabDivineWeaponRefine.addEventListener(MouseEvent.CLICK, tabClickedHandler);
        showTab(tabDivineWeaponEquip);
    }

    private function starUpgradeHandler(event:EventEx):void {
        if (this.currentSelectedDWItem == null)
            return

        pnlWeaponUpgrade.activeStarUpgradePanel(this.currentSelectedDWItem);
    }

    private function attribUpgradeHandler(event:EventEx):void {
        if (this.currentSelectedDWItem == null)
            return

        pnlWeaponUpgrade.activeAttribUpgradePanel(this.currentSelectedDWItem);
    }

    private function onSelectAttribToUpgrade(event:EventEx):void {
        var attrib:DivineWeaponAttribute = event.data as DivineWeaponAttribute;
        if (attrib != null && attrib.dwParentItem == this.currentSelectedDWItem){
            currentSelectedAttrib = attrib;
            pnlWeaponUpgrade.subPnlAttribUpgrade.setAttribUpgradeInfo(currentSelectedDWItem, attrib.index);
        }
    }

    public function inventoriesUpdated():void{
        upgradeAttribSucceeded();
        upgradeStarSucceeded();
    }

    public function upgradeAttribSucceeded():void{
        if (iUpdateAttribProgress < 0 )
            return
        if (iUpdateAttribProgress > 0){
            iUpdateAttribProgress--;
        }
        if (iUpdateAttribProgress == 0){
            var oldItemIdx:int = currentSelectedDWItem.slotIndex;
            var oldAttribIdx:int = currentSelectedAttrib.index;
            this.currentSelectedDWItem = Game.database.inventory.getDWItemByIndex(oldItemIdx);
            if (!this.currentSelectedDWItem){
                resetView();
                return
            }
            this.currentSelectedAttrib = this.currentSelectedDWItem.getSingleAttrib(oldAttribIdx);
            pnlWeaponUpgrade.activeAttribUpgradePanel(this.currentSelectedDWItem);
            pnlWeaponUpgrade.subPnlAttribUpgrade.setAttribUpgradeInfo(currentSelectedDWItem, this.currentSelectedAttrib.index);
            dwWeaponInfo.setData(this.currentSelectedDWItem);
            trace("update thong tin attrib va item thanh cong")
            iUpdateAttribProgress = -1;
        }
    }

    public function upgradeStarSucceeded():void{
        if (iUpdateStarProgress < 0 )
            return
        if (iUpdateStarProgress > 0){
            iUpdateStarProgress--;
        }
        if (iUpdateStarProgress == 0){
            var oldItemIdx:int = currentSelectedDWItem.slotIndex;
            this.currentSelectedDWItem = Game.database.inventory.getDWItemByIndex(oldItemIdx);
            if (!this.currentSelectedDWItem){
                resetView();
                return
            }
            pnlWeaponUpgrade.activeStarUpgradePanel(this.currentSelectedDWItem);
            dwWeaponInfo.setData(this.currentSelectedDWItem);
            iUpdateStarProgress = -1;
        }
    }

    private function onDWSlotDbClicked(event:EventEx):void {
        var dwItem:DivineWeaponItem = event.data as DivineWeaponItem;
        this.currentSelectedDWItem = dwItem;
        this.currentSelectedAttrib = null;
        dwWeaponInfo.setData(dwItem);
        pnlWeaponUpgrade.setState(true);

        trace("lock state " + dwItem.bIsLocked)
        trace("equip state " + dwItem.bIsEquiped)
    }

    private function closeDivineWeaponHandler(e:MouseEvent):void
    {
        this.dispatchEvent(new EventEx(DivineWeaponEvent.HIDE_DIVINE_WEAPON_UI, this, true));
    }

    private function tabClickedHandler(e: MouseEvent):void
    {
        showTab(e.target as ToggleMov);
    }

    private function showTab(tab:ToggleMov):void
    {
        if (tab == _currentTab)
            return;

        if (_currentTab == tabDivineWeaponEquip) {
            pnlWeaponEquip.resetCharaterSlot();
        }

        _currentTab = tab;

        resetView();
        dwWeaponInfo.setLayout((_currentTab == tabDivineWeaponEquip)? 1: 2);

        weaponInventoryUI.updateFilterByElement();

        tabDivineWeaponEquip.isActive = _currentTab == tabDivineWeaponEquip;
        pnlWeaponEquip.visible = _currentTab == tabDivineWeaponEquip;
        tabDivineWeaponUpgrade.isActive = _currentTab  == tabDivineWeaponUpgrade;
        pnlWeaponUpgrade.visible = _currentTab == tabDivineWeaponUpgrade;
        tabDivineWeaponRefine.isActive = _currentTab == tabDivineWeaponRefine;
        pnlWeaponRefine.visible = _currentTab == tabDivineWeaponRefine;
    }

    public function resetView():void{
        this.currentSelectedDWItem = null;
        this.currentSelectedAttrib = null;
        pnlWeaponUpgrade.setState(false);
        dwWeaponInfo.reset();
        pnlWeaponEquip.resetCharaterSlot();
        weaponInventoryUI.reset();
    }

    public function updateCharacter(character:Character):void{
        this.currentSelectedDWItem = null;
        pnlWeaponUpgrade.setState(false);
        dwWeaponInfo.reset();
        if (character.hasDivineWeapon()){
            var equipedWeapon:DivineWeaponItem = Game.database.inventory.getDWItemByIndex(character.divineWeaponEquiped);
            if (equipedWeapon){
                dwWeaponInfo.setData(equipedWeapon);
            }
        }
        pnlWeaponEquip.updateCharacter(character);
    }

}
}
