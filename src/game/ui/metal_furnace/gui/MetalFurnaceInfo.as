package game.ui.metal_furnace.gui
{

	import com.greensock.TweenLite;

	import core.util.FontUtil;
	import core.util.TextFieldUtil;
	import core.util.Utility;

	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormatAlign;

	import game.Game;
	import game.data.xml.DataType;
	import game.data.xml.VIPConfigXML;
	import game.enum.Font;
	import game.enum.GameConfigID;
	import game.ui.components.CheckBox;
	import game.ui.metal_furnace.MetalFurnaceView;
	import game.utility.TimerEx;

	/**
	 * ...
	 * @author anhtinh & chuongth2
	 */
	public class MetalFurnaceInfo extends MovieClip
	{
		public function MetalFurnaceInfo()
		{
			FontUtil.setFont(xuTf, Font.ARIAL, false);
			FontUtil.setFont(goldTf, Font.ARIAL, false);
			FontUtil.setFont(timeTf, Font.ARIAL, false);
			FontUtil.setFont(vipTf, Font.ARIAL, false);
			FontUtil.setFont(vipTimeTf, Font.ARIAL, false);
			FontUtil.setFont(cbDescriptionTf, Font.ARIAL, false);
			FontUtil.setFont(timeRemainTf, Font.ARIAL, false);
			FontUtil.setFont(priceTf, Font.ARIAL, true);

			countDownMov.visible = false;
			countDownMov.mouseEnabled = false;
			countDownMov.mouseChildren = false;

			autoSkipCoolDown.setChecked(false);

			doingBtn.addEventListener(MouseEvent.CLICK, doingBtn_clicked);
			skipCoolDownBtn.addEventListener(MouseEvent.CLICK, skipCoolDownBtn_clicked);
			skipCoolDownBtn.visible = false;

			price = Game.database.gamedata.getConfigData(GameConfigID.COST_SKIP_TIME_WAIT_ALCHEMY) as int;

			cbDescriptionTf.text = "Tự động bỏ thời gian chờ (" + price + " Vàng/Lần)";
		}

		public var xuTf:TextField;
		public var goldTf:TextField;
		public var timeTf:TextField;
		public var vipTf:TextField;
		public var cbDescriptionTf:TextField;
		public var vipTimeTf:TextField;
		public var countDownMov:MovieClip;
		public var doingBtn:SimpleButton;
		public var skipCoolDownBtn:SimpleButton;
		public var autoSkipCoolDown:CheckBox;
		private var timeWait:int;
		private var timerID:int = -10;
		private var price:int = 0;

		private var furnaceTimer:int = -10;

		public function get timeRemainTf():TextField
		{
			return countDownMov.timeRemainTf as TextField;
		}

		public function get priceTf():TextField
		{
			return countDownMov.priceTf as TextField;
		}

		public function showCountDown(timeWait:int = 0):void
		{
			if (!autoSkipCoolDown.isChecked() && timeWait > 0)
			{
				this.timeWait = timeWait;

				countDownMov.visible = true;
				priceTf.text = price.toString();
				timeRemainTf.text = Utility.math.formatTime("M-S", timeWait);

				doingBtn.visible = false;
				doingBtn.removeEventListener(MouseEvent.CLICK, doingBtn_clicked);

				skipCoolDownBtn.visible = true;

				TimerEx.stopTimer(timerID);
				timerID = TimerEx.startTimer(1000, timeWait, countDown, finishedCountDown);
			}
		}

		public function finishedCountDown():void
		{
			doingBtn.visible = true;
			skipCoolDownBtn.visible = false;

			if (!doingBtn.hasEventListener(MouseEvent.CLICK))
			{
				doingBtn.addEventListener(MouseEvent.CLICK, doingBtn_clicked);
			}

			countDownMov.visible = false;
		}

		public function update(num:int):void
		{
			timeTf.text = "" + num;

			var vipCurrentXML:VIPConfigXML = Game.database.gamedata.getData(DataType.VIP, Game.database.userdata.vip) as VIPConfigXML;
			var vipNextXML:VIPConfigXML = Game.database.gamedata.getNextVIPConfigXML(Game.database.userdata.vip, "additionAlchemyInDay") as VIPConfigXML;
			if (vipNextXML)
			{
				gotoAndStop(1);
				vipTf.text = "" + vipNextXML.ID;
				vipTimeTf.text = "" + (vipNextXML.additionAlchemyInDay - (vipCurrentXML == null ? 0 : vipCurrentXML.additionAlchemyInDay));
			}
			else
			{
				gotoAndStop(2);
				vipTf.text = "";
				vipTimeTf.text = "";
			}
		}

		public function updateTrans(xu:String, gold:String):void
		{
			xuTf.text = xu;
			goldTf.text = gold;
		}

		public function setBonusGold(value:int):void
		{

			if (value > 0)
			{
				var tf:TextField = TextFieldUtil.createTextfield(Font.ARIAL, 16, 146, 50, 0xffffff, false, TextFormatAlign.CENTER, [new GlowFilter(0, 1, 5, 5, 3, 1)]);
				tf.text = "Nhận thêm: " + value + " Vàng";
				tf.autoSize = TextFieldAutoSize.CENTER;

				tf.x = -189;
				tf.y = -36;
				tf.alpha = 0.5;
				addChild(tf);

				TweenLite.to(tf, 3, {y: -66, alpha: 1, onComplete: function (target:DisplayObject):void
				{
					target.parent.removeChild(target);
				},
					onCompleteParams  : [tf]
				});
			}
		}

		private function countDown():void
		{
			timeRemainTf.text = Utility.math.formatTime("M-S", --timeWait);
			Game.database.userdata.remainTimeWaitAlchemy--;
		}

		private function skipCoolDownBtn_clicked(event:MouseEvent):void
		{
			dispatchEvent(new Event(MetalFurnaceView.SKIP_COOLDOWN_EVENT, true));
		}

		private function doingBtn_clicked(event:MouseEvent):void
		{
			doingBtn.mouseEnabled = false;
			dispatchEvent(new Event("processMetalFurnace"));

			TimerEx.stopTimer(furnaceTimer);
			furnaceTimer = TimerEx.startTimer(1000, 1, null, furnaceTimeout);
		}

		private function furnaceTimeout():void
		{
			doingBtn.mouseEnabled = true;
		}

	}

}