package game.enum 
{
	import core.util.Enum;
	import game.utility.UtilityUI;
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class FocusSignalType extends Enum
	{
		
		public static const SIGNAL_NEW:FocusSignalType = new FocusSignalType(1, "signal_new");
		public static const SIGNAL_COMPLETE:FocusSignalType = new FocusSignalType(2, "signal_complete");
		public static const SIGNAL_RED_ALERT:FocusSignalType = new FocusSignalType(3, "signal_red_alert");
		
		//public static const ALL:Array = [SIGNAL_COMPLETE, SIGNAL_NEW];
		
		public function FocusSignalType(ID:int, name:String = "") 
		{
			super(ID, name);
		}
		
	}

}