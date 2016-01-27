package game.ui.home.event 
{
	import flash.events.Event;
	/**
	 * ...
	 * @author anhtinh
	 */
	public class EventHome extends Event 
	{
		
		public static const SHOW_CHANGE_FORMATION : String 	= "showChangeFormation";	
		public static const SHOW_POWER_TRANSFER : String	= "showPowerTransfer";
		public static const SHOW_UPGRADE_SKILL : String 	= "showUpgradeSkill";
		public static const SHOW_FORMATION_STYLE : String 	= "showFormationStyle";
		public static const SHOW_SHOP : String 				= "showShop";
		
		public static const SHOW_WORLD_MAP_POPUP : String = "showWorldMapPopup";			
		
		//public static const CHALLENGE_PVP : String = "challengePVP";	
		public static const SHOW_ARENA_MODE : String = "showArenaMode";
		public static const OPEN_INVENTORY : String = "openInventory";
		public static const OPEN_FORMATION_TYPE : String = "openFormationType";
		public static const OPEN_SOUL_CENTER : String = "openSoulCenter";
		static public const SHOW_QUEST_TRANSPORT:String = "showQuestTransport";
		
		public var data : Object;
		
		public function EventHome(type:String, data : Object = null, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			this.data = data;
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new EventHome(type, data, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("EventHome", "data", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}