package game.ui.daily_task 
{
	import core.display.ModuleBase;
	
	/**
	 * ...
	 * @author MaiPTT
	 */
	public class DailyTaskModule extends ModuleBase 
	{
		
		public function DailyTaskModule() {
			
		}
		
		override protected function createView():void {
			baseView = new DailyTaskView();
		}

		//TUTORIAL
		public function showHint(taskID:int, content:String = ""):void
		{
			if(baseView)
				DailyTaskView(baseView).showHint(taskID, content);
		}
	}

}