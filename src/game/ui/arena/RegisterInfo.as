/**
 * Created by NINH on 1/28/2015.
 */
package game.ui.arena
{

	import core.event.EventEx;
	import core.util.FontUtil;
	import core.util.Utility;

	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	import game.Game;
	import game.enum.FlowActionEnum;
	import game.enum.Font;
	import game.enum.GameMode;
	import game.utility.TimerEx;

	public class RegisterInfo extends MovieClip
	{
		public var registerBtn:SimpleButton;
		public var countMov:MovieClip;
		private var timerID:int = -1;
		private var waitTime:int = 0;
		private var startGameSuccess:Boolean = false;

		public function RegisterInfo()
		{
			FontUtil.setFont(countDownTf, Font.ARIAL, true);

			registerBtn.addEventListener(MouseEvent.CLICK, registerBtn_clickHandler);
			countMov.visible = false;
		}

		private function get countDownTf():TextField
		{
			return countMov.countDownTf as TextField;
		}

		private function registerBtn_clickHandler(event:MouseEvent):void
		{
			dispatchEvent(new EventEx(ArenaEventName.MODE_INFO_SELECTED, ArenaEventName.MODE_INFO_REGISTER, true));
		}

		public function registerMatching(mode:GameMode):void
		{
			var timeNow:Number = new Date().getTime() + Game.database.userdata.serverTimeDifference;
			var currentDate:Date = new Date();
			currentDate.setTime(timeNow);

			var totalSecond:int = currentDate.getMinutes()*60 + currentDate.getSeconds();

			if(mode == GameMode.PVP_2vs2_MM)
			{

				var roundDuration:int = Game.database.gamedata.getConfigData(279);
				var totalWaitTime:int = Game.database.gamedata.getConfigData(280);
			}
			else if(mode == GameMode.PVP_1vs1_MM)
			{
				roundDuration = Game.database.gamedata.getConfigData(282);
				totalWaitTime = Game.database.gamedata.getConfigData(283);
			}

			var waitTimeLeft:int = totalSecond % roundDuration;
			var delta:int = waitTimeLeft - totalWaitTime;

			startGameSuccess = false;

			registerBtn.mouseEnabled = false;
			Utility.setGrayscale(registerBtn, true);

			if(delta == 0) // Het thoi gian cho => Start tran dau luon
			{
				finishCountDown();
			}
			else
			{
				if (delta < 0) 	//Nam trong khoang thoi gian bao danh
				{
					waitTime = Math.abs(delta);
				}
				else
				{ //Nam trong khoang thoi gian dang da'nh => cho den luot danh ke tiep

					waitTime = roundDuration - delta;
				}

				TimerEx.stopTimer(timerID);
				timerID = TimerEx.startTimer(1000, waitTime, updateCountDown, finishCountDown);
				countMov.visible = true;
			}
		}

		private function finishCountDown():void
		{
			Game.flow.doAction(FlowActionEnum.START_LOBBY);
			countMov.visible = false;
		}

		private function updateCountDown():void
		{
			countDownTf.text = Utility.math.formatTime("M-S", --waitTime);
		}

		public function checkEnable(modeValid:Boolean):void
		{
			if(modeValid)
			{
				Utility.setGrayscale(registerBtn, false);
				registerBtn.mouseEnabled = true;
			}
			else
			{
				countMov.visible = false;
				TimerEx.stopTimer(timerID);
				Utility.setGrayscale(registerBtn, true);
				registerBtn.mouseEnabled = false;
			}
		}

		public function startSuccess(value:Boolean):void
		{
			startGameSuccess = value;
		}

		public function unregisterMatchMaking():void
		{
			if(!startGameSuccess && countMov.visible)
			{
				Game.flow.doAction(FlowActionEnum.LEAVE_GAME);
			}

			countMov.visible = false;
			TimerEx.stopTimer(timerID);

			registerBtn.mouseEnabled = true;
			Utility.setGrayscale(registerBtn, false);
		}
	}
}
