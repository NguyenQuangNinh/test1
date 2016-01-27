package game.ui.worldmap 
{
	import core.display.layer.LayerManager;
	import core.display.ViewBase;
	import core.event.EventEx;
	import core.Manager;

	import flash.display.SimpleButton;
	import flash.geom.Point;
	import game.data.xml.CampaignXML;
	import game.Game;
	import game.data.xml.DataType;
	import game.enum.Direction;
	import game.net.lobby.response.ResponseCampaignInfo;
	import game.ui.ModuleID;
	import game.ui.tooltip.TooltipEvent;
	import game.ui.tutorial.TutorialEvent;
	import game.ui.worldmap.event.EventWorldMap;
	import game.ui.worldmap.gui.GlobalMap;
	import game.ui.worldmap.gui.LocalMap;
	/**
	 * ...
	 * @author anhtinh
	 */
	public class WorldMapView extends ViewBase
	{
		public var globalMap : GlobalMap;
		public var localMap : LocalMap;
		//private var levelUpPopup : LevelUpPopup;
		
		public function WorldMapView() 
		{
			localMap.visible = false;
			//this.levelUpPopup = new LevelUpPopup();
			//this.addChild(levelUpPopup);
		}
		
		public function showMissionsOfCampaign(campaignData : CampaignXML, responseCampaignInfo : ResponseCampaignInfo, highlightNewestMission : Boolean = false) : void {
			localMap.showMissionsOfCampaign(campaignData, responseCampaignInfo, highlightNewestMission);
			localMap.show();
		}

		public function showLocalMapTutorial(value:Boolean):void
		{
			if (!localMap.visible && value) {
				var xmlData:CampaignXML = Game.database.gamedata.getData(DataType.CAMPAIGN, 1) as CampaignXML;
				dispatchEvent(new EventWorldMap(EventWorldMap.ENTER_CAMPAIGN, xmlData, true));
//				localMap.show();
			} else if (localMap.visible && !value) {
				localMap.hide();
			}
		}

		public function showLocalMap(value:Boolean):void {
			if (!localMap.visible && value) {
				localMap.show();
			} else if (localMap.visible && !value) {
				localMap.hide();
			}
		}
		
		override public function transitionIn():void {
			localMap.visible = false;
			globalMap.showPlacesIcon();
			super.transitionIn();
		}
		override protected function transitionOutComplete():void {
			super.transitionOutComplete();
			onClose();
		}
		
		override protected function transitionInComplete():void {
			super.transitionInComplete();
			dispatchEvent(new EventEx(TutorialEvent.EVENT, { type:TutorialEvent.WORLD_MAP_TRANS_IN }, true));
		}
		
		private function onClose() : void {
		}
		
		override public function set visible(value : Boolean) : void {
			super.visible = value;
			if (value == false) {
				dispatchEvent(new EventEx(TooltipEvent.HIDE_TOOLTIP, null, true));	
			}
		}

		//TUTORIAL
		public function showHintBtn():void
		{
			var back:SimpleButton = globalMap.closeBtn;
			Game.hint.showHint(back, Direction.RIGHT, back.x, back.y + back.height/2, "Click chuột");
		}

		public function getRewardStatus(index:int = 0):int
		{
			return localMap.rewardPanel.getRewardStatus(index);
		}
	}

}