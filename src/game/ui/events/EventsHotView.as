package game.ui.events
{

	import core.display.ViewBase;
	import core.util.FontUtil;
	import core.util.MovieClipUtils;

	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	import game.Game;
	import game.data.model.event.EventData;
	import game.enum.Font;
	import game.ui.events.gui.EventPanel;
	import game.ui.events.gui.EventTab;
	import game.utility.UtilityUI;

	/**
	 * ...
	 * @author
	 */
	public class EventsHotView extends ViewBase
	{
		public function EventsHotView()
		{
			FontUtil.setFont(eventNameTf, Font.ARIAL, true);

			closeBtn = UtilityUI.getComponent(UtilityUI.CLOSE_BTN) as SimpleButton;

			if (closeBtn != null)
			{
				closeBtn.x = 968;
				closeBtn.y = 33;
				addChild(closeBtn);
				closeBtn.addEventListener(MouseEvent.CLICK, closeHandler);
			}
		}

		public var tabsMov:MovieClip;
		public var panelMov:EventPanel;
		public var eventNameTf:TextField;
		public var closeBtn:SimpleButton;
		private var tabs:Array = [];
		private var selectedTab:EventTab;

		public function update():void
		{
			reset();

			var availableEvents:Array = Game.database.gamedata.eventsData.availableEvents;

			for (var i:int = 0; i < availableEvents.length; i++)
			{
				var data:EventData = availableEvents[i] as EventData;

				var tab:EventTab = new EventTab();
				tab.text = data.eventXML.name;
				tab.y = i * EventTab.HEIGHT;
				tab.data = data;
				tab.addEventListener(MouseEvent.CLICK, tabClickHdl);

				tabsMov.addChild(tab);
				tabs.push(tab);
			}

			setActive(tabs[0] as EventTab);
		}

		public function reset():void
		{
			for each (var tab:EventTab in tabs)
			{
				tab.removeEventListener(MouseEvent.CLICK, tabClickHdl);
				tab.data = null;
			}

			MovieClipUtils.removeAllChildren(tabsMov);
			tabs = [];
		}

		private function setActive(target:EventTab):void
		{
			if (selectedTab) selectedTab.setActive(false);

			selectedTab = target;
			selectedTab.setActive(true);

			eventNameTf.text = selectedTab.data.eventXML.name.toUpperCase();
			panelMov.setData(selectedTab.data);
		}

		private function closeHandler(event:MouseEvent):void
		{
			dispatchEvent(new Event("close", true));
		}

		private function tabClickHdl(event:MouseEvent):void
		{
			var target:EventTab = event.currentTarget as EventTab;
			if (target != selectedTab)
			{
				setActive(target);
			}
		}
	}
}