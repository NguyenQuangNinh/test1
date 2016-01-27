package game.ui.soul_center.gui
{
	import com.greensock.TweenMax;
	import core.event.EventEx;
	import core.Manager;
	import flash.display.MovieClip;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author chuongth2
	 */
	public class SoulContentPanel extends MovieClip
	{
		public var exchangePanel:ExchangeSoulPanel;
		public var divinePanel:DivineSoulPanel;
		
		public function SoulContentPanel()
		{
			exchangePanel.visible = false;
			divinePanel.visible = true;
			
			this.addEventListener(ExchangePointInfo.EXCHANGE_SOUL_BTN, onShowExchangeSoul);
			this.addEventListener(ExchangeSoulPanel.BACK_EXCHANGE_BTN, onBackExchange);
		}
		
		private function onBackExchange(e:Event):void
		{
			exchangePanel.visible = false;
			divinePanel.visible = true;
			//TweenMax.to(exchangePanel, 1, {setSize:{width:100, height:100}, onComplete: onBackFinishTween});
		}
		
		private function onBackFinishTween():void
		{
			exchangePanel.visible = false;
			divinePanel.visible = true;
		}
		
		private function onShowExchangeSoul(e:EventEx):void
		{
			var exchangePoint:int = e.data as int;
			if (exchangePoint >= 0)
			{
				exchangePanel.setExchangePoint(exchangePoint);
				exchangePanel.init();
				
				exchangePanel.visible = true;
				divinePanel.visible = false;
				//TweenMax.to(exchangePanel, 1, {setSize:{width:exchangePanel.width, height:exchangePanel.height}, onComplete: onShowFinishTween});
			}
		}
		
		private function onShowFinishTween():void
		{
		
		}
		
		public function buyItemSuccess():void
		{
			Manager.display.showMessage("Thực hiện thành công ^^");
		}
		
		public function updateExchangePoint():void
		{
			exchangePanel.updateExchangePoint();
			divinePanel.updateExchangePoint();
		}
		
		public function activeAutoDivine(active:Boolean):void {
			divinePanel.activeAutoDivine(active);
		}
	}

}