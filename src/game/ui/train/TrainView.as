package game.ui.train
{
	import core.display.ViewBase;
	import core.Manager;
	import core.util.FontUtil;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import game.enum.GameConfigID;
	import game.Game;
	import game.ui.hud.HUDModule;
	import game.ui.ModuleID;
	import game.ui.train.home.TrainHome;
	import game.ui.train.inroom.TrainInRoom;
	public class TrainView extends ViewBase
	{

		public var home:TrainHome;
		public var roomView:TrainInRoom;
		
		public function TrainView()
		{
			home.closeBtn.addEventListener(MouseEvent.CLICK, closeBtnHdl);
		}
		
		private function closeBtnHdl(e:MouseEvent):void 
		{
			HUDModule(Manager.module.getModuleByID(ModuleID.HUD)).updateHUDButtonStatus(ModuleID.KUNGFU_TRAIN, false);
		}
		
		public function showHome():void
		{
			roomView.pauseAllAnims();
			roomView.visible = false;
			home.visible = true;
			home.roomList.getRoomList();
		}
		
		public function showRoom():void
		{
			home.visible = false;
			roomView.visible = true;
			roomView.reset();
		}
		
		public function startKungfu():void
		{
			roomView.startTraining();
		}
		
		public function stopKungfu():void
		{
			roomView.stopTraining();
		}

	}

}