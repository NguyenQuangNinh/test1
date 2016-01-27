/**
 * Created by merino on 1/6/2015.
 */
package game.ui.divine_weapon.gui.panels {
import core.event.EventEx;

import flash.display.MovieClip;
import flash.display.SimpleButton;
import flash.events.MouseEvent;

import game.data.model.Character;
import game.ui.components.characterslot.CharacterSlotAnimation;
import game.ui.divine_weapon.DivineWeaponEvent;

public class DivineWeaponPanelEquip extends MovieClip
{
    public var btnWeaponUnequip:SimpleButton;
    public var btnWeaponEquip:SimpleButton;
    public var dummyCharacter:MovieClip;
    public var characterContainer:MovieClip;
    public var characterSlot:CharacterSlotAnimation;

    public function DivineWeaponPanelEquip() {
        btnWeaponEquip.enabled = btnWeaponEquip.visible = false;
        btnWeaponUnequip.enabled = btnWeaponUnequip.visible = false;
        btnWeaponEquip.addEventListener(MouseEvent.CLICK, onBtnWeaponEquipClicked);
        btnWeaponUnequip.addEventListener(MouseEvent.CLICK, onBtnWeaponUnequipClicked);

        characterSlot = new CharacterSlotAnimation();
        characterSlot.mouseChildren = false;
        characterSlot.doubleClickEnabled = true;
        characterContainer.addChild(characterSlot);
        characterSlot.addEventListener(MouseEvent.DOUBLE_CLICK, characterSlot_onDBClicked);
        resetCharaterSlot();
    }

    private function onBtnWeaponEquipClicked(e:MouseEvent):void
    {
       this.dispatchEvent(new EventEx(DivineWeaponEvent.CLICK_BUTTON_EQUIP_WEAPON, null, true));
    }

    private function onBtnWeaponUnequipClicked(e:MouseEvent):void
    {
        this.dispatchEvent(new EventEx(DivineWeaponEvent.CLICK_BUTTON_UNEQUIP_WEAPON, null, true));
    }

    public function updateCharacter(character:Character):void{
        characterSlot.setData(character);
        characterSlot.visible = true;
        dummyCharacter.visible = false;
        btnWeaponUnequip.enabled = btnWeaponUnequip.visible = true;
        btnWeaponEquip.enabled = btnWeaponEquip.visible = true;
    }

    private function characterSlot_onDBClicked(e:MouseEvent):void
    {
        resetCharaterSlot();
    }

    public function resetCharaterSlot():void{
        dummyCharacter.visible = true;
        characterSlot.visible = false;
        btnWeaponEquip.enabled = btnWeaponEquip.visible = false;
        btnWeaponUnequip.enabled = btnWeaponUnequip.visible = false;
        this.dispatchEvent(new EventEx(DivineWeaponEvent.RESET_CHARACTER_SLOT, null, true));
    }
}
}
