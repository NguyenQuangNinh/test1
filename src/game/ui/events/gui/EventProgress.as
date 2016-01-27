/**
 * Created by NinhNQ on 9/23/2014.
 */
package game.ui.events.gui
{
	import core.event.EventEx;
	import core.util.FontUtil;

	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	import game.data.model.event.EventData;
	import game.data.xml.event.EventType;
	import game.enum.Font;
	import game.ui.components.ProgressBar;

	public class EventProgress extends MovieClip
	{
		public function EventProgress()
		{
			FontUtil.setFont(titleTf, Font.ARIAL, true);
			payBtn.addEventListener(MouseEvent.CLICK, payBtn_clickHandler);
		}

		public var payBtn:SimpleButton;
		public var progress:ProgressBar;
		public var titleTf:TextField;

		public function setData(data:EventData):void
		{
			var title:String = "";

			switch (data.eventXML.type)
			{
				case EventType.CHARGE_XU:
					title = "Vàng đã nạp";
					break;
				case EventType.CONSUME_XU:
					title = "Vàng đã sử dụng";
					break;
				case EventType.ACTIVATE:
					title = "Số ngày đã gửi";
					break;
				case EventType.EXCHANGE:
					title = "Vật phẩm đã sử dụng";
					break;
			}

			titleTf.text = title.toUpperCase();

			payBtn.visible = (data.eventXML.type == EventType.CHARGE_XU);
			progress.setProgress(data.currentAcc, data.maxAcc, true);
		}

		private function payBtn_clickHandler(event:MouseEvent):void
		{
			dispatchEvent(new EventEx(EventPanel.CHARGE, null, true));
		}
	}
}
