package game.ui.dice
{

	import com.greensock.TweenMax;
	import com.greensock.easing.Elastic;

	import core.Manager;
	import core.display.ViewBase;
	import core.event.EventEx;
	import core.util.FontUtil;
	import core.util.Utility;

	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.setTimeout;

	import game.Game;
	import game.enum.Font;
	import game.net.lobby.response.ResponseDiceBetResult;
	import game.net.lobby.response.ResponseDiceLog;
	import game.net.lobby.response.ResponseDicePlayerInfo;
	import game.net.lobby.response.ResponseDiceRollResult;
	import game.ui.components.CheckBox;
	import game.ui.dialog.DialogID;
	import game.ui.dialog.dialogs.YesNo;
	import game.ui.dice.gui.Bet;
	import game.ui.dice.gui.Dices;
	import game.ui.dice.gui.LogPanel;
	import game.ui.dice.gui.RankList;
	import game.ui.dice.gui.RewardPanel;
	import game.utility.UtilityUI;

	/**
	 * ...
	 * @author
	 */
	public class DiceView extends ViewBase
	{
		public static const START:String = "START_DICE";
		public static const BET:String = "BET_DICE";
		public static const RECEIVE_REWARD:String = "RECEIVE_REWARD_DICE";
		public static const GET_LOG:String = "DICE_GET_LOG";
		public static const UPDATE_RANKING:String = "UPDATE_DICE_RANKING";

		public function DiceView()
		{
			FontUtil.setFont(freeTf, Font.ARIAL, true);
			FontUtil.setFont(fixTf, Font.ARIAL, true);
			FontUtil.setFont(timeoutTf, Font.ARIAL, true);
			FontUtil.setFont(priceTf, Font.ARIAL, true);

			priceTf.autoSize = TextFieldAutoSize.LEFT;

			closeBtn = UtilityUI.getComponent(UtilityUI.CLOSE_BTN) as SimpleButton;

			if (closeBtn != null)
			{
				closeBtn.x = 1080;
				closeBtn.y = 94;
				addChild(closeBtn);
				closeBtn.addEventListener(MouseEvent.CLICK, closeHandler);
			}

			startBtn.visible = true;
			resultMov.visible = false;
			maxMov.visible = false;
			resultMov.mouseEnabled = false;
			logPanel.close();
			betMov.hide();

			startBtn.addEventListener(MouseEvent.CLICK, btnClickHdl);
			smallerBtn.addEventListener(MouseEvent.CLICK, btnClickHdl);
			greaterBtn.addEventListener(MouseEvent.CLICK, btnClickHdl);

			autoFix.setChecked(false);
		}

		public var myDice:Dices;
		public var yourDice:Dices;
		public var freeTf:TextField;
		public var fixTf:TextField;
		public var timeoutTf:TextField;
		public var priceTf:TextField;
		public var rankList:RankList;
		public var autoFix:CheckBox;
		public var startBtn:SimpleButton;
		public var betMov:Bet;
		public var resultMov:MovieClip;
		public var maxMov:MovieClip;
		public var rewardPanel:RewardPanel;
		public var logPanel:LogPanel;
		private var myInfo:ResponseDicePlayerInfo;
		private var closeBtn:SimpleButton;
		private var dontAsk:Boolean = false;


		private function get totalFreePlay():int
		{
			var priceList:Array = Game.database.gamedata.getConfigData(256);
			var count:int = 0;

			for each (var price:int in priceList)
			{
				if (price == 0) count++;
			}

			return count - 1; // Phan tu dau tien cua mang gia khong su dung
		}

		private function get totalFreeFix():int
		{
			var priceList:Array = Game.database.gamedata.getConfigData(258);
			var count:int = 0;

			for each (var price:int in priceList)
			{
				if (price == 0) count++;
			}

			return count - 1; // Phan tu dau tien cua mang gia khong su dung
		}

		private function get smallerBtn():SimpleButton
		{
			return betMov.smallerBtn;
		}

		private function get greaterBtn():SimpleButton
		{
			return betMov.greaterBtn;
		}

		public function updateInfo(packet:ResponseDicePlayerInfo):void
		{
			myInfo = packet;

			myDice.reset();
			yourDice.reset();

			updateText();

			if (packet.diceValues[0] != 0)
			{
				myDice.openWithAnim(packet.diceValues);
				startBtn.visible = false;
				setTimeout(betMov.show, 500);
				resultMov.visible = false;
			}
			else
			{
				restart();
			}
		}

		private function restart():void
		{
			maxMov.visible = rewardPanel.isFull;
			startBtn.visible = !rewardPanel.isFull;
			betMov.hide();
			resultMov.visible = false;
			myDice.reset();
			yourDice.reset();
		}

		public function showDiceRollResult(packet:ResponseDiceRollResult):void
		{
			myInfo.currBetCount = packet.currBetCount;
			myInfo.accWinPoint = packet.accWinPoint;
			myInfo.currCorrectCount = packet.currCorrectCount;

			myDice.openWithAnim(packet.diceValues);
			startBtn.visible = false;
			setTimeout(betMov.show, 500);
			resultMov.visible = false;

			updateText();
		}

		public function showBetResult(packet:ResponseDiceBetResult):void
		{
			myInfo.showCorrectPanel = packet.showCorrectPanel;
			myInfo.currBetCount = packet.currBetCount;
			myInfo.currCorrectCount = packet.currCorrectCount;
			myInfo.accWinPoint = packet.accWinPoint;

			yourDice.openWithAnim(packet.diceValues);
			updateText();
			showWinLooseAnim(packet.isWin);
		}

		private function startHandler():void
		{
			if (myInfo && myInfo.showCorrectPanel && !autoFix.isChecked())
			{
				var priceList:Array = Game.database.gamedata.getConfigData(258);
				var index:int = myInfo.currCorrectCount + 1;
				var price:int = (index >= priceList.length) ? priceList[priceList.length - 1] : priceList[index];
				var msg:String = (price > 0) ? "Dùng " + price + " Vàng để giữ liên thắng?" : "Sử dụng lần sửa sai miễn phí để giữ liên thắng?";
				Manager.display.showDialog(DialogID.YES_NO, onAcceptPayment, onCancelPayment, {
					title  : "THÔNG BÁO",
					message: msg,
					option : YesNo.YES | YesNo.NO
				});
			}
			else
			{
				processStart(autoFix.isChecked());
			}
		}

		private function onCancelPayment(data:Object):void
		{
			processStart(false);
		}

		private function onAcceptPayment(data:Object):void
		{
			processStart(true);
		}

		public function showLog(packet:ResponseDiceLog):void
		{
			logPanel.show(packet.logString);
		}

		public function processStart(correctMistake:Boolean):void
		{
			var priceList:Array = Game.database.gamedata.getConfigData(256);
			var index:int = myInfo.currBetCount + 1;
			var price:int = (index >= priceList.length) ? priceList[priceList.length - 1] : priceList[index];
			if(price > 0 && !dontAsk)
			{
				var msg:String = "Dùng " + price + " Vàng để mua lượt chơi?";
				Manager.display.showDialog(DialogID.YES_NO, onAcceptPaymentForBet, null, {
					title  : "THÔNG BÁO",
					message: msg,
					correctMistake: correctMistake,
					option : YesNo.YES | YesNo.NO | YesNo.DONT_ASK
				});
			}
			else
			{
				dispatchEvent(new EventEx(START, correctMistake, true));
			}
		}

		private function onAcceptPaymentForBet(data:Object):void
		{
			dontAsk = data.dontAsk;
			dispatchEvent(new EventEx(START, data.correctMistake, true));
		}

		private function updateText():void
		{
			var freePlay:int = totalFreePlay - myInfo.currBetCount;
			var freeFix:int = totalFreeFix - myInfo.currCorrectCount;
			freeTf.text = freePlay < 0 ? "0" : freePlay.toString();
			fixTf.text = freeFix < 0 ? "0" : freeFix.toString();

			var priceList:Array = Game.database.gamedata.getConfigData(258);
			var index:int = myInfo.currCorrectCount + 1;
			var price:int = (index >= priceList.length) ? priceList[priceList.length - 1] : priceList[index];
			priceTf.text = (price > 0) ? "Đoán sai sử dụng " + price + " vàng để sửa sai." : "Tự động sử dụng lần sửa sai miễn phí.";

			timeoutTf.text = (myInfo.timeLeft >= 86400) ? Utility.math.formatTime("DD", myInfo.timeLeft) : Utility.math.formatTime("H-M-S", myInfo.timeLeft);

			rewardPanel.updateInfo(myInfo);
		}

		private function showWinLooseAnim(isWin:Boolean):void
		{
			betMov.hide();
			isWin ? resultMov.gotoAndStop(1) : resultMov.gotoAndStop(2);
			resultMov.visible = true;

			TweenMax.fromTo(resultMov, 1, {scaleX:0, scaleY:0},{scaleX:1, scaleY:1, ease:Elastic.easeOut, onComplete:onFinishTween, onCompleteParams:[isWin]});
		}

		private function onFinishTween(isWin:Boolean):void
		{
			if(isWin)
			{
				yourDice.reset();
				dispatchEvent(new EventEx(START, false, true));
			}
			else
			{
				setTimeout(restart, 1000);
			}
		}

		private function btnClickHdl(event:MouseEvent):void
		{
			switch (event.target)
			{
				case startBtn:
					startHandler();
					break;
				case greaterBtn:
				case smallerBtn:
					var isGreater:Boolean = event.target == greaterBtn;
					dispatchEvent(new EventEx(BET, {isAutoSave: autoFix.isChecked(), isGreater: isGreater}, true));
					break;
			}
		}

		private function closeHandler(event:MouseEvent):void
		{
			dispatchEvent(new Event("close", true));
		}

		public function updateRankList(players:Array):void
		{
			rankList.updateData(players);
		}
	}
}