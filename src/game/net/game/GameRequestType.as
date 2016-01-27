package game.net.game
{
	import game.net.RequestPacket;
	
	public class GameRequestType
	{
		public static const CAST_SKILL	:int = 1;
		public static const INIT_PLAYER	:int = 2;
		public static const READY_GAME_SERVER:int = 3;
		public static const NEXT_WAVE	:int = 4;
	}
}