package game.ui.waitting
{
	import core.display.ModuleBase;
	import core.display.ViewBase;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author chuongth2
	 */
	public class WaittingModule extends ModuleBase
	{
		
		private var msg:String;
		
		public function WaittingModule()
		{
			this.addEventListener(ViewBase.TRANSITION_IN_COMPLETE, onTransitionInCompleteHandler)
		}
		
		private function onTransitionInCompleteHandler(e:Event):void 
		{
			if (baseView)
			{
				WaittingView(baseView).showWaitting(this.msg);
			}
		}
		
		override protected function createView():void
		{
			baseView = new WaittingView();
		}
		
		public function showWaitting(msg:String):void
		{
			this.msg = msg;
		}
		
		public function hideWaitting():void
		{
			this.msg = "";
			if (baseView)
			{
				WaittingView(baseView).hideWaitting();
			}
		}
	}

}