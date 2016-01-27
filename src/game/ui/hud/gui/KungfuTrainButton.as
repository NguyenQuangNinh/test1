package game.ui.hud.gui 
{
	/**
	 * ...
	 * @author vu anh
	 */
	import flash.display.MovieClip;

	import game.ui.hud.HUDButtonID;

	/**
	 * ...
	 * @author chuongth2
	 */
	public class KungfuTrainButton extends HUDButton
	{

		public function KungfuTrainButton() 
		{
			ID = HUDButtonID.KUNGFU_TRAIN;
		}

		override public function checkVisible():void
		{
			this.visible = false;
		}
	}

}