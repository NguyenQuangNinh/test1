package game.ui.ingame.pvp 
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import core.Manager;
	import core.display.animation.Animator;
	import core.event.EventEx;
	
	import game.Game;
	import game.data.gamemode.ModeDataPVEHeroic;
	import game.data.gamemode.ModeDataPvE;
	import game.data.model.Character;
	import game.data.vo.lobby.LobbyPlayerInfo;
	import game.data.xml.DataType;
	import game.data.xml.MissionXML;
	import game.enum.GameMode;
	import game.enum.ObjectLayer;
	import game.enum.TeamID;
	import game.ui.ingame.CharacterObject;
	import game.ui.ingame.RewardItem;
	import game.ui.ingame.World;
	

	/**
	 * ...
	 * @author bangnd2
	 */
	public class WorldPvE extends World 
	{
		private var currentWave	:int = -1;
		private var isOpenedAllRewards:Boolean;
		private var blackCurtain:Animator;
		
		public function WorldPvE() {
			blackCurtain = Manager.pool.pop(Animator) as Animator;
			blackCurtain.reset();
			blackCurtain.x = 705;
			blackCurtain.y = 345;
			blackCurtain.load("resource/anim/ui/ingame_fade.banim");
			blackCurtain.stop();
			blackCurtain.visible = false;
		}
		
		override public function reset():void 
		{
			super.reset();
			currentWave = -1;
			
			blackCurtain.visible = false;
		}
		
		override public function init():void
		{
			var modeData:ModeDataPvE = Game.database.userdata.getCurrentModeData() as ModeDataPvE;
			modeData.currentWave = 1;
			var missionXML:MissionXML = Game.database.gamedata.getData(DataType.MISSION, modeData.missionID) as MissionXML;
			if(missionXML != null)
			{
				setBackground(missionXML.backgroundID);
			}
		}
		
		override  protected function mapCharacterObject(character:CharacterObject):void
		{
			if(character.teamID == Game.database.userdata.getCurrentModeData().teamID)
			{
				switch(Game.database.userdata.getGameMode()) {
					case GameMode.PVE_HEROIC:
						var index:int = ModeDataPVEHeroic(Game.database.userdata.getModeData(GameMode.PVE_HEROIC)).formationIndex[character.formationIndex];
						var playerIndex:int = Math.floor(index / 2);
						for each (var lobbyPlayer:LobbyPlayerInfo in ModeDataPVEHeroic(Game.database.userdata.getModeData(GameMode.PVE_HEROIC)).getPlayers()) {
							if (lobbyPlayer && (lobbyPlayer.index == playerIndex)) {
								var sex:int = lobbyPlayer.charactersSex[index % 2];
								var characterData:Character = lobbyPlayer.characters[index % 2];
								characterData.sex = sex;
								character.setData(characterData);
							}
						}
						break;
						
					default:
						character.setData(Game.database.userdata.formation[character.formationIndex]);
						break;
				}
			}
		}
		
		override public function endGame(result:Boolean):void 
		{
			super.endGame(result);
			
			var layer:Sprite = objectLayers[ObjectLayer.REWARDS];
			if (layer != null)
			{
				layer.addChild(blackCurtain);
			}
			blackCurtain.visible = true;
			blackCurtain.addEventListener(Event.COMPLETE, onBlackCurtainCompleteHdl);
			blackCurtain.play(0, 1);
			
			if (result)
			{
				gameEnding = true;
				reform(TeamID.LEFT);
			}
			else {
				dispatchEvent(new Event(SHOW_RESULT, true));
			}
		}
		
		override public function nextWaveReady():void
		{
			super.nextWaveReady();
			if(stateTeamID == 0)
			{
				createCharacters(TeamID.LEFT);
				summonCharacters(TeamID.LEFT);
			}
			else
			{
				reform(TeamID.LEFT);
				var modeData:ModeDataPvE = Game.database.userdata.getCurrentModeData() as ModeDataPvE;
				modeData.currentWave++;
				dispatchEvent(new EventEx(CHANGE_WAVE, TeamID.RIGHT, true));
			}
		}
		
		override protected function reformComplete():void 
		{
			if (gameEnding)
			{
				showRewards(TeamID.LEFT);
				var rewardsLength:int = rewards.length;
				var deltaX:int = (Game.WIDTH + rewardsLength * 120 - 20) / 2
				for each(var reward:RewardItem in rewards)
				{
					reward.runTo(reward.x - deltaX, SCENARIO_SPEED);
				}
			}
			else
			{
				createCharacters(TeamID.RIGHT);
			}
			rushCharacters(TeamID.LEFT);
		}
		
		private function onBlackCurtainCompleteHdl(e:Event):void {
			blackCurtain.removeEventListener(Event.COMPLETE, onBlackCurtainCompleteHdl);
			blackCurtain.play(1, -1);
		}
		
		override protected function getStartPosition(teamID:int):int
		{
			var result:int = 0;
			switch(teamID)
			{
				case TeamID.LEFT:
					if(Game.database.userdata.getGameMode() == GameMode.PVE_WORLD_CAMPAIGN)	result = 250;
					else result = 50;
					break;
				case TeamID.RIGHT:
					result = Game.WIDTH - FORMATION_WIDTH - 10;
					break;
			}
			return result;
		}
	}

}