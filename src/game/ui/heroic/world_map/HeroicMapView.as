package game.ui.heroic.world_map 
{
	import com.greensock.TweenMax;
	import core.display.ViewBase;
	import core.Manager;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import game.Game;
	import game.enum.Direction;
	import game.ui.ModuleID;
	import game.utility.UtilityUI;
	
	/**
	 * ...
	 * @author MaiPTT
	 */
	public class HeroicMapView extends ViewBase 
	{
		public var btnClose		:SimpleButton;
		private var campaigns	:Array;
		
		public function HeroicMapView() {
			campaigns = [];
			initUI();
			initHandlers();
		}
		
		public function setData(value:Array):void {
			for each (var itemView:CampaignView in campaigns) {
				removeChild(itemView);
				itemView = null;
			}
			
			campaigns.splice(0);
			
			var displayCampaigns:Array = [];
			var notReadyCampaigns:Array = [];
			
			for each (var data:CampaignData in value) {
				if (data) {
					if (data.levelRequired <= Game.database.userdata.level) {
						displayCampaigns.push(data);
					} else {
						notReadyCampaigns.push(data);
					}
				}
			}
			
			notReadyCampaigns.sortOn('levelRequired', Array.NUMERIC);
			if (notReadyCampaigns[0] != null) {
				displayCampaigns.push(notReadyCampaigns[0]);
			}
			
			for each (data in displayCampaigns) {
				itemView = new CampaignView();
				itemView.setData(data);
				itemView.alpha = 0;
				addChild(itemView);
				campaigns.push(itemView);
				TweenMax.to(itemView, 0.0, { alpha:1.0, delay:Number(Math.random() * 0.5)} );
			}
		}
		
		private function initUI():void {
			btnClose = UtilityUI.getComponent(UtilityUI.BACK_BTN) as SimpleButton;
			var btnClosePos:Point = UtilityUI.getComponentPosition(UtilityUI.BACK_BTN) as Point;
			btnClose.x = btnClosePos.x;
			btnClose.y = btnClosePos.y;
			addChild(btnClose);
		}
		
		private function initHandlers():void {
			btnClose.addEventListener(MouseEvent.CLICK, onMouseClickHandlers);
		}
		
		private function onMouseClickHandlers(e:MouseEvent):void {
			switch(e.target) {
				case btnClose:
					Manager.display.to(ModuleID.HOME);
					break;
			}
		}

		public function showHintNode():void
		{
			for (var i:int = 0; i < campaigns.length; i++)
			{
				var item:CampaignView = campaigns[i];
				if(item.isReady)
				{
					Game.hint.showHint(item, Direction.UP, item.x + item.width/2, item.y + item.height - 31, "Chọn Ải");
					return;
				}

			}
		}
	}

}