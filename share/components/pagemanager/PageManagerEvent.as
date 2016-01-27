package components.pagemanager
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author ...
	 */
	public class PageManagerEvent extends Event
	{
		public static var CHANGE_INDEX:String = "changeindex";
		public var index:int;
		public function PageManagerEvent(type:String) 
		{
			super(type);
		}
		
	}
	
}