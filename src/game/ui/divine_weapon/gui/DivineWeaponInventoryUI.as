/**
 * Created by merino on 1/12/2015.
 */
package game.ui.divine_weapon.gui {
import components.scroll.VerScroll;

import core.Manager;
import core.event.EventEx;

import flash.display.MovieClip;
import flash.display.SimpleButton;
import flash.events.MouseEvent;
import flash.ui.Mouse;
import flash.utils.getDefinitionByName;

import game.Game;
import game.data.model.item.DivineWeaponItem;
import game.enum.Element;
import game.ui.divine_weapon.DivineWeaponEvent;

public class DivineWeaponInventoryUI extends MovieClip{
    //scroll
    public var maskMov: MovieClip;
    public var scrollBar: MovieClip;
    private var _scroller: VerScroll;
    private var _content: MovieClip = new MovieClip();
    private var _arrDWSlots:Array = new Array();
    private var _arrDWSlotsShowUp:Array = new Array();
    public var btnLockWeapon:SimpleButton;
    public var btnDestroyWeapon:SimpleButton;
    private var _curFilterByElement:Element = null;
    private var _lockMov:MovieClip;
    private var _delMov:MovieClip;

    private var _arrDWItems: Array = [];
    private var _isSelectLock:Boolean = false;
    private var _isSelectDestroy:Boolean = false;

    public function DivineWeaponInventoryUI() {
        maskMov.visible = false;
        _content.x = maskMov.x+4;
        _content.y = maskMov.y;
        this.addChild(_content);

        updateFilterByElement();

        var lockClass:Class = getDefinitionByName("LockMov") as Class;
        _lockMov = lockClass ? new lockClass() as MovieClip : new MovieClip();
        _lockMov.visible = false;
        Manager.display.getStage().addChild(_lockMov);
        Manager.display.getStage().addEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveHdl);

        var delClass:Class = getDefinitionByName("DelMov") as Class;
        _delMov = delClass ? new delClass() as MovieClip : new MovieClip();
        _delMov.visible = false;
        Manager.display.getStage().addChild(_delMov);

        this.addEventListener(DivineWeaponItemSlot.DW_SLOT_CLICK, onDWItemSlotClick);
        btnLockWeapon.addEventListener(MouseEvent.CLICK, onClickBtnLockWeapon);
        btnDestroyWeapon.addEventListener(MouseEvent.CLICK, onClickBtnDestroyWeapon);
    }

    private function onDWItemSlotClick(event:EventEx):void {
        var dwItem:DivineWeaponItem = event.data as DivineWeaponItem;
        var dwItemSlot:DivineWeaponItemSlot = event.target as DivineWeaponItemSlot;
        if (dwItemSlot && !dwItemSlot.isEmpty){
            if (_isSelectLock) {
                _isSelectLock = false;
                processCursor();
                this.dispatchEvent(new EventEx(DivineWeaponEvent.DIVINE_WEAPON_LOCK_ITEM, dwItem, true))
            }else if(_isSelectDestroy){
                _isSelectDestroy = false;
                processCursor();
                this.dispatchEvent(new EventEx(DivineWeaponEvent.DIVINE_WEAPON_DESTROY_ITEM, dwItem, true))
            }
        }
    }

    private function onMouseMoveHdl(event:MouseEvent):void {
        if (_isSelectLock) {
            _lockMov.x = event.stageX;
            _lockMov.y = event.stageY;
        }
        if (_isSelectDestroy){
            _delMov.x = event.stageX;
            _delMov.y = event.stageY;
        }
    }

    private function onClickBtnLockWeapon(event:MouseEvent):void {
        _isSelectLock = !_isSelectLock;
        _isSelectDestroy = false;
        processCursor(event.stageX, event.stageY);
    }

    private function onClickBtnDestroyWeapon(event:MouseEvent):void {
        _isSelectDestroy = !_isSelectDestroy;
        _isSelectLock = false;
        processCursor(event.stageX, event.stageY);
    }

    private function processCursor(posX:int = 0, posY:int = 0):void
    {        
        if (_isSelectLock)
        {
            _lockMov.x = posX;
            _lockMov.y = posY;
            _lockMov.visible = true;
        }
        else
        {
            _lockMov.visible = false;
        }
        if (_isSelectDestroy)
        {
            _delMov.x = posX;
            _delMov.y = posY;
            _delMov.visible = true;
        }
        else
        {
            _delMov.visible = false;
        }
        if (_lockMov.visible || _delMov.visible){
            Mouse.hide();
        }else
        {
            Mouse.show();
        }
    }

    public function update():void
    {
        _arrDWItems = Game.database.inventory.getDWItems();
    }

    public function updateInventoryContent():void{
        _content.removeChildren();
        var numOpenSlot:int = _arrDWItems.length;
        for (var i:int = 0; i < numOpenSlot; i++){
            var dwSlot:DivineWeaponItemSlot = new DivineWeaponItemSlot();
            dwSlot.x = (i % 4) * 59;
            dwSlot.y = Math.floor(i / 4) * 59 + 2;
            dwSlot.status = DivineWeaponItemSlot.UNLOCK;
            if (_curFilterByElement == null || DivineWeaponItem(_arrDWItems[i]).dwXML.element == _curFilterByElement){
                dwSlot.status = (_arrDWItems[i].bIsLocked) ? DivineWeaponItemSlot.LOCK_MERGE : DivineWeaponItemSlot.UNLOCK;
                dwSlot.setData(_arrDWItems[i]);
            }
            _arrDWSlots.push(dwSlot);
            _content.addChild(dwSlot);
        }

        var totalSlot:int = Math.max(28, numOpenSlot + (8 - (numOpenSlot % 4)));

        for (var j:int = numOpenSlot; j < totalSlot; j++){
            var dwSlot2:DivineWeaponItemSlot = new DivineWeaponItemSlot();
            dwSlot2.x = (j % 4) * 59;
            dwSlot2.y = Math.floor(j / 4) * 59 + 2;
            dwSlot2.status = (j > numOpenSlot) ? DivineWeaponItemSlot.LOCK : DivineWeaponItemSlot.UNLOCK_GUILD;
            _content.addChild(dwSlot2);
        }

        if (!_scroller) {
            _scroller = new VerScroll(maskMov, _content, scrollBar);
            _scroller.updateScroll();
        } else {
            _scroller.updateScroll();
        }
        this.dispatchEvent(new EventEx(DivineWeaponEvent.DIVINE_INVENTORY_UI_UPDATED, null, true));
    }

    public function updateFilterByElement(element:Element = null):void
    {
        _curFilterByElement = element;
        updateInventoryContent();
    }

    public function reset():void{
        _isSelectDestroy = _isSelectLock = false;
        processCursor();
        _content.removeChildren();
    }
}
}
