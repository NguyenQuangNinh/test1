package components 
{
	import components.StageManager;
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author 
	 */
	public class ObjectUtils 
	{
		private static var instance:ObjectUtils;
		private var registeredStartDragArr:Array;
		private var startDragRecMap:Dictionary;
		private var startDragDisMap:Dictionary;
		
		public function ObjectUtils() 
		{
			if (instance) throw new Error("the ObjectUtils instance is already exist!");
			instance = this;
			registeredStartDragArr = new Array();
			startDragRecMap = new Dictionary();
			startDragDisMap = new Dictionary();
			StageManager.getInstance().registerEvent(MouseEvent.MOUSE_MOVE, stageMouseMoveHdl);
		}
		
		private function stageMouseMoveHdl(e:MouseEvent):void 
		{
			var mc:DisplayObject;
			var rec:Rectangle;
			var x:Number;
			var y:Number;
	 
			for (var i:int = 0; i < registeredStartDragArr.length; i++) 
			{
				mc = registeredStartDragArr[i];
				rec = startDragRecMap[mc];
				x = mc.parent.mouseX - startDragDisMap[mc].x;
				y = mc.parent.mouseY - startDragDisMap[mc].y;
				if (x < rec.left) x = rec.left;
				if (x > rec.right) x = rec.right;
				if (y < rec.top) y = rec.top;
				if (y > rec.bottom) y = rec.bottom;

				mc.x = x;
				mc.y = y;
			}
		}
		
		public static function getInstance():ObjectUtils 
		{
			if (instance) return instance;
			else 
			{
				instance = new ObjectUtils();
				return instance;
			}
		}
		
		public function clearMemoryRecursive(dobj:DisplayObject):void
		{
			if (! (dobj is DisplayObjectContainer)) 
			{
				if (dobj is Bitmap) Bitmap(dobj).bitmapData.dispose();
				return;
			}
			while (DisplayObjectContainer(dobj).numChildren > 0)
			{
				if (DisplayObjectContainer(dobj).getChildAt(0) is MovieClip) MovieClip(DisplayObjectContainer(dobj).getChildAt(0)).stop();
				clearMemoryRecursive(DisplayObjectContainer(dobj).getChildAt(0));
				DisplayObjectContainer(dobj).removeChildAt(0);
			}
		}
		
		public function startDrag(mc:DisplayObject, rec:Rectangle):void
		{
			if (startDragRecMap[mc]) return;
			registeredStartDragArr.push(mc);
		
			startDragRecMap[mc] = rec;
			startDragDisMap[mc] = new Point(mc.mouseX, mc.mouseY);
		}
		
		public function stopDrag(mc:DisplayObject):void
		{
			Utilities.removeElementFromArray(registeredStartDragArr, mc);
			delete startDragRecMap[mc];
			delete startDragDisMap[mc];
		}
		
		public function getObjString(obj:Object):String
		{
			var str:String = "{ ";
			for (var i:* in obj) 
			{
				str += i.toString() + ": " + obj[i] + ", ";
			}
			str = str.substr(0, str.length - 2) + "}";
			return str;
		}
		
	}

}