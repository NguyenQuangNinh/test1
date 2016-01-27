package core.display.layer 
{
	import core.display.ModuleBase;
	import core.display.ViewBase;
	import core.Manager;
	import core.util.Utility;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author ...
	 */
	public class Layer extends Sprite 
	{
		public static const BLOCK_BLACK:int = 0;
		public static const BLOCK_ALPHA:int = 1;
		public static const NONE:int = 2;
		public static var blackBlock:Sprite;
		public static var alphaBlock:Sprite;
		
		private var blackBlockList:Array = [];
		private var alphaBlockList:Array = [];
		private var childList:Array = [];
		
		public function Layer() 
		{
			mouseEnabled = false;
			
			if(!blackBlock) {
				blackBlock = new Sprite();
				blackBlock.graphics.beginFill(0, 0.6);
				blackBlock.graphics.drawRect(-500, -200, 2100, 1600);
				blackBlock.graphics.endFill();
			}
			
			if(!alphaBlock) {
				alphaBlock = new Sprite();
				alphaBlock.graphics.beginFill(0, 0.001);
				alphaBlock.graphics.drawRect(-500, -200, 2100, 1110);
				alphaBlock.graphics.endFill();
			}
			
		}
		
		public function add(target:DisplayObject, blocked:int = NONE):void {
			removeFromBlockList(target);
			
			switch (blocked) 
			{
				case BLOCK_ALPHA:
					//trace("Block alpha: " + target);
					alphaBlockList.push(target);
					addChild(alphaBlock);
				break;
				case BLOCK_BLACK:
					//trace("Block black: " + target);
					blackBlockList.push(target);
					addChild(blackBlock);
				break;
				default:
			}
			
			childList.push(target);
			addChild(target);
		}
		
		private function removeFromBlockList(target:DisplayObject):void 
		{
			var index:int = alphaBlockList.indexOf(target);
			if (index != -1) {
				alphaBlockList.splice(index, 1);
			}
			
			index = blackBlockList.indexOf(target);
			if (index != -1) {
				blackBlockList.splice(index, 1);
			}
		}
		
		private function checkBlock(target:DisplayObject):int {
			var index:int = alphaBlockList.indexOf(target);
			if (index != -1) return BLOCK_ALPHA;
			
			index = blackBlockList.indexOf(target);
			if (index != -1) return BLOCK_BLACK;
			
			return NONE;
		}
		
		public function remove(target:DisplayObject):void {
			var targetIndex:int = childList.indexOf(target);
			if (targetIndex == -1) return;
			
			try {
				childList.splice(targetIndex, 1);
				removeChild(target);
				removeFromBlockList(target);
				
				if (blackBlock.parent == this) removeChild(blackBlock);
				if (alphaBlock.parent == this) removeChild(alphaBlock);
				
				if (childList.length == 0) return;
				
				target = childList[childList.length - 1] as DisplayObject;
				
				switch (checkBlock(target)) 
				{
					case BLOCK_ALPHA:
						addChildAt(alphaBlock, getChildIndex(target));
					break;
					case BLOCK_BLACK:
						addChildAt(blackBlock, getChildIndex(target));
					break;
					default:
				}
				
			} catch (error:Error) {
				Utility.error("Layer > error occur");
				Utility.error(error.getStackTrace());
			}
		}
		
		public function clear():void {
			var child:DisplayObject;
			var index:int = -1;
			var module:ModuleBase;
			
			while (numChildren > 0) {
				//if(child is ViewBase) ViewBase(child).transitionOut();
				child = removeChildAt(0);
				removeFromBlockList(child);
				
				index = childList.indexOf(child);
				if (index != -1) childList.splice(index, 1);
				
				if (child is ViewBase) {
					(ViewBase(child)).hideWithoutTween();
					//module = Manager.module.getModuleByView(child as ViewBase);
					//if(module) module.hide();
				}
			}
		}
	}

}