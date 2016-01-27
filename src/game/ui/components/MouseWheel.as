package game.ui.components
{
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author Vu Anh
	 */
	public class MouseWheel 
	{
		
		private static var instance:MouseWheel;
		private var targetMap:Dictionary;
		private var selectedTarget:DisplayObject;
		private var isStageRegister:Boolean;
		
		public function MouseWheel() 
		{
			if (instance) throw new Error("MouseWheel singleton error!");
			targetMap = new Dictionary();
		}
		
		public function initMouseWheel(stage:Stage):void
		{
			if (!isStageRegister)
			{
				isStageRegister = true;
				stage.addEventListener(MouseEvent.MOUSE_WHEEL, stageMouseWheelHdl);
			}
		}
		
		public static function getInstance():MouseWheel
		{
			if (!instance) instance = new MouseWheel();
			return instance;
		}
		
		public function register(target:DisplayObject, wheelHdl:Function):void
		{
			if (targetMap[target])
			{
				throw new Error("MouseWheel - target registered allready!");
				return;
			}
			targetMap[target] = wheelHdl;
			target.addEventListener(MouseEvent.MOUSE_DOWN, targetMouseDownHdl);
		}
		
		private function stageMouseWheelHdl(e:MouseEvent):void 
		{
			if (selectedTarget) targetMap[selectedTarget](e);
		}
		
		private function targetMouseDownHdl(e:MouseEvent):void 
		{
			selectedTarget = DisplayObject(e.currentTarget);
		}
		
	}

}