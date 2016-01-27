/**
 * Created by merino on 1/27/2015.
 */
package game.ui.divine_weapon.gui.panels {
import core.util.FontUtil;

import flash.display.MovieClip;
import flash.text.TextField;

import game.enum.Font;

public class DivineWeaponPanelRefine extends MovieClip{
    public function DivineWeaponPanelRefine() {
        for (var iCounter:int = 0; iCounter < this.numChildren; iCounter++){
            var _object:* = this.getChildAt(iCounter);
            if (_object is TextField) {
                FontUtil.setFont(_object, Font.ARIAL, true);
            }
        }
    }
}
}
