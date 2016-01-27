package components.popups 
{
	import com.greensock.TweenMax;
	import components.enum.PopupAction;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	/**
	 * ...
	 * @author vu anh
	 */
	public class OKCancelPopup extends MovieClip
	{
		public var okBtn:SimpleButton;
		public var cancelBtn:SimpleButton;
		protected var callbackHdl:Function;
		protected var data:Object;
		public var titleTf:TextField;
		public var messageTf:TextField;
		
		protected var okPos:Number;
		protected var cancelPos:Number;
		
		public function OKCancelPopup() 
		{
			if (okBtn) 
			{
				okBtn.addEventListener(MouseEvent.CLICK, okBtnClickHdl);
				okPos = okBtn.x;
			}
			if (cancelBtn) 
			{
				cancelBtn.addEventListener(MouseEvent.CLICK, cancelBtnClickHdl);
				cancelPos = cancelBtn.x;
			}
		}
		
		protected function cancelBtnClickHdl(e:Event):void 
		{
			hide(PopupAction.CANCEL);
		}
		
		protected function okBtnClickHdl(e:Event):void 
		{
			hide(PopupAction.OK);
		}
		
		public function show(callback:Function = null, title:String = "", msg:String = "", data:Object = null, isHideCancelBtn:Boolean = false):void
		{
			if (okBtn && cancelBtn)
			{
				if (!isHideCancelBtn)
				{
					okBtn.x = okPos;
					cancelBtn.x = cancelPos;
					cancelBtn.visible = true;
				}
				else 
				{
					okBtn.x = (okPos + cancelPos) / 2;
					cancelBtn.visible = false;
				}
			}
			if (callbackHdl != null) throw new Error("The popup is showed already!");
			if (titleTf && title != "") titleTf.text = title;
			if (messageTf && msg != "") messageTf.text = msg;
			this.data = data;
			callbackHdl = callback;
			this.visible = true;
			this.alpha = 0;
			TweenMax.to(this, 0.5, {alpha: 1});
		}
		
		public function hide(action:int = -1):void
		{
			if (callbackHdl != null) callbackHdl(action, data);
			callbackHdl = null;
			TweenMax.to(this, 0.5, {alpha: 0, onComplete:onComplete});
		}
		
		protected function onComplete():void 
		{
			this.visible = false;
		}
		
	}

}