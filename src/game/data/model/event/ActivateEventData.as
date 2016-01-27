/**
 * Created by NinhNQ on 9/19/2014.
 */
package game.data.model.event
{

	import flash.events.Event;

	import game.data.xml.event.EventXML;
	import game.net.lobby.response.ResponseEventInfo;

	public class ActivateEventData extends EventData
	{
		public function ActivateEventData(xml:EventXML, currentTime:Number)
		{
			super(xml, currentTime);
		}

		override public function update(serverData:ResponseEventInfo):void
		{
			_isActivated = serverData.isActivated;
			super.update(serverData);
		}

		private var _isActivated:Boolean = false;
		public function set isActivated(value:Boolean):void
		{
			_isActivated = value;
			dispatchEvent(new Event(EventData.UPDATE));
		}
		public function get isActivated():Boolean {			return _isActivated;		}
	}
}
