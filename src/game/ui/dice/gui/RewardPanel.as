/**
 * Created by NINH on 1/12/2015.
 */
package game.ui.dice.gui
{

	import core.event.EventEx;
	import core.util.FontUtil;

	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	import game.Game;

	import game.enum.Font;
	import game.net.lobby.response.ResponseDicePlayerInfo;
	import game.ui.dice.DiceView;


	public class RewardPanel extends MovieClip
	{
		public var receiveBtn:SimpleButton;
		public var logBtn:SimpleButton;
		public var accTf:TextField;
		public var progress:ProgressBar;
		public var rewardsContainer:MovieClip;

		private var rewards:Array = [];

		public function RewardPanel()
		{
			FontUtil.setFont(accTf, Font.ARIAL, true);

			receiveBtn.addEventListener(MouseEvent.CLICK, btnClickHdl);
			logBtn.addEventListener(MouseEvent.CLICK, btnClickHdl);

			var rewardIDs:Array = Game.database.gamedata.getConfigData(263);
			var milestones:Array = Game.database.gamedata.getConfigData(262);
			var reward:RewardItem;

			for (var i:int = 0; i < rewardIDs.length; i++)
			{
				var id:int = rewardIDs[i];
				var milestone:int = milestones[i];

				reward = new RewardItem();
				reward.setData(id,milestone);
				reward.x = Math.round((milestone * 662)/totalPoint);

				rewardsContainer.addChild(reward);
				rewards.push(reward);
			}
		}

		public function updateInfo(data:ResponseDicePlayerInfo):void
		{
			progress.setProgress(data.accWinPoint, totalPoint, false);
			accTf.text = data.accWinPoint.toString();

			for (var i:int = 0; i < rewards.length; i++)
			{
				var item:RewardItem = rewards[i];
				item.checkMilestone(data.accWinPoint);
			}
		}

		public function get isFull():Boolean
		{
			return parseInt(accTf.text) >= totalPoint;
		}

		private function btnClickHdl(event:MouseEvent):void
		{
			switch (event.target)
			{
				case receiveBtn:
					dispatchEvent(new EventEx(DiceView.RECEIVE_REWARD, null, true));
					break;
				case logBtn:
					dispatchEvent(new EventEx(DiceView.GET_LOG, null, true));
					break;
			}
		}
		
		public function get totalPoint():int {
			var list:Array = Game.database.gamedata.getConfigData(262);
			return (list.length > 0) ? list[list.length - 1] : 0;
		}
	}
}
