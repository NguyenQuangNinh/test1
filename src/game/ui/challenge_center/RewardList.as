package game.ui.challenge_center
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	import core.Manager;
	
	import game.Game;
	import game.data.gamemode.ModeDataHeroicTower;
	import game.data.xml.DataType;
	import game.data.xml.MissionXML;
	import game.data.xml.RewardXML;
	import game.data.xml.config.HeroicTowerXML;
	import game.enum.GameMode;
	import game.ui.components.ButtonClose;
	import game.utility.UtilityUI;
	
	public class RewardList extends MovieClip
	{
		public var btnCloseContainer:MovieClip;
		public var rewardsContainer:MovieClip;
		
		private var btnClose:ButtonClose;
		private var rewards:Array = [];
		private var floorMilestones:Array = [0,58,90,100,105];
		
		public function RewardList()
		{
			btnClose = new ButtonClose();
			btnCloseContainer.addChild(btnClose);
			btnClose.addEventListener(MouseEvent.CLICK, btnClose_onClicked);
		}
		
		protected function btnClose_onClicked(event:MouseEvent):void
		{
			visible = false;
		}
		
		public function parseRewards():void
		{
			for each(var reward:FloorRewardInfo in rewards)
			{
				rewardsContainer.removeChild(reward);
				Manager.pool.push(reward, FloorRewardInfo);
			}
			rewards.splice(0);
			
			var modeData:ModeDataHeroicTower = Game.database.userdata.getModeData(GameMode.HEROIC_TOWER) as ModeDataHeroicTower;
			var towerData:HeroicTowerData = modeData.getCurrentTowerData();
			var config:HeroicTowerXML = towerData.getXMLData();
			var missionXML:MissionXML;
			var rewardNames:Array;
			var startFloor:int;
			var endFloor:int;
			for(var i:int = 0; i < floorMilestones.length - 1; ++i)
			{
				rewardNames = [];
				startFloor = floorMilestones[i];
				endFloor = floorMilestones[i + 1];
				var items:Array = [];
				for(var floorIndex:int = startFloor; floorIndex < endFloor; ++floorIndex)
				{
					missionXML = Game.database.gamedata.getData(DataType.MISSION, config.missionIDs[floorIndex]) as MissionXML;
					if(missionXML == null) continue;
					UtilityUI.sumRewards(items, missionXML.fixRewardIDs);
					UtilityUI.sumRewards(items, missionXML.randomRewardIDs);
				}
				reward = Manager.pool.pop(FloorRewardInfo) as FloorRewardInfo;
				reward.setData((startFloor + 1) + " - " + endFloor, items);
				rewards.push(reward);
				reward.y = i * 29;
				rewardsContainer.addChild(reward);
			}
		}
	}
}