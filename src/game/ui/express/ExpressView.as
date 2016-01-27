package game.ui.express
{
	import core.display.ViewBase;
	import core.event.EventEx;
	import core.util.Utility;

	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;

	import game.enum.PorterType;

	import game.net.lobby.response.ResponsePorterList;

	import game.net.lobby.response.ResponsePorterPlayerInfo;

	import game.ui.express.gui.HireDialog;

	import game.ui.express.gui.Info;
	import game.ui.express.gui.PorterInfoDialog;
	import game.ui.express.gui.PortersContainer;
	import game.utility.UtilityUI;

	/**
	 * ...
	 * @author ninhnq
	 */
	public class ExpressView extends ViewBase
	{
		public static const REFRESH:String = "refresh_porter_transport_event";
		public static const RAID:String = "raid_express_event";
		public static const START:String = "start_express_event";
		public static const SELECT_PORTER:String = "select_porter_event";
		public static const BUY_RED:String = "express_buy_red";
		public static const COMPLETE:String = "express_complete_transport_event";

		public var info:Info;
		public var closeBtn:SimpleButton;
		public var hireBtn:SimpleButton;
		public var hireDlg:HireDialog;
		public var porterInfoDlg:PorterInfoDialog;

		public var porters:PortersContainer;
		private var myInfo:ResponsePorterPlayerInfo;

		public function ExpressView()
		{
			closeBtn = UtilityUI.getComponent(UtilityUI.BACK_BTN) as SimpleButton;

			var closeBtnPoint:Point = UtilityUI.getComponentPosition(UtilityUI.BACK_BTN) as Point;
			if (closeBtn != null) {
				closeBtn.x = closeBtnPoint.x;
				closeBtn.y = closeBtnPoint.y;
				addChild(closeBtn);
				closeBtn.addEventListener(MouseEvent.CLICK, backHdl);
			}

			hireDlg.visible = false;
			porterInfoDlg.visible = false;
			hireBtn.addEventListener(MouseEvent.CLICK, hireHdl);
		}

		private function hireHdl(event:MouseEvent):void
		{
			if(myInfo)
			{
				hireDlg.show(myInfo.refreshPorterType, myInfo.numOfRefresh);
			}
		}

		private function backHdl(e:MouseEvent):void
		{
			dispatchEvent(new Event(Event.CLOSE, true));
		}

		public function updateMyInfo(packet:ResponsePorterPlayerInfo):void
		{
			myInfo = packet;
			info.reset();
			porters.resetMyPorter();

			if(packet.porterType)
			{
				info.setData(packet);
				porters.updateMyPorter(packet);
				Utility.setGrayscale(hireBtn, true);
				hireBtn.mouseEnabled = false;
			}
			else
			{
				info.setGeneralInfo(packet);
				Utility.setGrayscale(hireBtn, false);
				hireBtn.mouseEnabled = true;
			}
		}

		public function updatePorterList(packet:ResponsePorterList):void
		{
			porters.updateList(packet.porters);
		}

		public function refreshResult(newPorterType:PorterType, numOfRefresh:int):void
		{
			myInfo.numOfRefresh = numOfRefresh;
			myInfo.refreshPorterType = newPorterType;
			hireDlg.show(myInfo.refreshPorterType, myInfo.numOfRefresh);
		}
	}
}