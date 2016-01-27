package game.ui.components
{
	import flash.display.DisplayObject;
	import flash.display.SimpleButton;
	
	public class ButtonClose extends SimpleButton
	{
		public function ButtonClose(upState:DisplayObject=null, overState:DisplayObject=null, downState:DisplayObject=null, hitTestState:DisplayObject=null)
		{
			super(upState, overState, downState, hitTestState);
		}
	}
}