package core.display.layer
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import core.Manager;
	import core.event.EventEx;
	import core.util.Utility;
	
	/**
	 * ...
	 * @author ...
	 */
	public class LayerManager
	{
		public static const LAYER_SCREEN:int 		= getIndex();
		public static const LAYER_SCREEN_TOP:int 	= getIndex();
		public static const LAYER_HUD_TOP:int 		= getIndex();
		public static const LAYER_POPUP:int 		= getIndex();
		public static const LAYER_HUD:int 		= getIndex();
		public static const LAYER_DIALOG:int 		= getIndex();
		public static const LAYER_TOP:int 		= getIndex();
		public static const LAYER_TOOLTIP:int 	= getIndex();
		public static const LAYER_MESSAGE:int 	= getIndex();
		public static const LAYER_EFFECT:int 		= getIndex();
		public static const LAYER_COUNT:int 		= getIndex();
		
		private var _arrLayer:Array = [];

		private static var index:int = 0;

		private static function getIndex():int
		{
			return index++;
		}
		
		public function addToLayer(target:DisplayObject, layerIndex:int, block:int = 2):void
		{
			var layer:Layer = getLayerByID(layerIndex);
			if (layer)
			{
				layer.add(target, block);
			}
			else
			{
				Utility.error("LayerManager > removeFromLayer() > layer at : " + layerIndex + "not exist");
			}
		}
		
		public function removeFromLayer(target:DisplayObject, layerIndex:int):void
		{
			var layer:Layer = getLayerByID(layerIndex);
			if (layer)
			{
				layer.remove(target);
			}
			else
			{
				Utility.error("LayerManager > removeFromLayer() > layer at : " + layerIndex + "not exist");
			}
		}
		
		public function clearLayer(layerIndex:int):void
		{
			var layer:Layer = getLayerByID(layerIndex);
			if (layer)
			{
				layer.clear();
			}
			else
			{
				Utility.error("LayerManager > clearLayer() > layer at : " + layerIndex + "not exist");
			}
		}
		
		private function init():void
		{
			var container:Sprite = Manager.display.getContainer();
			
			//add layer theo thu tu index
			var layer:Layer;
			for (var i:int = LAYER_SCREEN; i < LAYER_COUNT; i++)
			{
				layer = new Layer();
				_arrLayer.push(layer);
				container.addChild(layer);
			}
		}
		
		private function getLayerByID(layerIndex:int):Layer
		{
			if (layerIndex >= LAYER_SCREEN && layerIndex < LAYER_COUNT)
				return _arrLayer[layerIndex];
			Utility.error("invalid layer id:" + layerIndex);
			return new Layer();
		}
		
		public function LayerManager()
		{
			init();
		}
	}
}