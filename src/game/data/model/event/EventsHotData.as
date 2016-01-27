/**
 * Created by NinhNQ on 9/19/2014.
 */
package game.data.model.event
{

	import core.Manager;
	import core.event.EventEx;
	import core.util.Utility;

	import flash.events.EventDispatcher;

	import game.Game;
	import game.data.model.item.IItemConfig;
	import game.data.model.item.ItemFactory;
	import game.data.vo.reward.RewardInfo;
	import game.data.xml.DataType;
	import game.data.xml.event.EventType;
	import game.data.xml.event.EventXML;
	import game.data.xml.event.EventsHotXML;
	import game.enum.FlowActionEnum;
	import game.enum.ItemType;
	import game.enum.PaymentType;
	import game.net.IntResponsePacket;
	import game.net.RequestPacket;
	import game.net.ResponsePacket;
	import game.net.Server;
	import game.net.lobby.LobbyRequestType;
	import game.net.lobby.LobbyResponseType;
	import game.net.lobby.request.RequestEventInfo;
	import game.net.lobby.response.ResponseConvertEventItem;
	import game.net.lobby.response.ResponseEventInfo;
	import game.net.lobby.response.ResponseEventRewards;
	import game.net.lobby.response.ResponseGameLevelUp;
	import game.net.lobby.response.ResponseGetAvailableEvents;
	import game.net.lobby.response.ResponseRequestATMPayment;
	import game.ui.components.ItemSlot;
	import game.ui.message.MessageID;
	import game.utility.UtilityEffect;

	public class EventsHotData extends EventDispatcher
	{
		public static const UPDATE:String = "EventsHotData_event_update";

		public function EventsHotData()
		{
			Game.network.lobby.addEventListener(Server.SERVER_DATA, onLobbyServerData);
		}

		public var availableEvents:Array = [];
		private var initialized:Boolean = false;
		private var currentTime:Number;
		private var arrRewardEffect:Array;

		public function init():void
		{
			if (initialized) return;

			currentTime = Game.database.userdata.loginTime;

			Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.EVENT_GET_AVAILABLE_EVENTS));

			initialized = true;
		}

		private function checkExist(eventXML:EventXML):Boolean
		{
			for each (var eventData:EventData in availableEvents)
			{
				if (eventData.eventXML == eventXML)
				{
					return true;
				}
			}

			return false;
		}

		private function getEvent(eventID:int):EventData
		{
			for each (var eventData:EventData in availableEvents)
			{
				if (eventData.eventXML.ID == eventID) return eventData;
			}

			return null;
		}

		private function eventExpiredHdl(event:EventEx):void
		{
			var eventData:EventData = event.target as EventData;
			availableEvents.splice(availableEvents.indexOf(eventData), 1);
			eventData.removeEventListener(EventData.EXPIRED, eventExpiredHdl)

			dispatchEvent(new EventEx(UPDATE));
		}

		private function onLobbyServerData(event:EventEx):void
		{
			var packet:ResponsePacket = event.data as ResponsePacket;
			switch (packet.type)
			{
				case LobbyResponseType.GAME_LEVEL_UP:
					onGameLevelUp(packet as ResponseGameLevelUp);
					break;
				case LobbyResponseType.EVENT_GET_INFO:
					onReceiveEventInfo(packet as ResponseEventInfo);
					break;
				case LobbyResponseType.EVENT_BUY_ITEM_ACTIVE:
					onBuyItemActiveResult(packet as IntResponsePacket);
					break;
				case LobbyResponseType.EVENT_CONVERT_ITEM:
					onConvertItemResult(packet as ResponseConvertEventItem);
					break;
				case LobbyResponseType.EVENT_RECEIVE_REWARD:
					onReceiveRewardResult(packet as ResponseEventRewards);
					break;
				case LobbyResponseType.GET_AVAILABLE_EVENTS:
					onReceiveAvailableEvents(packet as ResponseGetAvailableEvents);
					break;
			}
		}

		private function onReceiveAvailableEvents(packet:ResponseGetAvailableEvents):void
		{
			Utility.log("onReceiveAvailableEvents > result: " + packet.eventIDs);

			var serverID:int = parseInt(Game.database.flashVar.server);
			var eventsHotXML:EventsHotXML = Game.database.gamedata.getData(DataType.EVENTS_HOT, serverID) as EventsHotXML;

			clear();

			for each (var eventXML:EventXML in eventsHotXML.events)
			{
				if(packet.eventIDs.indexOf(eventXML.ID) != -1)
				{
					var event:EventData = new eventXML.type.classData(eventXML, currentTime);
					event.addEventListener(EventData.EXPIRED, eventExpiredHdl);
					availableEvents.push(event);
				}
			}

			dispatchEvent(new EventEx(UPDATE));
		}

		private function clear():void
		{
			for (var i:int = 0; i < availableEvents.length; i++)
			{
				var data:EventData = availableEvents[i] as EventData;
				data.removeEventListener(EventData.EXPIRED, eventExpiredHdl)
			}

			availableEvents = [];
		}

		private function onReceiveRewardResult(packet:ResponseEventRewards):void
		{
			Utility.log("onReceiveRewardResult > result: " + packet.errorCode);
			switch (packet.errorCode)
			{
				case 0: //success
					var eventData:EventData = getEvent(packet.eventID);
					eventData.requestServerInfo();
					showReceiveRewardsAnim(eventData, packet.milestoneIndex);
					Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.GET_PLAYER_INFO));
					break;
				case 1: //fail
					Manager.display.showMessageID(124);
					break;
				case 2: //FULL_INVENTORY
					Manager.display.showMessageID(15);
					break;
				case 3: ////Khong du dieu kien nhan thuong
					Manager.display.showMessageID(124);
					break;
				case 4: //Da nhan thuong roi
					Manager.display.showMessageID(128);
					break;
				case 5: //Da het thoi gian nhan thuong
					Manager.display.showMessageID(126);
					break;
			}
		}

		private function showReceiveRewardsAnim(eventData:EventData, milestoneIndex:int):void
		{
			var data:Milestone = eventData.eventXML.milestones[milestoneIndex] as Milestone;
			arrRewardEffect = [];

			var stageWidth:int = Manager.display.getStage().stageWidth;
			var stageHeight:int = Manager.display.getStage().stageHeight;
			var length:int = data.rewardInfos.length;

			for (var i:int = 0; i < length; i++)
			{
				var info:RewardInfo = data.rewardInfos[i] as RewardInfo;

				var rewardSlot:ItemSlot = Manager.pool.pop(ItemSlot) as ItemSlot;
				rewardSlot.x = (stageWidth - length*65)/2 + i* 65;
				rewardSlot.y = (stageHeight - 65)/2;
				rewardSlot.setConfigInfo(info.itemConfig);
				rewardSlot.setQuantity(info.quantity);
				arrRewardEffect.push(rewardSlot);
			}

			UtilityEffect.tweenItemEffects(arrRewardEffect, function():void
			{
				for each(var slot:ItemSlot in arrRewardEffect)
				{
					slot.reset();
					Manager.pool.push(slot, ItemSlot);
				}

				arrRewardEffect = [];
			}, true);
		}

		private function onConvertItemResult(packet:ResponseConvertEventItem):void
		{
			Utility.log("onConvertItemResult > result: " + packet.errorCode);
			switch (packet.errorCode)
			{
				case 0: //success
					showConvertAnim(packet.eventID);
					break;
				case 1: //fail
					Manager.display.showMessageID(125);
					break;
				case 2:  //Da het thoi gian nhan thuong
					Manager.display.showMessageID(126);
					break;
				case 3: //FULL_INVENTORY
					Manager.display.showMessageID(15);
					break;
			}
		}

		private function showConvertAnim(eventID:int):void
		{
			var data:ExchangeEventData;
			for each (var eventData:EventData in availableEvents)
			{
				if(eventData.eventXML.ID == eventID)
				{
					data = eventData as ExchangeEventData;
					data.requestServerInfo(); // update lai maxCombination
					break;
				}
			}

			arrRewardEffect = [];
			var stageWidth:int = Manager.display.getStage().stageWidth;
			var stageHeight:int = Manager.display.getStage().stageHeight;
			var config:IItemConfig = ItemFactory.buildItemConfig(ItemType.NORMAL_CHEST, data.exchangeEventXML.equation.dest.itemID);
			var slot:ItemSlot = Manager.pool.pop(ItemSlot) as ItemSlot;
			slot.x = (stageWidth - 65)/2;
			slot.y = (stageHeight - 65)/2;
			slot.setConfigInfo(config);
			slot.setQuantity(data.exchangeEventXML.equation.dest.quantity * data.currentCombination);
			arrRewardEffect.push(slot);

			UtilityEffect.tweenItemEffects(arrRewardEffect, function():void
			{
				for each(var slot:ItemSlot in arrRewardEffect)
				{
					slot.reset();
					Manager.pool.push(slot, ItemSlot);
				}

				arrRewardEffect = [];
			}, true);
		}

		private function onBuyItemActiveResult(packet:IntResponsePacket):void
		{
			Utility.log("onBuyItemActiveResult > result: " + packet.value);
			switch (packet.value)
			{
				case 0: //success
					for (var i:int = 0; i < availableEvents.length; i++)
					{
						var eventData:EventData = availableEvents[i] as EventData;
						if(eventData.eventXML.type == EventType.ACTIVATE)
						{
							ActivateEventData(eventData).isActivated = true;
						}
					}
					Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.GET_PLAYER_INFO));
					break;
				case 1: //fail
					Manager.display.showMessageID(127);
					break;
				case 2:  //Da het thoi gian nhan thuong
					Manager.display.showMessageID(126);
					break;
				case 3: //Not enough money
					Game.flow.doAction(FlowActionEnum.PURCHASE_RESOURCE, PaymentType.XU_NORMAL.ID);
					break;
			}
		}

		private function onGameLevelUp(responseGameLevelUp:ResponseGameLevelUp):void
		{
			currentTime = new Date().getTime() + Game.database.userdata.serverTimeDifference;
			Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.EVENT_GET_AVAILABLE_EVENTS));
		}

		private function onReceiveEventInfo(packet:ResponseEventInfo):void
		{
			if (packet.eventID > 0)
			{
				var event:EventData = getEvent(packet.eventID);
				if (event)
				{
					event.update(packet);
				}
				else
				{
					Utility.warning("onReceiveEventInfo > Event not exist: " + packet.eventID);
				}
			}
		}
	}
}
