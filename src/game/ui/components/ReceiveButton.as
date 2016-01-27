package game.ui.components 
{
	import core.event.EventEx;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class ReceiveButton extends MovieClip
	{
		public static const ON_RECEIVE:String = "receive";
		
		private var _data:Object;
		
		public function ReceiveButton() 
		{
			if (stage)
				init();
			else addEventListener(Event.ADDED_TO_STAGE, init);	
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			initUI();
		}
		
		private function initUI():void 
		{
			//init button
			this.buttonMode = true;			
			
			//add events
			addEventListener(MouseEvent.CLICK, onReceiveClickHdl);
			addEventListener(MouseEvent.MOUSE_DOWN, onChangeStateHdl);
			addEventListener(MouseEvent.MOUSE_UP, onChangeStateHdl);
			
		}
		
		private function onChangeStateHdl(e:MouseEvent):void 
		{
			switch(e.type) {
				case MouseEvent.MOUSE_DOWN:
					this.x += 2;
					this.y += 2;
					break;
				case MouseEvent.MOUSE_UP:
					this.x -= 2;
					this.y -= 2;
					break;
			}
		}
		
		private function onReceiveClickHdl(e:MouseEvent):void 
		{
			dispatchEvent(new EventEx(ON_RECEIVE, _data, true));
		}
		
		public function setData(data:Object):void {
			_data = data;
		}
		
		public function setActive(active:Boolean):void {
			this.mouseEnabled = active;
			this.gotoAndStop(active ? "active" : "inactive");
		}
	}

}