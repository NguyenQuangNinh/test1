package components 
{
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author ...
	 */
	public class StageManager 
	{
		private static var instance:StageManager;
		public var stage:Stage;
		private var handlerMap:Object;
		private var isInited:Boolean;
		public function StageManager() 
		{
			if (instance) throw new Error("StageManager singleton error!");
			handlerMap = new Object();
		}
		
		public static function getInstance():StageManager
		{
			if (!instance) instance = new StageManager();
			return instance;
		}
		
		public function initStage(stage:Stage):void
		{
			if (isInited) return;
			isInited = true;
			this.stage = stage;
			stage.addEventListener(MouseEvent.MOUSE_DOWN, stageEventHdl, false, 0, true);
			stage.addEventListener(MouseEvent.MOUSE_UP, stageEventHdl, false, 0, true);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, stageEventHdl, false, 0, true);
			stage.addEventListener(MouseEvent.CLICK, stageEventHdl, false, 0, true);
			stage.addEventListener(Event.FULLSCREEN, stageEventHdl, false, 0, true);
		}
		
		private function stageEventHdl(e:Event):void 
		{
			var hdlList:Array = handlerMap[e.type];
			if (!hdlList) return;
			for (var i:int = 0; i < hdlList.length; i++) 
			{
				hdlList[i](e);
			}
		}
	
		public function unregisterAllEvents():void
		{
			if (stage)
			{
				stage.removeEventListener(MouseEvent.MOUSE_DOWN, stageEventHdl);
				stage.removeEventListener(MouseEvent.MOUSE_UP, stageEventHdl);
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, stageEventHdl);
				stage.removeEventListener(MouseEvent.CLICK, stageEventHdl);
				stage.removeEventListener(Event.FULLSCREEN, stageEventHdl);
				stage = null;
				instance = null;
			}
		}
		
		public function registerEvent(type:String, hdl:Function):void
		{
			if (!handlerMap[type]) handlerMap[type] = new Array();
			if (ComponentUtilities.getElementIndex(handlerMap[type], hdl) >= 0) return;
			handlerMap[type].push(hdl);
		}
		
		public function unregisterEvent(type:String, hdl:Function):void
		{
			if (!handlerMap[type]) return;
			ComponentUtilities.removeElementFromArray(handlerMap[type], hdl);
		}
	}

}