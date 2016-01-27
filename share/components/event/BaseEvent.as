package components.event 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author 
	 */
	public class BaseEvent extends Event 
	{
		public var action:String;
		public var data:Object;
		
		public function BaseEvent(type:String, data:Object = null, action:String = "", bubbles:Boolean=true, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			this.data = data;
			this.action = action;
		} 
		
		public override function clone():Event 
		{ 
			return new BaseEvent(type, data, action, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("BaseEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}