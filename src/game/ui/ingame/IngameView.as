package game.ui.ingame
{
	import com.greensock.TweenMax;
	import game.ui.ingame.replay.GameReplayManager;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.ui.Keyboard;
	import flash.utils.setTimeout;
	
	import core.Manager;
	import core.display.ViewBase;
	import core.display.animation.Animator;
	import core.display.layer.Layer;
	import core.display.layer.LayerManager;
	import core.event.EventEx;
	import core.sound.SoundManager;
	import core.util.Enum;
	import core.util.FontUtil;
	import core.util.Utility;
	
	import game.Game;
	import game.data.gamemode.ModeDataPVEHeroic;
	import game.data.gamemode.ModeDataPvE;
	import game.data.model.Character;
	import game.data.model.ModeConfigGlobalBoss;
	import game.data.vo.chat.ChatType;
	import game.data.vo.skill.Skill;
	import game.data.xml.DataType;
	import game.data.xml.SkillXML;
	import game.data.xml.SoundXML;
	import game.enum.FlowActionEnum;
	import game.enum.Font;
	import game.enum.GameConfigID;
	import game.enum.GameMode;
	import game.enum.SkillTargetType;
	import game.enum.SkillType;
	import game.enum.SoundID;
	import game.enum.TeamID;
	import game.enum.WorldMode;
	import game.flow.FlowManager;
	import game.net.BoolRequestPacket;
	import game.net.ByteResponsePacket;
	import game.net.IntRequestPacket;
	import game.net.RequestPacket;
	import game.net.ResponsePacket;
	import game.net.Server;
	import game.net.game.GameRequestType;
	import game.net.game.GameResponseType;
	import game.net.game.request.RequestCastSkill;
	import game.net.game.response.ResponseIngame;
	import game.net.lobby.LobbyRequestType;
	import game.ui.ModuleID;
	import game.ui.chat.ChatEvent;
	import game.ui.chat.ChatModule;
	import game.ui.chat.ChatView;
	import game.ui.components.CharacterAvatar;
	import game.ui.dialog.DialogID;
	import game.ui.hud.HUDView;
	import game.ui.hud.gui.HUDButton;
	import game.ui.hud.gui.SoundButton;
	import game.ui.ingame.pvp.Team;
	import game.ui.ingame.pvp.WorldTutorial;
	import game.ui.tooltip.TooltipEvent;
	import game.ui.tooltip.TooltipID;
	import game.ui.tutorial.TutorialEvent;
	
	public class IngameView extends ViewBase
	{
		public var saveBtn:SimpleButton;
		public var btnExit:SimpleButton;
		public var btnChatOn:SimpleButton;
		public var btnChatOff:SimpleButton;
		public var msgChatTf:TextField;
		
		public var movWorldContainer:MovieClip;
		
		protected var worlds:Array;
		protected var formation:Array = [];
		protected var avatarsContainer:Sprite;
		protected var animCountdown:Animator;
		protected var skillTarget:SkillTarget;
		protected var endGameView:EndgameView;
		protected var gameMode:GameMode;
		
		protected var teams:Array = [];
		
		public function IngameView()
		{
			worlds = [];
			var worldModes:Array = Enum.getAll(WorldMode);
			for each (var worldMode:WorldMode in worldModes)
			{
				worlds[worldMode.ID] = new worldMode.worldClass();
			}
			
			teams = [];
			for each (var teamID:int in TeamID.ALL)
			{
				teams[teamID] = new Team();
				teams[teamID].teamID = teamID;
			}
		
			animCountdown = new Animator();
			animCountdown.setCacheEnabled(false);
			animCountdown.x = 650;
			animCountdown.y = 325;
			animCountdown.load("resource/anim/ui/ui_tancong.banim");
			animCountdown.stop();
			animCountdown.visible = false;
			addChild(animCountdown);
			
			skillTarget = new SkillTarget();
			skillTarget.visible = false;
			skillTarget.mouseEnabled = false;
			skillTarget.y = World.GROUND_ZERO - 26;
			addChild(skillTarget);
			
			avatarsContainer = new Sprite();
			avatarsContainer.y = 528;
			avatarsContainer.x = 295;
			addChild(avatarsContainer);
			
			endGameView = new EndgameView();
			addChild(endGameView);
			endGameView.visible = false;
			endGameView.addEventListener(EndgameView.END_GAME_REQUEST, onEndGameRequestHdl);
			
			btnChatOff.visible = false;
			
			initEventHandlers();
			
			FontUtil.setFont(msgChatTf, Font.ARIAL, false);
			msgChatTf.mouseEnabled = false;
			msgChatTf.text = "";
			
			msgChatTf.visible = true;
		}
		
		public function updateMessage(msg:String):void
		{
			msgChatTf.text = msg;
		}
		
		private function initEventHandlers():void
		{
			addEventListener(MouseEvent.CLICK, onClicked);
			addEventListener(CharacterAvatar.USE_SKILL, onUseSkill);
			addEventListener(World.CREATE_CHARACTER, onCreateCharacter);
			addEventListener(World.DESTROY_CHARACTER, onDestroyCharacter);
			addEventListener(World.CHANGE_WAVE, onChangeWave);
			addEventListener(World.START_COUNTDOWN, onPlayCountdown);
			addEventListener(World.SHOW_RESULT, onShowResult);
			addEventListener(World.SHOW_REPLAY_BTN, onShowReplayBtn);
			addEventListener(World.CAST_SKILL, onCastSkill);
			addEventListener(World.RELEASE_SKILL, onReleaseSkill);
			addEventListener(CharacterAvatar.FOCUS_IN, onAvatarFocusIn);
			addEventListener(CharacterAvatar.FOCUS_OUT, onAvatarFocusOut);
			if (saveBtn) saveBtn.addEventListener(MouseEvent.CLICK, saveBtnHdl);
		}
		
		private function saveBtnHdl(e:MouseEvent):void 
		{
			
		}
		
		protected function onCastSkill(event:Event):void
		{
			for each(var avatar:CharacterAvatar in formation)
			{
				avatar.skillSlot.pauseCooldown();
			}
		}
		
		protected function onClicked(event:MouseEvent):void
		{
			switch (event.target)
			{
				case btnExit: 
					exit();
					break;
				case btnChatOn: 
					toggleChat(true);
					break;
				case btnChatOff: 
					toggleChat(false);
					break;
			}
		}
		
		protected function toggleChat(visible:Boolean):void
		{
			btnChatOn.visible  = !visible;
			btnChatOff.visible =  visible;
			var chatModule:ChatModule = Manager.module.getModuleByID(ModuleID.CHAT) as ChatModule;
			if (chatModule) {
				if (Manager.display.checkVisible(ModuleID.CHAT)) {
					if (chatModule.baseView) {
						if (ChatView(chatModule.baseView).isMinimize == false) {
							ChatView(chatModule.baseView).isMinimize = true;
							return;
						}
					}
					Manager.display.hideModule(ModuleID.CHAT);
				} else {
					Manager.display.showModule(ModuleID.CHAT, new Point(890, 140), LayerManager.LAYER_SCREEN_TOP, "top_left", Layer.NONE);	
				}
			}
		}
		
		protected function setChatVisible(visible:Boolean):void
		{
			btnChatOn.visible  = !visible;
			btnChatOff.visible =  visible;
			var chatModule:ChatModule = Manager.module.getModuleByID(ModuleID.CHAT) as ChatModule;
			if (chatModule) {
				if (!visible) // hide
				{
					if (chatModule.baseView) 
					{
						if (ChatView(chatModule.baseView).isMinimize == false) {
							ChatView(chatModule.baseView).isMinimize = true;
							return;
						}
					}
					Manager.display.hideModule(ModuleID.CHAT);
				} else {
					Manager.display.showModule(ModuleID.CHAT, new Point(890, 140), LayerManager.LAYER_SCREEN_TOP, "top_left", Layer.NONE);	
				}
			}
		}
		
		private function onAvatarFocusIn(e:Event):void
		{
			var avatar:CharacterAvatar = CharacterAvatar(e.target);
			if (avatar.getData() != null)
			{
				getCurrentWorld().focusCharacter(avatar.getData().ID);
				
				if (avatar.skillSlot != null && avatar.skillSlot.getData() != null)
				{
					var skillData:Skill = avatar.skillSlot.getData();
					var skillXmlData:SkillXML = skillData.xmlData;
					if (skillXmlData != null)
					{
						//An - hien tooltips cua skill
						dispatchEvent(new EventEx(TooltipEvent.SHOW_TOOLTIP, { type: TooltipID.SIMPLE, value: skillXmlData.inGameDesc }, true));
					}
				}
			}
		}
		
		private function onAvatarFocusOut(e:Event):void
		{
			var avatar:CharacterAvatar = CharacterAvatar(e.target);
			if (avatar.getData() != null)
			{
				getCurrentWorld().infocusCharacter(avatar.getData().ID);
				
				//An - hien tooltips cua skill
				dispatchEvent(new EventEx(TooltipEvent.HIDE_TOOLTIP, null, true));
			}
		}
		
		private function onReleaseSkill(e:EventEx):void
		{
			var character:CharacterObject = e.data as CharacterObject;
			var globalCooldown:Number = Number(Game.database.gamedata.getConfigData(GameConfigID.GLOBAL_SKILL_COOLDOWN))/1000;
			for each(var avatar:CharacterAvatar in formation)
			{
				avatar.skillSlot.resumeCooldown();
				if (character.teamID == Game.database.userdata.getCurrentModeData().teamID)
				{
					if(avatar.skillSlot.getData() == null) continue;
					var skillXML:SkillXML = avatar.skillSlot.getData().xmlData;
					if(avatar.getData() == character)
					{
						avatar.skillSlot.cooldown(Math.max(globalCooldown, skillXML.cooldown));
					}
					else
					{
						if(avatar.skillSlot.isCoolingDown() == false || avatar.skillSlot.getRemainCooldown() < globalCooldown)
						{
							avatar.skillSlot.cooldown(globalCooldown);
						}
					}
				}
			}
		}
		
		private function onShowResult(e:Event):void
		{
			avatarsContainer.visible = false;
			//if(endGameView.isInit() == false) endGameView.initAnim();
			endGameView.visible = true;
			endGameView.processTransIn(gameMode);
		}
		
		private function onShowReplayBtn(e:Event):void
		{
			//if(endGameView.isInit() == false) endGameView.initAnim();
			endGameView.showReplayBtn();
		}
		
		private function onPlayCountdown(e:Event):void
		{
			animCountdown.visible = true;
			animCountdown.play(0, 1);
			for each (var teamID:int in TeamID.ALL)
			{
				Team(teams[teamID]).updateHPBar();
			}
			setTimeout(onAnimCountdownComplete, 1455);
		}
		
		private function onAnimCountdownComplete():void
		{
			animCountdown.visible = false;
			getCurrentWorld().skillEnabled = true;
			Game.network.game.sendPacket(new RequestPacket(GameRequestType.NEXT_WAVE));
			if (getCurrentWorld() is WorldTutorial && Game.database.userdata.isFirstTutorial == true)
			{
				WorldTutorial(getCurrentWorld()).animCountdownComplete();
			}
		}
		
		protected function onChangeWave(event:EventEx):void
		{
			var teamID:int = event.data as int;
			Team(teams[teamID]).reset();
			for each(var avatar:CharacterAvatar in formation)
			{
				if(avatar.skillSlot.isCoolingDown()) 
				{
					avatar.skillSlot.resetCooldown();
				}
			}
		}
		
		private function onCreateCharacter(e:EventEx):void
		{
			var character:CharacterObject = e.data as CharacterObject;
			if (character.teamID == Game.database.userdata.getCurrentModeData().teamID)
			{
				var avatar:CharacterAvatar = Manager.pool.pop(CharacterAvatar) as CharacterAvatar;
				avatar.x = character.formationIndex * (avatar.width + 5);
				avatar.skillSlot.setHotkey(character.formationIndex + 1);
				avatar.setData(character);
				formation[character.formationIndex] = avatar;
				avatarsContainer.addChild(avatar);
			}
			
			Team(teams[character.teamID]).addCharacter(character);
		}
		
		private function onDestroyCharacter(e:EventEx):void
		{
			var character:CharacterObject = e.data as CharacterObject;
			if (character.teamID == Game.database.userdata.getCurrentModeData().teamID)
			{
				var avatar:CharacterAvatar = formation[character.formationIndex];
				if (avatar != null)
				{
					TweenMax.to(avatar, 0, {colorMatrixFilter: {saturation: 0}});
				}
			}
		}
		
		private function onUseSkill(e:Event):void
		{
			if (getCurrentWorld().skillEnabled)
			{
				useSkill(formation.indexOf(e.target));
			}
			else
			{
				Utility.log("skill disabled");
			}
		}
		
		private function useSkill(avatarIndex:int):void
		{
			Utility.log("use skill");
			var avatar:CharacterAvatar = formation[avatarIndex] as CharacterAvatar;
			if (avatar == null || avatar.skillSlot.isUsable() == false)
			{
				return;
			}
				
			var character:Character = avatar.getData().getData();
			//this skill 1 not true, should be skill actived and equiped
			var skillActiveEquiped:Skill;
			if (character && character.skills)
			{
				for each (var skill:Skill in character.skills)
				{
					if (skill && skill.xmlData && skill.xmlData.type == SkillType.ACTIVE && skill.isEquipped)
					{
						skillActiveEquiped = skill;
						break;
					}
				}
			}
			
			if (character != null && skillActiveEquiped != null)
			{
				var skillXML:SkillXML = skillActiveEquiped.xmlData;
				if (skillXML != null)
				{
					switch (skillXML.targetType)
					{
						case SkillTargetType.NONE: 
							castSkill(avatar.getData().ID, skillXML.ID, 0);
							break;
						case SkillTargetType.POINT: 
							skillTarget.visible = true;
							skillTarget.objectID = avatar.getData().ID;
							skillTarget.setXMLData(skillXML);
							skillTarget.x = Manager.display.getMouseX() - (skillTarget.width >> 1);
							skillTarget.y = World.GROUND_ZERO - skillTarget.getHalfHeight();
							break;
					}
				}
				
				dispatchEvent(new EventEx(TutorialEvent.EVENT, { type:TutorialEvent.USE_SKILL }, true ));
			}
		}
		
		private function castSkill(objectID:int, skillID:int, target:int):void
		{
			var packet:RequestCastSkill = new RequestCastSkill();
			packet.objectID = objectID;
			packet.skillID = skillID;
			packet.target = target;
			Utility.log("request cast skill, objectID: " + packet.objectID + ", skill: " + packet.skillID + " target: " + target);
			Game.network.game.sendPacket(packet);
		}
		
		private function onEndGameRequestHdl(e:EventEx):void
		{
			switch (e.data)
			{
				case EndgameView.PLAY_AGAIN: 
					handlePlayAgain();
					break;
				case EndgameView.PLAY_CONTINUE: 
					handleContinue();
					break;
			}
		}
		
		private function handlePlayAgain():void
		{
			Game.network.game.disconnect();
			switch (Game.database.userdata.getGameMode())
			{
				case GameMode.PVE_HEROIC: 
					Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.HEROIC_START_GAME,
														ModeDataPvE(Game.database.userdata.getModeData(GameMode.PVE_HEROIC)).missionID));
					break;
				
				default: 
					Game.flow.doAction(FlowActionEnum.START_LOBBY);
					break;
			}
		}
		
		private function handleContinue():void
		{
			Game.network.game.disconnect();
			switch (Game.database.userdata.getGameMode())
			{
				case GameMode.PVE_HEROIC: 
				case GameMode.PVP_1vs1_FREE:
				case GameMode.PVP_3vs3_FREE:
				case GameMode.PVP_3vs3_MM:
					Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.END_GAME_CONTINUE,
														ModeDataPVEHeroic(Game.database.userdata.getModeData(GameMode.PVE_HEROIC)).caveID));
					break;
				case GameMode.PVP_2vs2_MM:
					Manager.display.to(ModuleID.HOME);
					break;
				default: 
					if (!GameReplayManager.getInstance().isReplaying)
					{
						dispatchEvent(new EventEx(TutorialEvent.EVENT, { type: TutorialEvent.GET_REWARD }, true));
						Game.flow.doAction(FlowActionEnum.LEAVE_GAME);
					}
					else 
					{
						Game.flow.doAction(FlowActionEnum.GAME_END_REPLAY);
					}
					break;
			}
			Manager.tutorial.onTriggerCondition();
		}
		
		private function exit():void
		{
			Utility.log("on exit game click ... ");
			switch(Game.database.userdata.getGameMode()) {
				case GameMode.PVE_GLOBAL_BOSS:
					var missionID:int = ModeDataPvE(Game.database.userdata.getCurrentModeData()).missionID;
					Game.database.userdata.globalBossData.setReviveCountDown(Game.database.gamedata.getGlobalBossConfig().defaultReviveTime);
					Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.GLOBAL_BOSS_LEAVE_GAME, missionID));
					Game.network.lobby.sendPacket(new IntRequestPacket(LobbyRequestType.GLOBAL_BOSS_START_REVIVE_COUNT_DOWN, missionID));
					break;
			}
			
			//Game.database.userdata.getCurrentModeData().backModuleID  = null;
			if (!GameReplayManager.getInstance().isReplaying) 
			{
				Game.network.game.disconnect();
				Game.flow.doAction(FlowActionEnum.LEAVE_GAME);
			}
			else Game.flow.doAction(FlowActionEnum.GAME_END_REPLAY);
		}
		
		override public function transitionIn():void
		{
			Utility.log( "IngameView.transitionIn : " + transitionIn );
			Manager.resource.cleanAnimRef();
			
			super.transitionIn();
			setChatVisible(false);
			//add sound button
			var hudView:HUDView = Manager.module.getModuleByID(ModuleID.HUD).baseView as HUDView;
			var soundBtn:HUDButton = hudView ? hudView.getSoundButton() : null;
			if (soundBtn) {
				soundBtn.x = 1207;
				soundBtn.y = 55;
				soundBtn.addEventListener(SoundButton.SOUND_TOOGLE, onToogleSoundHdl);
				addChild(soundBtn);
			}
			
			reset();
			
			avatarsContainer.visible = true;
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			addEventListener(MouseEvent.CLICK, onMouseClick);
			stage.focus = this;
			
			Game.network.game.addEventListener(Server.SERVER_DATA, onGameServerData);
			Game.flow.addEventListener(FlowManager.ACTION_COMPLETED, onFlowActionCompletedHdl);

			btnExit.visible = false;
			btnExit.mouseEnabled = false;

			setGameMode(Game.database.userdata.getGameMode());
			getCurrentWorld().init();
			getCurrentWorld().start();
			
			if (Game.database.userdata.getGameMode() != GameMode.PVE_TUTORIAL && !GameReplayManager.getInstance().isReplaying) 
			{
				Game.network.lobby.sendPacket(new BoolRequestPacket(LobbyRequestType.GAME_READY, true));	
			}
			
			//btnExit.visible = !GameReplayManager.getInstance().isReplaying;
			btnChatOn.visible = !GameReplayManager.getInstance().isReplaying;
			btnChatOff.visible = !GameReplayManager.getInstance().isReplaying;
			
			onToogleSoundHdl();
		}
		
		private function onToogleSoundHdl(e:Event = null):void 
		{
			var hudView:HUDView = Manager.module.getModuleByID(ModuleID.HUD).baseView as HUDView;
			var soundBtn:HUDButton = hudView ? hudView.getSoundButton() : null;
			var soundXML:SoundXML = Game.database.gamedata.getData(DataType.SOUND, SoundID.BG_MUSIC_IN_GAME.ID) as SoundXML;
			if (soundBtn) {
				if (soundBtn.isSelected)
					SoundManager.addOrPlaySound(SoundID.BG_MUSIC_IN_GAME.ID.toString(), soundXML.src, 999, true);	
				else 
					SoundManager.stopSoundByID(SoundID.BG_MUSIC_IN_GAME.ID.toString());
			}
		}
		
		override public function transitionOut():void
		{
			super.transitionOut();
			dispatchEvent(new EventEx(ChatEvent.RESTORE_DOWN, null, true));
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			removeEventListener(MouseEvent.CLICK, onMouseClick);
			
			Game.network.game.removeEventListener(Server.SERVER_DATA, onGameServerData);
			Game.flow.removeEventListener(FlowManager.ACTION_COMPLETED, onFlowActionCompletedHdl);
			
			getCurrentWorld().stop();
			
			endGameView.reset();
			dispatchEvent(new EventEx(TutorialEvent.EVENT, { type:TutorialEvent.INGAME_TRANS_OUT }, true));
			
			SoundManager.stopSoundByID(SoundID.BG_MUSIC_IN_GAME.ID.toString());
			var hudView:HUDView = Manager.module.getModuleByID(ModuleID.HUD).baseView as HUDView;
			var soundBtn:HUDButton = hudView ? hudView.getSoundButton() : null;
			if (soundBtn) {
				soundBtn.removeEventListener(SoundButton.SOUND_TOOGLE, onToogleSoundHdl);

				var id:int = SoundID.randomOutgameMusicID();
				var soundXML:SoundXML = Game.database.gamedata.getData(DataType.SOUND, id) as SoundXML;

				if (soundBtn.isSelected)
					SoundManager.addOrPlaySound(id.toString(), soundXML.src, 999, true);
				else
					SoundManager.stopAllSound();
			}
			reset();
			Manager.resource.cleanAnimRef();
			Manager.module.getModuleByID(ModuleID.HUD).baseView.renderAnim();
			Manager.module.getModuleByID(ModuleID.TOP_BAR).baseView.renderAnim();
		}
		
		override protected function transitionOutComplete():void
		{
			if(!Game.database.userdata.isFirstTutorial) {
				Manager.display.showModule(ModuleID.CHAT, new Point(), LayerManager.LAYER_SCREEN_TOP);
			}
			super.transitionOutComplete();
		}
		
		private function onGameServerData(e:EventEx):void
		{
			var packet:ResponsePacket = e.data as ResponsePacket;
			switch (packet.type)
			{
				case GameResponseType.IN_GAME: 
					getCurrentWorld().processPacket(packet as ResponseIngame);
					break;
				case GameResponseType.PREPARE_NEXT_WAVE: 
					getCurrentWorld().prepareNextWave(ByteResponsePacket(packet).value);
					break;
				case GameResponseType.NEXT_WAVE_READY: 
					getCurrentWorld().nextWaveReady();
					break;
			}
		}
		
		public function setGameMode(mode:GameMode):void
		{
			this.gameMode = mode;
			if (movWorldContainer.numChildren > 0)
				movWorldContainer.removeChildAt(0);
			movWorldContainer.addChild(getCurrentWorld());
		}
		
		private function onFlowActionCompletedHdl(e:EventEx):void
		{
			switch (e.data.type)
			{
				case FlowActionEnum.END_GAME_RESULT:
					Utility.log("world: end game");
					Game.network.game.removeEventListener(Server.SERVER_DATA, onGameServerData);
					getCurrentWorld().endGame(e.data.result);
					
					break;				
			}
		}
		
		private function onResponseStartGameErrorCode(value:int):void
		{
			switch (value)
			{
				case 5: 
					Manager.display.showDialog(DialogID.HEAL_AP, onHealAPOKHdl, null, null, Layer.BLOCK_BLACK);
					break;
			}
		}
		
		private function onHealAPOKHdl(data:Object):void
		{
			Manager.display.to(ModuleID.HOME);
			Manager.display.showPopup(ModuleID.HEAL_AP, Layer.BLOCK_BLACK);
		}
		
		private function onKeyDown(e:KeyboardEvent):void
		{
			if (GameReplayManager.getInstance().isReplaying || !stage) return;
			switch (e.keyCode)
			{
				case Keyboard.NUMBER_1: 
				case Keyboard.NUMBER_2: 
				case Keyboard.NUMBER_3: 
				case Keyboard.NUMBER_4: 
				case Keyboard.NUMBER_5: 
				case Keyboard.NUMBER_6: 
				case Keyboard.NUMBER_7: 
				case Keyboard.NUMBER_8: 
					if (getCurrentWorld().skillEnabled)
						useSkill(e.keyCode - Keyboard.NUMBER_1);
					break;
			}
		}
		
		private function onMouseMove(e:MouseEvent):void
		{
			if (GameReplayManager.getInstance().isReplaying || !stage) return;
			if (skillTarget.visible)
			{
				skillTarget.x = Manager.display.getMouseX() - (skillTarget.width >> 1);
			}
		}
		
		private function onMouseClick(e:MouseEvent):void
		{
			if (GameReplayManager.getInstance().isReplaying || !stage) return;
			stage.focus = this;
			if (skillTarget.visible)
			{
				skillTarget.visible = false;
				castSkill(skillTarget.objectID, skillTarget.getXMLData().ID, Manager.display.getMouseX());
			}
		}
		
		public function reset():void
		{
			for each (var world:World in worlds)
			{
				world.reset();
			}
			
			animCountdown.stop();
			animCountdown.visible = false;
			
			skillTarget.visible = false;
			
			clearAvatars();
			
			for each (var teamID:int in TeamID.ALL)
			{
				Team(teams[teamID]).reset();
			}
		}
		
		protected function clearAvatars():void {
			var i:int;
			var length:int;
			var avatar:CharacterAvatar;
			for (i = 0, length = formation.length; i < length; ++i)
			{
				avatar = formation[i];
				if (avatar != null)
				{
					avatarsContainer.removeChild(avatar);
					avatar.reset();
					Manager.pool.push(avatar, CharacterAvatar);
				}
			}
			formation.splice(0);
		}	
		
		public function getCurrentWorld():World
		{
			return worlds[gameMode.worldMode.ID];
		}

		//TUTORIAL
		public function showHintEndGame(content:String):void
		{
			endGameView.showHintButton(content);
		}
	}
}