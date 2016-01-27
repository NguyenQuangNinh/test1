/**
 * Created by merino on 1/12/2015.
 */
package game.ui.divine_weapon.gui {
import core.display.BitmapEx;
import core.display.animation.Animator;
import core.event.EventEx;

import flash.display.MovieClip;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.utils.getDefinitionByName;

import game.data.model.item.DivineWeaponItem;
import game.enum.ItemType;
import game.ui.tooltip.TooltipEvent;
import game.ui.tooltip.TooltipID;

public class DivineWeaponItemSlot extends MovieClip{
    public static const ICON_LOADED:String = "icon_loaded";
    public static const LOCK : String = "lock";
    public static const UNLOCK : String = "unlock";
    public static const LOCK_MERGE:String = "lock_merge";
    public static const UNLOCK_GUILD : String = "unlock_guild";
    public static const DW_SLOT_DBCLICK: String = "dw_slot_dbclick_event";
    public static const DW_SLOT_CLICK: String = "dw_slot_click_event";
    public static const DW_UNLOCK_SLOT:String = "dw_unlock_slot";
    private var _status:String;
    private var _dwBorder:Animator;
    private var _dwItem:DivineWeaponItem;
    private var _bmDWIconSmall:BitmapEx;
    public var animContainer:MovieClip;
    private var _mcLockIcon:MovieClip;

    public function DivineWeaponItemSlot() {
        _bmDWIconSmall = new BitmapEx();
        _bmDWIconSmall.addEventListener(BitmapEx.LOADED, onIconLoaded);
        this.buttonMode = true;
        var lockIcon:Class = getDefinitionByName("LockIcon") as Class;
        _mcLockIcon = lockIcon ? new lockIcon() as MovieClip : new MovieClip();
        _mcLockIcon.visible = false;
        _mcLockIcon.x = 44.5;
        _mcLockIcon.y = 15.5;
        this.addEventListener(MouseEvent.CLICK, onMouseClickHandler);
    }

    public function set status(value:String):void
    {
        switch (value)
        {
            case LOCK:
            case UNLOCK:
            case UNLOCK_GUILD:
            case LOCK_MERGE:
                this.gotoAndStop(value);
                break;
            default:
                break;
        }

        _status = value;
    }

    public function setData(divineItem:DivineWeaponItem):void {
        this._dwItem = divineItem;

        if (divineItem.bIsEquiped || isEmpty)
            return;

        _bmDWIconSmall.reset();
        _bmDWIconSmall.load(_dwItem.dwXML.iconURL);

        //test
        _dwBorder = new Animator();

        if (!_dwBorder.hasEventListener(Animator.LOADED))
            _dwBorder.addEventListener(Animator.LOADED, onAnimLoaded);
        _dwBorder.setCacheEnabled(true);
        _dwBorder.load(_dwItem.dwXML.urlBorder);
        _dwBorder.x = 63/2-2;
        _dwBorder.y = 62/2-2;
        _dwBorder.alpha = 0.8;
        _dwBorder.mouseChildren = false;
        _dwBorder.mouseEnabled = false;

        animContainer.addChild(_dwBorder);
        animContainer.mouseChildren = false;
        animContainer.mouseEnabled = false;
        if (!isEmpty)
        {
            if (_status == LOCK_MERGE){
                _mcLockIcon.visible = true;
                this.addChild(_mcLockIcon);
            }
            this.doubleClickEnabled = true;
            this.mouseChildren = false;
            this.addEventListener(MouseEvent.ROLL_OVER, onMouseOverHandler);
            this.addEventListener(MouseEvent.ROLL_OUT, onMouseOutHandler);
            this.addEventListener(MouseEvent.DOUBLE_CLICK, onMouseDbClickHandler);
            this.addEventListener(MouseEvent.CLICK, onMouseClickHandler);
        }
    }

    private function onMouseClickHandler(event:MouseEvent):void {
        if (_status == LOCK || _status == UNLOCK_GUILD){
            this.dispatchEvent(new Event(DW_UNLOCK_SLOT, true));
        }else
        {
            if (!isEmpty)
                this.dispatchEvent(new EventEx(DW_SLOT_CLICK, dwItem, true));
        }
    }

    private function onMouseOutHandler(event:MouseEvent):void {
        this.dispatchEvent(new EventEx(TooltipEvent.HIDE_TOOLTIP, null, true));
    }

    private function onMouseDbClickHandler(event:MouseEvent):void {
        this.dispatchEvent(new EventEx(DW_SLOT_DBCLICK, _dwItem, true));
    }

    private function onMouseOverHandler(event:MouseEvent):void {
        this.dispatchEvent(new EventEx(TooltipEvent.SHOW_TOOLTIP, {type: TooltipID.DIVINE_WEAPON, value: this._dwItem}, true));
    }

    private function onAnimLoaded(e:Event):void
    {
        //var index:int = Math.min(_dwBorder.getAnimationCount() - 1, soulItem.level - 1)
        _dwBorder.play(0);
    }

    public function get isEmpty() : Boolean {
        return _dwItem != null && (_dwItem.dwXML.ID == 0 && _dwItem.dwXML.type == ItemType.EMPTY_SLOT);
    }

    private function onIconLoaded(event:Event):void {
        _bmDWIconSmall.x = 29 - _bmDWIconSmall.bitmapData.width/2;
        _bmDWIconSmall.y = 29 - _bmDWIconSmall.bitmapData.height/2;
        this.addChildAt(_bmDWIconSmall, 2);
    }

    public function get dwItem():DivineWeaponItem {
        return _dwItem;
    }
}
}
