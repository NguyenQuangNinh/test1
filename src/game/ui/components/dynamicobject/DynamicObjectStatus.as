package game.ui.components.dynamicobject 
{
	/**
	 * ...
	 * @author anhtinh
	 */
	public class DynamicObjectStatus 
	{
		public static const WALKING:uint = 0x1;
		public static const STANDING:uint = 0x10;
		public static const RUNNING:uint = 0x100;
		public static const WALKING_CLEAR:uint = ~WALKING;
		public static const STANDING_CLEAR:uint = ~STANDING;
		
	}

}