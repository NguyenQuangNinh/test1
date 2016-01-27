package components.popups 
{
	import com.greensock.TweenMax;
	import components.enum.PopupAction;
	import components.HoverButton;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	/**
	 * ...
	 * @author 
	 */
	public class BasePopup extends MovieClip
	{
		public var closeBtn:MovieClip;
		public var bg:Sprite;
		private var callbackHdl:Function;
		
		public function BasePopup() 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			if (closeBtn) 
			{
				closeBtn.addEventListener(MouseEvent.CLICK, closeBtnClickHdl);
				HoverButton.initHover(closeBtn);
			}
			bg = new Sprite();
			addChildAt(bg, 0);
			bg.graphics.beginFill(0x000000, 0.5);
			bg.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			bg.graphics.endFill();
			var p:Point = new Point(0, 0);
			p = this.localToGlobal(p);
			bg.x = - p.x;
			bg.y = - p.y;
			this.visible = false;
		}
		
		private function closeBtnClickHdl(e:MouseEvent):void 
		{
			hide(PopupAction.CLOSE);
		}
		
		public function show(callback:Function = null, title:String = "", msg:String = ""):void
		{
			if (callbackHdl != null) throw new Error("The popup is showed already!");
			callbackHdl = callback;
			this.visible = true;
			TweenMax.to(this, 0.5, {alpha: 1});
		}
		
		public function hide(action:int = -1, data:Object = null):void
		{
			if (callbackHdl != null) callbackHdl(action, data);
			callbackHdl = null;
			TweenMax.to(this, 0.5, {alpha: 0, onComplete:onComplete});
		}
		
		private function onComplete():void 
		{
			this.visible = false;
		}
	}

}