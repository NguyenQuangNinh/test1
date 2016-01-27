/**
 * Created by merino on 1/21/2015.
 */
package game.enum {

import core.util.Utility;

import game.data.xml.XMLData;

public class DivineWeaponAttributeType extends XMLData{

    private var _description:String;
    private var _valueType:String;
    private var _arrValueByLevel:Array;
    private var _arrValueType:Object = {1 : "", 2: "%"};

    override public function parseXML(xml : XML) : void
    {
        super.parseXML(xml);
        _description = xml.Desc.toString();
        _valueType = xml.ValueType.toString();
        _arrValueByLevel = Utility.toIntArray(xml.ArrayValue.toString());
    }

    public function get description():String
    {
        return _description;
    }

    public function get valueType():String
    {
        return _arrValueType[_valueType];
    }

    public function getAttribValueByLevel(level:int):int{
        return _arrValueByLevel[level - 1];
    }
}
}
