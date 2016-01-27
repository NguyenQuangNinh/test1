/**
 * Created by NINH on 1/14/2015.
 */
package game.ui.dice.gui
{

	import com.greensock.TweenMax;
	import com.greensock.easing.Elastic;

	import flash.display.MovieClip;
	import flash.display.SimpleButton;

	public class Bet extends MovieClip
	{
		public var smallerBtn:SimpleButton;
		public var greaterBtn:SimpleButton;

		public function Bet()
		{
		}

		public function show():void
		{
			smallerBtn.scaleX = 0;
			greaterBtn.scaleY = 0;
			smallerBtn.visible = true;
			greaterBtn.visible = true;

			TweenMax.to(smallerBtn, 1, {scaleX:1, scaleY:1, ease:Elastic.easeOut});
			TweenMax.to(greaterBtn, 1, {scaleX:1, scaleY:1, ease:Elastic.easeOut});

		}

		public function hide():void
		{
			smallerBtn.visible = false;
			greaterBtn.visible = false;
		}
	}
}
