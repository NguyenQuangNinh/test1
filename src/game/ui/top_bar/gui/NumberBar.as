package game.ui.top_bar.gui 
{
	import com.greensock.TweenLite;
	import core.util.FontUtil;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;
	import game.enum.Font;
	import game.ui.components.RuningNumberTf;
	/**
	 * ...
	 * @author chuongth2
	 */
	public class NumberBar extends MovieClip
	{
		
		public var valueTf:TextField;
		
		private var runingNumberTf:RuningNumberTf;
		private var _val:int = 0;
		
		public function NumberBar()
		{
			FontUtil.setFont(valueTf, Font.ARIAL, false);
			runingNumberTf = new RuningNumberTf(valueTf);
		}
		
		public function setValue(val:int):void
		{
			if (val == 0)
				valueTf.text = "0";
			if (val == this._val)
				return;	
			runingNumberTf.value = this._val
			this._val = val;
			var timeTween:Number = this._val / 10000;
			timeTween = Math.min(timeTween, 2);
			TweenLite.to(runingNumberTf, timeTween, {value: this._val});
		
		}
	}

}