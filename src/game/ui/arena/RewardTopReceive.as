package game.ui.arena 
{
	import flash.display.MovieClip;
	import flash.display.Shape;
	import game.data.xml.DataType;
	import game.data.xml.RewardXML;
	import game.enum.GameMode;
	import game.Game;
	import game.ui.components.ReceiveButton;
	import game.ui.components.Reward;
	import game.ui.tooltip.TooltipID;
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class RewardTopReceive extends MovieClip
	{
		private static const DISTANCE_Y_PER_REWARD:int = 95;
		private static const MAX_REWARD_RECEIVE:int = 2;
		private static const REWARD_START_FROM_X:int = 0;
		private static const REWARD_START_FROM_Y:int = 0;
		
		private var _rewards:Array = [];		
		private var _buttons:Array = [];
		
		private var _mode:int;
		
		public function RewardTopReceive() 
		{
			initUI();
		}
		
		public function setMode(mode:int):void {
			_mode = mode;
		}
		
		private function initUI():void 
		{
			//init reward
			var reward:Reward;
			var button:ReceiveButton;
			for (var i:int = 0; i < MAX_REWARD_RECEIVE; i++) {
				reward = new Reward();
				reward.x = REWARD_START_FROM_X + DISTANCE_Y_PER_REWARD * i;
				reward.y = REWARD_START_FROM_Y;	
				reward.changeType(Reward.EMPTY);
				//reward.visible = false;
				//reward.updateInfo(
				_rewards.push(reward);
				addChild(reward);
				
				button = new ReceiveButton();
				button.x = reward.x + 16;
				button.y = reward.y + reward.height * 2 / 3 ;
				//button.visible = false;
				//button.gotoAndStop("inactive");
				button.setActive(false);
				//button.setData({mode: _mode, index: i});
				//button.buttonMode = false;
				_buttons.push(button);
				addChild(button);
			}
		}
		
		public function updateReward(dailyRewardID:int, dailyRewardReceived:Boolean, weeklyRewardID:int, weeklyRewardReceived:Boolean,
										timeRemainDailyReward:int, timeRemainWeeklyReward:int):void {
			var rewardXML:RewardXML = Game.database.gamedata.getData(DataType.REWARD, dailyRewardID) as RewardXML;
			if(rewardXML) {
				(_rewards[0] as Reward).updateInfo(rewardXML.getItemInfo(), rewardXML.quantity, TooltipID.ITEM_SET, timeRemainDailyReward);
				(_buttons[0] as ReceiveButton).setActive(!dailyRewardReceived);
			}

			(_rewards[0] as Reward).visible = (rewardXML != null);
			(_buttons[0] as ReceiveButton).visible = (rewardXML != null);

			rewardXML = Game.database.gamedata.getData(DataType.REWARD, weeklyRewardID) as RewardXML;
			if(rewardXML) {
				(_rewards[1] as Reward).updateInfo(rewardXML.getItemInfo(), rewardXML.quantity, TooltipID.ITEM_SET, timeRemainWeeklyReward, "D-H-M");
				(_buttons[1] as ReceiveButton).setActive(!weeklyRewardReceived);
			}

			(_rewards[1] as Reward).visible = (rewardXML != null);
			(_buttons[1] as ReceiveButton).visible = (rewardXML != null);

			for (var i:int = 0; i < MAX_REWARD_RECEIVE; i++) {
				var button:ReceiveButton = _buttons[i] as ReceiveButton;
				button.setData({mode: _mode, index: i});
			}
			
		}
	}

}