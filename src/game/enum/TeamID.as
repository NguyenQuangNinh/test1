package game.enum 
{
	/**
	 * ...
	 * @author bangnd2
	 */
	public class TeamID 
	{
		public static const LEFT:int = 1;
		public static const RIGHT:int = 2;
		
		public static const ALL:Array = [LEFT, RIGHT];
		
		public static function exclude(teamID:int):int
		{
			var result:int;
			switch(teamID)
			{
				case LEFT:
					result = RIGHT;
					break;
				case RIGHT:
					result = LEFT;
					break;
			}
			return result;
		}
	}
}