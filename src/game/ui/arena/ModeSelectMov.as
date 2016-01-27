package game.ui.arena 
{
	import core.event.EventEx;
	import core.util.FontUtil;
	import core.util.MovieClipUtils;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import game.enum.Font;
	import game.enum.GameMode;

	/**
	 * ...
	 * @author TrungLNM
	 */
	public class ModeSelectMov extends MovieClip
	{
		public static const MODE_SELECTED	:String = "filter_mode_select_mov_selected";
		
		public var contentTf				:TextField;
		public var hitMov					:MovieClip;
		
		protected var _mode			:GameMode;
		protected var _isSelect		:Boolean;
		
		public function ModeSelectMov() 
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
			FontUtil.setFont(contentTf, Font.ARIAL);
			gotoAndStop(1);
			contentTf.mouseEnabled = false;
			buttonMode = true;
			initHandlers();
			
			_isSelect = false;
		}
		
		public function set textContent(value:String):void {
			if (!value) return;
			contentTf.text = value;
		}
		
		private function initHandlers():void {
			hitMov.addEventListener(MouseEvent.ROLL_OVER, onMouseOverHdl);
			hitMov.addEventListener(MouseEvent.ROLL_OUT, onMouseOutHdl);
			hitMov.addEventListener(MouseEvent.CLICK, onMouseClickHdl);
		}
		
		private function onMouseClickHdl(e:MouseEvent):void {
			//gotoAndStop(3);
			isSelect = true;
		}
		
		private function onMouseOutHdl(e:MouseEvent):void {
			if (!_isSelect) {
				gotoAndStop(1);
			}
		}
		
		private function onMouseOverHdl(e:MouseEvent):void 	{
			if (!_isSelect) {
				gotoAndStop(2);
			}
		}
		
		public function set isSelect(value:Boolean):void {
			_isSelect = value;
			hitMov.mouseEnabled = !value;
			if (value) {
				gotoAndStop(3);
				dispatchEvent(new EventEx(MODE_SELECTED, {name: contentTf.text, mode: _mode}, true));
			} else {
				gotoAndStop(1);
			}
		}
		
		public function updateInfo(content:String, mode:GameMode):void {
			contentTf.text = content;
			_mode = mode;
		}
		
		public function getMode():GameMode {
			return _mode;
		}
	}

}