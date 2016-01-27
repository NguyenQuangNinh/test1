package game.ui.wiki
{
	import core.display.ViewBase;
	import core.util.FontUtil;
	import core.util.MovieClipUtils;

	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.text.TextField;
	import flash.utils.Dictionary;

	import game.Game;
	import game.data.xml.DataType;
	import game.data.xml.WikiXML;

	import game.enum.Font;
	import game.ui.wiki.gui.SubTab;

	import game.ui.wiki.gui.Tab;
	import game.utility.UtilityUI;

	/**
	 * ...
	 * @author ninhnq
	 */
	public class WikiView extends ViewBase
	{
		private var tabs:Array = [];
		private var subTabs:Array = [];

		public var tabsMov:MovieClip;
		public var subTabsMov:MovieClip;
		public var detailsBtn:SimpleButton;
		public var contentTf:TextField;
		public var closeBtn:SimpleButton;
		private var initialized:Boolean = false;

		private var selectedTab:Tab;
		private var selectedSubTab:SubTab;

		public function WikiView()
		{
			FontUtil.setFont(contentTf, Font.ARIAL, true);

			closeBtn = UtilityUI.getComponent(UtilityUI.CLOSE_BTN) as SimpleButton;

			if (closeBtn != null)
			{
				closeBtn.x = 1138;
				closeBtn.y = 104;
				addChild(closeBtn);
				closeBtn.addEventListener(MouseEvent.CLICK, closeHandler);
			}

			detailsBtn.addEventListener(MouseEvent.CLICK, detailClickHdl);
		}

		private function detailClickHdl(event:MouseEvent):void
		{
			if(ExternalInterface.available && selectedSubTab)
			{
				navigateToURL(new URLRequest(selectedSubTab.data.link), "_blank");
			}
		}

		public function init():void
		{
			if(initialized) return;

			var allTabData:Dictionary = Game.database.gamedata.getTable(DataType.WIKI);
			var tabData:WikiXML;
			var tab:Tab;
			var index:int = 0;

			for (var key:Object in allTabData)
			{
				tabData = allTabData[key] as WikiXML;

				tab = new Tab();
				tab.setData(tabData);
				tab.x = index * 172;
				tab.addEventListener(MouseEvent.CLICK, tabClickHdl);
				tabsMov.addChild(tab);
				tabs.push(tab);
				index++;
			}

			setActiveTab(tabs[0] as Tab);

			initialized = true;
		}

		private function setActiveTab(target:Tab):void
		{
			if (selectedTab) selectedTab.setActive(false);

			reset();

			selectedTab = target;
			selectedTab.setActive(true);

			subTabs = selectedTab.getSubtabs();
			for (var i:int = 0; i < subTabs.length; i++)
			{
				var sTab:SubTab = subTabs[i];
				sTab.y = i*SubTab.HEIGHT;
				sTab.addEventListener(MouseEvent.CLICK, sTabClickHdl);
				subTabsMov.addChild(sTab);
			}

			setActiveSubTab(subTabs[0] as SubTab);
		}

		private function setActiveSubTab(target:SubTab):void
		{
			if (selectedSubTab) selectedSubTab.setActive(false);

			selectedSubTab = target;
			selectedSubTab.setActive(true);
			contentTf.htmlText = selectedSubTab.data.content;
			FontUtil.setFont(contentTf, Font.ARIAL, true);
		}

		public function reset():void
		{
			for each (var tab:SubTab in subTabs)
			{
				tab.removeEventListener(MouseEvent.CLICK, sTabClickHdl);
			}

			MovieClipUtils.removeAllChildren(subTabsMov);
			subTabs = [];
		}

		private function closeHandler(event:MouseEvent):void
		{
			dispatchEvent(new Event("close", true));
		}

		private function sTabClickHdl(event:MouseEvent):void
		{
			var target:SubTab = event.currentTarget as SubTab;
			if (target != selectedSubTab)
			{
				setActiveSubTab(target);
			}
		}

		private function tabClickHdl(event:MouseEvent):void
		{
			var target:Tab = event.currentTarget as Tab;
			if (target != selectedTab)
			{
				setActiveTab(target);
			}
		}
	}

}