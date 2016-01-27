/**
 * Created by NINH on 1/12/2015.
 */
package game.ui.dice.gui
{

	import com.greensock.TweenLite;
	import com.greensock.TweenMax;

	import core.util.FontUtil;

	import flash.display.MovieClip;
	import flash.text.TextField;

	import game.enum.Font;

	public class Dices extends MovieClip
	{
		public var dice1:MovieClip;
		public var dice2:MovieClip;
		public var dice3:MovieClip;
		public var scoreTf:TextField;
		public var coverMov:MovieClip;

		public function Dices()
		{
			FontUtil.setFont(scoreTf, Font.ARIAL, true);
			dice1.gotoAndStop(1);
			dice2.gotoAndStop(1);
			dice3.gotoAndStop(1);
			scoreTf.text = "";
		}

		public function reset():void
		{
			coverMov.y = -60;
			dice1.gotoAndStop(1);
			dice2.gotoAndStop(1);
			dice3.gotoAndStop(1);
			scoreTf.text = "";
		}

		public function openWithAnim(diceValues:Array):void
		{
			var total:int = 0;
			for (var i:int = 0; i < diceValues.length; i++)
			{
				var value:int = diceValues[i];
				this["dice"+(i + 1)].gotoAndStop(value);
				total += value;
			}
			coverMov.y = -60;

			TweenMax.to(coverMov, 0.3, {y:-130});
			scoreTf.text = total.toString();
		}
	}
}
