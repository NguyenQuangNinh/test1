/**
 * Created by merino on 1/29/2015.
 */
package game.ui.divine_weapon.gui {
import core.event.EventEx;
import core.util.FontUtil;

import flash.display.MovieClip;
import flash.display.SimpleButton;
import flash.events.MouseEvent;
import flash.text.TextField;

import game.enum.Font;
import game.ui.divine_weapon.DivineWeaponAttribute;
import game.ui.divine_weapon.DivineWeaponEvent;

public class DivineWeaponAttribSelector extends MovieClip{
    public var tfAttribDesc:TextField;
    public var btnSelect:SimpleButton;
    private var _attrib:DivineWeaponAttribute;

    public function DivineWeaponAttribSelector() {
        FontUtil.setFont(tfAttribDesc, Font.ARIAL, true);
        btnSelect.addEventListener(MouseEvent.CLICK, onSelectAttrib)
    }

    private function onSelectAttrib(event:MouseEvent):void {
        if (btnSelect.enabled == false)
            return
        this.dispatchEvent(new EventEx(DivineWeaponEvent.SELECT_ATTRIB_TO_UPGRADE, _attrib, true));
    }

    public function setSelectButtonState(state:Boolean):void{
        btnSelect.enabled = state;
    }

    public function reset():void{
        _attrib = null;
        tfAttribDesc.htmlText = "";
        btnSelect.enabled = false;
        btnSelect.visible = false;
        this.visible = false;
    }

    public function setData(attrib:DivineWeaponAttribute):void{
        _attrib = attrib;
        tfAttribDesc.htmlText = attrib.getAttribDescriptionHTML();
        FontUtil.setFont(tfAttribDesc, Font.ARIAL, true);

        if (!attrib.isMaxLevel()) {
            btnSelect.enabled = true;
            btnSelect.visible = true;
        }

        this.visible = true;
    }

    public function ID():int{
        return _attrib?_attrib.index:-1;
    }
}
}
