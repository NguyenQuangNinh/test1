package game.ui.components
{
	import com.greensock.TweenLite;
	import core.util.FontUtil;
	import core.util.Utility;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;
	import game.enum.Font;
	
	/**
	 * ...
	 * @author anhtinh
	 */
	public class ProgressBar extends Sprite
	{
		public var progressMovie:MovieClip;
		public var progressTf:TextField;
		public var bgMov:MovieClip;
		
		protected var runingNumberTf:RuningNumberTf;
		
		protected var lastValue:Number = 0;
		protected var lastMaxValue:Number = 1;
		
		public function ProgressBar()
		{
			if (progressTf != null)
			{
				FontUtil.setFont(progressTf, Font.ARIAL);
				if (runingNumberTf) runingNumberTf = new RuningNumberTf(progressTf);
			}
			
			progressMovie.scaleX = 0;
		}
		
		public function setPercent(percent:Number, runFromZero:Boolean = false):void
		{
			
			if (runFromZero)
			{
				progressMovie.scaleX = 0;
				if (runingNumberTf) runingNumberTf.value = 0;
			}
			
			percent = Utility.math.clamp(percent, 0, 1);
			
			var tweenTime:Number = Math.abs(percent - progressMovie.scaleX) * 2;
			
			TweenLite.to(progressMovie, tweenTime, {scaleX: percent, onComplete: tweenComplete});
			
			if (runingNumberTf) TweenLite.to(runingNumberTf, tweenTime, {value: this.lastValue});
		
		}
		
		private function tweenComplete():void
		{
		
		}
		
		public function setProgress(currentValue:Number, maxValue:Number, runFromZero:Boolean = false):void
		{
			
			if (currentValue == lastValue && maxValue == lastMaxValue)
				return;
			
			if (progressTf != null)
			{
				if (runingNumberTf) runingNumberTf.setExtraText("/" + Utility.math.formatInteger(maxValue));
			}
			
			if (progressTf != null)
				progressTf.text = Utility.math.formatInteger(currentValue) + "/" + Utility.math.formatInteger(maxValue);
			if (maxValue == 0)
			{
				Utility.error("ProgressBar error : set maxValue = 0 => devide by zero");
				Logger.traceCallStack();
				maxValue = 1;
			}
			
			if (runingNumberTf) runingNumberTf.value = this.lastValue;
			
			this.lastMaxValue = maxValue;
			this.lastValue = currentValue;
			
			setPercent(currentValue / maxValue, runFromZero);
		}
	
	}

}