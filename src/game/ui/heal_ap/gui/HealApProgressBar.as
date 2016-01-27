package game.ui.heal_ap.gui 
{
	import core.event.EventEx;
	import core.util.FontUtil;
	import core.util.Utility;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import game.enum.Font;
	import game.ui.heal_ap.HealApEvent;
	/**
	 * ...
	 * @author anhtinh
	 */
	public class HealApProgressBar extends Sprite
	{
		private static const PROGRESS_WIDTH : int = 386;
		private static const BEGIN_X : int = 13;
		
		public var totalTf : TextField;
		public var currentProgressMov : MovieClip;
		public var addedProgressMov : MovieClip;
		private var slider : HealSlider;
		private var minX : Number ;
		private var currentPercent:Number = 0;
		private var maxAp:int = 1;
		private var apBuy:int;
		private var amountCanBuy:int;
		
		public function HealApProgressBar() 
		{
			FontUtil.setFont(totalTf, Font.ARIAL, false);
			
			slider = new HealSlider();
			slider.x = 185;
			slider.y = 25;
			this.addChild(slider);
			init();
		}
		
		private function init() : void {
			slider.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		}
		
		private function onMouseDown(e:MouseEvent):void 
		{
			this.stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			this.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		private function onMouseMove(e:MouseEvent):void 
		{
			var localPos : Point = this.globalToLocal(new Point(e.stageX, 0));
			
			var maxX : int = Math.min( (PROGRESS_WIDTH + BEGIN_X), Math.round(minX + (amountCanBuy / maxAp) * PROGRESS_WIDTH) );
			slider.x = Utility.math.clamp(localPos.x, minX, maxX);
			
			var percent : Number = Utility.math.clamp((slider.x - BEGIN_X) / PROGRESS_WIDTH, 0, 1); 
			setPercent(percent);
		}
		
		private function onMouseUp(e:MouseEvent):void 
		{
			this.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			this.stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		public function setInfo(current : int, max : int, amountCanBuy : int) : void {
			maxAp = max;
			this.amountCanBuy = amountCanBuy;
			
			totalTf.text = Utility.math.formatInteger(maxAp);
			
			current = Utility.math.clamp(current, 0, max);
			var percent : Number = current / max;
			currentPercent = percent;
			currentProgressMov.scaleX = percent;
			
			minX = BEGIN_X + percent * PROGRESS_WIDTH;
			var maxX : int = Math.min( (PROGRESS_WIDTH + BEGIN_X), Math.round(minX + (amountCanBuy / maxAp) * PROGRESS_WIDTH) );
			slider.x = maxX;
			
			percent = Utility.math.clamp((slider.x - BEGIN_X) / PROGRESS_WIDTH, 0, 1); 
			setPercent(percent);
		}
		
		private function setPercent(percent : Number) : void {
			addedProgressMov.scaleX = percent;
			
			apBuy = Math.round((percent - currentPercent) * maxAp);
			apBuy = Utility.math.clamp(apBuy, 0, amountCanBuy);
			slider.setAddedAmount(apBuy);
			
			this.dispatchEvent(new EventEx(HealApEvent.HEAL_AMOUNT, apBuy, true));
		}
		
		public function getApBuy() : int {
			return apBuy;
		}
	}

}