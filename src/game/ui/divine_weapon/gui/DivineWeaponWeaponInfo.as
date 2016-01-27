/**
 * Created by merino on 1/19/2015.
 */
package game.ui.divine_weapon.gui {
import core.display.BitmapEx;
import core.util.FontUtil;

import flash.display.MovieClip;
import flash.events.Event;
import flash.text.TextField;

import game.data.model.item.DivineWeaponItem;
import game.enum.Font;

public class DivineWeaponWeaponInfo extends MovieClip{
    private var _bitmapIcon:BitmapEx;
    public static const arrTextColor:Array = ["'#90FF00'", "'#00CCFF'", "'#FF0000'", "'#FF00FF'", "'#FFFF00'"];
    public var dwBigIcon:MovieClip;
    public var tfWeaponDesc:TextField;
    public var tfWeaponName:TextField;
    public var mcStars:MovieClip;

    public function DivineWeaponWeaponInfo() {
        setLayout(1);
        _bitmapIcon = new BitmapEx();
        _bitmapIcon.reset();
        _bitmapIcon.addEventListener(BitmapEx.LOADED, onBitmapLoaded);
        mcStars.gotoAndStop(1);
        FontUtil.setFont(tfWeaponName, Font.ARIAL, true);
        FontUtil.setFont(tfWeaponDesc, Font.ARIAL, true);
        this.visible = false;
    }

    public function setLayout(layoutNumber:int):void{
        this.gotoAndStop(layoutNumber);
    }

    private function onBitmapLoaded(event:Event):void {
        _bitmapIcon.x = 356/2 - _bitmapIcon.bitmapData.width/2;
        _bitmapIcon.y = 275/2 - _bitmapIcon.bitmapData.height/2;
        dwBigIcon.addChild(_bitmapIcon);
        this.visible = true;
    }

    public function setData(dwItem:DivineWeaponItem):void
    {
        _bitmapIcon.reset();
        _bitmapIcon.load(dwItem.dwXML.urlBigIcon);
        tfWeaponName.htmlText = "<font color = " + arrTextColor[dwItem.dwXML.level - 1] + ">" + dwItem.dwXML.getName() + "</font>";
        FontUtil.setFont(tfWeaponName, Font.ARIAL, true);
        mcStars.gotoAndStop(dwItem.dwXML.level);
        tfWeaponDesc.htmlText = dwItem.getAttribDescHTML();
        FontUtil.setFont(tfWeaponDesc, Font.ARIAL, true);
    }

    public function reset():void
    {
        _bitmapIcon.reset();
        tfWeaponName.htmlText = "";
        tfWeaponDesc.htmlText = "";
        mcStars.gotoAndStop(1);
        this.visible = false;
    }
}
}
