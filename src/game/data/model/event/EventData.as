/**
 * Created by NinhNQ on 9/19/2014.
 */
package game.data.model.event
{

	import core.event.EventEx;

	import flash.events.Event;

	import flash.events.EventDispatcher;

	import game.Game;

	import game.data.xml.event.EventXML;
	import game.data.xml.event.MilestoneStatus;
	import game.net.lobby.LobbyRequestType;
	import game.net.lobby.request.RequestEventInfo;
	import game.net.lobby.response.ResponseEventInfo;
	import game.utility.TimerEx;

	public class EventData extends EventDispatcher
	{
		public static const EXPIRED:String = "EventData_event_expired";
		public static const UPDATE:String = "EventData_event_data_update";

		public function EventData(xml:EventXML, currentTime:Number)
		{
			this.eventXML = xml;

			var interval:int = eventXML.timeEndReceive - currentTime;

			if(interval < 0) return;

			TimerEx.startTimer(interval, 1, function ():void
			{
				dispatchEvent(new EventEx(EXPIRED));
			});
		}

		public var eventXML:EventXML;
		public function get isMax():Boolean {return currentAcc >= maxAcc;}
		public var currentAcc:int = 0; //số tích lũy hiện tại
		public function get maxAcc():int
		{
			var max:int = 0;

			for each (var m:Milestone in eventXML.milestones)
			{
				max = (max < m.value) ? m.value : max;
			}

			return max;
		}

		public function update(serverData:ResponseEventInfo):void
		{
			currentAcc = serverData.currentAcc;

			for (var j:int = 0; j < eventXML.milestones.length; j++)
			{
				var milestone:Milestone = eventXML.milestones[j] as Milestone;
				milestone.status = (milestone.value <= currentAcc) ? MilestoneStatus.READY : MilestoneStatus.NOT_READY;
			}

			for (var i:int = 0; i < serverData.receivedRewardIndexs.length; i++)
			{
				var index:int = serverData.receivedRewardIndexs[i] as int;
				milestone = eventXML.milestones[index] as Milestone;

				if(milestone)
				{
					milestone.status = MilestoneStatus.RECEIVED;
				}
			}

			dispatchEvent(new Event(UPDATE));
		}

		public function requestServerInfo():void
		{
			Game.network.lobby.sendPacket(new RequestEventInfo(LobbyRequestType.EVENT_GET_INFO, eventXML.ID, eventXML.type.ID))
		}

	}
}
