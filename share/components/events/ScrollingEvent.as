package com.vn.components.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author 
	 */
	public class ScrollingEvent extends Event 
	{
		
		public static var SCROLLING: String = "scrolling";
		
		public var percent:Number = 0;
		
		public function ScrollingEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new ScrollingEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("ScrollEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}