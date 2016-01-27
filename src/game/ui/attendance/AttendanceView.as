package game.ui.attendance
{
	import com.greensock.TweenMax;

	import core.Manager;
	import core.display.ViewBase;
	import core.event.EventEx;
	import core.util.FontUtil;

	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	import game.Game;
	import game.enum.Font;
	import game.enum.GameConfigID;
	import game.net.RequestPacket;
	import game.net.ResponsePacket;
	import game.net.Server;
	import game.net.lobby.LobbyRequestType;
	import game.net.lobby.LobbyResponseType;
	import game.net.lobby.response.ResponseErrorCode;
	import game.ui.ModuleID;
	import game.ui.components.ButtonClose;
	import game.ui.hud.HUDModule;
	import game.ui.hud.HUDView;
	import game.utility.GameUtil;

	/**
	 * ...
	 * @author anhpnh2
	 */
	public class AttendanceView extends ViewBase
	{
		public function AttendanceView()
		{
			super();
			btnClose = new ButtonClose();
			btnCloseContainer.addChild(btnClose);

			FontUtil.setFont(txtCount, Font.ARIAL);

			initUI();

			arrowL.visible = false;
			arrowR.visible = false;
			addEventListener(MouseEvent.CLICK, onClicked);
		}

		public var btnCloseContainer:MovieClip;
		public var taps:MovieClip;
		public var rewardTable:AttendanceTable;
		public var txtCount:TextField;
		public var checkInBtn:SimpleButton;
		public var checkedInMov:MovieClip;
		public var arrowL:SimpleButton;
		public var arrowR:SimpleButton;
		private var tabWidth:Number;
		private var tabsX_Min:Number;
		private var tabsX_Max:Number;
		private var btnClose:ButtonClose;
		private var arrTab:Array;
		private var tabActive:AttendanceTap;
		private var tabCurrent:AttendanceTap;

		override public function transitionOut():void
		{
			super.transitionOut();
			Game.network.lobby.removeEventListener(Server.SERVER_DATA, onLobbyServerData);
		}

		override public function transitionIn():void
		{
			super.transitionIn();
			Game.network.lobby.addEventListener(Server.SERVER_DATA, onLobbyServerData);
			//Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.UPDATE_ATTENDANCE_INFO));
			onUpdateAttendance(null);
		}

		override protected function transitionInComplete():void
		{
			super.transitionInComplete();
			UpdateArrows();
		}

		public function onUpdateAttendance(object:Object):void
		{
			var time:int = Game.database.userdata.attendanceTime;
			txtCount.text = time + " lần";

			var tab:AttendanceTap;
			for (var i:int = arrTab.length - 1; i >= 0; i--)
			{
				tab = arrTab[i];
				if (tab.index > time)
				{
					tabActive = tab;
				}
			}
			//if (tabActive == null)
			//	tabActive = arrTab[0];
			tabCurrent = tabActive;
			UpdateRewardTable();
		}

		private function initUI():void
		{
			var arrTabInfo:Array = [];
			var i:int;
			var arrInt:Array = Game.database.gamedata.getConfigData(GameConfigID.ATTENDANCE_REWARDS) as Array;
			for (i = 1; i < arrInt.length; i++)
			{
				if (arrInt[i] > 0)
				{
					var arrReward:Array = GameUtil.getItemRewardsByID(arrInt[i]) as Array;
					if (arrReward != null && arrReward.length > 0)
					{
						arrTabInfo.push(new AttendendTapInfo(i, arrReward));
					}
				}
			}

			var tab:AttendanceTap;
			arrTab = [];
			for (i = 0; i < arrTabInfo.length; i++)
			{
				tab = new AttendanceTap();
				tab.gotoAndStop("UNSELECT");
				tab.info = arrTabInfo[i];
				tab.x = i * tab.width;
				taps.addChild(tab);
				arrTab.push(tab);
			}
			tabWidth = tab.width;
			tabsX_Max = taps.x;
			tabsX_Min = taps.x - taps.width + 486;
			rewardTable.gotoAndStop("NORMAL");
		}

		private function UpdateArrows():void
		{
			arrowL.visible = taps.x < tabsX_Max;
			arrowR.visible = taps.x > tabsX_Min;
		}

		private function UpdateRewardTable():void
		{
			for each(var tab:AttendanceTap in arrTab)
			{
				tab.gotoAndStop("UNSELECT");
			}

			tabCurrent.gotoAndStop("SELECT");

			var state:int = 2;
			if (tabCurrent.index >= tabActive.index) state = 1;
			if (Game.database.userdata.attendanceChecked)
			{
				checkInBtn.visible = false;
				checkedInMov.visible = true;
			}
			else
			{
				checkInBtn.visible = true;
				checkedInMov.visible = false;
			}
			rewardTable.update(tabCurrent, state);
		}

		private function onLobbyServerData(e:EventEx):void
		{
			var packet:ResponsePacket = ResponsePacket(e.data);
			switch (packet.type)
			{
				case LobbyResponseType.ERROR_CODE:
					var error:ResponseErrorCode = packet as ResponseErrorCode;
					if (error.requestType == LobbyRequestType.LOGIC_CHECK_IN)
					{
						if (error.errorCode == 0)
						{
							if (Game.database.userdata.attendanceTime == tabActive.index)
							{
								rewardTable.showEffectGetReward();
							}
							var hudModule:HUDModule = Manager.module.getModuleByID(ModuleID.HUD) as HUDModule;
							if (hudModule != null)
							{
								HUDView(hudModule.baseView).btnAttendance.checkVisible();
							}
							onUpdateAttendance(null);
						}
						else if (error.errorCode == 4)
						{
							Manager.display.showMessage("Thùng đồ đầy, không thể nhận thưởng điểm danh");
						}
						e.stopImmediatePropagation();
					}
					break;

			}
		}

		private function onClicked(event:MouseEvent):void
		{
			if (event.target is AttendanceTap)
			{
				tabCurrent = AttendanceTap(event.target);
				UpdateRewardTable();
				return;
			}

			var xMove:Number;
			switch (event.target)
			{
				case btnClose:
					dispatchEvent(new EventEx(AttendanceModule.CLOSE_ATTENDANCE_VIEW));
					break;
				case arrowR:
					xMove = taps.x - tabWidth;
					if (xMove < tabsX_Min) xMove = tabsX_Min;
					TweenMax.to(taps, 0.5, { x: xMove, onComplete: UpdateArrows});
					break;
				case arrowL:
					xMove = taps.x + tabWidth;
					if (xMove > tabsX_Max) xMove = tabsX_Max;
					TweenMax.to(taps, 0.5, { x: xMove, onComplete: UpdateArrows});
					break;
				case checkInBtn:
					tabCurrent = tabActive;
					UpdateRewardTable();
					checkInBtn.visible = false;
					Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.LOGIC_CHECK_IN));
					break;
			}
		}
	}

}