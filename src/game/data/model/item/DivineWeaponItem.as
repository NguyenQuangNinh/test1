package game.data.model.item
{
import game.Game;
import game.data.xml.DataType;
import game.data.xml.item.DivineWeaponXML;
import game.enum.GameConfigID;
import game.enum.ItemType;
import game.ui.divine_weapon.DivineWeaponAttribute;

public class DivineWeaponItem extends Item
{
	private var _arrAttributes:Array = new Array();
	public static const maxLevel:uint = 5;
    private var _slotIndex:int = -1;
    public var bIsLocked:Boolean = false;
    public var bIsEquiped:Boolean = false;
    public var bIsKeepLuck:Boolean = false;
    public var nUpStarLuckyPoint:int = 0;
    private var _maxLuckyPoint:int = 0;

	public function DivineWeaponItem()
	{

	}

	override public function init(xmlID:int, type:ItemType):void
	{
		super.init(xmlID, type);
		xmlData = Game.database.gamedata.getData(DataType.DIVINEWEAPON, xmlID) as DivineWeaponXML;
		if (xmlData == null)
		{
			var dwXML:DivineWeaponXML = new DivineWeaponXML();
			dwXML.ID = 0;
			dwXML.type = ItemType.EMPTY_SLOT;

			xmlData = dwXML;
		}
	}

	public function get dwXML():DivineWeaponXML{
		return xmlData as DivineWeaponXML;
	}

	public function insertAttrib(attrib:DivineWeaponAttribute):void
	{
        var index:int = this._arrAttributes.length;
        attrib.index = index;
		this._arrAttributes.push(attrib);
	}

	public function getAttribDescription():String{
		var desc:String = "";
		for each(var attrib:DivineWeaponAttribute in _arrAttributes){
			desc += ("- " + attrib.getAttribDescription() + '\n');
		}
		return desc;
	}

	public function getAttribDescHTML():String{
		var descHTML:String = "";
		for each(var attrib:DivineWeaponAttribute in _arrAttributes){
			descHTML += (attrib.getAttribDescriptionHTML() + '\n');
		}
		return descHTML
	}

	public function isMaxLevel():Boolean{
		return (dwXML.level >= maxLevel);
	}

	public function get arrAttributes():Array {
		return _arrAttributes;
	}

	public function getSingleAttrib(idx:int):DivineWeaponAttribute{
		if (_arrAttributes[idx]){
			return _arrAttributes[idx];
		}
		return null;
	}

    public function get slotIndex():int {
        return _slotIndex;
    }

    public function set slotIndex(value:int):void {
        _slotIndex = value;
    }

    public function get maxLuckyPoint():int {
        return _maxLuckyPoint;
    }

    public function set maxLuckyPoint(value:int):void {
        _maxLuckyPoint = value;
    }

    public function get maxAttribLevel():int{
        var arrAttribLevels:Array = Game.database.gamedata.getConfigData(GameConfigID.DIVINE_WEAPON_MAX_ATTRIB_LEVEL);
        if (!arrAttribLevels)
            return 99999;

        return arrAttribLevels[this.dwXML.level];
    }

    public function get nextMaxAttribLevel():int{
        var arrAttribLevels:Array = Game.database.gamedata.getConfigData(GameConfigID.DIVINE_WEAPON_MAX_ATTRIB_LEVEL);
        if (!arrAttribLevels)
            return 99999;
        if (this.isMaxLevel())
            return arrAttribLevels[this.dwXML.level];
        else
            return arrAttribLevels[this.dwXML.level+1];
    }
}

}