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
	public class ModeItemMov extends MovieClip
	{
		public static const MODE_ITEM_SELECTED	:String = "filter_mode_item_mov_selected";
		public var modeTf					:TextField;
		public var movHit					:MovieClip;
		
		protected var _mode			:GameMode;
		protected var _isSelect		:Boolean;
		
		public function ModeItemMov() 
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
			FontUtil.setFont(modeTf, Font.ARIAL);
			gotoAndStop(1);
			modeTf.mouseEnabled = false;
			buttonMode = true;
			initHandlers();
			
			_isSelect = false;
		}
		
		public function set textContent(value:String):void {
			if (!value) return;
			modeTf.text = value;
		}
		
		private function initHandlers():void {
			movHit.addEventListener(MouseEvent.ROLL_OVER, onMouseOverHdl);
			movHit.addEventListener(MouseEvent.ROLL_OUT, onMouseOutHdl);
			movHit.addEventListener(MouseEvent.CLICK, onMouseClickHdl);
		}
		
		private function onMouseClickHdl(e:MouseEvent):void {
			gotoAndStop(3);
			dispatchEvent(new EventEx(MODE_ITEM_SELECTED, {name: modeTf.text, mode: _mode}, true));
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
			if (value) {
				gotoAndStop(3);
			} else {
				gotoAndStop(1);
			}
		}
		
		public function updateInfo(content:String, value:GameMode):void {
			modeTf.text = content;
			_mode = value;
		}
		
		public function setActive():void {
			onMouseClickHdl(null);
		}
		
	}

}