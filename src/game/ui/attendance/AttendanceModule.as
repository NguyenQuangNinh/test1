package game.ui.attendance 
{
	import core.display.ModuleBase;
	import core.Manager;
	import flash.events.Event;
	import game.ui.hud.HUDModule;
	import game.ui.ModuleID;
	
	/**
	 * ...
	 * @author anhpnh2
	 */
	public class AttendanceModule extends ModuleBase 
	{
		public static const CLOSE_ATTENDANCE_VIEW:String = "close_Attendance_View";
		
		public function AttendanceModule() {
			
		}
		
		override protected function createView():void {
			baseView = new AttendanceView();
			
			baseView.addEventListener(CLOSE_ATTENDANCE_VIEW, closeHandler);
		}
		
		private function closeHandler(e:Event):void 
		{
			var hudModule : HUDModule = Manager.module.getModuleByID(ModuleID.HUD) as HUDModule;
			if (hudModule != null) {
				hudModule.updateHUDButtonStatus(ModuleID.ATTENDANCE, false);
			}
		}
		
	}

}