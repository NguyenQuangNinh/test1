package game.ui.ingame
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getTimer;
	
	import core.Manager;
	import core.display.animation.Animator;
	import core.display.pixmafont.PixmaText;
	import core.event.EventEx;
	import core.util.Utility;
	
	import game.Game;
	import game.data.gamemode.ModeData;
	import game.data.gamemode.ModeDataHeroicTower;
	import game.data.vo.item.ItemInfo;
	import game.data.xml.BackgroundXML;
	import game.data.xml.CharacterXML;
	import game.data.xml.DataType;
	import game.data.xml.SkillXML;
	import game.enum.CharacterAnimation;
	import game.enum.ErrorCode;
	import game.enum.ObjectLayer;
	import game.enum.TeamID;
	import game.net.game.ingame.IngamePacket;
	import game.net.game.ingame.ResponseAddEffect;
	import game.net.game.ingame.ResponseAddStatus;
	import game.net.game.ingame.ResponseByte;
	import game.net.game.ingame.ResponseCastSkill;
	import game.net.game.ingame.ResponseCreateBullet;
	import game.net.game.ingame.ResponseCreateObject;
	import game.net.game.ingame.ResponseInt;
	import game.net.game.ingame.ResponseObjectEvent;
	import game.net.game.ingame.ResponseObjectStatus;
	import game.net.game.ingame.ResponseRemoveStatus;
	import game.net.game.ingame.ResponseShort;
	import game.net.game.ingame.ResponseUpdateHP;
	import game.net.game.ingame.ResponseUpdateObject;
	import game.net.game.response.ResponseIngame;
	
	public class World extends Sprite
	{
		public static const CREATE_CHARACTER:String = "create_character";
		public static const DESTROY_CHARACTER:String = "destroy_character";
		public static const START_COUNTDOWN:String = "start_countdown";
		//public static const SHOW_RESULT_BOARD:String = "world_show_result_board";
		public static const CAST_SKILL:String = "castSkill";
		public static const RELEASE_SKILL:String = "release_skill";
		public static const CHANGE_WAVE:String = "reset_team";
		public static const PLAYER_LOSE:String = "player_lose";
		
		public static const SHOW_RESULT:String = "end_game_pve_show_result";
		public static const SHOW_REPLAY_BTN:String = "show_replay_btn";
		
		public static const FX_BLOCKING:int = 122;
		public static const FX_FOCUS:int = 123;
		
		public static const GROUND_ZERO:int = 500;
		public static const SCENARIO_OFFSET:int = 200;
		public static const SCENARIO_SPEED:int = 300;
		public static const CAMERA_SPEED:int = 300;
		public static const DELTA_Y_BETWEEN_LINE:int = 5;
		public static const CHARACTERS_GAP:int = 40;
		public static const FORMATION_WIDTH:int = Game.MAX_CHARACTER * CHARACTERS_GAP;
		
		public var skillEnabled:Boolean = true;
		
		protected var objects:Array = [];
		private var deadObjects:Array = [];
		private var paused:Boolean = false;
		private var blackCurtain:Bitmap;
		private var castingCharacters:Array = [];
		protected var objectLayers:Array = [];
		protected var backgroundLayers:Array = [];
		protected var gameEnding:Boolean = false;
		protected var summonUnitData:Array = [];
		protected var teamCharacters:Array;
		protected var state:int;
		protected var stateTeamID:int;
		protected var rewards:Array = [];
		protected var changingWave:Boolean;
		private var animSkill:Animator;
		private var pixmaText:PixmaText;
		private var castSkillID:int;
		private var isOpenedAllRewards:Boolean;
		
		public function World()
		{
			for each (var i:int in ObjectLayer.ALL)
			{
				objectLayers[i] = new Sprite();
				addChild(objectLayers[i]);
			}
			
			teamCharacters = [];
			teamCharacters[TeamID.LEFT] = [];
			teamCharacters[TeamID.RIGHT] = [];
			
			blackCurtain = new Bitmap();
			blackCurtain.bitmapData = new BitmapData(Game.WIDTH, Game.HEIGHT, true, 0xff000000);
			blackCurtain.alpha = 0;
			Sprite(objectLayers[ObjectLayer.SKILL_SHOW]).addChild(blackCurtain);
			
			animSkill = new Animator();
			animSkill.setCacheEnabled(false);
			animSkill.load("resource/anim/ui/skill_text.banim");
			animSkill.stop();
			animSkill.visible = false;
			animSkill.mouseChildren = false;
			animSkill.mouseEnabled = false;
			
			pixmaText = new PixmaText();
			pixmaText.loadFont("resource/anim/font/font_skill_name.banim");
		}
		
		public function reset():void
		{
			skillEnabled = false;
			paused = true;
			showBlackCurtain(false);
			castingCharacters.splice(0);
			gameEnding = false;
			state = WorldState.FIGHTING;
			for each (var teamID:int in TeamID.ALL)
			{
				teamCharacters[teamID].splice(0);
			}
			for each (var rewardItem:RewardItem in rewards) {
				rewardItem.removeEventListener(RewardItem.OPENED, onRewardItemOpenedHdl);
				rewardItem = null;
			}
			rewards = [];
			isOpenedAllRewards = true;
			removeAllObjects();
		}
		
		public function destroy():void
		{
			removeAllObjects();
			objects = null;
			backgroundLayers = null;
			
			for each (var i:int in ObjectLayer.ALL)
			{
				removeChild(objectLayers[i]);
				objectLayers[i] = null;
			}
			objectLayers = null;
			
			blackCurtain.bitmapData.dispose();
			blackCurtain.bitmapData = null;
			blackCurtain = null;
		}
		
		private function removeAllObjects():void
		{
			var i:int;
			var length:int;
			var deadObjects:Array = objects.slice();
			for (i = 0, length = deadObjects.length; i < length; ++i)
			{
				removeObject(deadObjects[i]);
			}
			deadObjects = null;
		}
		
		protected function removeObject(object:BaseObject):void
		{
			if (object != null)
			{
				if (object is VisualEffect)
					removeEffect(object as VisualEffect);
				else
				{
					if (object.parent != null)
					{
						object.parent.removeChild(object);
						var index:int = objects.indexOf(object);
						if (index > -1)
							objects.splice(index, 1);
						object.reset();
						Manager.pool.push(object);
					}
				}
			}
		}
		
		public function focusCharacter(characterID:int):void
		{
			var character:CharacterObject;
			for each (var object:BaseObject in objects)
			{
				if (object is CharacterObject)
				{
					character = CharacterObject(object);
					if (character.ID == characterID)
					{
						var effect:VisualEffect = addEffect(FX_FOCUS);
						effect.start();
						character.addEffect(effect);
					}
					else
						character.removeStatus(FX_FOCUS);
				}
			}
		}
		
		public function infocusCharacter(characterID:int):void
		{
			var character:CharacterObject;
			for each (var object:BaseObject in objects)
			{
				if (object is CharacterObject)
				{
					character = CharacterObject(object);
					if (character.ID == characterID)
					{
						character.removeStatus(FX_FOCUS);
						break;
					}
				}
			}
		}
		
		public function init():void
		{
		
		}
		
		public function start():void
		{
			paused = false;
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		public function endGame(result:Boolean):void
		{
			state = WorldState.END_GAME;
			skillEnabled = false;
			for each (var object:BaseObject in objects)
			{
				if (object != null && object is CharacterObject)
				{
					var character:CharacterObject = CharacterObject(object);
					if (character.getCurrentAnimation() != CharacterAnimation.DIE)
					{
						character.currentVelocity = 0;
						character.acceleration = 0;
						CharacterObject(object).changeAnimation(CharacterAnimation.STAND);
					}
				}
			}
		}
		
		protected function reform(teamID:int):void
		{
			state = WorldState.CHARACTER_REFORMING;
			stateTeamID = teamID;
			var offsetX:int = getStartPosition(teamID);
			var scrollDirection:int;
			switch (teamID)
			{
				case TeamID.LEFT: 
					scrollDirection = 1;
					break;
				case TeamID.RIGHT: 
					scrollDirection = -1;
					break;
			}
			setBackgroundScrollDirection(scrollDirection);
			setBackgroundScrolling(true);
			for each (var object:BaseObject in objects)
			{
				if (object is CharacterObject)
				{
					var characterObject:CharacterObject = object as CharacterObject;
					if (characterObject.getCurrentAnimation() == CharacterAnimation.DIE)
					{
						characterObject.currentVelocity = -SCENARIO_SPEED * scrollDirection;
					}
					else
					{
						characterObject.runTo(offsetX + characterObject.formationIndex * CHARACTERS_GAP, SCENARIO_SPEED);
					}
				}
			}
		}
		
		protected function reformComplete():void
		{
		
		}
		
		public function prepareNextWave(teamID:int):void
		{
			//Utility.log("prepare next wave " + teamID);
			changingWave = true;
			stateTeamID = teamID;
			if (teamID == 0)
			{
				dispatchEvent(new EventEx(CHANGE_WAVE, TeamID.LEFT, true));
				dispatchEvent(new EventEx(CHANGE_WAVE, TeamID.RIGHT, true));
			}
			else
			{
				dispatchEvent(new EventEx(CHANGE_WAVE, TeamID.exclude(teamID), true));
			}
		}
		
		private function clearEffect():void
		{
			for each(var object:BaseObject in objects)
			{
				if(object is VisualEffect)
				{
					VisualEffect(object).lastComponent();
				}
			}
		}
		
		public function nextWaveReady():void
		{
			//Utility.log("next wave ready");
			changingWave = false;
		}
		
		protected function setBackgroundScrollDirection(direction:int):void
		{
			for each (var backgroundLayer:BackgroundLayer in backgroundLayers)
			{
				backgroundLayer.setScrollDirection(direction);
			}
		}
		
		protected function setBackgroundScrolling(value:Boolean):void
		{
			for each (var backgroundLayer:BackgroundLayer in backgroundLayers)
			{
				backgroundLayer.setScrolling(value);
			}
		}
		
		protected function setBackground(ID:int):void
		{
			backgroundLayers.splice(0);
			var backgroundXML:BackgroundXML = Game.database.gamedata.getData(DataType.BACKGROUND, ID) as BackgroundXML;
			if (backgroundXML != null)
			{
				for each (var layerID:int in backgroundXML.layerIDs)
				{
					var backgroundLayer:BackgroundLayer = Manager.pool.pop(BackgroundLayer) as BackgroundLayer;
					backgroundLayer.setXMLID(layerID);
					addObject(backgroundLayer);
					backgroundLayers.push(backgroundLayer);
				}
			}
		}
		
		public function processPacket(packet:ResponseIngame):void
		{
			for each (var subpacket:IngamePacket in packet.subpackets)
			{
				switch (subpacket.type)
				{
					case IngamePacket.CREATE_BULLET: 
						onCreateBullet(subpacket as ResponseCreateBullet);
						break;
					case IngamePacket.CREATE_OBJECT: 
						onCreateCharacter(subpacket as ResponseCreateObject);
						break;
					case IngamePacket.DESTROY_OBJECT: 
						onDestroyObject(subpacket);
						break;
					case IngamePacket.OBJECT_STATUS: 
						onChangeCharacterAnimation(subpacket as ResponseObjectStatus);
						break;
					case IngamePacket.UPDATE_HP: 
						onUpdateHP(subpacket as ResponseUpdateHP);
						break;
					case IngamePacket.UPDATE_MP: 
						onUpdateMP(subpacket as ResponseInt);
						break;
					case IngamePacket.UPDATE_OBJECT: 
						onUpdateObject(subpacket as ResponseUpdateObject);
						break;
					case IngamePacket.CAST_SKILL: 
						onCastSkill(subpacket as ResponseCastSkill);
						break;
					case IngamePacket.CAST_SKILL_ERROR:
						onCastSkillError(subpacket as ResponseByte);
						break;
					case IngamePacket.RELEASE_SKILL: 
						onReleaseSkill();
						break;
					case IngamePacket.ADD_STATUS: 
						onAddStatus(subpacket as ResponseAddStatus);
						break;
					case IngamePacket.ADD_EFFECT: 
						onAddEffect(subpacket as ResponseAddEffect);
						break;
					case IngamePacket.PREPARE_NEXT_WAVE: 
						prepareNextWave(ResponseByte(subpacket).value);
						break;
					case IngamePacket.NEXT_WAVE_READY: 
						nextWaveReady();
						break;
					case IngamePacket.REMOVE_STATUS: 
						removeStatus(subpacket as ResponseRemoveStatus);
						break;
					case IngamePacket.CHANGE_CHARACTER_MODEL: 
						changeCharacterModel(subpacket as ResponseInt);
						break;
					case IngamePacket.SHOW_HIDE_CHARACTER: 
						toggleCharacterVisibility(subpacket as ResponseByte);
						break;
					case IngamePacket.CHARACTER_ATTACK_SPEED: 
						changeCharacterAttackSpeed(subpacket as ResponseShort);
						break;
				}
			}
		}
		
		private function onCastSkillError(packet:ResponseByte):void
		{
			var object:BaseObject = getObject(packet.objectID);
			if(object.teamID == Game.database.userdata.getCurrentModeData().teamID)
			{
				//Utility.log("cast skill error: " + packet.value);
				switch(packet.value)
				{
					case ErrorCode.CAST_SKILL_GLOBAL_COOLDOWN:
						Manager.display.showMessage("Kỹ năng chưa hồi phục");
						break;
					case ErrorCode.CAST_SKILL_NOT_ENOUGH_MANA:
						Manager.display.showMessage("Không đủ năng lượng");
						break;
					case ErrorCode.CAST_SKILL_KNOCKED_BACK:
						Manager.display.showMessage("Đang bị đánh bật");
						break;
					case ErrorCode.CAST_SKILL_SILENCED:
						Manager.display.showMessage("Đang bị khóa kỹ năng");
						break;
					case ErrorCode.CAST_SKILL_STUNNED:	
						Manager.display.showMessage("Đang bị choáng");
						break;
				}
			}
		}
		
		private function changeCharacterAttackSpeed(packet:ResponseShort):void
		{
			var character:CharacterObject = getObject(packet.objectID) as CharacterObject;
			if (character != null)
			{
				//Utility.log("change attackSpeed, objectID=" + packet.objectID + " attackSpeed=" + packet.value);
				character.attackSpeed = packet.value;
			}
		}
		
		private function changeCharacterModel(packet:ResponseInt):void
		{
			//Utility.log("change character model, objectID=" + packet.objectID + ", xmlID=" + packet.value);
			var character:CharacterObject = getObject(packet.objectID) as CharacterObject;
			var characterXML:CharacterXML = Game.database.gamedata.getData(DataType.CHARACTER, packet.value) as CharacterXML;
			if (character != null && characterXML != null)
			{
				character.setXMLData(characterXML);
			}
		}
		
		private function toggleCharacterVisibility(packet:ResponseByte):void
		{
			var invisible:Boolean = Boolean(packet.value);
			//Utility.log("toggle character visibility, objectID=" + packet.objectID + ", invisible=" + invisible);
			var character:CharacterObject = getObject(packet.objectID) as CharacterObject;
			if (character != null)
				character.visible = !invisible;
		}
		
		private function onUpdateMP(packet:ResponseInt):void
		{
			////Utility.log("update mana, objectID: " + packet.objectID + " value: " + packet.value);
			var character:CharacterObject = getObject(packet.objectID) as CharacterObject;
			if (character != null)
			{
				character.setCurrentMP(packet.value);
			}
		}
		
		private function removeStatus(packet:ResponseRemoveStatus):void
		{
			//Utility.log("remove status, characterID: " + packet.objectID + " effectID: " + packet.effectID);
			var character:CharacterObject = getObject(packet.objectID) as CharacterObject;
			if (character != null)
				character.removeStatus(packet.effectID);
		}
		
		public function stop():void
		{
			removeAllObjects();
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onObjectEvent(packet:ResponseObjectEvent):void
		{
			var character:CharacterObject = getObject(packet.objectID) as CharacterObject;
			if (character != null)
			{
				switch (packet.event)
				{
					case 0: // dodge
						//var effect:VisualEffect = addEffect(FX_BLOCKING);
						//effect.x = character.x + (character.getWidth() >> 1);
						//effect.y = character.y;
						var damageText:DamageText = Manager.pool.pop(DamageText) as DamageText;
						damageText.x = character.x + (character.getWidth() >> 1);
						damageText.y = character.y;
						addChild(damageText);
						damageText.addEventListener(DamageText.COMPLETE, onPlayDamageTextCompleteHdl);
						damageText.playDodgeEffect();
						break;
					case 1: // knock
						break;
					case 2: // resist
						break;
				}
			}
		}
		
		private function onPlayDamageTextCompleteHdl(e:Event):void
		{
			var damageText:DamageText = e.target as DamageText;
			if (damageText)
			{
				damageText.removeEventListener(DamageText.COMPLETE, onPlayDamageTextCompleteHdl);
				removeChild(damageText);
				
				Manager.pool.push(damageText, DamageText);
			}
		}
		
		private function addEffect(ID:int):VisualEffect
		{
//			Utility.log("add effectID=" + ID);
			var effect:VisualEffect = Manager.pool.pop(VisualEffect) as VisualEffect;
			effect.reset();
			effect.setXmlID(ID);
			if (effect.getXmlData() != null)
			{
				var compositions:Array = effect.getCompositions();
				var compIndex:int;
				var compTotal:int;
				var component:VisualEffectComponent;
				var layer:Sprite;
				for (compIndex = 0, compTotal = compositions.length; compIndex < compTotal; ++compIndex)
				{
					component = compositions[compIndex];
					var animators:Array = component.getAnimators();
					var i:int;
					var length:int;
					var animator:Animator;
					for (i = 0, length = animators.length; i < length; ++i)
					{
						animator = animators[i];
						if (animator != null)
						{
							if (DebuggerUtil.getInstance().isShowingBoundingBox)
							{
								if (animator["boundingBox"]) Sprite(animator["boundingBox"]).graphics.clear();
								else 
								{
									animator["boundingBox"] = new Sprite();
									animator.addChild(animator["boundingBox"]);
								}
								
								var c:uint = 0x0000ff;
								
								animator["boundingBox"].graphics.lineStyle(1, c);
								animator["boundingBox"].graphics.drawRect(0, -50, 50, 50);
								animator["boundingBox"].cacheAsBitmap = true;
							}
							layer = objectLayers[component.getAnimatorLayer(i)];
							if (layer != null)
							{
								layer.addChild(animator);
							}
						}
					}
				}
				objects.push(effect);
				return effect;
			}
			else
			{
				Manager.pool.push(effect, VisualEffect);
			}
			return null;
		}
		
		private function removeEffect(effect:VisualEffect):void
		{
			if (effect != null)
			{
				var compositions:Array = effect.getCompositions();
				var compIndex:int;
				var compTotal:int;
				var component:VisualEffectComponent;
				var layer:Sprite;
				for (compIndex = 0, compTotal = compositions.length; compIndex < compTotal; ++compIndex)
				{
					component = compositions[compIndex];
					var animators:Array = component.getAnimators();
					var i:int;
					var length:int;
					var animator:Animator;
					for (i = 0, length = animators.length; i < length; ++i)
					{
						animator = animators[i];
						if (animator != null)
						{
							layer = objectLayers[component.getAnimatorLayer(i)];
							if (layer != null)
							{
								layer.removeChild(animator);
							}
						}
					}
				}
				var index:int = objects.indexOf(effect);
				objects.splice(index, 1);
				effect.reset();
				Manager.pool.push(effect, VisualEffect);
			}
		}
		
		private function onChangeCharacterAnimation(packet:ResponseObjectStatus):void
		{
			var character:CharacterObject = getObject(packet.objectID) as CharacterObject;
			if (character != null)
			{
				////Utility.log("change character animation, objectID=" + packet.objectID + " index=" + packet.status);
				if (packet.status == CharacterAnimation.BLOCKING)
				{
					var effect:VisualEffect = addEffect(FX_BLOCKING);
					effect.start()
					character.addEffect(effect);
					effect.setTeamID(TeamID.LEFT);
				}
				if(packet.status == CharacterAnimation.KNOCKBACK && character.getCurrentAnimation() == CharacterAnimation.MELEE_ATTACK)
				{
					character.setKnockback(true);
				}
				else
				{
					character.changeAnimation(packet.status);
				}
			}
		}
		
		private function onUpdateHP(packet:ResponseUpdateHP):void
		{
			var character:CharacterObject = getObject(packet.objectID) as CharacterObject;
			if (character != null)
			{
				var hpChange:int = packet.currentHP - character.getCurrentHP();
				character.setCurrentHP(packet.currentHP);
				if (hpChange < 0)
					character.getHit();
				character.setDisplayDamageTxt(hpChange, packet.critical);
			}
		}
		
		private function onCreateCharacter(packet:ResponseCreateObject):void
		{
			//Utility.log("create character, objectID: " + packet.objectID + " teamID: " + packet.teamID + " index: " + packet.formationIndex + ", x=" + packet.x + " xmlID=" + packet.xmlID + " velocity=" + packet.speed + " maxHP=" + packet.maxHP+ " currentHP=" + packet.currentHP+ " currentMP=" + packet.currentMP);
			var characterObject:CharacterObject = Manager.pool.pop(CharacterObject) as CharacterObject;
			characterObject.reset();
			characterObject.ID = packet.objectID;
			characterObject.setTeamID(packet.teamID);
			characterObject.setMaxHP(packet.maxHP);
			characterObject.setCurrentHP(packet.currentHP);
			characterObject.setCurrentMP(packet.currentMP);
			characterObject.currentVelocity = packet.speed;
			characterObject.formationIndex = packet.formationIndex;
			characterObject.x = packet.x;
			characterObject.oWorld = this;
			characterObject.attackSpeed = packet.attackSpeed;
			if (changingWave)
			{
				mapCharacterObject(characterObject);
				characterObject.setXMLData(Game.database.gamedata.getData(DataType.CHARACTER, packet.xmlID) as CharacterXML);
				teamCharacters[packet.teamID].push(characterObject);
			}
			else
			{
				characterObject.setXMLData(Game.database.gamedata.getData(DataType.CHARACTER, packet.xmlID) as CharacterXML);
				characterObject.layer = ObjectLayer.CHARACTER_LINE_2;
				characterObject.y = GROUND_ZERO - characterObject.getHeight();
				characterObject.alpha = 0;
				TweenMax.to(characterObject, 0.8, {alpha: 1, ease: Linear.easeNone});
				addObject(characterObject);
			}
		}
		
		protected function mapCharacterObject(character:CharacterObject):void
		{
		
		}
		
		public function CanMove(oCharacter:CharacterObject, nXPred:Number):Boolean
		{
			if (state == WorldState.FIGHTING)
			{
				if (!oCharacter)
					return false;
				var oEnemy:CharacterObject;
				for each (var object:BaseObject in objects)
				{
					if (object != null && object is CharacterObject && !object.isDead && oCharacter.teamID != object.teamID && oCharacter.ID != object.ID)
					{
						oEnemy = CharacterObject(object);
						if (oEnemy.getCurrentHP() <= 0 || oEnemy.visible == false)
							continue;
						if (oCharacter.teamID == TeamID.LEFT)
						{
							if ((nXPred + (oCharacter.getWidth() >> 1)) >= oEnemy.x)
								return false;
						}
						else
						{
							if (nXPred <= (oEnemy.x + (oEnemy.getWidth() >> 1)))
								return false;
						}
					}
				}
			}
			return true;
		}
		
		private function onAnimationComplete(e:Event):void
		{
			var animator:Animator = e.target as Animator;
			animator.removeEventListener(Event.COMPLETE, onAnimationComplete);
			Sprite(objectLayers[ObjectLayer.BACK_EFFECT]).removeChild(animator);
			animator.reset();
			Manager.pool.push(animator, Animator);
		}
		
		private function onUpdateObject(packet:ResponseUpdateObject):void
		{
			var object:BaseObject = getObject(packet.objectID);
			if (object != null)
			{
				////Utility.log(packet.objectID + " packetX: " + packet.x + " X: " + object.x + " velocity: " + packet.velocity + " acceleration=" + packet.acceleration + " time: " + getTimer());
				object.x = packet.x;
				object.currentVelocity = packet.velocity;
				object.acceleration = packet.acceleration;
			}
		}
		
		private function onDestroyObject(packet:IngamePacket):void
		{
			Utility.log("destroy object, ID=" + packet.objectID);
			var object:BaseObject = getObject(packet.objectID);
			if (object != null)
			{
				object.currentVelocity = 0;
				object.acceleration = 0;
				object.ID = 0;
				if (object is VisualEffect)
				{
					//Utility.log("destroy object, ID=" + packet.objectID + ", effectID=" + VisualEffect(object).getXmlData().ID);
					VisualEffect(object).lastComponent();
				}
				else
				{
					var character:CharacterObject = object as CharacterObject;
					character.die();
					var team:Array = teamCharacters[character.teamID];
					team.splice(team.indexOf(character), 1);
					dispatchEvent(new EventEx(DESTROY_CHARACTER, object, true));
				}
			}
		}
		
		private function onCreateBullet(packet:ResponseCreateBullet):void
		{
			//if(packet.effectID == 8)
			//Utility.log("create bullet, objectID=" + packet.objectID + ", effectID=" + packet.effectID + ", x=" + packet.x+ ", speed=" + packet.speed);

			if(!Game.database.gamedata.isBullet(packet.effectID)
			    && Game.database.gamedata.enableReduceEffect) return;

			var effect:VisualEffect = addEffect(packet.effectID);
			if (effect != null)
			{
				effect.ID = packet.objectID;
				effect.x = packet.x;
				effect.y = GROUND_ZERO + effect.getXmlData().offsetY;
				effect.setTeamID(packet.teamID);
				effect.currentVelocity = packet.speed;
				effect.start();
			}
		}
		
		private function onCastSkill(packet:ResponseCastSkill):void
		{
			Utility.log("server response " + packet.objectID + " cast skill " + packet.skillXMLID + " time=" + getTimer());
			pause();
			castSkillID = packet.skillXMLID;
			showBlackCurtain();
			Sprite(objectLayers[ObjectLayer.SKILL_SHOW]).addChild(animSkill);
			castingCharacters.splice(0);
			for each (var objectID:int in packet.objectIDs)
			{
				var character:CharacterObject = getObject(objectID) as CharacterObject;
				if (character != null)
				{
					castingCharacters.push(character);
					Sprite(objectLayers[ObjectLayer.SKILL_SHOW]).addChild(character);
					animSkill.x = character.x + character.getWidth() / 2;
					animSkill.y = Game.HEIGHT / 2;
				}
			}
			var skillData:SkillXML = Game.database.gamedata.getData(DataType.SKILL, castSkillID) as SkillXML;
			if (skillData)
			{
				var skillName:Array = skillData.name.split(" ");
				var replaceBitmap:Array = [];
				var bitmapData:BitmapData;
				for each (var char:String in skillName)
				{
					pixmaText.setText(char);
					bitmapData = new BitmapData(pixmaText.width, pixmaText.getHeight(), true, 0);
					bitmapData.draw(pixmaText);
					
					replaceBitmap.push(bitmapData);
				}
				
				animSkill.visible = true;
				animSkill.addEventListener(Event.COMPLETE, onAnimSkillCompleteHdl);
				switch (skillName.length)
				{
					/*case 1: 
						animSkill.replaceFMBitmapData([16], replaceBitmap);
						animSkill.play(0, 1);
						break;
					
					case 2: 
						animSkill.replaceFMBitmapData([16, 17], replaceBitmap);
						animSkill.play(1, 1);
						break;*/
					
					case 3: 
						animSkill.replaceFMBitmapData([11, 0, 10], replaceBitmap);
						animSkill.play(2, 1);
						break;
					
					case 4: 
						animSkill.replaceFMBitmapData([11, 0, 10, 9], replaceBitmap);
						animSkill.play(3, 1);
						break;
					
					case 5: 
						animSkill.replaceFMBitmapData([11, 0, 10, 9, 12], replaceBitmap);
						animSkill.play(4, 1);
						break;
					default:
						Utility.error("World.onCastSkill() >> skill name is too long: " + skillData.name);
						break;
				}
			}
			else
			{
				castSkill();
			}
			dispatchEvent(new Event(CAST_SKILL, true));
		}
		
		private function onAnimSkillCompleteHdl(e:Event):void
		{
			var anim:Animator = e.target as Animator;
			if (anim)
			{
				anim.removeEventListener(Event.COMPLETE, onAnimSkillCompleteHdl);
				castSkill();
				if (anim.parent) {
					anim.parent.removeChild(anim);
				}
			}
		}
		
		private function castSkill():void
		{
			for each (var character:CharacterObject in castingCharacters)
			{
				var skillIndex:int = 0;
				var characterXML:CharacterXML = character.getXMLData();
				if (characterXML != null)
				{
					skillIndex = characterXML.activeSkills.indexOf(castSkillID);
				}
				Utility.log("cast skill, objectID: " + character.ID + " xmlID: " + characterXML.ID + " skillID: " + castSkillID + " skillIndex: " + skillIndex + " time: " + getTimer());
				character.changeAnimation(CharacterAnimation.SKILL1_CASTING + skillIndex);
				character.resume();
			}
		}
		
		private function onReleaseSkill():void
		{
			//Utility.log("server response release skill, time=" + getTimer());
			resume();
			showBlackCurtain(false);
			for each (var character:CharacterObject in castingCharacters)
			{
				Sprite(objectLayers[character.layer]).addChild(character);
				dispatchEvent(new EventEx(RELEASE_SKILL, character, true));
			}
			castingCharacters.splice(0);
		}
		
		protected function showBlackCurtain(value:Boolean = true):void
		{
			TweenMax.to(blackCurtain, 0.5, {alpha: (value ? 0.8 : 0)});
		}
		
		public function getObject(ID:int):BaseObject
		{
			var result:BaseObject = null;
			for each (var object:BaseObject in objects)
			{
				if (object != null && object.ID == ID)
				{
					result = object;
					break;
				}
			}
			return result;
		}
		
		protected function addObject(object:BaseObject):void
		{
			if (object != null)
			{
				var layer:Sprite = objectLayers[object.layer];
				if (layer != null)
				{
					layer.addChild(object);
					objects.push(object);
				}
				else
					Utility.error("World.addObject() >> undefined object layer: " + object.layer);
			}
		}
		
		private function pause():void
		{
			paused = true;
			for each (var object:BaseObject in objects)
			{
				if (object != null)
				{
					object.pause();
				}
			}
		}
		
		private function resume():void
		{
			paused = false;
			for each (var object:BaseObject in objects)
			{
				if (object != null)
					object.resume();
			}
		}
		
		protected function onEnterFrame(event:Event):void
		{
			if (paused)
				return;
			var delta:Number = Manager.time.getFrameDelta();
			deadObjects = [];
			for each (var object:BaseObject in objects)
			{
				if (object != null)
				{
					if (!object.isDead)
						object.update(delta);
					if (object.isDead)
					{
						deadObjects.push(object);
					}
				}
			}
			if (state == WorldState.FIGHTING)
			{
				var oCharacter:CharacterObject;
				var oEnemy:CharacterObject;
				for each (object in objects)
				{
					if (object != null && object is CharacterObject && !object.isDead)
					{
						for each (var object2:BaseObject in objects)
						{
							if (object2 != null && object.teamID != object2.teamID && object2 is CharacterObject && !object2.isDead)
							{
								oCharacter = CharacterObject(object);
								oEnemy = CharacterObject(object2);
								
								if (oEnemy.getCurrentHP() <= 0 || oEnemy.visible == false)
									continue;
								
								var bInMeleeAttackRange:Boolean = false;
								switch (oCharacter.getCurrentAnimation())
								{
									case CharacterAnimation.STAND: 
									case CharacterAnimation.RUN: 
									case CharacterAnimation.RANGER_ATTACK_PREPARE: 
									case CharacterAnimation.RANGER_ATTACK_HOLD: 
									case CharacterAnimation.RANGER_ATTACK_RELEASE: 
									{
										if (oCharacter.teamID == TeamID.LEFT)
										{
											var nRangeMeleeAttack:int = oCharacter.x + oCharacter.getWidth() + oCharacter.getMeleeAttackrange();
											if (oEnemy.getCurrentAnimation() != CharacterAnimation.RUN)
												nRangeMeleeAttack -= ((oCharacter.getMeleeAttackrange() / 3) * 2);
											if (oEnemy.x <= nRangeMeleeAttack)
												bInMeleeAttackRange = true;
										}
										else
										{
											nRangeMeleeAttack = oCharacter.x - oCharacter.getMeleeAttackrange();
											if (oEnemy.getCurrentAnimation() != CharacterAnimation.RUN)
												nRangeMeleeAttack += ((oCharacter.getMeleeAttackrange() / 3) * 2);
											if (oEnemy.x >= oCharacter.x - oCharacter.getMeleeAttackrange())
												bInMeleeAttackRange = true;
										}
										if (bInMeleeAttackRange)
											oCharacter.changeAnimation(CharacterAnimation.MELEE_ATTACK);
										break;
									}
								}
								if (bInMeleeAttackRange)
									break;
							}
						}
					}
				}
			}
			for each (object in deadObjects)
			{
				removeObject(object);
			}
			
			switch (state)
			{
				case WorldState.SUMMON_CHARACTERS: 
				{
					var finish:Boolean = true;
					for each (var characterObject:CharacterObject in teamCharacters[stateTeamID])
					{
						if (characterObject.hasReachedTarget() == false)
						{
							finish = false;
							break;
						}
					}
					if (finish)
					{
						createCharacters(TeamID.exclude(stateTeamID));
						rushCharacters(stateTeamID);
					}
					break;
				}
				case WorldState.CHARACTER_RUSHING: 
				{
					finish = true;
					if (gameEnding == false)
					{
						for each (characterObject in teamCharacters[stateTeamID])
						{
							if (characterObject.hasReachedTarget() == false)
							{
								finish = false;
								break;
							}
						}
					}
					else
					{
						for each (var reward:RewardItem in rewards)
						{
							if (reward.hasReachedTarget() == false)
							{
								finish = false;
								break;
							}
						}
					}
					if (finish)
					{
						for each (characterObject in teamCharacters[TeamID.exclude(stateTeamID)])
						{
							characterObject.changeAnimation(CharacterAnimation.STAND);
						}
						state = WorldState.FIGHTING;
						stateTeamID = 0;
						setBackgroundScrolling(false);
						if (gameEnding == false)
							dispatchEvent(new Event(START_COUNTDOWN, true));
						else
							dispatchEvent(new Event(World.SHOW_RESULT, true));
					}
					break;
				}
				case WorldState.CHARACTER_REFORMING: 
				{
					finish = true;
					for each (characterObject in teamCharacters[stateTeamID])
					{
						if (characterObject.hasReachedTarget() == false)
						{
							if(characterObject.x > characterObject.target)
							{
								characterObject.changeAnimation(CharacterAnimation.STAND);
							}
							else
							{
								characterObject.changeAnimation(CharacterAnimation.RUN);
							}
							finish = false;
						}
						else
						{
							characterObject.changeAnimation(CharacterAnimation.RUN);
						}
					}
					if (finish)
					{
						reformComplete();
					}
					break;
				}
			}
		}
		
		protected function rushCharacters(teamID:int):void
		{
			for each (var character:CharacterObject in teamCharacters[teamID])
			{
				character.changeAnimation(CharacterAnimation.RUN);
			}
			teamID = TeamID.exclude(teamID);
			var offset:int;
			var scrollDirection:int;
			switch (teamID)
			{
				case TeamID.LEFT: 
					offset = (FORMATION_WIDTH + SCENARIO_OFFSET);
					scrollDirection = -1;
					break;
				case TeamID.RIGHT: 
					offset = -(FORMATION_WIDTH + SCENARIO_OFFSET);
					scrollDirection = 1;
					break;
			}
			for each (character in teamCharacters[teamID])
			{
				character.runTo(character.x + offset, SCENARIO_SPEED);
			}
			setBackgroundScrollDirection(scrollDirection);
			setBackgroundScrolling(true);
			state = WorldState.CHARACTER_RUSHING;
			stateTeamID = teamID;
		}
		
		protected function summonCharacters(teamID:int):void
		{
			var characters:Array = teamCharacters[teamID];
			var offset:int = getStartPosition(teamID);
			for each (var characterObject:CharacterObject in characters)
			{
				characterObject.runTo(offset + characterObject.formationIndex * CHARACTERS_GAP, SCENARIO_SPEED);
				characterObject.changeAnimation(CharacterAnimation.RUN);
			}
			state = WorldState.SUMMON_CHARACTERS;
			stateTeamID = teamID;
		}
		
		protected function createCharacters(teamID:int):void
		{
			var characters:Array = teamCharacters[teamID];
			for each (var characterObject:CharacterObject in characters)
			{
				switch (teamID)
				{
					case TeamID.LEFT: 
						characterObject.x = getStartPosition(teamID) - (FORMATION_WIDTH + SCENARIO_OFFSET) + characterObject.formationIndex * CHARACTERS_GAP;
						break;
					case TeamID.RIGHT: 
						characterObject.x = getStartPosition(teamID) + (FORMATION_WIDTH + SCENARIO_OFFSET) + characterObject.formationIndex * CHARACTERS_GAP;
						break;
				}
				characterObject.changeAnimation(CharacterAnimation.STAND);
				if (characters.length == 1)
				{
					characterObject.y = GROUND_ZERO - characterObject.getHeight();
					characterObject.layer = ObjectLayer.CHARACTER_LINE_2;
				}
				else
				{
					var nDeltaY:int = 0;
					if (characterObject.formationIndex % 2 == 1)
					{
						nDeltaY = Math.random() * -DELTA_Y_BETWEEN_LINE - DELTA_Y_BETWEEN_LINE;
						characterObject.layer = ObjectLayer.CHARACTER_LINE_1;
					}
					else
					{
						nDeltaY = Math.random() * DELTA_Y_BETWEEN_LINE + DELTA_Y_BETWEEN_LINE;
						characterObject.layer = ObjectLayer.CHARACTER_LINE_3;
					}
					characterObject.y = GROUND_ZERO - characterObject.getHeight() + nDeltaY;
				}
				addObject(characterObject);
				dispatchEvent(new EventEx(CREATE_CHARACTER, characterObject, true));
			}
		}
		
		protected function showRewards(teamID:int):void
		{
			var rewardItem:RewardItem;
			var i:int = 0;
			
			var modeData:ModeData = Game.database.userdata.getCurrentModeData();
			var rewardsData:Array = modeData.fixReward;
			var x2:Boolean = false;
			if(modeData is ModeDataHeroicTower)
			{
				x2 = ModeDataHeroicTower(modeData).itemActivated;
			}
			if (rewardsData && (rewardsData.length > 0))
			{
				rewardsData = rewardsData.concat(modeData.randomReward);
				for each (var item:ItemInfo in rewardsData)
				{
					rewardItem = new RewardItem();
					rewardItem.addEventListener(RewardItem.OPENED, onRewardItemOpenedHdl);
					rewardItem.layer = ObjectLayer.REWARDS;
					switch(teamID) {
						case TeamID.RIGHT:
							rewardItem.x = - i * 120;
							break;
							
						case TeamID.LEFT:
							rewardItem.x = Game.WIDTH + i * 120;
							break;
					}
					rewardItem.y = GROUND_ZERO;
					rewardItem.setData(item, x2);
					addObject(rewardItem);
					rewards.push(rewardItem);
					
					i++;
				}
			}
			else
			{
				dispatchEvent(new Event(SHOW_REPLAY_BTN, true));
			}
		}
		
		protected function onRewardItemOpenedHdl(e:Event):void
		{
			isOpenedAllRewards = true;
			for each (var reward:RewardItem in rewards)
			{
				if (reward)
				{
					if (!reward.getIsOpened())
					{
						isOpenedAllRewards = false;
					}
				}
			}
			if (isOpenedAllRewards)
			{
				dispatchEvent(new Event(SHOW_REPLAY_BTN, true));
			}
		}
		
		private function onAddEffect(packet:ResponseAddEffect):void
		{
			if(Game.database.gamedata.enableReduceEffect) return;

			Utility.log("add effect, effectID: " + packet.effectID + " x: " + packet.x + ", objectID=" + packet.objectID);
			var effect:VisualEffect = addEffect(packet.effectID);
			if (effect != null)
			{
				effect.x = packet.x;
				effect.y = GROUND_ZERO + effect.getXmlData().offsetY;
				effect.start();
				effect.setTeamID(packet.teamID);
			}
		}
		
		private function onAddStatus(packet:ResponseAddStatus):void
		{
			if(Game.database.gamedata.enableReduceEffect) return;

			Utility.log("add status, characterID: " + packet.objectID + " effectID: " + packet.effectID + " duration: " + packet.duration + " replace=" + packet.replace);
			var character:CharacterObject = getObject(packet.objectID) as CharacterObject;
			if(character != null) {
				var effect:VisualEffect = addEffect(packet.effectID);
				character.addEffect(effect);

				if(effect != null) {
					effect.setDuration(packet.duration);
					effect.start();
				}
			}
		}
		
		protected function getStartPosition(teamID:int):int
		{
			return 0;
		}
	}
}