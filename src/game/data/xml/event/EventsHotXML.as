/**
 * Created by NinhNQ on 9/19/2014.
 */
package game.data.xml.event
{

	import core.util.Enum;

	import game.data.xml.*;

	public class EventsHotXML extends XMLData
	{
		public function EventsHotXML()
		{

		}

		public var events:Array = [];

		override public function parseXML(xml:XML): void
		{
			ID = parseInt(xml.ServerID.toString());
			for each (var record:XML in xml.Events.Event)
			{
				var eventType:EventType = Enum.getEnum(EventType, parseInt(record.Type.toString())) as EventType;

				var event:EventXML = new eventType.classXML();
				event.parseXML(record);
				events.push(event);
			}

		}
	}
}
