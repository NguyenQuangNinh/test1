package game.utility
{
	import core.display.layer.Layer;
	import core.display.layer.LayerManager;
	import core.Manager;
	import flash.geom.Point;
	import game.enum.ItemType;
	import game.ui.components.ItemSlot;
	import game.ui.effect.EffectModule;
	import game.ui.ModuleID;
	
	/**
	 * ...
	 * @author chuongth2
	 */
	public class UtilityEffect
	{
		
		public static function tweenItemEffect(itemSlot:ItemSlot, type:ItemType, onCompleteTween:Function = null):void
		{
			if (itemSlot && type)
			{
				Manager.display.showModule(ModuleID.EFFECT, new Point(0, 0), LayerManager.LAYER_EFFECT, "top_left", Layer.NONE);
				var effectModule:EffectModule = Manager.module.getModuleByID(ModuleID.EFFECT) as EffectModule;
				if (effectModule)
				{
					effectModule.actionTweenItem(itemSlot, type, onCompleteTween);
				}
			}
		}
		
		public static function tweenItemEffects(itemSlots:Array, onCompleteTween:Function, sync:Boolean = false, bonusX:int = 1):void
		{
			if (itemSlots)
			{
				Manager.display.showModule(ModuleID.EFFECT, new Point(0, 0), LayerManager.LAYER_EFFECT, "top_left", Layer.NONE);
				var effectModule:EffectModule = Manager.module.getModuleByID(ModuleID.EFFECT) as EffectModule;
				if (effectModule)
				{
					effectModule.actionTweenItems(itemSlots, onCompleteTween, sync, bonusX);
				}
			}
		}
	
	}

}