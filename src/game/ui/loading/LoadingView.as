package game.ui.loading
{
	import com.greensock.easing.Back;
	import com.greensock.TweenLite;
	import core.display.animation.Animator;
	import core.display.BitmapEx;
	import core.display.ViewBase;
	import core.Manager;
	import core.util.FontUtil;
	import core.util.MovieClipUtils;
	import core.util.Utility;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.text.TextField;
	import game.data.gamemode.ModeDataPVEHeroic;
	import game.data.model.Character;
	import game.data.gamemode.ModeData;
	import game.data.gamemode.ModeDataPvE;
	import game.data.vo.lobby.LobbyInfo;
	import game.data.vo.lobby.LobbyPlayerInfo;
	import game.data.xml.DataType;
	import game.data.xml.MissionXML;
	import game.data.xml.ModeConfigXML;
	import game.enum.Font;
	import game.enum.GameMode;
	import game.enum.TeamID;
	import game.Game;
	import game.ui.components.InteractiveAnim;
	import game.ui.lobby.LobbyPlayerInfoUI;
	import game.ui.ModuleID;
	//import preloader.PreloaderUI;
	
	/**
	 * ...
	 * @author bangnd2
	 */
	public class LoadingView extends ViewBase
	{
		private static const TEAM_1_START_FROM_X:int = 0;
		private static const TEAM_2_START_FROM_X:int = 850;
		private static const TEAM_START_FROM_Y:int = 50 + 50;
		
		private static const DISTANCE_X_PER_PLAYER:int = 30;
		private static const DISTANCE_Y_PER_PLAYER:int = 125;
		
		private static const MAX_PLAYERS_PER_TEAM:int = 3;
		
		public static const VS_START_FROM_X:int = 630;
		public static const VS_START_FROM_Y:int = 250;
			
		public var nameTf:TextField;
		public var timeoutTf:TextField;
		public var vsMov:MovieClip;
		
		private var enemyContainer:MovieClip;
		private static const ENEMY_CONTAINER_WIDTH:int = 318;
		private static const ENEMY_CONTAINER_HEIGHT:int = 404;
		private static const LINE_POS_Y:int = 300 - 25;
		
		//private var _info:LobbyInfo;
		private var _playerUIs:Array = [];
		private var _playerInfos:Array = [];
		
		//private static const 
		private var image:BitmapEx;
		private var characterObj:InteractiveAnim;
		
		public function LoadingView()
		{			
			//set fonts
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}			
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			FontUtil.setFont(nameTf, Font.ARIAL, true);
			FontUtil.setFont(timeoutTf, Font.ARIAL, true);

			prepareUI();
		}
		
		private function prepareUI():void 
		{
			enemyContainer = new MovieClip();
			enemyContainer.x = TEAM_2_START_FROM_X - TEAM_START_FROM_Y;
			enemyContainer.y = 93;
			
			addChild(enemyContainer);
			
			//prepare player UI
			for (var i:int = 0; i < MAX_PLAYERS_PER_TEAM * 2; i++) {
				var player:LobbyPlayerInfoUI = new LobbyPlayerInfoUI();			
				player.x = i < MAX_PLAYERS_PER_TEAM ? TEAM_1_START_FROM_X + DISTANCE_X_PER_PLAYER * (i % MAX_PLAYERS_PER_TEAM)
													: TEAM_2_START_FROM_X - DISTANCE_X_PER_PLAYER * (i % MAX_PLAYERS_PER_TEAM);
				player.y = TEAM_START_FROM_Y + DISTANCE_Y_PER_PLAYER * (i % MAX_PLAYERS_PER_TEAM);
				
				//Utility.log("player pos at index " + i + " is " + player.x + "//" + player.y);
				player.setType(LobbyPlayerInfoUI.TYPE_LOADING);
				player.visible = false;
				addChild(player);
				_playerUIs.push(player);	
				_playerInfos.push(null);
			}
		}

		public function updateTimeout(value:int):void
		{
			timeoutTf.text = value.toString();
		}

		public function initUI():void {
			hideAllPlayers();
			
			for (var j:int = 0; j < enemyContainer.numChildren; j++) {
				var child:DisplayObject = enemyContainer.getChildAt(j);
				if (child is InteractiveAnim)
					Manager.pool.push(child,InteractiveAnim);
			}
			MovieClipUtils.removeAllChildren(enemyContainer);
			
			var currentGameMode:GameMode = Game.database.userdata.getGameMode();	
			var currentModeData:ModeData = Game.database.userdata.getCurrentModeData();
			switch(currentGameMode) {
				case GameMode.PVE_HEROIC:
				case GameMode.PVE_WORLD_CAMPAIGN:
				case GameMode.PVE_GLOBAL_BOSS:
				case GameMode.PVE_SHOP_WARRIOR:
				case GameMode.HEROIC_TOWER:
				case GameMode.PVE_RESOURCE_WAR_NPC:					
					var player:LobbyPlayerInfo = new LobbyPlayerInfo();
					player.id = Game.database.userdata.userID;
					player.name = Game.database.userdata.playerName;
					player.characters = (currentModeData is ModeDataPVEHeroic) ? (currentModeData as ModeDataPVEHeroic).buildFormation() : Game.database.userdata.formation;
					player.teamIndex = TeamID.LEFT;
					updatePlayerInfo(1, player);
					
					var missionXML:MissionXML = Game.database.gamedata.getData(DataType.MISSION, (currentModeData as ModeDataPvE).missionID) as MissionXML;
					//depend on mode load resource adap
					if (missionXML) {
						nameTf.text = missionXML.name;
						
						if (currentGameMode == GameMode.PVE_WORLD_CAMPAIGN || currentGameMode == GameMode.PVE_RESOURCE_WAR_NPC) {
							image = new BitmapEx();								
							image.addEventListener(BitmapEx.LOADED, onBitmapLoadedHdl);
							image.load(missionXML.image);
							enemyContainer.addChild(image);
						}
						
						var character:Character = new Character(missionXML.getLastModID());
						characterObj = Manager.pool.pop(InteractiveAnim) as InteractiveAnim;
						characterObj.enableInteractive = false;
						characterObj.enableMoving(false);
						
						characterObj.addEventListener(Animator.LOADED, onAnimatorLoadedHdl);
						characterObj.loadAnim(character ? character.xmlData.animURLs[character.sex] : "");
						characterObj.direction = InteractiveAnim.LEFT;
						enemyContainer.addChild(characterObj);						
					}						
					break;
				case GameMode.PVP_1vs1_AI:
				case GameMode.PVP_1vs1_MM:
				case GameMode.PVP_1vs1_FREE:
				case GameMode.PVP_RESOURCE_WAR_PVP:
				case GameMode.PVE_EXPRESS_WAR_PVP:
					var modeXML:ModeConfigXML = Game.database.gamedata.getData(DataType.MODE_CONFIG, currentGameMode.ID) as ModeConfigXML;
					nameTf.text = modeXML ? modeXML.name : "";					
					var players:Array = Game.database.userdata.lobbyPlayers;
					for (var i:int = 0; i < players.length; i++) {
						player = players[i];
						updatePlayerInfo(player.teamIndex == 1 ? 1 : 4, player);
					}
					break;
				case GameMode.PVP_3vs3_FREE:
				case GameMode.PVP_3vs3_MM:	
				case GameMode.PVP_2vs2_MM:
					modeXML = Game.database.gamedata.getData(DataType.MODE_CONFIG, currentGameMode.ID) as ModeConfigXML;
					nameTf.text = modeXML ? modeXML.name : "";						
					players = Game.database.userdata.lobbyPlayers;
					for (i = 0; i < players.length; i++) {
						player = players[i];
						updatePlayerInfo((player.teamIndex - 1)* MAX_PLAYERS_PER_TEAM + player.index, player);
					}						
					break;
			}
			//Utility.log("set title loading name is " + nameTf.text);
		}
		
		private function onAnimatorLoadedHdl(e:Event):void 
		{
			characterObj.x = (ENEMY_CONTAINER_WIDTH - characterObj.width) / 2 + characterObj.width / 2;
			characterObj.y = LINE_POS_Y;


			/*var rectangle:Shape = new Shape(); // initializing the variable named rectangle
			rectangle.graphics.beginFill(0x00FF00); // choosing the colour for the fill, here it is red
			rectangle.graphics.drawRect(0,0, characterObj.width, characterObj.height); // (x spacing, y spacing, width, height)
			rectangle.graphics.endFill(); // not always needed but I like to put it in to end the fill
			rectangle.alpha = 0.3;
			rectangle.x = 0;
			rectangle.y = 0;
			enemyContainer.addChild(rectangle);*/
			
			//Utility.log("anim pos is " + characterObj.x + " // " + characterObj.y + " rect " + characterObj.width + " == " + characterObj.height);
		}
		
		private function onBitmapLoadedHdl(e:Event):void 
		{
			enemyContainer.x = 800;
			enemyContainer.y = 93;
		}
		
		private function hideAllPlayers():void 
		{
			for each(var player:LobbyPlayerInfoUI in _playerUIs) {
				player.visible = false;
			}
		}
		
		private function updatePlayerInfo(index: int, data:LobbyPlayerInfo):void {			
			if (index < 0 || index > MAX_PLAYERS_PER_TEAM * 2) {
				//Utility.log(" can not update index out of range ");
			}else {
				var player:LobbyPlayerInfoUI = _playerUIs[index];
				player.updateInfo(data ? data: null, index < MAX_PLAYERS_PER_TEAM ? false : true);
				_playerInfos[index] = data;
				player.visible = data != null;				
			}
		}
		
		public function updatePercent(data:Array): void {
			for (var i:int = 0; i < data.length; i++) {
				for (var j:int = 0; j < _playerInfos.length; j++ ) {
					var player:LobbyPlayerInfo = _playerInfos[j];
					if (player && player.id == data[i].ID) {
						(_playerUIs[j] as LobbyPlayerInfoUI).updatePercent(data[i].percent);
					}
				}
			}
		}
		
		public function transitionToInGame():void {
			vsMov.x = VS_START_FROM_X;
			vsMov.y = VS_START_FROM_Y;
			vsMov.visible = true;
			vsMov.alpha = 0.5;
			vsMov.scaleX = vsMov.scaleY = 0.1;					
			TweenLite.to(vsMov, 1, { scaleX:1, scaleY:1, alpha: 1, ease:Back.easeOut,

				onComplete:function():void {
					//Manager.display.to(ModuleID.INGAME);
					dispatchEvent(new Event(Event.COMPLETE));
					vsMov.visible = false;
				}
			});
		}
	}
}