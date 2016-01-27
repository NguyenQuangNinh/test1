package game.ui.tutorial 
{
	import core.display.ModuleBase;
	
	/**
	 * ...
	 * @author MaiPTT
	 */
	public class TutorialModule extends ModuleBase 
	{
		
		public function TutorialModule() {
			
		}
		
		public function setTutorialScene(value:int):void {
			(TutorialView)(baseView).setTutorialStep(value);
		}
		
		public function restart(sceneID:int):void {
			(TutorialView)(baseView).restart(sceneID);
		}
		
		override protected function createView():void {
			baseView = new TutorialView();
		}
	}

}