/**
 * Created by NinhNQ on 12/23/2014.
 */
package game.ui.express.gui
{

	import core.event.EventEx;
	import core.util.FontUtil;
	import core.util.Utility;

	import flash.display.MovieClip;
	import flash.text.TextField;

	import game.Game;
	import game.data.vo.reward.RewardInfo;

	import game.enum.Font;
	import game.enum.ItemType;
	import game.net.lobby.response.ResponsePorterPlayerInfo;
	import game.ui.express.ExpressView;
	import game.utility.TimerEx;

	public class Info extends MovieClip
	{

		public var numOfRaidTf:TextField;
		public var numOfTransportTf:TextField;
		public var timeTf:TextField;
		public var goldReceivableTf:TextField;
		public var honorReceivableTf:TextField;
		public var robbedRemainTf:TextField;
		public var icon:MovieClip;

		private var remainTime:int = 0; // thoi gian con lai
		private var timerID:int = -1;

		public function Info()
		{
			FontUtil.setFont(numOfRaidTf, Font.ARIAL, true);
			FontUtil.setFont(numOfTransportTf, Font.ARIAL, true);
			FontUtil.setFont(timeTf, Font.ARIAL, true);
			FontUtil.setFont(goldReceivableTf, Font.ARIAL, true);
			FontUtil.setFont(honorReceivableTf, Font.ARIAL, true);
			FontUtil.setFont(robbedRemainTf, Font.ARIAL, true);

		}

		public function setData(packet:ResponsePorterPlayerInfo):void
		{
			setGeneralInfo(packet);
			remainTime = packet.elapsedTransportTime;

			for each (var info:RewardInfo in packet.rewards)
			{
				switch (info.itemType)
				{
					case ItemType.HONOR:
						honorReceivableTf.text = info.quantity.toString();
						break;
					case ItemType.GOLD:
						goldReceivableTf.text = info.quantity.toString();
						break;
				}
			}

			icon.visible = true;
			icon.gotoAndStop(packet.porterType.ID);

			robbedRemainTf.text = packet.robbedRemainCount.toString();

			TimerEx.stopTimer(timerID);
			timerID = TimerEx.startTimer(1000,remainTime, updateHdl, finishHdl);
		}

		public function setGeneralInfo(packet:ResponsePorterPlayerInfo):void
		{
			var maxRaid:int = Game.database.gamedata.getConfigData(219);
			var maxTransport:int = Game.database.gamedata.getConfigData(206);

			numOfRaidTf.text = packet.raidRemainCountInDay + "/" + maxRaid;
			numOfTransportTf.text = packet.transportRemainCount + "/" + maxTransport;
		}

		public function reset():void
		{
			numOfRaidTf.text = "-";
			numOfTransportTf.text = "-";
			timeTf.text = "-";
			goldReceivableTf.text = "-";
			honorReceivableTf.text = "-";
			robbedRemainTf.text = "-";

			TimerEx.stopTimer(timerID);
			timerID = -1;

			icon.visible = false;
		}

		private function finishHdl():void
		{
			dispatchEvent(new EventEx(ExpressView.COMPLETE, null, true));
		}

		private function updateHdl():void
		{
			timeTf.text = Utility.math.formatTime("M-S", --remainTime);
		}
	}
}
