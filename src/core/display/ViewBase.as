package core.display 
{
	import com.greensock.TweenLite;
	import core.display.animation.Animator;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author ...
	 */
	public class ViewBase extends MovieClip 
	{
		public static const TRANSITION_IN_COMPLETE:String = "viewTransitionInComplete";
		public static const TRANSITION_OUT_COMPLETE:String = "viewTransitionOutComplete";
		public static const PRE_TRANSITION_OUT:String = "preTransitionOut";
		public static const PRE_TRANSITION_IN:String = "preTransitionIn";
		
		protected var data:Object;
		public function setViewData(data:Object):void { this.data = data; }
		
		public function ViewBase() 
		{
			this.visible = false;
		}
		
		public function destroy():void
		{
			data = null;
		}
		
		protected function renderChildAnim(container:DisplayObjectContainer):void
		{
			var child:DisplayObject;
			for (var i:int = 0; i < container.numChildren; i++) 
			{
				child = container.getChildAt(i);
				if (child is Animator) 
				{
					Animator(child).render(); 
				}
				else 
				{
					if (child is DisplayObjectContainer) renderChildAnim(child as DisplayObjectContainer);
				}
			}
		}
		
		public function renderAnim():void
		{
			renderChildAnim(this);
		}
		
		public function transitionIn():void {
			this.visible = true;
			this.alpha = 0;
			mouseChildren = false;
			mouseEnabled = false;
			renderChildAnim(this);
			TweenLite.to(this, 0.4, { alpha: 1, onComplete: transitionInComplete } );
		}
		
		protected function transitionInComplete():void {
			mouseChildren = true;
			mouseEnabled = true;
			dispatchEvent(new Event(TRANSITION_IN_COMPLETE));
		}
		
		public function transitionOut():void {
			this.alpha = 1;
			mouseChildren = false;
			mouseEnabled = false;
			TweenLite.to(this, 0.3, {alpha: 0, onComplete: transitionOutComplete} );
		}
		
		protected function transitionOutComplete():void {
			this.visible = false;
			dispatchEvent(new Event(TRANSITION_OUT_COMPLETE));
		}
		
		public function hideWithoutTween():void {
			dispatchEvent(new Event(PRE_TRANSITION_OUT));
			this.visible = false;
			transitionOutComplete();
		}
		
		public function showWithoutTween():void {
			dispatchEvent(new Event(PRE_TRANSITION_IN));
			this.visible = true;
			this.alpha = 1;
			transitionInComplete();
		}
		
		protected function dispose():void {
			
		}
	}
}