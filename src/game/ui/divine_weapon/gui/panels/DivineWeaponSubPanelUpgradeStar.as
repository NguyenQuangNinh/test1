/**
 * Created by merino on 1/28/2015.
 */
package game.ui.divine_weapon.gui.panels {
import core.event.EventEx;
import core.util.FontUtil;

import flash.display.MovieClip;
import flash.display.SimpleButton;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.text.TextField;

import game.Game;
import game.data.model.item.DivineWeaponItem;
import game.data.model.item.IItemConfig;
import game.data.model.item.ItemFactory;
import game.enum.Font;
import game.ui.components.CheckBox;
import game.ui.components.ItemSlot;
import game.ui.components.ProgressBar;
import game.ui.divine_weapon.DivineWeaponEvent;

public class DivineWeaponSubPanelUpgradeStar extends MovieClip{
    public static const CLICK_BUTTON_KEEP_LUCK:String = "DW_Click_Button_Keep_Luck_Up_Star";
    public static const CLICK_BUTTON_UPGRADE_STAR:String = "DW_Click_Button_Upgrade_Star";
    public var tfWeaponAttrib:TextField;
    public var mcCurLevelStars:MovieClip;
    public var mcNextLevelStars:MovieClip;
    public var tfMaxAttribLevel:TextField;
    public var tfNextMaxAttribLevel:TextField;
    public var tfLuckyPoint:TextField;
    public var btnKeepLuck:SimpleButton;
    public var btnStarUpgrade:SimpleButton;
    public var mcItemSlotContainer:MovieClip;
    public var movAdditionRate:ProgressBar;
    public var quickbuyCheckbox:CheckBox;
    public var tfItemPrice:TextField;
    public var tfMaterialRequire:TextField;
    public var tfMaterialCount:TextField;
    private var _isActive:Boolean = false;

    public function DivineWeaponSubPanelUpgradeStar() {

        for (var iCounter:int = 0; iCounter < this.numChildren; iCounter++){
            var _object:* = this.getChildAt(iCounter);
            if (_object is TextField) {
                FontUtil.setFont(_object, Font.ARIAL, true);
            }
        }
        quickbuyCheckbox.setChecked(false);
        quickbuyCheckbox.addEventListener(CheckBox.CHANGED, onCheckBoxChange);
        tfLuckyPoint.text = "0";
        movAdditionRate.progressTf.visible = false;
        btnKeepLuck.visible = true;
        btnKeepLuck.addEventListener(MouseEvent.CLICK, onClickBtnKeepLuck);
        btnStarUpgrade.addEventListener(MouseEvent.CLICK, onClickBtnUpgradeStar);
    }

    private function onClickBtnUpgradeStar(event:MouseEvent):void {
        this.dispatchEvent(new Event(CLICK_BUTTON_UPGRADE_STAR, true));
    }

    private function onClickBtnKeepLuck(event:MouseEvent):void {
        this.dispatchEvent(new Event(CLICK_BUTTON_KEEP_LUCK, true));
    }

    private function onCheckBoxChange(event:Event):void {
        dispatchEvent(new EventEx(DivineWeaponEvent.AUTO_BUY_MATERIAL_CHANGE_STATE, {Checked: quickbuyCheckbox.isChecked()}, true));
    }

    public function reset():void{
        _isActive = false;
        movAdditionRate.setPercent(0);
        btnKeepLuck.visible = true;
    }

    public function active():void{
        if (_isActive)
            return;

        this._isActive = true;

    }

    public function get isActive():Boolean {
        return _isActive;
    }

    public function set isActive(value:Boolean):void {
        _isActive = value;
        this.visible = _isActive;
    }

    public function setDWItemInfo(dwItem:DivineWeaponItem):void {
        //weapon info
        tfWeaponAttrib.htmlText = dwItem.getAttribDescHTML();
        FontUtil.setFont(tfWeaponAttrib, Font.ARIAL, true);
        mcCurLevelStars.gotoAndStop(dwItem.dwXML.level);
        mcNextLevelStars.gotoAndStop(dwItem.dwXML.level + 1)
        tfMaxAttribLevel.text = "Thuộc tính tối đa: cấp " + dwItem.maxAttribLevel;
        tfNextMaxAttribLevel.text = "Thuộc tính tối đa: cấp " + dwItem.nextMaxAttribLevel;
        //set material
        var materialList:Array = dwItem.dwXML.arrStarUpgradeRecipe;
        var itemCount:int = Game.database.inventory.getItemQuantity(materialList[0].Type, materialList[0].ID);
        tfMaterialCount.text = itemCount.toString();
        var materialSlot:ItemSlot = new ItemSlot();
        var material:IItemConfig = ItemFactory.buildItemConfig(materialList[0].Type, materialList[0].ID);
        materialSlot.setConfigInfo(material);
        mcItemSlotContainer.addChild(materialSlot);
        mcItemSlotContainer.visible = true;
        tfMaterialRequire.text = "x " + materialList[0].Count;
        //chuc phuc
        movAdditionRate.setPercent(dwItem.nUpStarLuckyPoint/dwItem.maxLuckyPoint);
        btnKeepLuck.visible = !dwItem.bIsKeepLuck;
    }

    public function lockLuckyPointSucceed():void{
        btnKeepLuck.visible = false;
    }
}
}
