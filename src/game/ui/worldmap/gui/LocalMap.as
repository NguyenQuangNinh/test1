package game.ui.worldmap.gui
{
	import com.facebook.data.notes.NoteData;
	import com.greensock.TweenMax;
	import core.event.EventEx;
	import core.util.FontUtil;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import game.data.xml.CampaignXML;
	import game.enum.Font;
	import game.Game;
	import game.net.lobby.response.ResponseCampaignInfo;
	import game.ui.tutorial.TutorialEvent;
	import game.ui.worldmap.event.EventWorldMap;
	import game.utility.UtilityUI;
	
	/**
	 * ...
	 * @author anhtinh
	 */
	public class LocalMap extends Sprite
	{
		public var titleTf:TextField;
		public var numStarTf:TextField;
		public var rewardPanel:RewardPanel;
		
		private var closeBtn:SimpleButton;
		private var campaignData:CampaignXML;
		private var missionPanel:MissionPanel = new MissionPanel();
		
		public function LocalMap()
		{
			
			FontUtil.setFont(numStarTf, Font.ARIAL);
			FontUtil.setFont(titleTf, Font.ARIAL, true);
			
			closeBtn = UtilityUI.getComponent(UtilityUI.CLOSE_BTN) as SimpleButton;
			
			if (closeBtn != null)
			{
				closeBtn.x = 895 - 14;
				closeBtn.y = 100 - 8;
				addChild(closeBtn);
				closeBtn.addEventListener(MouseEvent.CLICK, closeCampaignHandler);
			}
			
			missionPanel.x = 435;
			missionPanel.y = 135;
			this.addChild(missionPanel);
			
			titleTf.text = "";
		
		}
		
		private function closeCampaignHandler(e:MouseEvent):void
		{
			dispatchEvent(new EventEx(TutorialEvent.EVENT, {type: TutorialEvent.LOCAL_MAP_CLOSE}, true));
			hide();
		}
		
		public function showMissionsOfCampaign(campaignData:CampaignXML, responseCampaignInfo:ResponseCampaignInfo, highlightNewestMission:Boolean = false):void
		{
			this.campaignData = campaignData;
			missionPanel.renderWithData(campaignData, Game.database.userdata.finishedMissions, highlightNewestMission);
			rewardPanel.renderWithData(campaignData, responseCampaignInfo);
			
			var totalAchiveStar:int = responseCampaignInfo.totalStar;
			var totalStar:int = campaignData.missionIDs.length * 3;
			numStarTf.text = totalAchiveStar + "/" + totalStar;
			titleTf.text = campaignData.name;
			this.visible = true;
		
		}
		
		public function show():void
		{
			this.alpha = 0;
			this.visible = true;
			TweenMax.to(this, 0.5, {alpha: 1});
		}
		
		public function hide():void
		{
			this.visible = false;
		}
	
	}

}