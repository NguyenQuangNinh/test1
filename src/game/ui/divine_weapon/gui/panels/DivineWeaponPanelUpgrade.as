/**
 * Created by merino on 1/27/2015.
 */
package game.ui.divine_weapon.gui.panels {

import core.Manager;
import core.event.EventEx;

import flash.display.MovieClip;
import flash.display.SimpleButton;
import flash.events.MouseEvent;

import game.data.model.item.DivineWeaponItem;
import game.ui.divine_weapon.DivineWeaponEvent;

public class DivineWeaponPanelUpgrade extends MovieClip{
    public var subPnlAttribUpgrade:DivineWeaponSubPanelUpgradeAttrib;
    public var subPnlStarUpgrade:DivineWeaponSubPanelUpgradeStar;
    public var btnUpgradeAttrib: SimpleButton;
    public var btnUpgradeStar: SimpleButton;
    private var _isActive: Boolean = false;

    public function DivineWeaponPanelUpgrade() {
        _isActive = false;
        subPnlAttribUpgrade.visible = false;
        subPnlStarUpgrade.visible = false;
        btnUpgradeAttrib.visible = btnUpgradeStar.visible = _isActive;
        btnUpgradeAttrib.enabled = btnUpgradeStar.enabled = _isActive;
        btnUpgradeAttrib.addEventListener(MouseEvent.CLICK, onClickBtnUpgradeAttrib);
        btnUpgradeStar.addEventListener(MouseEvent.CLICK, onClickBtnUpgradeStar);
    }

    private function onClickBtnUpgradeStar(event:MouseEvent):void {
        btnUpgradeStar.dispatchEvent(new EventEx(DivineWeaponEvent.ACTIVE_STAR_UPGRADE_PANEL, null, true));
    }

    private function onClickBtnUpgradeAttrib(event:MouseEvent):void {
        btnUpgradeAttrib.dispatchEvent(new EventEx(DivineWeaponEvent.ACTIVE_ATTRIB_UPGRADE_PANEL, null, true));
    }

    public function setState(active:Boolean):void{
        this._isActive = active
        btnUpgradeAttrib.visible = btnUpgradeStar.visible = _isActive;
        btnUpgradeAttrib.enabled = btnUpgradeStar.enabled = _isActive;
        subPnlAttribUpgrade.visible = false;
        subPnlAttribUpgrade.reset();
        subPnlStarUpgrade.visible = false;
        subPnlStarUpgrade.reset();
    }

    public function activeAttribUpgradePanel(dwItem:DivineWeaponItem):void{
        setState(true);
        subPnlAttribUpgrade.isActive = true;
        subPnlAttribUpgrade.setDWItemInfo(dwItem);
        subPnlStarUpgrade.isActive = false;
        btnUpgradeAttrib.visible = false
    }

    public function activeStarUpgradePanel(dwItem:DivineWeaponItem):void{
        if (dwItem.isMaxLevel())
        {
            Manager.display.showMessageID(1036);
            return;
        }
        setState(true);
        subPnlStarUpgrade.isActive = true;
        subPnlStarUpgrade.setDWItemInfo(dwItem);
        subPnlAttribUpgrade.isActive = false;
        btnUpgradeStar.visible = false;
    }
}
}
