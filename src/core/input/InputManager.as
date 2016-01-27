package core.input 
{
	import flash.display.Stage;
	import flash.events.EventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;

	/**
	 * ...
	 * @author bangnd2
	 */
	public class InputManager extends EventDispatcher
	{
		private var stage:Stage;
		
		public function InputManager(stage:Stage):void
		{
			if(stage != null)
			{
				this.stage = stage;
				stage.addEventListener(MouseEvent.CLICK, onClicked);
			}
		}
		
		protected function onClicked(event:MouseEvent):void
		{
			dispatchEvent(event);
		}
	}
}