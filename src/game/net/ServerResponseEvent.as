package game.net
{
	import flash.events.Event;
	import flash.utils.ByteArray;
	
	public class ServerResponseEvent extends Event
	{
		public var responseType:int;
		public var data:ByteArray;
		
		public function ServerResponseEvent(type:String, responseType:int, data:ByteArray, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.responseType = responseType;
			this.data = data;
		}
	}
}