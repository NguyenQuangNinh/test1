/**
 * Created by merino on 1/21/2015.
 */
package game.ui.divine_weapon {
import game.Game;
import game.data.model.item.DivineWeaponItem;
import game.data.xml.DataType;
import game.enum.DivineWeaponAttributeType;

public class DivineWeaponAttribute {
    private var _attributeType:DivineWeaponAttributeType;
    private var _attributeLevel:int = 0;
    private var _dwParentItem:DivineWeaponItem;
    private var _index:int = -1;
    public var isLocked:Boolean = false;

    public function DivineWeaponAttribute(dwItem:DivineWeaponItem, attribID:int, attribLevel:int) {
        this._attributeType = Game.database.gamedata.getData(DataType.DIVINEWEAPON_ATTRIBUTE, attribID) as DivineWeaponAttributeType;
        this._attributeLevel = attribLevel;
        this._dwParentItem = dwItem;
    }

    public function get attributeType():DivineWeaponAttributeType {
        return _attributeType;
    }

    public function get attributeValue():int {
        return _attributeType.getAttribValueByLevel(_attributeLevel);
    }

    public function attributeNextLevelValue():int{
        if (isMaxLevel()) {
            return attributeValue;
        }else
            {
                return _attributeType.getAttribValueByLevel(_attributeLevel + 1);
            }
    }

    public function getAttribDescription():String
    {
        return _attributeType.description + " +" + attributeValue + _attributeType.valueType+ " (cấp "+ _attributeLevel+ ")";
    }

    public function getAttribDescriptionHTML():String
    {
        var htmlAttrib:String = "<font color = '#ffff99'>- %desc</font> <font color = '#66ff00'>+%value (cấp %level)</font><font color = '#ff0000'> %maxlv</font>";
        var szMaxLv:String = "";
        if (_dwParentItem.maxAttribLevel <= this._attributeLevel)
            szMaxLv = "(tối đa)";
        htmlAttrib = htmlAttrib.replace("%desc", _attributeType.description);
        htmlAttrib = htmlAttrib.replace("%value", attributeValue + _attributeType.valueType);
        htmlAttrib = htmlAttrib.replace("%level", _attributeLevel);
        htmlAttrib = htmlAttrib.replace("%maxlv", szMaxLv);
        return htmlAttrib;
    }

    public function get attributeLevel():int {
        return _attributeLevel;
    }

    public function isMaxLevel():Boolean{
        return (_dwParentItem.maxAttribLevel <= this._attributeLevel);
    }

    public function get index():int {
        return _index;
    }

    public function set index(value:int):void {
        _index = value;
    }

    public function get dwParentItem():DivineWeaponItem {
        return _dwParentItem;
    }
}
}
