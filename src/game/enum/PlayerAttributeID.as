package game.enum
{
	import core.util.Enum;
	
	public class PlayerAttributeID extends Enum
	{
		public static const BATTLE_POINT	:PlayerAttributeID = new PlayerAttributeID(1);
		public static const GOLD			:PlayerAttributeID = new PlayerAttributeID(2);
		public static const XU				:PlayerAttributeID = new PlayerAttributeID(3);
		
		public function PlayerAttributeID(ID:int, name:String="")
		{
			super(ID, name);
		}
	}
}