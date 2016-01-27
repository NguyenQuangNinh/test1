package game.data.gamemode 
{

	/**
	 * ...
	 * @author bangnd2
	 */
	public class ModeDataPvP extends ModeData
	{
		public var gameMode:int = 0;
		public var newRank:int = 0;
		public var oldRank:int = 0;
		public var score:int = 0;
		public var eloScore:int = 0;
		public var honorScore:int = 0;
		public var isHost:Boolean = false;
		
		public function ModeDataPvP() 
		{
			
		}
	}
}