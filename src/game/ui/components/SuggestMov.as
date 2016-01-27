package game.ui.components 
{
	import core.event.EventEx;
	import core.util.FontUtil;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import game.data.vo.suggestion.SuggestionInfo;
	import game.data.xml.SuggestionXML;
	import game.enum.Font;
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class SuggestMov extends MovieClip
	{
		public static const MOVE_TO_SUGGESTION:String = "mov_to_suggestion";
		
		public var descTf:TextField;
		public var gotoBtn:SimpleButton;		
		
		private var _suggestInfo:SuggestionInfo;
		
		public function SuggestMov() 
		{
			initUI();
		}
		
		private function initUI():void 
		{
			FontUtil.setFont(descTf, Font.ARIAL, false);
			gotoBtn.addEventListener(MouseEvent.CLICK, onGoToClickHdl);
		}
		
		private function onGoToClickHdl(e:MouseEvent):void 
		{
			dispatchEvent(new EventEx(MOVE_TO_SUGGESTION, _suggestInfo, true));			
		}
		
		public function updateInfo(info:SuggestionInfo):void {
			_suggestInfo = info;
			
			descTf.text = _suggestInfo.desc;			
		}
	}

}