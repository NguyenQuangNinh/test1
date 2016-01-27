package game.ui.dialog.dialogs 
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import core.Manager;
	import core.util.Utility;
	
	/**
	 * ...
	 * @author ...
	 */
	public class Dialog extends MovieClip 
	{
		public var okBtn:DisplayObject;
		public var cancelBtn:DisplayObject;
		
		public var okCallback:Function;
		public var cancelCallback:Function;
		public var block:int;
		protected var _data:Object;
		
		protected var okBtnPos:Number;
		protected var cancelBtnPos:Number;
		
		public function Dialog() 
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
			if(okBtn) okBtnPos = okBtn.x;
			if(cancelBtn) cancelBtnPos = cancelBtn.x;
		}
		
		private function init(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			x = (Manager.display.getWidth() - this.width) / 2;
			y = (Manager.display.getHeight() - this.height) / 2;
			
			if (okBtn && !okBtn.hasEventListener(MouseEvent.CLICK)) 
			{
				okBtn.addEventListener(MouseEvent.CLICK, onOK);
			}
			if (cancelBtn && !cancelBtn.hasEventListener(MouseEvent.CLICK)) 
			{
				cancelBtn.addEventListener(MouseEvent.CLICK, onCancel);
			}
		}
		
		protected function close():void {
			if (parent) parent.removeChild(this);
			visible = false;
			dispatchEvent(new Event(Event.CLOSE, true));
		}
		
		public function onShow():void { }
		
		public function onHide():void { }
		
		protected function onOK(event:Event = null):void {
			close();
			if (okCallback != null) okCallback(data);
		}
		
		protected function onCancel(event:Event = null):void {
			close();
			if (cancelCallback != null) cancelCallback(data);
		}
		
		public function get data():Object {
			return _data;
		}
		
		public function set data(value:Object):void {
			_data = value;
		}

		public function showHint():void {}
	}

}