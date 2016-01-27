package game.ui.soul_center.gui
{
	import com.greensock.TweenLite;
	import core.event.EventEx;
	import core.util.FontUtil;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.text.TextField;
	import game.enum.Font;
	import game.ui.components.RuningNumberTf;
	
	/**
	 * ...
	 * @author chuongth2
	 */
	public class ExchangePointInfo extends MovieClip
	{
		public static const EXCHANGE_SOUL_BTN:String = "exchange_soul_btn";
		
		public var exchangePointTf:TextField;
		public var btnExchangeSoul:SimpleButton;
		
		private var _runningTf:RuningNumberTf;
		private var oldExchangePoint:int = 0;
		
		public function ExchangePointInfo()
		{
			FontUtil.setFont(exchangePointTf, Font.ARIAL);
			_runningTf = new RuningNumberTf(exchangePointTf);
			
			btnExchangeSoul.addEventListener(MouseEvent.CLICK, onExchangeSoul);
		}
		
		private function onExchangeSoul(e:Event):void
		{
			if(oldExchangePoint>=0)
				this.dispatchEvent(new EventEx(EXCHANGE_SOUL_BTN, oldExchangePoint, true));
		}
		public function setExchangePoint(val:int):void
		{
			_runningTf.value = oldExchangePoint;
			oldExchangePoint = val;
			//exchangePointTf.text = "" + val;
			TweenLite.to(_runningTf, 1.5, {value : val } );	
		}
	
	}

}