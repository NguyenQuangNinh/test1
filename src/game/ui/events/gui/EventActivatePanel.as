/**
 * Created by NinhNQ on 9/24/2014.
 */
package game.ui.events.gui
{
	import core.display.BitmapEx;
	import core.event.EventEx;
	import core.util.FontUtil;

	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	import game.data.model.event.ActivateEventData;

	import game.data.model.event.EventData;
	import game.data.xml.event.ActivateEventXML;
	import game.enum.Font;

	public class EventActivatePanel extends MovieClip
	{
		public function EventActivatePanel()
		{
			FontUtil.setFont(priceTf, Font.ARIAL, true);
			FontUtil.setFont(descTf, Font.ARIAL, true);
			activeBtn.addEventListener(MouseEvent.CLICK, activeBtn_clickHandler);
		}

		public var activeBtn:SimpleButton;
		public var priceTf:TextField;
		public var descTf:TextField;
		public var iconMov:MovieClip;
		private var data:ActivateEventXML;
		private var bitmap:BitmapEx;

		public function setData(eventData:EventData):void
		{
			activeBtn.visible = !ActivateEventData(eventData).isActivated;

			if (eventData.eventXML == data) return;

			reset();

			this.data = eventData.eventXML as ActivateEventXML;

			bitmap = new BitmapEx();
			bitmap.addEventListener(BitmapEx.LOADED, bitmap_loadedHandler);
			bitmap.load(this.data.itemActive.iconURL);
			iconMov.addChild(bitmap);

			priceTf.text = this.data.itemActive.price.toString();
			descTf.text = this.data.itemActive.description.toUpperCase();
		}

		private function reset():void
		{
			if (bitmap && iconMov.contains(bitmap))
			{
				iconMov.removeChild(bitmap);
				bitmap.destroy();
				bitmap = null;
				data = null;
			}
		}

		private function bitmap_loadedHandler(event:Event):void
		{
			bitmap.removeEventListener(BitmapEx.LOADED, bitmap_loadedHandler);
			bitmap.x = -bitmap.width / 2;
			bitmap.y = -bitmap.height / 2;
		}

		private function activeBtn_clickHandler(event:MouseEvent):void
		{
			dispatchEvent(new EventEx(EventPanel.ACTIVATE, null, true));
		}
	}
}
