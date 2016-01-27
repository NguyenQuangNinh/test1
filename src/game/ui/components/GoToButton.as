package game.ui.components
{
	import flash.display.DisplayObject;
	import flash.display.SimpleButton;
	
	public class GoToButton extends SimpleButton
	{
		public function GoToButton(upState:DisplayObject=null, overState:DisplayObject=null, downState:DisplayObject=null, hitTestState:DisplayObject=null)
		{
			super(upState, overState, downState, hitTestState);
		}
	}
}