package game.ui.soul_center.gui
{
	import core.util.FontUtil;
	import core.util.Utility;
	import game.enum.Font;
	import game.ui.components.ProgressBar;
	import game.ui.components.RuningNumberTf;
	
	/**
	 * ...
	 * @author anhtinh
	 */
	public class SoulProgressBar extends ProgressBar
	{
		
		public function SoulProgressBar()
		{
			if (progressTf != null)
			{
				FontUtil.setFont(progressTf, Font.ARIAL);
				runingNumberTf = new RuningNumberTf(progressTf);
			}
			
			progressMovie.scaleX = 0;
		}
		
		override public function setProgress(currentValue:Number, maxValue:Number, runFromZero:Boolean = false):void
		{
			
			if (progressTf != null)
			{
				runingNumberTf.setExtraText("/" + Utility.math.formatInteger(maxValue));
			}
			
			if (progressTf != null)
				progressTf.text = Utility.math.formatInteger(currentValue) + "/" + Utility.math.formatInteger(maxValue);
			if (maxValue == 0)
			{
				Utility.error("ProgressBar error : set maxValue = 0 => devide by zero");
				maxValue = 1;
			}
			
			this.lastMaxValue = maxValue;
			this.lastValue = currentValue;
			
			var percent:Number = currentValue / maxValue;
			percent = Utility.math.clamp(percent, 0, 1);
			progressMovie.scaleX = percent;
			runingNumberTf.value = currentValue;
		
		}
		
		public function setFullLevel():void
		{
			progressMovie.scaleX = 1;
			runingNumberTf.tf.text = "Tối đa";
		}
	}

}