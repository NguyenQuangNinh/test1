package game.ui.ingame.pvp 
{
	import flash.display.MovieClip;
	
	import core.event.EventEx;
	
	import game.Game;
	import game.data.vo.lobby.LobbyPlayerInfo;
	import game.enum.GameMode;
	import game.enum.TeamID;
	import game.ui.ingame.IngameView;
	import game.ui.ingame.World;
	
	/**
	 * ...
	 * @author bangnd2
	 */
	public class IngamePVPView extends IngameView 
	{
		private static const MAX_PLAYER_PER_TEAM:int = 3;
		
		public var movPlayerTeam1:MovieClip;
		public var movPlayerTeam2:MovieClip;
		public var movRedHPBar:MovieClip;
		public var movBlueHPBar:MovieClip;
		
		private var playerTeams:Array;
		
		public function IngamePVPView():void
		{
			super();
			
			playerTeams = [];
			for each(var teamID:int in TeamID.ALL)
			{
				playerTeams[teamID] = new PlayerTeam();
			}
			movPlayerTeam1.addChild(playerTeams[TeamID.LEFT]);
			movPlayerTeam2.addChild(playerTeams[TeamID.RIGHT]);
			Team(teams[TeamID.LEFT]).hpBar = movRedHPBar;
			Team(teams[TeamID.RIGHT]).hpBar = movBlueHPBar;
			
			btnExit.visible = !(Game.database.userdata.getGameMode() == GameMode.PVE_TUTORIAL);
			
			addEventListener(World.PLAYER_LOSE, onPlayerLose);
		}
		
		override public function reset():void
		{
			for each(var teamID:int in TeamID.ALL)
			{
				PlayerTeam(playerTeams[teamID]).reset();
			}
			super.reset();
		}
		
		protected function onPlayerLose(event:EventEx):void
		{
			var playerTeam:PlayerTeam = playerTeams[event.data.teamID];
			if(playerTeam == null) return;
			switch(event.data.teamID)
			{
				case TeamID.LEFT:
					playerTeam.disable(event.data.index);
					break;
				case TeamID.RIGHT:
					playerTeam.disable(MAX_PLAYER_PER_TEAM - event.data.index - 1);
					break;
			}
			if(event.data.teamID == Game.database.userdata.getCurrentModeData().teamID) {
				clearAvatars();
			}
		}
		
		override public function transitionIn():void 
		{
			var lobbyPlayers:Array = Game.database.userdata.lobbyPlayers;
			setChatVisible(false);
			if(lobbyPlayers != null && lobbyPlayers.length > 2)
			{
				movPlayerTeam1.visible = true;
				movPlayerTeam2.visible = true;
				for each(var player:LobbyPlayerInfo in lobbyPlayers)
				{
					if(player == null) continue;
					var playerTeam:PlayerTeam = playerTeams[player.teamIndex];
					if(playerTeam == null) continue;
					switch(player.teamIndex)
					{
						case TeamID.LEFT:
							playerTeam.setPlayerLeader(player.index, player.getTeamLeader(), player.name);
							break;
						case TeamID.RIGHT:
							playerTeam.setPlayerLeader(MAX_PLAYER_PER_TEAM - player.index - 1, player.getTeamLeader(), player.name);
							break;
					}
				}
			}
			else
			{
				movPlayerTeam1.visible = false;
				movPlayerTeam2.visible = false;
			}
			super.transitionIn();
		}
	}
}