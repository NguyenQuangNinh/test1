package game.ui.ingame 
{
	import com.greensock.TweenMax;
	import flash.display.Sprite;
	
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import core.Manager;
	import core.display.animation.Animator;
	import core.util.Utility;
	
	import game.Game;
	import game.data.model.Character;
	import game.data.xml.CharacterXML;
	import game.data.xml.DataType;
	import game.data.xml.SkillXML;
	import game.data.xml.VisualEffectXML;
	import game.enum.CharacterAnimation;
	import game.enum.TeamID;

	/**
	 * ...
	 * @author bangnd2
	 */
	public class CharacterObject extends BaseObject 
	{
		public static const HP_CHANGED:String = "hp_changed";
		public static const MP_CHANGED:String = "mp_changed";
		public static const DIE:String = "character_object_ingame_die";

		private static const CASTING_TIME:Number		= 0.915;
		private static const DELAY_DISPLAY_DAMAGE_TEXT:Number = 0.15;
		public static const MAX_MP:int = 10000;
		
		public var formationIndex:int;
		public var isKnockBacking:Boolean; // chi su dung cho tutorial
		
		private var maxHP:int;
		private var currentHP:int;
		private var currentMP:int;
		private var knockback:Boolean;
		private var data:Character;
		private var xmlData:CharacterXML;
		private var animator:Animator;
		private var effects:Array = [];
		private var deadEffects:Array = [];
		private var effectGetDamage:TweenMax;
		private var attackTimer:Timer;
		private var attackReleaseTime:int;
		private var damageValues:Vector.<Object>;
		private var damageTextDelay:Number;
		private var boundingBox:Sprite;
		private var skillCastingTime:Array = [];

		public var oWorld:World;
		
		public function CharacterObject():void
		{
			animator = new Animator();
			animator.addEventListener(Animator.LOADED, onAnimationLoaded);
			animator.addEventListener(Event.COMPLETE, onAnimationComplete);
			addChild(animator);
			
			attackTimer = new Timer(0, 1);
			attackTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onAttack);
			
			effectGetDamage = new TweenMax(animator, 0.1, { colorTransform: { redOffset:150, greenOffset:150, blueOffset:150 }, repeat:5, yoyo:true } );
			damageValues = new Vector.<Object>();
		}
		
		protected function onAttack(event:TimerEvent):void
		{
			changeAnimation(CharacterAnimation.RANGER_ATTACK_RELEASE);
		}
		
		public function setCurrentHP(value:int):void
		{
			currentHP = Utility.math.clamp(value, 0, maxHP);
			dispatchEvent(new Event(HP_CHANGED));
		}
		
		public function getCurrentHP():int { return currentHP; }
		
		public function setCurrentMP(value:int):void
		{
			currentMP = value;
			currentMP = Utility.math.clamp(currentMP, 0, MAX_MP);
			dispatchEvent(new Event(MP_CHANGED));
		}
		
		public function getCurrentMP():int { return currentMP; }
		
		public function setMaxHP(value:int):void
		{
			maxHP = value;
		}
		
		public function getMaxHP():int { return maxHP; }
		
		public function setDisplayDamageTxt(value:int, isCritical:Boolean):void {
			damageValues.push( { value:value, isCritical:isCritical } );
		}
		
		private function onPlayDamageTextCompleteHdl(e:Event):void {
			var damageText:DamageText = e.target as DamageText;
			if (damageText) {
				damageText.removeEventListener(DamageText.COMPLETE, onPlayDamageTextCompleteHdl);
				removeChild(damageText);
				
				Manager.pool.push(damageText, DamageText);
			}
		}
		
		override public function reset():void 
		{
			super.reset();
			formationIndex = -1;
			currentHP = 0;
			currentMP = 0;
			currentVelocity = 0;
			acceleration = 0;
			animator.reset();
			damageValues = new Vector.<Object>();
			damageTextDelay = DELAY_DISPLAY_DAMAGE_TEXT;
		}
		
		public function getHit():void
		{
			if (effectGetDamage.isActive() == false) effectGetDamage.restart();
		}
		
		override public function pause():void 
		{
			animator.pause();
			for each(var effect:VisualEffect in effects) effect.pause();
			super.pause();
		}
		
		override public function resume():void 
		{
			animator.resume();
			for each(var effect:VisualEffect in effects) effect.resume();
			super.resume();
		}
		
		public function addEffect(effect:VisualEffect):void
		{
			if (effect != null)
			{
				effects.push(effect);
				effect.x = x + (getWidth() >> 1);
				effect.y = y + getHeight();
				effect.setTeamID(teamID);
			}
		}
		
		public function getWidth():int
		{
			if(xmlData != null) return xmlData.width;
			return 0;
		}
		
		public function getHeight():int
		{
			if(xmlData != null) return xmlData.height;
			return 0;
		}
		
		public function getMeleeAttackrange():int {
			if(xmlData != null) return xmlData.meleeAttackRange;
			return 0;
		}
		
		public function removeStatus(effectID:int):void
		{
			var i:int;
			var length:int;
			var effect:VisualEffect;
			var effectXML:VisualEffectXML;
			for (i = 0, length = effects.length; i < length; ++i)
			{
				effect = effects[i];
				if (effect != null)
				{
					effectXML = effect.getXmlData();
					if (effectXML != null && effectXML.ID == effectID)
					{
						effect.isDead = true;
						break;
					}
				}
			}
		}

		public function die():void
		{
			changeAnimation(CharacterAnimation.DIE);
			for each(var effect:VisualEffect in effects)
			{
				effect.isDead = true;
			}

			dispatchEvent(new Event(DIE));
		}
		
		public function setData(data:Character):void
		{
			this.data = data;
		}
		
		public function getXMLData():CharacterXML { return xmlData; }
		public function setXMLData(xmlData:CharacterXML):void
		{
			this.xmlData = xmlData;
			skillCastingTime = [];

			if (xmlData != null)
			{
				if (data != null) animator.load(xmlData.animURLs[data.sex]);
				else
				{
					var sex:int = Math.random() > 0.5 ? 0 : 1;
					animator.load(xmlData.animURLs[sex]);
				}
				
				animator.alpha = xmlData.opacity > 0 ? xmlData.opacity : 1;

				for (var i:int = 0; i < xmlData.activeSkills.length; i++)
				{
					var skillID:int = xmlData.activeSkills[i] as int;
					var skillXML:SkillXML = Game.database.gamedata.getData(DataType.SKILL, skillID) as SkillXML;
					if (skillXML)
					{
						skillCastingTime.push(skillXML.castTime);
					}
					else
					{
						skillCastingTime.push(-1);
					}
				}
			}

			if (DebuggerUtil.getInstance().isShowingBoundingBox)
			{
				if (!boundingBox) 
				{
					boundingBox = new Sprite();
					addChild(boundingBox);
				}
				else boundingBox.graphics.clear();
				
				var c:uint = Math.random() * 0xffffff;
				//c = c << 8; // green
				
				boundingBox.graphics.lineStyle(1, c);
				boundingBox.graphics.drawRect(0, 0, xmlData.width, xmlData.height);
				//boundingBox.cacheAsBitmap = true;
			}
		}
		
		public function getData():Character { return data; }
		
		public function onAnimationLoaded(event:Event):void
		{
			switch(teamID)
			{
				case TeamID.LEFT:
					animator.scaleX = 1;
					animator.x = (getWidth() >> 1);
					animator.y = getHeight();
					break;
				case TeamID.RIGHT:
					animator.scaleX = -1;
					animator.x = (getWidth() >> 1);
					animator.y =  getHeight();
					break;
			}
			attackReleaseTime = animator.getAnimationTime(CharacterAnimation.RANGER_ATTACK_RELEASE) * 1000;
		}
		
		public function getCurrentAnimation():int
		{
			return animator.getCurrentAnimation();
		}
		
		private function onAnimationComplete(event:Event):void
		{
			var currentAnimation:int = animator.getCurrentAnimation();
			switch(currentAnimation)
			{
				case CharacterAnimation.MELEE_ATTACK:
					if(knockback)
					{
						changeAnimation(CharacterAnimation.KNOCKBACK);
						break;
					}
				case CharacterAnimation.SKILL1_CASTING:
				case CharacterAnimation.SKILL2_CASTING:
				case CharacterAnimation.SKILL3_CASTING:
				case CharacterAnimation.SKILL4_CASTING:
					//Utility.log("casting animation complete, time=" + getTimer());
					if(xmlData.rangerAttackRange == 0) changeAnimation(CharacterAnimation.RUN);
					else changeAnimation(CharacterAnimation.RANGER_ATTACK_PREPARE);
					break;
				case CharacterAnimation.RANGER_ATTACK_RELEASE:
					changeAnimation(CharacterAnimation.RANGER_ATTACK_PREPARE);
					break;
				case CharacterAnimation.RANGER_ATTACK_PREPARE:
					changeAnimation(CharacterAnimation.RANGER_ATTACK_HOLD);
					break;
				case CharacterAnimation.DIE:
					isDead = true;
					break;
			}
		}
		
		public function changeAnimation(index:int):void
		{
			//Utility.log("changeAnimation: objectID:" + ID + ",index: " + index);
			knockback = false;
			if(animator.getCurrentAnimation() != index)
			{
				if(index != CharacterAnimation.RANGER_ATTACK_PREPARE && index != CharacterAnimation.RANGER_ATTACK_HOLD) attackTimer.stop();
				switch(index)
				{
					case CharacterAnimation.RANGER_ATTACK_PREPARE:
						if(xmlData.ID == 295)
							trace("stop");
						attackTimer.delay = attackSpeed - attackReleaseTime;
						attackTimer.reset();
						attackTimer.start();
					case CharacterAnimation.MELEE_ATTACK:
					case CharacterAnimation.RANGER_ATTACK_RELEASE:
					case CharacterAnimation.DIE:
						animator.setAnimationSpeed(1);
						animator.play(index, 1);
						break;
					case CharacterAnimation.RANGER_ATTACK_HOLD:
						animator.setAnimationSpeed(1);
						animator.play(index);
						break;
					case CharacterAnimation.RUN:
						animator.setAnimationSpeed(1);
						animator.play(index, 0, 0, true);
						break;
					case CharacterAnimation.SKILL1_CASTING:
					case CharacterAnimation.SKILL2_CASTING:
					case CharacterAnimation.SKILL3_CASTING:
					case CharacterAnimation.SKILL4_CASTING:
						if(skillCastingTime[index - CharacterAnimation.SKILL1_CASTING] == -1)
						{
							animator.setAnimationSpeed(CASTING_TIME / animator.getAnimationTime(index));
						}
						else
						{
							animator.setAnimationSpeed(1);
						}
						animator.play(index, 1);
						break;
					case CharacterAnimation.KNOCKBACK:
					case CharacterAnimation.BLOCKING:
					case CharacterAnimation.STUNNED:
					case CharacterAnimation.STAND:
					case CharacterAnimation.CHARGING:
						animator.setAnimationSpeed(1);
						animator.play(index);
						break;
				}
			}
		}
		
		override public function update(delta:Number):void
		{
			if(paused) return;
			
			if (target > -1)
			{
				if (target != x)
				{
					var movementDelta:Number = delta * currentVelocity;
					if (Math.abs(x - target) < Math.abs(movementDelta))
					{
						x = target;
					}
					else x += movementDelta;
				}
				else
				{
					target = -1;
					currentVelocity = 0;
				}
			}
			else
			{
				if(acceleration != 0 && currentVelocity != 0)
				{
					var nextVelocity:Number = currentVelocity + acceleration * delta;
					if ((currentVelocity > 0 && nextVelocity < 0) ||
						(currentVelocity < 0 && nextVelocity > 0))
					{
						currentVelocity = 0;
					}
					else
					{
						currentVelocity = nextVelocity;
					}
				}
				if(currentVelocity != 0)
				{
					if (((teamID == TeamID.LEFT && currentVelocity > 0) || (teamID == TeamID.RIGHT && currentVelocity < 0)) && getCurrentAnimation() != CharacterAnimation.CHARGING)
					{
						var fXPred:Number = x + delta * currentVelocity;
						var bCanMove:Boolean = true;
						if (oWorld != null)
							bCanMove = oWorld.CanMove(this, fXPred);
						if (bCanMove)
							x = fXPred;
					}
					else x += delta * currentVelocity;
				}
				x = Utility.math.clamp(x, 0, Game.WIDTH - getWidth());
			}
			
			updateStatus();
			updateDisplayDamageText(delta);
		}
		
		private function updateDisplayDamageText(delta:Number):void {
			if (damageTextDelay < DELAY_DISPLAY_DAMAGE_TEXT) {
				damageTextDelay += delta;
				return;
			}
			
			var obj:Object = damageValues.shift();
			if (obj) {
				var damageText:DamageText = Manager.pool.pop(DamageText) as DamageText;
				damageText.addEventListener(DamageText.COMPLETE, onPlayDamageTextCompleteHdl);
				damageText.setText(( obj.value).toString(), obj.isCritical, teamID);
				if (animator) {
					damageText.x = getWidth() >> 1 - damageText.width >> 1;	
				} else {
					damageText.x = - damageText.width >> 1;
				}
				damageText.y = -75;
				addChild(damageText);
			}
			damageTextDelay = 0;
		}
		
		private function updateStatus():void
		{
			var effectsCopy:Array = effects.slice();
			var i:int;
			var length:int;
			var effect:VisualEffect;
			var index:int;
			for (i = 0, length = effectsCopy.length; i < length; ++i)
			{
				effect = effectsCopy[i];
				if (effect.isDead)
				{
					index = effects.indexOf(effect);
					effects.splice(index, 1);
				}
				else
				{
					effect.x = x + (getWidth() >> 1);
				}
			}
		}
		
		public function setKnockback(value:Boolean):void { knockback = value; }
		
		public function getEffect(effectID:int):VisualEffect {
			for each(var effect:VisualEffect in effects) {
				if(effect.getXmlData().ID == effectID) {
					return effect;
				}
			}
			return null;
		}
	}
}