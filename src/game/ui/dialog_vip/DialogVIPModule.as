package game.ui.dialog_vip 
{
	import core.display.ModuleBase;
	
	/**
	 * ...
	 * @author MaiPTT
	 */
	public class DialogVIPModule extends ModuleBase 
	{
		
		public function DialogVIPModule() {
			
		}
		
		override protected function createView():void {
			baseView = new DialogVIPView();
		}
	}

}