package game.ui.heroic_tower
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	
	import core.Manager;
	import core.display.ViewBase;
	import core.display.animation.Animator;
	import core.display.layer.Layer;
	import core.display.layer.LayerManager;
	import core.event.EventEx;
	import core.util.FontUtil;
	import core.util.Utility;
	
	import game.Game;
	import game.data.gamemode.ModeDataHeroicTower;
	import game.data.model.Character;
	import game.data.vo.lobby.LobbyInfo;
	import game.data.xml.CharacterXML;
	import game.data.xml.DataType;
	import game.data.xml.MissionXML;
	import game.data.xml.ModeConfigXML;
	import game.data.xml.config.ChallengeCenterConfig;
	import game.data.xml.config.XMLConfig;
	import game.enum.CharacterAnimation;
	import game.enum.Direction;
	import game.enum.ErrorCode;
	import game.enum.FlowActionEnum;
	import game.enum.Font;
	import game.enum.GameMode;
	import game.enum.Sex;
	import game.flow.FlowManager;
	import game.net.RequestPacket;
	import game.net.ResponsePacket;
	import game.net.Server;
	import game.net.lobby.LobbyRequestType;
	import game.net.lobby.LobbyResponseType;
	import game.net.lobby.response.ResponseErrorCode;
	import game.ui.ModuleID;
	import game.ui.challenge_center.HeroicTowerData;
	import game.ui.components.ButtonBack;
	import game.ui.dialog.DialogID;
	import game.ui.dialog.dialogs.YesNo;
	import game.ui.tutorial.TutorialEvent;

	public class HeroicTowerView extends ViewBase
	{
		public var btnBackContainer:MovieClip;
		public var doorway:MovieClip;
		public var btnEnter:MovieClip;
		public var myCharactersContainer:MovieClip;
		public var enemyCharactersContainer:MovieClip;
		public var txtFloorName:TextField;
		public var itemIcon:MovieClip;
		
		private var btnBack:ButtonBack;
		private var characterAnimators:Array = [];
		private var animFight:Animator = new Animator();
		
		public function HeroicTowerView()
		{
			btnBack = new ButtonBack();
			btnBack.addEventListener(MouseEvent.CLICK, btnBack_onClicked);
			btnBackContainer.addChild(btnBack);
			
			btnEnter.addEventListener(MouseEvent.CLICK, btnEnter_onClicked);
			doorway.addChild(btnEnter);
			
			addChild(animFight);
			animFight.x = Game.WIDTH / 2;
			animFight.y = Game.HEIGHT / 2;
			animFight.load("resource/anim/ui/fx_tancong.banim");
			animFight.stop();
			animFight.visible = false;
			animFight.buttonMode = true;
			animFight.addEventListener(MouseEvent.CLICK, animFight_onClicked);
			animFight.addEventListener(Event.COMPLETE, animFight_onComplete);
			
			FontUtil.setFont(txtFloorName, Font.UVN_THANGVU, true);
		}
		
		protected function itemIcon_loaded(event:Event):void
		{
			itemIcon.x = -itemIcon.width / 2;
			itemIcon.y = -itemIcon.height / 2;
		}
		
		protected function animFight_onComplete(event:Event):void
		{
			animFight.mouseEnabled = true;
			animFight.visible = false;
			
			var modeData:ModeDataHeroicTower = Game.database.userdata.getModeData(GameMode.HEROIC_TOWER) as ModeDataHeroicTower;
			Utility.log("create room mode=HEROIC_TOWER, towerID=" + modeData.currentTower);
			var lobbyInfo:LobbyInfo = new LobbyInfo();
			lobbyInfo.mode = GameMode.HEROIC_TOWER;
			lobbyInfo.towerID = modeData.currentTower;
			lobbyInfo.backModule = ModuleID.HEROIC_TOWER;
			Game.flow.doAction(FlowActionEnum.CREATE_BASIC_LOBBY, lobbyInfo);
		}
		
		protected function animFight_onClicked(event:MouseEvent):void
		{
			var modeData:ModeDataHeroicTower = Game.database.userdata.getModeData(GameMode.HEROIC_TOWER) as ModeDataHeroicTower;
			if(modeData.isDead)
			{
				var modeConfig:ModeConfigXML = Game.database.gamedata.getData(DataType.MODE_CONFIG, XMLConfig.CHALLENGE_CENTER) as ModeConfigXML;
				var challengeCenterConfig:ChallengeCenterConfig = modeConfig.xmlConfig as ChallengeCenterConfig;
				Manager.display.showDialog(DialogID.HEROIC_TOWER, onConfirm, null, {quantity:challengeCenterConfig.extraTurnPrice}, Layer.BLOCK_BLACK);
			}
			else
			{
				enterBattle();
			}
		}
		
		protected function btnBack_onClicked(event:MouseEvent):void
		{
			//Manager.display.back();
			Manager.display.to(ModuleID.HOME);
		}
		
		protected function btnEnter_onClicked(event:MouseEvent):void
		{
			for each(var animator:Animator in characterAnimators)
			{
				if(animator.parent == myCharactersContainer) animator.play(CharacterAnimation.RUN);
			}
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		protected function onEnterFrame(event:Event):void
		{
			if(myCharactersContainer.x >= Game.WIDTH)
			{
				removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				var modeData:ModeDataHeroicTower = Game.database.userdata.getModeData(GameMode.HEROIC_TOWER) as ModeDataHeroicTower;
				modeData.nextFloorReady = false;
				Manager.display.to(ModuleID.HEROIC_TOWER);
			}
			else
			{
				myCharactersContainer.x += 10;
			}
		}
		
		private function onConfirm(data:Object):void
		{
			Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.HEROIC_TOWER_BUY_EXTRA_TURN));
		}
		
		/*protected function onActionComplete(event:EventEx):void
		{
			switch(event.data.type)
			{
				case FlowActionEnum.CREATE_LOBBY_SUCCESS:
					Game.network.lobby.sendPacket(new RequestPacket(LobbyRequestType.NOTIFY_JOIN_ROOM_READY));
					break;
				case FlowActionEnum.UPDATE_LOBBY_INFO_SUCCESS:
					Game.flow.doAction(FlowActionEnum.START_LOBBY);
					break;
				case FlowActionEnum.START_LOBBY_SUCCESS:
					Game.flow.doAction(FlowActionEnum.START_LOADING_RESOURCE);
					break;
			}
		}*/
		
		override public function transitionIn():void
		{
			super.transitionIn();
			
			//Game.flow.addEventListener(FlowManager.ACTION_COMPLETED, onActionComplete);
			Game.network.lobby.addEventListener(Server.SERVER_DATA, onLobbyServerData);
			
			var modeData:ModeDataHeroicTower = Game.database.userdata.getModeData(GameMode.HEROIC_TOWER) as ModeDataHeroicTower;
			var formation:Array = Game.database.userdata.formation;
			var character:Character;
			var animator:Animator;
			for(var i:int = 0; i < Game.MAX_CHARACTER; ++i)
			{
				character = formation[i];
				if(character == null) continue;
				animator = Manager.pool.pop(Animator) as Animator;
				animator.reset();
				animator.load(character.xmlData.animURLs[character.sex]);
				animator.play(CharacterAnimation.STAND);
				animator.x = i * 50;
				animator.y = 0;
				animator.scaleX = 1;
				characterAnimators.push(animator);
				myCharactersContainer.addChild(animator);
			}
			Utility.setGrayscale(myCharactersContainer, modeData.isDead);
			myCharactersContainer.x = 100;
			
			var towerData:HeroicTowerData = modeData.getCurrentTowerData();
			if(towerData.getCurrentFloor() > towerData.getXMLData().missionIDs.length)
			{
				doorway.visible = false;
				animFight.visible = false;
				
				var dialogData:Object = {};
				dialogData.message = "Đã đến đỉnh tháp, không thể tiếp tục chinh phục";
				dialogData.option = YesNo.YES;
				Manager.display.showDialog(DialogID.YES_NO, onDialogClose, null, dialogData);
			}
			else
			{
				if(modeData.nextFloorReady)
				{
					doorway.visible = true;
					animFight.visible = false;
				}
				else
				{
					doorway.visible = false;
					
					modeData.missionID = towerData.getCurrentMissionID();
					var missionXML:MissionXML = Game.database.gamedata.getData(DataType.MISSION, towerData.getCurrentMissionID()) as MissionXML;
					var characterXML:CharacterXML;
					Utility.log(missionXML.waves[0].toString());
					for(i = 0; i < Game.MAX_CHARACTER; ++i)
					{
						characterXML = Game.database.gamedata.getData(DataType.CHARACTER, missionXML.waves[0][i]) as CharacterXML;
						if(characterXML == null) continue;
						animator = Manager.pool.pop(Animator) as Animator;
						animator.reset();
						animator.load(characterXML.animURLs[Sex.FEMALE]);
						animator.play(CharacterAnimation.STAND);
						animator.scaleX = -1;
						animator.x = i * -50;
						animator.y = 0;
						characterAnimators.push(animator);
						enemyCharactersContainer.addChild(animator);
					}
					txtFloorName.text = missionXML.name.toLocaleUpperCase();
					animFight.visible = true;
					animFight.play(0);
				}
			}
			
			itemIcon.visible = modeData.itemActivated;
			
			Manager.display.showModule(ModuleID.HUD, new Point(), LayerManager.LAYER_HUD);
			Manager.display.showModule(ModuleID.TOP_BAR, new Point(), LayerManager.LAYER_HUD);
		}
		
		private function onDialogClose(data:Object):void
		{
			Manager.display.to(ModuleID.HOME);
		}
		
		protected function onLobbyServerData(event:EventEx):void
		{
			var packet:ResponsePacket = event.data as ResponsePacket;
			switch(packet.type)
			{
				case LobbyResponseType.ERROR_CODE:
				{
					onErrorCode(packet as ResponseErrorCode);
					break;
				}
			}
		}
		
		private function onErrorCode(packet:ResponseErrorCode):void
		{
			switch(packet.requestType)
			{
				case LobbyRequestType.HEROIC_TOWER_BUY_EXTRA_TURN:
					onBuyExtraTurnResult(packet.errorCode);
					break;
			}
		}
		
		private function onBuyExtraTurnResult(errorCode:int):void
		{
			Utility.log("heroic tower, buy extra turn, errorCode=" + errorCode);
			switch(errorCode)
			{
				case ErrorCode.SUCCESS:
					var modeData:ModeDataHeroicTower = Game.database.userdata.getModeData(GameMode.HEROIC_TOWER) as ModeDataHeroicTower;
					modeData.isDead = false;
					enterBattle();
					break;
				case ErrorCode.HEROIC_TOWER_BUY_EXTRA_TURN_NOT_ENOUGH_XU:
					Manager.display.showMessage("Không đủ vàng");
					break;
			}
		}
		
		private function enterBattle():void
		{
			animFight.mouseEnabled = false;
			animFight.play(1, 1);
			dispatchEvent(new EventEx(TutorialEvent.EVENT, {type: TutorialEvent.START_GAME}, true));
		}
		
		override public function transitionOut():void
		{
			super.transitionOut();
			
			//Game.flow.removeEventListener(FlowManager.ACTION_COMPLETED, onActionComplete);
			Game.network.lobby.removeEventListener(Server.SERVER_DATA, onLobbyServerData);
			
			for each(var animator:Animator in characterAnimators)
			{
				animator.parent.removeChild(animator);
				Manager.pool.push(animator, Animator);
			}
			characterAnimators.splice(0);
		}

		//TUTORIAL
		public function showHintButton():void
		{
			Game.hint.showHint(animFight, Direction.LEFT, animFight.x + animFight.width - 164, animFight.y + animFight.height/2 - 155, "Click Chuột");
		}
	}
}