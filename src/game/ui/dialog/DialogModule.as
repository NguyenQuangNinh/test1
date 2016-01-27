package game.ui.dialog 
{
	import core.display.ModuleBase;
	import core.event.EventEx;
	
	import game.ui.dialog.dialogs.DialogEvent;
	
	/**
	 * ...
	 * @author ...
	 */
	public class DialogModule extends ModuleBase 
	{
		
		public function DialogModule() 
		{
			
		}
		
		override protected function createView():void 
		{
			baseView = new DialogView();
			baseView.addEventListener(DialogView.EVENT, onViewEventHdl);
		}
		
		private function onViewEventHdl(e:EventEx):void {
			switch(e.data.type) {
				case DialogEvent.SUB_CLASS_CONFIRMED:
					upClassSelect(e.data.value);
					break;
			}
		}
		
		private function upClassSelect(nextCharacterID:int):void {
			//(LevelUpModule)(modulesManager.getModuleByID(ModuleID.LEVEL_UP)).nextCharacterID = nextCharacterID;
		}
		
		public function showDialog(dialogID:String, okCallback:Function, cancelCallback:Function, data:Object, block:int = 2):void {
			if(baseView) DialogView(baseView).show(dialogID, okCallback, cancelCallback, data, block);
		}
		
		public function hideDialog(dialogID:String):void {
			if (baseView) DialogView(baseView).hide(dialogID);
		}
		
		public function closeAll():void {
			if(baseView) DialogView(baseView).closeAll();
		}

		//TUTORIAL
		public function showHint(dialogID:String):void
		{
			if (baseView) DialogView(baseView).showHint(dialogID);
		}
	}

}