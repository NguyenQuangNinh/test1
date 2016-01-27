package game.data.gamemode
{
	public class Team
	{
		private var players:Array = [];
		private var currentPlayerIndex:int = -1;
		
		public function Team()
		{
		}
		
		public function clear():void
		{
			players.splice(0);
		}
		
		public function addPlayer(player:Player):void
		{
			players.push(player);
		}
	}
}