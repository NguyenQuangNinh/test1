/**
 * Created by NinhNQ on 12/25/2014.
 */
package game.ui.express.gui
{

	import core.Manager;
	import core.event.EventEx;
	import core.util.FontUtil;
	import core.util.Utility;

	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	import game.Game;
	import game.data.vo.reward.RewardInfo;

	import game.enum.Font;
	import game.net.lobby.response.ResponsePorterInfo;
	import game.ui.components.ItemSlot;
	import game.ui.express.ExpressView;
	import game.utility.TimerEx;
	import game.utility.UtilityUI;

	public class PorterInfoDialog extends MovieClip
	{
		public var typeTf:TextField;
		public var timeTf:TextField;
		public var ownerTf:TextField;
		public var raidTf:TextField;

		public var closeBtn:SimpleButton;
		public var raidBtn:SimpleButton;
		public var rewards:MovieClip;

		private var _data:ResponsePorterInfo;

		private var timerID:int = -1;

		public function PorterInfoDialog()
		{
			addEventListener(Event.ADDED_TO_STAGE, initUI);
		}

		private function initUI(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, initUI);

			FontUtil.setFont(typeTf, Font.ARIAL, true);
			FontUtil.setFont(timeTf, Font.ARIAL, true);
			FontUtil.setFont(ownerTf, Font.ARIAL, true);
			FontUtil.setFont(raidTf, Font.ARIAL, true);

			closeBtn = UtilityUI.getComponent(UtilityUI.CLOSE_BTN) as SimpleButton;

			if (closeBtn != null)
			{
				closeBtn.x = 423;
				closeBtn.y = 35;
				addChild(closeBtn);
				closeBtn.addEventListener(MouseEvent.CLICK, close);
			}

			raidBtn.addEventListener(MouseEvent.CLICK, btnClickHdl);
		}

		private function btnClickHdl(event:MouseEvent):void
		{
			switch (event.target)
			{
				case raidBtn:
					dispatchEvent(new EventEx(ExpressView.RAID, {playerID: _data.playerID}, true));
					break;
			}
		}

		public function close(event:MouseEvent = null):void
		{
			this.visible = false;
		}

		public function show(data:ResponsePorterInfo):void
		{
			this.visible = true;
			this._data = data;

			TimerEx.stopTimer(timerID);
			timerID = TimerEx.startTimer(1000, data.elapsedTransportTime, countDown);

			typeTf.text = data.porterType.name;
			timeTf.text =  Utility.math.formatTime("M-S",  data.elapsedTransportTime);
			ownerTf.text = data.name + "-Cấp " + data.level;
			raidTf.text = data.robRemainCount + " Lần ";

			raidBtn.visible = data.playerID != Game.database.userdata.userID;

			while (rewards.numChildren > 0)
			{
				var child:ItemSlot = rewards.getChildAt(0) as ItemSlot;
				child.reset();
				Manager.pool.push(child, ItemSlot);
				rewards.removeChild(child);
			}

			var itemSlot:ItemSlot;
			var info:RewardInfo;
			for(var i:int = 0; i < data.rewards.length; i++)
			{
				info = data.rewards[i] as RewardInfo;
				itemSlot = Manager.pool.pop(ItemSlot) as ItemSlot;
				itemSlot.setConfigInfo(info.itemConfig);
				itemSlot.setQuantity(info.quantity);
				itemSlot.x = i* 65;
				itemSlot.y = 0;
				rewards.addChild(itemSlot);
			}
		}

		private function countDown():void
		{
			timeTf.text =  Utility.math.formatTime("M-S",  ++_data.elapsedTransportTime);
		}
	}
}
