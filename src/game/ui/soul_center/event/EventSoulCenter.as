package game.ui.soul_center.event 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author anhtinh
	 */
	public class EventSoulCenter extends Event 
	{
		public static const HIDE_POPUP : String = "hidePopup";
		public static const NORMAL_DIVINE : String = "normalDivine";
		public static const COMPLETE_EFFECT_DIVINE:String = "completeEffectDivine";
		public static const AUTO_DIVINE : String = "autoDivine";
		public static const STOP_AUTO_DIVINE : String = "stopAutoDivine";
		public static const SELL_SOUL : String = "sellSoul";
		public static const SELL_FAST_SOUL : String = "sellFastSoul";
		public static const COLLECT_SOUL : String = "collectSoul";
		public static const COLLECT_FAST_SOUL : String = "collectFastSoul";
		
		public static const EQUIP_ATTACH_SOUL : String = "equip_attach_soul";
		public static const EQUIP_MERGE_SOUL:String = "equip_merge_soul";
		
		public static const SWAP_SOUL_EQUIP_ATTACH : String = "swap_soul_equip_attach";
		public static const SWAP_SOUL_EQUIP_MERGE:String = "swap_soul_equip_merge";
		public static const SWAP_SOUL_INVENTORY : String = "swap_soul_inventory";
		public static const UPGRADE_SOUL : String = "upgrade_soul";
		
		public static const LOCK_MERGE_SOUL:String = "lock_soul";
		public static const SORT_SOUL:String = "sort_soul";
		public static const AUTO_INSERT_SOUL_RECIPE:String = "auto_insert_soul_recipe";
		public static const ACTION_MERGE_SOUL:String = "action_merge_soul";
		
		public var data : Object
		
		public function EventSoulCenter(type:String, data:Object=null, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			this.data = data;
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new EventSoulCenter(type, data, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("EventSoulCenter", "type", "data", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}