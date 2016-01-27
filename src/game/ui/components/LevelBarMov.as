package game.ui.components 
{
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author MaiPTT
	 */
	public class LevelBarMov extends MovieClip 
	{
		public static const TWEEN_COMPLETE:String = "tweenComplete";
		
		public var contentMov		:MovieClip;
		public var maskMov			:MovieClip;
		private var _levelPercent	:Number;
		private var _tweenTime		:Number;
		
		public function LevelBarMov() 	{
			contentMov.mask = maskMov;
			levelPercent = 0;
		}
		
		public function setTransmissionValue(src:int, desc:int):void {
			var repeat:int = Math.floor(desc / src);
			var duration:Number = (Number)(1 / repeat);
			TweenMax.to(maskMov, duration, { repeat:repeat, scaleX:1, onRepeat:onRepeatHdl, onComplete:continueTweening, onCompleteParams:[(int)(desc % src), (Number)((1/repeat * (desc % src) / 100))] } );
		}
		
		private function continueTweening(value:int, duration:Number):void {
			TweenMax.to(maskMov, duration, { scaleX:value } );
		}
		
		private function onRepeatHdl():void {
			scaleX = 0;
		}
		
		public function set levelPercent(value:Number):void {
			TweenMax.to(maskMov, 0.2, {scaleX:value});
		}
		
		public function setPercent(value:Number, tween:Boolean):void
		{
			if(tween)
			{
				TweenMax.to(maskMov, 0.5, {scaleX:value, onComplete: onTweenComplete});
			}
			else
			{
				maskMov.scaleX = value;
			}
		}
		
		private function onTweenComplete():void
		{
			dispatchEvent(new Event(TWEEN_COMPLETE, true));
		}
		
		private function conitueTween(value:Number):void {
			maskMov.scaleX = 0;
			_tweenTime = Math.abs(value - maskMov.scaleX) * 2;
			TweenLite.to(maskMov, _tweenTime, { scaleX : value} );
		}
	}

}