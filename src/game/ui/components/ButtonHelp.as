package game.ui.components
{
	import flash.display.DisplayObject;
	import flash.display.SimpleButton;
	
	public class ButtonHelp extends SimpleButton
	{
		public function ButtonHelp(upState:DisplayObject=null, overState:DisplayObject=null, downState:DisplayObject=null, hitTestState:DisplayObject=null)
		{
			super(upState, overState, downState, hitTestState);
		}
	}
}