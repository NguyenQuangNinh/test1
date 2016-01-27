package game.ui.effect
{
	import com.greensock.easing.Expo;
	import com.greensock.TweenMax;
	import core.display.ModuleBase;
	import core.Manager;
	import core.util.Utility;
	import flash.display.MovieClip;
	import game.enum.ItemType;
	import game.ui.components.ItemSlot;
	
	/**
	 * ...
	 * @author
	 */
	public class EffectModule extends ModuleBase
	{
		
		public function EffectModule()
		{
		
		}
		
		override protected function createView():void
		{
			baseView = new EffectView();
		}
		
		override protected function preTransitionIn():void 
		{
			Utility.log( "EffectModule.preTransitionIn" );
			Manager.display.getStage().mouseChildren = false;		
			super.preTransitionIn();			
		}
		
		override protected function preTransitionOut():void
		{
			Utility.log( "EffectModule.preTransitionOut" );
			Manager.display.getStage().mouseChildren = true;
			super.preTransitionOut();
			//remove all children
			//Utility.log("reset view from EffectModule.preTransitionOut");
			EffectView(baseView).reset();
		}
		
		public function actionTweenItem(itemSlot:ItemSlot, type:ItemType, onCompleteTween:Function = null):void
		{
			EffectView(baseView).actionTweenItem(itemSlot, type, onCompleteTween);
		}
		
		public function actionTweenItems(itemSlots:Array, onCompleteTween:Function, sync:Boolean = false, bonusX:int = 1):void
		{
			EffectView(baseView).actionTweenItems(itemSlots, onCompleteTween, sync, bonusX);
		}
	
	}

}