package game.ui.character_enhancement
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class Tab
	{
		private var tabButton:MovieClip;
		private var tabContent:TabContent;
		
		public function Tab(tabButton:MovieClip, tabContent:TabContent):void
		{
			if(tabButton != null && tabContent != null)
			{
				this.tabButton = tabButton;
				this.tabContent = tabContent;
				tabButton.gotoAndStop("normal");
				tabButton.buttonMode = true;
			}
			else
			{
				throw new Error("tabButton & tabContent paramenters must not be null");
			}
		}
		
		public function getButton():MovieClip { return tabButton; }
		public function getContent():TabContent { return tabContent; }
		
		public function activate():void
		{
			tabButton.gotoAndStop("selected");
			tabContent.activate();
		}
		
		public function deactivate():void
		{
			tabButton.gotoAndStop("normal");
			tabContent.deactivate();
		}
		
		public function isActivate():Boolean { return tabContent.visible; }
	}
}