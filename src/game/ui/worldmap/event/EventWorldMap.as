package game.ui.worldmap.event 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author anhtinh
	 */
	public class EventWorldMap extends Event 
	{
		public static const EFFECT_OPEN_MAP_FINISH : String = "efectOpenMapFinish";	
		public static const ENTER_CAMPAIGN : String = "enterCampaign";	
		public static const HIDE_WORLD_MAP : String = "hideWorldMap";	
		public static const PLAY_MISSION : String = "playMission";
        public static const QUICK_FINISH:String = "quick_finish";
        public static const GET_CAMPAIGN_REWARD : String = "getCampaignReward";
        public var data : Object ;

		public function EventWorldMap(type:String, data : Object = null, bubbles:Boolean = false, cancelable:Boolean = false) 
		{ 
			this.data = data;
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new EventWorldMap(type, data, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("EventWorldMap", "data", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}