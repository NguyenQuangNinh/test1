package game.ui.select_global_boss 
{
	import com.greensock.TweenMax;
	import components.scroll.VerScroll;
	import core.Manager;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import game.data.xml.DataType;
	import game.data.xml.ModeConfigXML;
	import game.ui.arena.RewardModeInfoItem;
	
	import game.Game;
	/**
	 * ...
	 * @author vu anh
	 */
	public class GlobalBossGiftPopup extends MovieClip
	{
		private var rewards:Array;
		public var rewardsContainerMov:MovieClip;
		public var scrollBarMov:MovieClip;
		public var masker:MovieClip;
		public var closeBtn:SimpleButton;
		
		private var scroller:VerScroll;
		
		public function GlobalBossGiftPopup() 
		{
			scroller = new VerScroll(masker, rewardsContainerMov, scrollBarMov);
			rewards = [];
			closeBtn.addEventListener(MouseEvent.CLICK, closeBtnHdl);
		}
		
		private function closeBtnHdl(e:MouseEvent):void 
		{
			fadeOut();
		}
		
		public function updateInfo(bossType:int):void
		{
			var topConfig:XML =  Game.database.gamedata.getGlobalBossConfig().topRewardsXML.Boss[bossType]; //(ModeConfigXML)(Game.database.gamedata.getData(DataType.MODE_CONFIG, GameMode.PVE_GLOBAL_BOSS.ID)).globalBossConfig
			var topRewards:XMLList = null;
			if (topConfig) topRewards = topConfig.Rank;
			
			var rewardItem:RewardModeInfoItem;
			for each (rewardItem in rewards) 
			{
				if (rewardItem.parent) 
				{
					rewardItem.parent.removeChild(rewardItem);
				}
				Manager.pool.push(rewardItem, RewardModeInfoItem);
			}
			rewards.splice(0);
			
			if (topRewards) 
			{
				var rank:XML;
				var itemData:Object;
				for (var i:int = 0; i < topRewards.length(); i++) 
				{
					rank = topRewards[i];
					itemData = new Object();
					itemData.from = rank.From;
					itemData.to = rank.To;
					itemData.rewardDaily = rank.RewardWin;
					itemData.rewardWeekly = rank.RewardLose;
					rewardItem = Manager.pool.pop(RewardModeInfoItem) as RewardModeInfoItem;
					rewardItem.updateInfo(itemData);
					rewardItem.y = i * rewardItem.height + 2;
					rewards.push(rewardItem);
					rewardsContainerMov.addChild(rewardItem);
				}
				scroller.updateScroll(rewardsContainerMov.height + 30);
			}
		}
		
		public function fadeIn():void
		{
			this.visible = true;
			this.alpha = 0;
			TweenMax.to(this, 0.3, { alpha: 1 } );
		}
		
		public function fadeOut():void
		{
			TweenMax.to(this, 0.3, { alpha: 0, onComplete:onCompleteHdl });
		}
		
		private function onCompleteHdl():void 
		{
			this.visible = false;
		}
		
	}
	
	

}