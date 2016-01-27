package game.ui.suggestion
{

	import core.display.ViewBase;
	import core.util.FontUtil;

	import flash.display.MovieClip;

	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	import game.data.vo.suggestion.SuggestionInfo;

	import game.enum.Font;
	import game.enum.SuggestionEnum;
	import game.ui.suggestion.gui.SuggestItem;

	import game.utility.UtilityUI;

	/**
	 * ...
	 * @author
	 */
	public class SuggestionView extends ViewBase
	{
		private var closeBtn:SimpleButton;
		public var container:MovieClip;
		public var titleTf:TextField;
		public var messageTf:TextField;

		public function SuggestionView()
		{
			FontUtil.setFont(titleTf, Font.ARIAL, true);
			FontUtil.setFont(messageTf, Font.ARIAL, true);

			closeBtn = UtilityUI.getComponent(UtilityUI.CLOSE_BTN) as SimpleButton;

			if (closeBtn != null)
			{
				closeBtn.x = 942;
				closeBtn.y = 134;
				addChild(closeBtn);
				closeBtn.addEventListener(MouseEvent.CLICK, closeHandler);
			}
		}

		public function update(list:Array, type:SuggestionEnum):void
		{
			reset();

			switch (type)
			{
				case SuggestionEnum.SUGGEST_LEVEL_UP:
					titleTf.text = "Bạn chưa đủ cấp".toUpperCase();
					messageTf.text = "Hướng dẫn: Có thể đạt kinh nghiệm từ: ";
					break;
			}

			for (var i:int = 0; i < list.length; i++)
			{
				var info:SuggestionInfo = list[i] as SuggestionInfo;
				var item:SuggestItem = new SuggestItem();
				item.setData(info, i+1);
				item.y = i*SuggestItem.HEIGHT;
				container.addChild(item);
			}
		}

		private function reset():void
		{
			var item:SuggestItem;
			while(container.numChildren > 0)
			{
				item = container.removeChildAt(0) as SuggestItem;
				item.reset();
			}
		}

		private function closeHandler(event:MouseEvent):void
		{
			dispatchEvent(new Event("close", true));
		}
	}
}