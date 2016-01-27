/**
 * Created by merino on 1/28/2015.
 */
package game.ui.divine_weapon.gui.panels {
import core.event.EventEx;
import core.util.FontUtil;

import flash.display.MovieClip;
import flash.display.SimpleButton;
import flash.events.MouseEvent;
import flash.text.TextField;

import game.Game;
import game.data.model.item.DivineWeaponItem;
import game.data.model.item.IItemConfig;
import game.data.model.item.ItemFactory;
import game.enum.Font;
import game.enum.ItemType;
import game.ui.components.ItemSlot;
import game.ui.divine_weapon.DivineWeaponAttribute;
import game.ui.divine_weapon.DivineWeaponEvent;
import game.ui.divine_weapon.gui.DivineWeaponAttribSelector;

public class DivineWeaponSubPanelUpgradeAttrib extends MovieClip{
    public var tfAttribName:TextField;
    public var tfCurrentAttribValue:TextField;
    public var tfNextAttribValue:TextField;
    public var btnDoUpgradeAttrib:SimpleButton;

    public var attribSelector1:DivineWeaponAttribSelector;
    public var attribSelector2:DivineWeaponAttribSelector;
    public var attribSelector3:DivineWeaponAttribSelector;
    public var attribSelector4:DivineWeaponAttribSelector;
    public var attribSelector5:DivineWeaponAttribSelector;
    public var attribSelector6:DivineWeaponAttribSelector;
    private var arrAttribSelectors:Array = [];

    public var tfMaterialCount1:TextField;
    public var tfMaterialCount2:TextField;
    public var tfMaterialCount3:TextField;
    public var tfMaterialCount4:TextField;
    public var tfMaterialCount5:TextField;
    public var tfMaterialCount6:TextField;
    private var arrMaterialCount:Array;

    public var mcMaterialContainer1:MovieClip;
    public var mcMaterialContainer2:MovieClip;
    public var mcMaterialContainer3:MovieClip;
    public var mcMaterialContainer4:MovieClip;
    public var mcMaterialContainer5:MovieClip;
    public var mcMaterialContainer6:MovieClip;
    private var arrMaterialContainter:Array = [];

    private var _isActive:Boolean = false;

    public function DivineWeaponSubPanelUpgradeAttrib() {

        for (var iCounter:int = 0; iCounter < this.numChildren; iCounter++){
            var _object:* = this.getChildAt(iCounter);
            if (_object is TextField) {
                FontUtil.setFont(_object, Font.ARIAL, true);
            }
        }
        arrAttribSelectors = [attribSelector1, attribSelector2, attribSelector3, attribSelector4, attribSelector5, attribSelector6];

        arrMaterialContainter = [mcMaterialContainer1, mcMaterialContainer2, mcMaterialContainer3, mcMaterialContainer4, mcMaterialContainer5, mcMaterialContainer6];
        arrMaterialCount = [tfMaterialCount1,tfMaterialCount2,tfMaterialCount3,tfMaterialCount4,tfMaterialCount5,tfMaterialCount6];
        for each (var tf:TextField in arrMaterialCount){
            tf.visible = false;
        }
        btnDoUpgradeAttrib.addEventListener(MouseEvent.CLICK, btnUpgradeAttribOnClick);
    }

    private function btnUpgradeAttribOnClick(event:MouseEvent):void {
        if (btnDoUpgradeAttrib.enabled == false)
            return
        this.dispatchEvent(new EventEx(DivineWeaponEvent.CLICK_BUTTON_UPGRADE_WEAPON_ATTRIB, null, true));
    }

    public function reset():void{
        _isActive = false;
        tfAttribName.text = "";
        tfCurrentAttribValue.text = "";
        tfNextAttribValue.text = "";
        for (var i:int = 0; i < arrAttribSelectors.length; i++){
            arrAttribSelectors[i].reset();
        }
        btnDoUpgradeAttrib.enabled = false;
        for each (var tf:TextField in arrMaterialCount){
            tf.htmlText = "";
            tf.visible = false;
        }

        for each(var mov:MovieClip in arrMaterialContainter){
            mov.removeChildren();
        }
    }

    public function setDWItemInfo(dwItem:DivineWeaponItem):void{
        var arrAttribs:Array = dwItem.arrAttributes;
        var numAttrib:int = arrAttribs.length;
        for (var i:int = 0; i < numAttrib; i++){
            DivineWeaponAttribSelector(arrAttribSelectors[i]).setData(arrAttribs[i]);
        }
    }

    public function setAttribUpgradeInfo(dwItem:DivineWeaponItem, attribID:int):void{
        resetMaterialInfo();
        var attrib:DivineWeaponAttribute = dwItem.getSingleAttrib(attribID);
        tfAttribName.text = attrib.attributeType.description.toUpperCase();
        tfCurrentAttribValue.text = "+" + attrib.attributeValue + attrib.attributeType.valueType;
        tfNextAttribValue.text = "+" + attrib.attributeNextLevelValue() + attrib.attributeType.valueType;
        var arrRecipe:Array = dwItem.dwXML.arrAttribUpgradeRecipe;
        var currentMaterialCount:int = 0;
        for (var i:int = 0; i < arrRecipe.length; i++){
            currentMaterialCount = Game.database.inventory.getItemQuantity(arrRecipe[i].Type, arrRecipe[i].ID);
            if (arrRecipe[i].Type == ItemType.GOLD){
                arrMaterialCount[i].htmlText = "<font color = '#00ff00'>" + arrRecipe[i].Count + "</font>";
            }else {
                if (currentMaterialCount < arrRecipe[i].Count) {
                    arrMaterialCount[i].htmlText = "<font color = '#ff0000'>" + currentMaterialCount + "/" + arrRecipe[i].Count + "</font>";
                } else {
                    arrMaterialCount[i].htmlText = "<font color = '#00ff00'>" + currentMaterialCount + "/" + arrRecipe[i].Count + "</font>";
                }
            }
            arrMaterialCount[i].visible = true;
            FontUtil.setFont(arrMaterialCount[i], Font.ARIAL, true);

            var materialSlot:ItemSlot = new ItemSlot();

            var material:IItemConfig = ItemFactory.buildItemConfig(arrRecipe[i].Type, arrRecipe[i].ID);
            materialSlot.setConfigInfo(material);
            if (material.getType() == ItemType.GOLD){
                materialSlot.x = 4;
                materialSlot.y = 4;
            }
            arrMaterialContainter[i].addChild(materialSlot);
            arrMaterialContainter[i].visible = true;
        }
        btnDoUpgradeAttrib.enabled = true;
        for (var j:int = 0; j < arrAttribSelectors.length; j++){
            if (arrAttribSelectors[j].ID() == attribID){
                arrAttribSelectors[j].setSelectButtonState(false);
            }else{
                arrAttribSelectors[j].setSelectButtonState(true);
            }
        }
    }

    private function resetMaterialInfo():void{
        tfAttribName.text = "";
        tfCurrentAttribValue.text = "";
        tfNextAttribValue.text = "";
        for (var i:int = 0; i < 6; i++){
            arrMaterialCount[i].htmlText = "";
            arrMaterialCount[i].visible = false;
            arrMaterialContainter[i].removeChildren();
        }
    }

    public function get isActive():Boolean {
        return _isActive;
    }

    public function set isActive(value:Boolean):void {
        _isActive = value;

        this.visible = _isActive;
    }
}
}
