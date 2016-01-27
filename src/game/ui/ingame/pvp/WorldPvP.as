package game.ui.ingame.pvp 
{
	import flash.events.Event;
	
	import core.event.EventEx;
	
	import game.Game;
	import game.data.gamemode.ModeData;
	import game.data.vo.lobby.LobbyPlayerInfo;
	import game.data.xml.DataType;
	import game.data.xml.ModeConfigXML;
	import game.enum.GameMode;
	import game.enum.TeamID;
	import game.ui.ingame.CharacterObject;
	import game.ui.ingame.RewardItem;
	import game.ui.ingame.World;

	/**
	 * ...
	 * @author bangnd2
	 */
	public class WorldPvP extends World 
	{
		private var currentTeamMembers:Array = [];
		
		public function WorldPvP() 
		{
			
		}
		
		override public function reset():void 
		{
			super.reset();
			currentTeamMembers[TeamID.LEFT] = -1;
			currentTeamMembers[TeamID.RIGHT] = -1;
		}
		
		override public function init():void
		{
			var gameMode:GameMode = Game.database.userdata.getGameMode();
			var modeConfigXML:ModeConfigXML = Game.database.gamedata.getData(DataType.MODE_CONFIG, gameMode.ID) as ModeConfigXML;
			if(modeConfigXML != null) setBackground(modeConfigXML.backGroundID);
		}
		
		override public function endGame(result:Boolean):void 
		{
			super.endGame(result);
			showBlackCurtain();
			gameEnding = true;
			if (result) {
				reform(Game.database.userdata.getCurrentModeData().teamID);
			} else {
				reform(TeamID.exclude(Game.database.userdata.getCurrentModeData().teamID));
			}
		}
		
		override public function prepareNextWave(winTeamID:int):void
		{
			super.prepareNextWave(winTeamID);
			if(winTeamID == 0)
			{
				for each(var teamID:int in TeamID.ALL)
				{
					dispatchEvent(new EventEx(PLAYER_LOSE, {teamID:teamID, index:currentTeamMembers[teamID]}, true));
					++currentTeamMembers[teamID];
				}
			}
			else
			{
				var loserTeamID:int = TeamID.exclude(stateTeamID);
				dispatchEvent(new EventEx(PLAYER_LOSE, {teamID:loserTeamID, index:currentTeamMembers[loserTeamID]}, true));
				++currentTeamMembers[loserTeamID];
			}
		}
		
		override public function nextWaveReady():void
		{
			super.nextWaveReady();
			if(stateTeamID == 0)
			{
				var modedata:ModeData = Game.database.userdata.getCurrentModeData();
				createCharacters(modedata.teamID);
				summonCharacters(modedata.teamID);
			}
			else
			{
				reform(stateTeamID);
			} 
		}
		
		override protected function reformComplete():void 
		{
			if (gameEnding) {
				if(Game.database.userdata.getCurrentModeData().result) {
					showRewards(Game.database.userdata.getCurrentModeData().teamID);
					var rewardsLength:int = rewards.length;
					for each(var reward:RewardItem in rewards)
					{
						switch(Game.database.userdata.getCurrentModeData().teamID) {
							case TeamID.LEFT:
								var deltaX:int = (Game.WIDTH + rewardsLength * 120 - 20) / 2;
								reward.runTo(reward.x - deltaX, SCENARIO_SPEED);
								break;
							
							case TeamID.RIGHT:
								deltaX = ( - Game.WIDTH - rewardsLength * 120 - 20) / 2;
								reward.runTo(reward.x - deltaX, SCENARIO_SPEED);
								break;
						}
					}
				} else {
					dispatchEvent(new Event(World.SHOW_REPLAY_BTN, true));
				}
				
			} else {
				createCharacters(TeamID.exclude(stateTeamID));
			}
			rushCharacters(stateTeamID);
		}
		
		override protected function mapCharacterObject(character:CharacterObject):void
		{
			var lobbyPlayers:Array = Game.database.userdata.lobbyPlayers;
			for each(var lobbyPlayer:LobbyPlayerInfo in lobbyPlayers)
			{
				if(lobbyPlayer.teamIndex == character.teamID && lobbyPlayer.index == currentTeamMembers[character.teamID])
				{
					switch(character.teamID)
					{
						case TeamID.LEFT:
							character.setData(lobbyPlayer.characters[character.formationIndex]);
							break;
						case TeamID.RIGHT:
							character.setData(lobbyPlayer.characters[Game.MAX_CHARACTER - character.formationIndex - 1]);
							break;
					}
					//character.setData(lobbyPlayer.characters[character.formationIndex]);
				}
			}
		}
		
		override protected function getStartPosition(teamID:int):int
		{
			var result:int = 0;
			switch(teamID)
			{
				case TeamID.LEFT:
					result = 50;
					break;
				case TeamID.RIGHT:
					result = Game.WIDTH - FORMATION_WIDTH - 50;
					break;
			}
			return result;
		}
	}
}