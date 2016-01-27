package game.data.xml.event
{

	import core.util.Enum;

	import game.data.model.event.ActivateEventData;

	import game.data.model.event.EventData;
	import game.data.model.event.ExchangeEventData;

	public class EventType extends Enum
	{
		public static const CONSUME_XU:EventType = new EventType(0, "Event tích lũy tiêu xu", EventXML, EventData);
		public static const CHARGE_XU:EventType = new EventType(1, "Event tích lũy nạp xu", EventXML, EventData);
		public static const EXCHANGE:EventType = new EventType(2, "Event đổi vật phẩm tích lũy", ExchangeEventXML, ExchangeEventData);
		public static const ACTIVATE:EventType = new EventType(3, "Dùng vàng kích hoạt tích lũy", ActivateEventXML, ActivateEventData);

		public function EventType(ID:int, desc:String, classXML:Class, classData:Class):void
		{
			super(ID, desc);
			this.classXML = classXML;
			this.classData = classData;
		}

		public var classXML:Class;
		public var classData:Class;
	}
}