package game.ui.events
{

	import core.Manager;
	import core.display.ModuleBase;
	import core.event.EventEx;

	import flash.events.Event;

	import game.Game;
	import game.data.model.event.EventsHotData;
	import game.data.model.event.Milestone;
	import game.enum.FlowActionEnum;
	import game.enum.PaymentType;
	import game.net.IntRequestPacket;
	import game.net.RequestPacket;
	import game.net.lobby.LobbyRequestType;
	import game.net.lobby.request.RequestCombineEventItem;
	import game.net.lobby.request.RequestEventReceiveReward;
	import game.ui.ModuleID;
import game.ui.events.gui.EventPanel;
	import game.ui.hud.HUDModule;

	/**
	 * ...
	 * @author
	 */
	public class EventsHotModule extends ModuleBase
	{

		public function EventsHotModule()
		{

		}

		private function get view():EventsHotView
		{
			return baseView as EventsHotView;
		}

		private function get data():EventsHotData
		{
			return Game.database.gamedata.eventsData as EventsHotData;
		}

		override protected function createView():void
		{
			baseView = new EventsHotView();
			baseView.addEventListener("close", closeHandler);
			baseView.addEventListener(EventPanel.RECEIVE_REWARD, receiveRewardHandler);
			baseView.addEventListener(EventPanel.ACTIVATE, activateHandler);
			baseView.addEventListener(EventPanel.COMBINE, combineHandler);
			baseView.addEventListener(EventPanel.CHARGE, chargeHandler);
		}

		private function chargeHandler(event:EventEx):void
		{
//			Manager.display.showPopup(ModuleID.PAYMENT);
			Game.database.gamedata.loadPaymentHTML();
		}

		private function combineHandler(event:EventEx):void
		{
			var eventID:int = event.data.eventID as int;
			var quantity:int = event.data.quantity as int;
			Game.network.lobby.sendPacket(new RequestCombineEventItem(LobbyRequestType.EVENT_CONVERT_ITEM, eventID, quantity));
		}

		private function activateHandler(event:EventEx):void
		{
			Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.EVENT_BUY_ITEM_ACTIVE));
		}

		private function receiveRewardHandler(event:EventEx):void
		{
			var milestone:Milestone = event.data as Milestone;
			var eventID:int = view.panelMov.data.eventXML.ID;
			var eventType:int = view.panelMov.data.eventXML.type.ID;
			Game.network.lobby.sendPacket(new RequestEventReceiveReward(LobbyRequestType.EVENT_RECEIVE_REWARD, eventID, eventType, milestone.index));
		}

		override protected function preTransitionIn():void
		{
			super.preTransitionIn();
			view.update();
			data.addEventListener(EventsHotData.UPDATE, dataUpdateHandler);
		}

		override protected function preTransitionOut():void
		{
			super.preTransitionOut();
			data.removeEventListener(EventsHotData.UPDATE, dataUpdateHandler);
		}

		private function dataUpdateHandler(event:EventEx):void
		{
			view.update();
		}

		private function closeHandler(e:Event):void
		{
			var hudModule:HUDModule = Manager.module.getModuleByID(ModuleID.HUD) as HUDModule;
			if (hudModule != null)
			{
				hudModule.updateHUDButtonStatus(ModuleID.EVENTS_HOT, false);
			}
		}
	}

}