/**
 * Created by NinhNQ on 11/25/2014.
 */
package game.ui.suggestion.gui
{

	import core.util.FontUtil;

	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	import game.data.vo.suggestion.SuggestionInfo;
	import game.enum.Font;
	import game.utility.GameUtil;

	public class SuggestItem extends MovieClip
	{
		public static const HEIGHT:int = 28;

		public var contentTf:TextField;
		public var gotoBtn:SimpleButton;
		private var data:SuggestionInfo;

		public function SuggestItem()
		{
			gotoBtn.addEventListener(MouseEvent.CLICK, onMouseClickHdl);
			FontUtil.setFont(contentTf, Font.ARIAL, true);
		}

		private function onMouseClickHdl(e:MouseEvent):void
		{
			GameUtil.moveToSuggestion(data);
		}

		public function setData(info:SuggestionInfo, index:int):void
		{
			data = info;
			contentTf.text = index + ". " + info.desc;
		}

		public function reset():void
		{
			data = null;
			gotoBtn.removeEventListener(MouseEvent.CLICK, onMouseClickHdl);
		}
	}
}
