/**
 * Created by merino on 1/22/2015.
 */
package game.ui.tooltip.tooltips {
import core.util.FontUtil;

import flash.display.MovieClip;
import flash.display.Sprite;
import flash.text.TextField;

import game.data.model.item.DivineWeaponItem;
import game.enum.Font;
import game.enum.ItemType;
import game.ui.divine_weapon.gui.DivineWeaponWeaponInfo;

public class DivineWeaponTooltip extends Sprite{
    public var tfName:TextField;
    public var mcStars:MovieClip;
    public var tfWeaponDesc:TextField;
    public var tfLevel:TextField;
    public var tfMaxAttribLevel:TextField;
    public var tfNextMaxAttribLevel:TextField;
    public var backgroundMov:MovieClip;

    public function DivineWeaponTooltip() {
    }

    public function setData(dwItem:DivineWeaponItem):void{
        if (dwItem.dwXML.getType() != ItemType.DIVINE_WEAPON)
            return;

        tfName.htmlText = "<font color = " + DivineWeaponWeaponInfo.arrTextColor[dwItem.dwXML.level - 1] + ">" + dwItem.dwXML.getName() + "</font>";
        FontUtil.setFont(tfName, Font.ARIAL, true);
        mcStars.gotoAndStop(dwItem.dwXML.level);
        tfWeaponDesc.htmlText = dwItem.getAttribDescHTML();
        FontUtil.setFont(tfWeaponDesc, Font.ARIAL, true);
        tfLevel.text = dwItem.dwXML.level.toString();
        FontUtil.setFont(tfLevel, Font.ARIAL, true);
        tfMaxAttribLevel.text = dwItem.maxAttribLevel.toString();
        FontUtil.setFont(tfMaxAttribLevel, Font.ARIAL, true);
        if (dwItem.isMaxLevel() == true) {
            tfNextMaxAttribLevel.text = "";
        }
        else {
            tfNextMaxAttribLevel.text = dwItem.nextMaxAttribLevel.toString();
        }
        FontUtil.setFont(tfNextMaxAttribLevel, Font.ARIAL, true);
    }


}
}
