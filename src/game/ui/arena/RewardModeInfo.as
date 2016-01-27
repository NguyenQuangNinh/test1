package game.ui.arena 
{
	import components.scroll.VerScroll;
	import core.Manager;
	import core.util.FontUtil;
	import core.util.MovieClipUtils;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	//import game.data.enum.pvp.ModePVPEnum;
	//import game.data.enum.topleader.LeaderBoardTypeEnum;
	import game.data.xml.DataType;
	import game.data.xml.TopConfigXML;
	import game.enum.Font;
	import game.enum.GameConfigID;
	import game.enum.GameMode;
	import game.enum.LeaderBoardTypeEnum;
	import game.Game;
	import game.ui.components.ScrollBar;
	import game.utility.GameUtil;
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class RewardModeInfo extends MovieClip
	{
		public var closeBtn:SimpleButton;
		public var scrollBarMov:MovieClip;
		public var maskMov:MovieClip;
		public var rewardsContainerMov:MovieClip;
		public var titleTf:TextField;			
		private var rewards:Array;
		public var scroller:VerScroll;
		public function RewardModeInfo() 
		{
			trace("RewardModeInfo ==============================");
			rewards = [];
			initUI();
			scroller = new VerScroll(maskMov, rewardsContainerMov, scrollBarMov);
		}
		
		private function initUI():void 
		{
			//set fonts
			FontUtil.setFont(titleTf, Font.ARIAL, true);
			//titleTf.text = "PHẦN THƯỞNG";
			
			//add events
			closeBtn.addEventListener(MouseEvent.CLICK, onCloseClickHdl);
			
			//initRewards();
		}
		
		private function onCloseClickHdl(e:MouseEvent):void 
		{
			this.visible = false;
			dispatchEvent(new Event(Event.CLOSE));
		}
		
		public function initReward(mode:int):void {						
			//get reward daily by game config and weekly by mode pvp config
			//var rewardDailyIDs:Array = Game.database.gamedata.getConfigData(GameConfigID.ARR_ID_CHAMPION_REWARD) as Array;
			//var modeXML:ModePvPXML = GameUtil.getModeXMLByType(ModePVPEnum.PvP_1vs1_MM) as ModePvPXML;
			var topID:int = -1;
			switch(mode) {
				case GameMode.PVP_1vs1_AI.ID:
					topID = LeaderBoardTypeEnum.TOP_1vs1_AI.type;
					break;
				case GameMode.PVP_1vs1_MM.ID:
					topID = LeaderBoardTypeEnum.TOP_1VS1_MM.type;
					break;
				case GameMode.PVP_3vs3_MM.ID:
					topID = LeaderBoardTypeEnum.TOP_3VS3_MM.type;
					break;
				case GameMode.PVP_2vs2_MM.ID:
					topID = LeaderBoardTypeEnum.TOP_2VS2_MM.type;
					break;
			}
			
			var topConfig:TopConfigXML = null;
			if (topID > 0)
				topConfig = Game.database.gamedata.getData(DataType.TOP_CONFIG, topID) as TopConfigXML;
			//var rewardDailyIDs:Array = modeXML ? modeXML.getDailyReward() : [];
			//var rewardWeeklyIDs:Array = modeXML ? modeXML.getWeeklyReward() : [];
			
			//var count:int = rewardDailyIDs.length <= rewardWeeklyIDs ? rewardWeeklyIDs.length : rewardWeeklyIDs.length;			
			var rewardRank:RewardModeInfoItem;
			for each (rewardRank in rewards) {
				if (rewardRank.parent) {
					rewardRank.parent.removeChild(rewardRank);
				}
				Manager.pool.push(rewardRank, RewardModeInfoItem);
			}
			rewards.splice(0);
			
			if (topConfig) {
				for (var i:int = 0; i < topConfig.getTopReward().length; i++) {
					var itemData:Object = topConfig.getTopReward()[i];
					//itemData.dailyID = i < rewardDailyIDs.length ? rewardDailyIDs[i] : -1;
					//itemData.weeklyID = itemData.id;
					
					rewardRank = Manager.pool.pop(RewardModeInfoItem) as RewardModeInfoItem;
					rewardRank.updateInfo(itemData);
					rewardRank.y = i * rewardRank.height + 2;
					rewards.push(rewardRank);
					rewardsContainerMov.addChild(rewardRank);
				}
				scroller.updateScroll(rewardsContainerMov.height + 20);
			}
		}
		
	}

}