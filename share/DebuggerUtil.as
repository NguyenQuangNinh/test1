/**
 * Created by anhnnv on 22/08/2014.
 */
package {

import components.KeyUtils;

import flash.display.DisplayObject;

import flash.display.Stage;
import flash.events.MouseEvent;
import flash.filters.BitmapFilterQuality;
import flash.filters.GlowFilter;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.ui.Keyboard;

import flash.utils.getQualifiedClassName;

public class DebuggerUtil
{

    public static var instance:DebuggerUtil;
    public var isInited:Boolean;
    public var isNetTraced:Boolean = true;
    public var isShowingBoundingBox:Boolean = false;
    public var serverDelay:int = 0;
    public var tf:TextField;
    public var stage:Stage;

    public function DebuggerUtil()
    {
        if (instance) throw new Error("Singleton Error!");
        isInited = false;
    }

    public static function getInstance():DebuggerUtil
    {
        if (!instance) instance = new DebuggerUtil();
        return instance;
    }

    public function init(pStage:Stage):void
    {
        if (isInited)
        {
            throw new Error("DebuggerUtil double init!");
            return;
        }

        
        tf = new TextField();
        this.stage = pStage;
        stage.addChild(tf);
        tf.visible = false;
        tf.width = stage.stageWidth;
        tf.height = 100;
        tf.textColor = 0xffffff;
        tf.defaultTextFormat = new TextFormat('Arial', 12, 0xffffff);
        tf.background = true;
        tf.backgroundColor = 0x333333;
        tf.multiline = true;
        tf.wordWrap = true;
        //tf.embedFonts = true;

        var outline:GlowFilter = new GlowFilter(0x000000,1.0,2.0,2.0,10);
        outline.quality = BitmapFilterQuality.MEDIUM;
        //tf.filters=[outline];
        //tf.border = true;
        stage.addEventListener(MouseEvent.MOUSE_DOWN, stageHdl);
    }

    private function stageHdl(e:MouseEvent):void
    {
        if (KeyUtils.isDown(Keyboard.SHIFT))
        {
            tf.visible = !tf.visible;
            return;
        }

        if (!KeyUtils.isDown(Keyboard.CONTROL))
        {
            return;
        }
        tf.visible = true;
        var mc:DisplayObject = e.target as DisplayObject;
        var str:String = mc.name;
        var name:String;
        while (mc.parent != stage)
        {
            //var classDef:Class = Class(getDefinitionByName(getQualifiedClassName(mc)));
            //var xmlType:XML = describeType(classDef);
            mc = mc.parent;
            name = mc.name.indexOf("insta") < 0 ? getQualifiedClassName(mc) + " -- " + mc.name : getQualifiedClassName(mc);
            str = name + "  >>>  " + str;
        }
        tf.appendText(str + "\n");
        tf.scrollV = tf.maxScrollV;
    }

    public function print(str:String):void
    {
		if (!isInited) return;
        tf.appendText(str + "\n");
        tf.scrollV = tf.maxScrollV;
    }
}
}
