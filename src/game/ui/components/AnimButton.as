package game.ui.components 
{
	import core.display.animation.Animator;
	import core.util.Utility;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author anhtinh
	 */
	public class AnimButton extends Sprite
	{
		private var anim : Animator = new Animator();
		private var _idleIndex : int ;
		private var _overIndex : int ;
		private var _pressIndex : int ;
		
		public function AnimButton() 
		{
			this.addChild(anim);
			anim.visible = false;
		}
		
		public function init(animURL : String, idleIndex : int = 0, overIndex : int = 0, pressIndex : int = 0) : void {
			if (animURL != null) {
				this._idleIndex = idleIndex;
				this._overIndex = overIndex;
				this._pressIndex = pressIndex;
				anim.addEventListener(Animator.LOADED, onAnimLoaded);
				anim.load(animURL);
			}
		}
		
		private function onAnimLoaded(e:Event):void 
		{
			anim.play(_idleIndex);
			anim.visible = true;
			
			this.addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			this.addEventListener(MouseEvent.ROLL_OUT, onRollOut);
			//this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			//this.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			this.addEventListener(MouseEvent.CLICK, onMouseClick);
			
			if (!this.stage) this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			else {
				this.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			}
			
		}
		
		private function onMouseClick(e:MouseEvent):void 
		{
			Utility.log("onMouseClick : ");
		}
		
		private function onAddedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			this.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		private function onRollOver(e:MouseEvent):void 
		{
			anim.play(_overIndex);
		}
		
		private function onRollOut(e:MouseEvent):void 
		{
			anim.play(_idleIndex);
		}
		
		private function onMouseDown(e:MouseEvent):void 
		{
			//Utility.log("onMouseDown : ");
			
			anim.play(_pressIndex);
		}
		
		private function onMouseUp(e:MouseEvent):void 
		{
			//Utility.log("onMouseUp : ");
			anim.play(_overIndex);
			
		}
		
	}

}