package game.ui.preloader 
{
	import com.greensock.TweenMax;
	import core.display.animation.Animator;
	import core.display.pixmafont.PixmaText;
	import core.display.ViewBase;
	import core.Manager;
	import core.util.FontUtil;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.TextField;
	import game.enum.Font;
	
	

	/**
	 * ...
	 * @author TrungLNM
	 */
	public class PreloaderView extends ViewBase
	{
		private static const MASK_WIDTH		:int = 615;
		public var processingBarMov	:MovieClip;
		public var processBarMask	:MovieClip;
		public var statusText		:TextField;
		
		private var _percent		:Number = 0;
		private var step:String = "";
		
		public function PreloaderView() {		

			FontUtil.setFont(statusText, Font.ARIAL);
			statusText.text = "";
		}
		
		private function onAnimLoadedHdl(e:Event):void {
			var anim:Animator = e.target as Animator;
			if (anim) {
				anim.play(0, 0);
			}
		}
		
		override protected function transitionOutComplete():void {
			setProgress(0, false);
			super.transitionOutComplete();
		}
		
		override public function transitionIn():void {
			super.transitionIn();
			setProgress(0, false);
		}
		
		public function get percent():Number {
			return _percent;
		}
		
		public function setStep(value:String = ""):void {
			step = "  Đã tải: " + value;
		}
		
		public function setProgress(value:Number, tween:Boolean):void
		{
			_percent = value;
			if (tween) {
				TweenMax.to(processBarMask, 0.25, { scaleX:_percent } );
			}
			else {
				processBarMask.scaleX = _percent;
			}
			
			statusText.text = "Đang tải dữ liệu: (" + int(_percent*100) + "%)" + step;
		}
	}
}