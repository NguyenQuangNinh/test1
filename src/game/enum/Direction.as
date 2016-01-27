package game.enum 
{

	import core.util.Enum;

	/**
	 * ...
	 * @author ...
	 */
	public class Direction extends Enum
	{
		public static const LEFT:Direction = new Direction(1, "left");
		public static const RIGHT:Direction =  new Direction(2,"right");
		public static const UP:Direction =  new Direction(3,"up");
		public static const DOWN:Direction =  new Direction(4,"down");

		public function Direction(ID:int, name:String)
		{
			super(ID,name);
		}
	}

}