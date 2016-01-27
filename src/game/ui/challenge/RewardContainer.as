package game.ui.challenge 
{
	import core.event.EventEx;
	import core.util.FontUtil;
	import core.util.TextFieldUtil;
	import core.util.Utility;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.text.TextFormatAlign;
	import flash.utils.Timer;
	import game.data.model.item.IItemConfig;
	import game.data.model.item.ItemFactory;
	import game.data.xml.DataType;
	import game.data.xml.item.MergeItemXML;
	import game.data.xml.RewardXML;
	import game.enum.Font;
	import game.enum.ItemType;
	import game.Game;
	import game.ui.components.ReceiveButton;
	import game.ui.components.Reward;
	import game.ui.tooltip.TooltipID;
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class RewardContainer extends MovieClip
	{
		private static const MAX_REWARD_RECEIVE:int = 2;
		
		private static const DISTANCE_Y_PER_REWARD:int = 90;
		
		private static const REWARD_START_FROM_X:int = 35;
		private static const REWARD_START_FROM_Y:int = 0;
		
		public static const COMPLETED_TIME_RECEIVE_REWARD:String = "completedTimeReceiveReward";
		
		//public var timeReceiveTf:TextField;
		
		private var _rewards:Array = [];
		private var _buttons:Array = [];
		
		//private var _timer:Timer;
		//private var _remainCount:int;	
		
		public function RewardContainer() 
		{
			/*if (stage)
				init();
			else addEventListener(Event.ADDED_TO_STAGE, init);*/	
			initUI();
		}
		
		/*private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
		}*/
		
		private function initUI():void 
		{
			//set font
			//FontUtil.setFont(timeReceiveTf, Font.ARIAL, true);
			//titleTf.text = "PHẦN THƯỞNG";
			
			//prepare reward
			var reward:Reward;
			var button:ReceiveButton;
			//var titleTf:TextField;
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
				button.x = reward.x + 3;
				button.y = reward.y + reward.height * 3 / 5 + 5;
				//button.visible = false;
				button.gotoAndStop("active");
				button.setData(i);
				//button.buttonMode = false;
				_buttons.push(button);
				addChild(button);
				
				//titleTf = TextFieldUtil.createTextfield(Font.ARIAL, 15, 60, 30, 0xFFFFCC, true, TextFormatAlign.CENTER);
				//titleTf.text = i % 2 == 0 ? "NGÀY" : "TUẦN";
				//titleTf.x = reward.x + 2;
				//titleTf.y +=  5;
				//addChild(titleTf);
			}
			
			//init timer
			//_timer = new Timer(1000);
			//_timer.addEventListener(TimerEvent.TIMER, onTimerUpdateHdl);
		}
		
		/*private function onTimerUpdateHdl(e:TimerEvent):void 
		{
			_remainCount = _remainCount > 0 ? _remainCount - 1 : 0;
			timeReceiveTf.text = Utility.math.formatTime("D-H-M", _remainCount);
			//Utility.log("mission on update timer from missionInfoUI: " + timeTf.text);
			
			if (_remainCount == 0) {
				_timer.stop();
				dispatchEvent(new Event(COMPLETED_TIME_RECEIVE_REWARD, true));
			}
		}*/
		
		/*public function stopCountDown():void {
			_timer.stop();
		}
		
		public function startCountDown():void {
			_timer.start();
		}*/
		
		//public function updateRewards(dailyRewardID:int, dailyRewardReceived:Boolean, dailyRewardTimeRemain:int, weeklyRewardID:int, weeklyRewardReceived:Boolean, weeklyRewardTimeRemain:int):void {
		public function updateRewards(rankRewardDailyID:int, rankDailyReceived:Boolean, dailyTimeRemain:int,
									rankRewardWeeklyID:int, rankWeeklyReceived:Boolean,
									groupRewardWeeklyID:int/*, groupWeeklyReceived:Boolean*/, weeklyTimeRemain:int):void {
			//var itemConfig:IItemConfig = ItemFactory.buildItemConfig(ItemType.ITEM_SET, groupRewardID) as IItemConfig;
			var rewardXML:RewardXML = Game.database.gamedata.getData(DataType.REWARD, rankRewardDailyID) as RewardXML;
			//if(rewardXML) {
				(_rewards[0] as Reward).updateInfo(rewardXML ? rewardXML.getItemInfo() : null, 0, TooltipID.ITEM_SET, dailyTimeRemain, "H-M");
				(_buttons[0] as ReceiveButton).setActive(!rankDailyReceived);
			//}
			
			//(_rewards[1] as Reward).addSubInfo([rewardXML]);
			//(_rewards[1] as Reward).setTooltipType(TooltipID.TOP_CHALLENGE_WEEKLY_REWARD);
			var mergeItem:IItemConfig = ItemFactory.buildItemConfig(ItemType.MERGE_ITEM, 0) as IItemConfig;
			
			rewardXML = Game.database.gamedata.getData(DataType.REWARD, groupRewardWeeklyID) as RewardXML;
			if (rewardXML) {
				(mergeItem as MergeItemXML).setIconURL(rewardXML.getItemInfo().getIconURL());
				(mergeItem as MergeItemXML).setName(rewardXML.getItemInfo().getName());
				(mergeItem as MergeItemXML).setDescription(rewardXML.getItemInfo().getDescription());
				(mergeItem as MergeItemXML).addMergeItem(rewardXML);
			}
			
			rewardXML = Game.database.gamedata.getData(DataType.REWARD, rankRewardWeeklyID) as RewardXML;
			if (rewardXML) {				
				(mergeItem as MergeItemXML).setIconURL(rewardXML.getItemInfo().getIconURL());
				(mergeItem as MergeItemXML).setName(rewardXML.getItemInfo().getName());
				(mergeItem as MergeItemXML).setDescription(rewardXML.getItemInfo().getDescription());
				(mergeItem as MergeItemXML).addMergeItem(rewardXML);
			}
			
			//if (mergeItem && (mergeItem as MergeItemXML).getMergeItem().length > 0) {				
				(_rewards[1] as Reward).updateInfo(
										mergeItem && (mergeItem as MergeItemXML).getMergeItem().length > 0 ? 
										mergeItem : null, 0, TooltipID.MERGE_ITEM, weeklyTimeRemain, "D-H-M");
				(_buttons[1] as ReceiveButton).setActive(!rankWeeklyReceived /*|| !groupWeeklyReceived*/);
			//}
			//dispatchEvent(new EventEx(TooltipEvent.SHOW_TOOLTIP, {type:TooltipID.MISSION_TOOLTIP, value: this.missionXML}, true));
			/*_remainCount = timeRemain
			timeReceiveTf.text = Utility.math.formatTime("D-H-M", timeRemain);
			if(timeRemain > 0)
				startCountDown();*/
			
		}
		
	}

}