package core.event
{
	import flash.events.Event;
	
	public class EventEx extends Event
	{
		public var data:Object;
		
		public function EventEx(type:String, data:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.data = data;
		}
		
		override public function clone():Event 
		{
			return new EventEx(type, data, bubbles, cancelable);
		}
	}
}