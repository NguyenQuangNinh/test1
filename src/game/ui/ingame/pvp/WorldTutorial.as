package game.ui.ingame.pvp 
{
	import core.display.layer.LayerManager;
	import core.event.EventEx;
	import core.Manager;
	import core.util.Utility;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.utils.setTimeout;
	import game.Game;
	import game.net.game.ingame.IngamePacket;
	import game.net.game.ingame.ResponseAddEffect;
	import game.net.game.ingame.ResponseCastSkill;
	import game.net.game.ingame.ResponseCreateBullet;
	import game.net.game.ingame.ResponseCreateObject;
	import game.net.game.ingame.ResponseObjectStatus;
	import game.net.game.ingame.ResponseUpdateHP;
	import game.net.game.ingame.ResponseUpdateObject;
	import game.net.game.response.ResponseIngame;
	import game.ui.ModuleID;
	import game.ui.tutorial.TutorialEvent;
	import game.ui.ingame.BaseObject;
	import game.ui.ingame.CharacterObject;

	/**
	 * ...
	 * @author ...
	 */
	public class WorldTutorial extends WorldPvE
	{
		private var tutorialStep:int = 0;
		private var pause:Boolean = false;
		private var endIngameTutorial:Boolean = false;
		
		public function WorldTutorial() 
		{
			Manager.display.getStage().addEventListener(Event.ACTIVATE, stage_onActivate);
			Manager.display.getStage().addEventListener(Event.DEACTIVATE, stage_onDeactivate);
		}
		
		private function stage_onDeactivate(e:Event):void 
		{
			//pause = true;
		}
		
		private function stage_onActivate(e:Event):void 
		{
			pause = false;
		}
		
		private function setEndIngameTutorial():void {
			//Lam gi thi lam nha Mai
			if (endIngameTutorial == false)
			{
				endIngameTutorial = true;
				Utility.log("end game tutorial");
				Game.logService.requestTracking("1_200", "end game tutorial");
				Manager.display.hideModule(ModuleID.INGAME_PVP);
				Manager.display.showModule(ModuleID.TUTORIAL, new Point(), LayerManager.LAYER_MESSAGE, "top_left");
				dispatchEvent(new EventEx(TutorialEvent.EVENT, { type:TutorialEvent.OPENING_TUTORIAL_END_GAME }, true));
			}			
		}
		
		private function createTutorialCharacter():void
		{
			var packet:ResponseCreateObject = new ResponseCreateObject();
			packet.type = IngamePacket.CREATE_OBJECT;
			packet.objectID = 1;
			packet.xmlID = 50;
			packet.x = 40;
			packet.y = 0;
			packet.teamID = 1;
			packet.speed = 225;
			packet.maxHP = 100000;
			packet.currentHP = 100000;
			packet.formationIndex = 1;
			packet.userID = -1;
			packet.currentMP = 0;
			packet.attackSpeed = 2000;
			
			var packetTLN:ResponseCreateObject = new ResponseCreateObject();
			packetTLN.type = IngamePacket.CREATE_OBJECT;
			packetTLN.objectID = 2;
			packetTLN.xmlID = 51;
			packetTLN.x = 0;
			packetTLN.y = 0;
			packetTLN.teamID = 1;
			packetTLN.speed = 225;
			packetTLN.maxHP = 100000;
			packetTLN.currentHP = 100000;
			packetTLN.formationIndex = 0;
			packetTLN.userID = -1;
			packetTLN.currentMP = 0;
			packetTLN.attackSpeed = 2000;			
			
			var packetLMS:ResponseCreateObject = new ResponseCreateObject();
			packetLMS.type = IngamePacket.CREATE_OBJECT;
			packetLMS.objectID = 3;
			packetLMS.xmlID = 247;
			packetLMS.x = 1220;
			packetLMS.y = 0;
			packetLMS.teamID = 2;
			packetLMS.speed = 225;
			packetLMS.maxHP = 100000;
			packetLMS.currentHP = 100000;
			packetLMS.formationIndex = 7;
			packetLMS.userID = -1;
			packetLMS.currentMP = 0;
			packetLMS.attackSpeed = 2000;
			
			var packetIngame:ResponseIngame = new ResponseIngame();
			packetIngame.subpackets = [];
			packetIngame.subpackets.push(packet);
			packetIngame.subpackets.push(packetLMS);
			packetIngame.subpackets.push(packetTLN);
			processPacket(packetIngame);
		}
		
		override public function init():void
		{
			setBackground(2);
			Game.logService.requestTracking("1_008", "world tutorial >> init background complete");
			prepareNextWave(0);
			createTutorialCharacter();
			Game.logService.requestTracking("1_009", "world tutorial >> create character complete");
			setTimeout(setEndIngameTutorial, 30000);
			endIngameTutorial = false;
			nextWaveReady();
		}

		private function CreateCharacter(objID:int,xmlID:int,velocity:int,maxHP:int,currHP:int, x:int, team:int,atkSpeed:int):void
		{
			var packet:ResponseCreateObject = new ResponseCreateObject();
			packet.type = IngamePacket.CREATE_OBJECT;
			packet.objectID = objID;
			packet.xmlID = xmlID;
			packet.x = x;
			packet.y = 0;
			packet.teamID = team;
			packet.speed = velocity;
			packet.maxHP = maxHP;
			packet.currentHP = currHP;
			packet.formationIndex = 7;
			packet.userID = -1;
			packet.currentMP = 0;
			packet.attackSpeed = atkSpeed;

			var packetIngame:ResponseIngame = new ResponseIngame();
			packetIngame.subpackets = [];
			packetIngame.subpackets.push(packet);

			processPacket(packetIngame);
		}

		private function CharacterMove(objectID:int, x:int, velocity:int, acceleration:int):void
		{
			var packet:ResponseUpdateObject = new ResponseUpdateObject();
			packet.type = IngamePacket.UPDATE_OBJECT;
			packet.objectID = objectID;
			packet.x = x;
			packet.velocity = velocity;
			packet.acceleration = acceleration;		
			
			var packetIngame:ResponseIngame = new ResponseIngame();
			packetIngame.subpackets = [];
			packetIngame.subpackets.push(packet);
			
			processPacket(packetIngame);
		}
		
		private function ChangeHP(objectID:int, hp:int, critical:Boolean):void {
			var packet:ResponseUpdateHP = new ResponseUpdateHP();
			packet.type = IngamePacket.UPDATE_HP;
			packet.objectID = objectID;
			packet.currentHP = hp;
			packet.critical = critical;
			
			var packetIngame:ResponseIngame = new ResponseIngame();
			packetIngame.subpackets = [];
			packetIngame.subpackets.push(packet);
			
			processPacket(packetIngame);
		}
		
		private function ChangeAnim(objectID:int, animID:int):void {
			var packet:ResponseObjectStatus = new ResponseObjectStatus();
			packet.objectID = objectID;
			packet.type = IngamePacket.OBJECT_STATUS;
			packet.status = animID;
			
			var packetIngame:ResponseIngame = new ResponseIngame();
			packetIngame.subpackets = [];
			packetIngame.subpackets.push(packet);
			
			processPacket(packetIngame);
		}
		
		public function animCountdownComplete():void {
			tutorialStep = 1;
		}
		
		//DQ va TLN cast skill combo
		private function DQTLNCastComboSkill():void {
			var packet:ResponseCastSkill = new ResponseCastSkill();
			packet.objectID = 1;
			packet.type = IngamePacket.CAST_SKILL;
			packet.objectIDs = [];
			packet.objectIDs.push(1);
			packet.skillXMLID = 63;

			var packet1:ResponseCastSkill = new ResponseCastSkill();
			packet1.objectID = 2;
			packet1.type = IngamePacket.CAST_SKILL;
			packet1.objectIDs = [];
			packet1.objectIDs.push(2);
			packet1.skillXMLID = 88;

			var packetIngame:ResponseIngame = new ResponseIngame();
			packetIngame.subpackets = [];
			packetIngame.subpackets.push(packet);
			packetIngame.subpackets.push(packet1);

			processPacket(packetIngame);
		}
		
		public function characterCastSkill(objectID:int, skillID:int):void {
			var packet:ResponseCastSkill = new ResponseCastSkill();
			packet.objectID = objectID;
			packet.type = IngamePacket.CAST_SKILL;
			packet.objectIDs = [];
			packet.objectIDs.push(objectID);
			packet.skillXMLID = skillID;
			
			var packetIngame:ResponseIngame = new ResponseIngame();
			packetIngame.subpackets = [];
			packetIngame.subpackets.push(packet);
			
			processPacket(packetIngame);
		}
		
		//Skill Realese
		private function releaseSkill(objectID:int):void {
			var packet:IngamePacket = new IngamePacket();
			packet.objectID = objectID;
			packet.type = IngamePacket.RELEASE_SKILL;
			
			var packetIngame:ResponseIngame = new ResponseIngame();
			packetIngame.subpackets = [];
			packetIngame.subpackets.push(packet);

			processPacket(packetIngame);
			
			if (tutorialStep == 15) {
				var objID:int = 4;
				var xmlID:int = 297;
				var caster:CharacterObject = getObject(3) as CharacterObject;

				CharacterMove(caster.ID,caster.x,0,0);

				for (var i:int = 0; i < 4; i++)
				{
					var delayTime:int = Math.random() * 2000;
					setTimeout(CreateCharacter, delayTime, objID + i,xmlID,-225,4560,4560,caster.x,2,6);
					setTimeout(ChangeAnim, delayTime, objID + i,1);
				}
			}

			if(tutorialStep == 16)
			{
				caster = getObject(2) as CharacterObject;
				createBullet(11, 2, 1, 900, caster.x, 0, 95);
				setTimeout(destroyBullet, 1000, 11);
				tutorialStep = 17;
			}

//			if (tutorialStep == 18) {
//				for each (var duongWa:BaseObject in objects)
//				{
//					if (duongWa.ID == 1) {
//						createBullet(4, 1, 1, 350, duongWa.x, 0, 63);
//						tutorialStep = 19;
//						duongWa.visible = false;
//						break;
//					}
//				}
//			}
			
//			if (tutorialStep == 26) {
//				bulletID = 4;
//				var effectID:int  = 69;
//				for (i = 0; i < 50; i++) {
//					delayTime = Math.random() * 2000;
//					randomX = Math.random() * 400 + 600;
//					setTimeout(createBullet, delayTime, bulletID, 1, 1, 0, randomX, 0, effectID);
//					setTimeout(destroyBullet, 500 + delayTime, bulletID);
//					bulletID++;
//					effectID = effectID == 69 ? 70 : 69;
//				}
//
//				for each (var object:BaseObject in objects)
//				{
//					if (object.ID == 1 || object.ID == 2) {
//						CharacterMove(object.ID, object.x, 0, 0);
//						ChangeAnim(object.ID, 0);
//					}
//				}
//			}
		}
		
		private function createBullet(objectID:int, characterCreate:int, teamID:int, speed:int, x:int, y:int, effectID:int):void {
			var packet:ResponseCreateBullet = new ResponseCreateBullet();
			packet.objectID = objectID;
			packet.type = IngamePacket.CREATE_BULLET;
			packet.effectID = effectID;
			packet.nCharacterIDCreate = characterCreate;
			packet.teamID = teamID;
			packet.speed = speed;
			packet.x = x;
			packet.y = y;
			
			var packetIngame:ResponseIngame = new ResponseIngame();
			packetIngame.subpackets = [];
			packetIngame.subpackets.push(packet);
			
			processPacket(packetIngame);
		}
		
		//DQ & TLN bi - mau
		private function changeHPSkillLMS():void {
			ChangeHP(1, -25000, false);
			ChangeHP(2, -25000, false);
			var oCharacter:CharacterObject;
			for each (var object:BaseObject in objects)
			{
				if (object != null && object is CharacterObject && !object.isDead && (object.ID == 1 || object.ID == 2))
				{
					oCharacter = CharacterObject(object);
					ChangeAnim(oCharacter.ID, 5);
					oCharacter.isKnockBacking = true;
					CharacterMove(oCharacter.ID, oCharacter.x, -1000, 2500);
				}
			}
		}		
		
		//Add Effect skill DQ len LMS
		private function addEffectSkillDQonLMS(effectID:int ):void {
			for each (var LMS:BaseObject in objects)
			{
				if (LMS.ID == 3) {
					CharacterObject(LMS).isKnockBacking = true;
					break;
				}
			}
			var packetEffectDQ:ResponseAddEffect = new ResponseAddEffect();
			packetEffectDQ.objectID = 4;
			packetEffectDQ.type = IngamePacket.ADD_EFFECT;
			packetEffectDQ.teamID = 1;
			packetEffectDQ.effectID = effectID;
			packetEffectDQ.x = LMS.x;
			
			var packetIngame:ResponseIngame = new ResponseIngame();
			packetIngame.subpackets = [];
			packetIngame.subpackets.push(packetEffectDQ);
			processPacket(packetIngame);
			
			ChangeHP(3, -5000, false);
			ChangeAnim(3, 5);
			if (effectID != 68) {
				CharacterMove(3, LMS.x, 1000, -3500);
			}else {
				CharacterMove(3, LMS.x, 1000, -1500);
			}			
		}
		
		private function destroyBullet(objectID:int):void {
			var packet:IngamePacket = new IngamePacket();
			packet.objectID = objectID;
			packet.type = IngamePacket.DESTROY_OBJECT;
			
			var packetIngame:ResponseIngame = new ResponseIngame();
			packetIngame.subpackets = [];			
			
//			//DQ tung skill trung LMS, LMS bi mat mau va bi day lui
//			if (tutorialStep == 19){
//				addEffectSkillDQonLMS(64);
//				setTimeout(addEffectSkillDQonLMS, 500, 65);
//				setTimeout(addEffectSkillDQonLMS, 1000, 66);
//				setTimeout(addEffectSkillDQonLMS, 1500, 67);
//				setTimeout(addEffectSkillDQonLMS, 2000, 68);
//			}
//			if (tutorialStep >= 26 && tutorialStep <= 27){
//				for each (var LMS: BaseObject in objects){
//					if (LMS.ID == 3 && CharacterObject(LMS).getCurrentHP() > 0) {
//						for each (var bullet:BaseObject in objects){
//							if (bullet.ID == objectID) {
//								if (Math.abs(bullet.x - LMS.x) < 50) {
//									ChangeHP(3, -5000, false);
//								}
//							}
//						}
//					}
//				}
//				if (objectID == 53) {
//					var LMSDie:IngamePacket = new IngamePacket();
//					LMSDie.objectID = 3;
//					LMSDie.type = IngamePacket.DESTROY_OBJECT;
//					packetIngame.subpackets.push(LMSDie);
//					setTimeout(setEndIngameTutorial, 1000);
//				}
//			}
			packetIngame.subpackets.push(packet);			
			processPacket(packetIngame);
		}
		
		override protected function onEnterFrame(event:Event):void
		{
			if (pause) {
				return;
			}
			super.onEnterFrame(event);
			
			//Step 1: cac nhan vat di chuyen ra giua
			if (tutorialStep == 1)
			{
				ChangeAnim(1, 1);
				ChangeAnim(2, 1);
				ChangeAnim(3, 1);
				CharacterMove(1, 40, 255, 0);
				CharacterMove(2, 0, 255, 0);
				CharacterMove(3, 1220, -255, 0);
				tutorialStep = 2;
			}
			
//			Step 2: 2 ben danh nhau binh thuong
			if (tutorialStep >= 2 && tutorialStep <= 13) {
				var oCharacter:CharacterObject;
				var oEnemy:CharacterObject;
				for each (var object:BaseObject in objects)
				{
					if (object != null && object is CharacterObject && !object.isDead && object.teamID == 1)
					{
						for each (var object2:BaseObject in objects)
						{
							if (object2 != null && object2.teamID == 2 && !object2.isDead)
							{
								//tru mau va knock back
								oCharacter = CharacterObject(object);
								oEnemy = CharacterObject(object2);
								if (oCharacter.x + oCharacter.getXMLData().width >= oEnemy.x)
								{
									ChangeAnim(oCharacter.ID, 5);
									oCharacter.isKnockBacking = true;
									CharacterMove(oEnemy.ID, oEnemy.x, 850, -2500);
									ChangeAnim(oEnemy.ID, 5);
									oEnemy.isKnockBacking = true;
									if (tutorialStep >= 10) {
										CharacterMove(oCharacter.ID, oCharacter.x, -1500, 1600);
									}
									else {
										CharacterMove(oCharacter.ID, oCharacter.x, -1000, 2500);
									}
									var damage:int = Math.random() * 1000 + 8000;
									var critical:Boolean = Math.random() > 0.7 ? true : false;
									damage = critical == true ? damage * 1.5 : damage;
									ChangeHP(oCharacter.ID, -damage, critical);

									damage = Math.random() * 1000 + 3000;
									critical = Math.random() > 0.7 ? true : false;
									damage = critical == true ? damage * 1.5 : damage;
									ChangeHP(oEnemy.ID, -damage, critical);
									if (tutorialStep < 12) {
										tutorialStep++;
									}
									Utility.log( "normal knock back tutorialStep : " + tutorialStep );
									Game.logService.requestTracking("1_" + (100 + tutorialStep), "tutorial step");
								}

								//dung lai va tiep tuc chay len sau khi knock back
								if (oCharacter.isKnockBacking == true && oCharacter.currentVelocity >= 0)
								{
									CharacterMove(oCharacter.ID, oCharacter.x, 255, 0);
									ChangeAnim(oCharacter.ID, 1);
									oCharacter.isKnockBacking = false;
									if (tutorialStep >= 12 && tutorialStep <= 13) {
										tutorialStep++;
										Utility.log( "big knock back tutorialStep : " + tutorialStep );
										Game.logService.requestTracking("1_" + (100 + tutorialStep), "big knock back");
										if (oCharacter.ID == 1) {
											CharacterMove(oCharacter.ID, oCharacter.x, 100, 0);
										}else {
											CharacterMove(oCharacter.ID, oCharacter.x, 50, 0);
										}

									}
								}
								if (oEnemy.isKnockBacking == true && oEnemy.currentVelocity <= 0)
								{
									CharacterMove(oEnemy.ID, oEnemy.x, -255, 0);
									ChangeAnim(oEnemy.ID, 1);
									oEnemy.isKnockBacking = false;
								}
							}
						}
					}
				}
			}

			//Step 3: Tay Doc cast skill
			if (tutorialStep == 14) {
				characterCastSkill(3, 90);
				setTimeout(releaseSkill, 2400, 3);
				tutorialStep = 15;
			}

			//Step 4: Quach Tinh cast skill
			if(tutorialStep == 15 && objects.length == 10)
			{
				setTimeout(function():void {
					characterCastSkill(1, 63);
					setTimeout(releaseSkill, 2400, 1);
				},500);
				tutorialStep = 16;
			}

			//Step 5: Bullet giet het Team Tay Doc
			if(tutorialStep == 17)
			{
				var thanlongBaiViBullet:BaseObject = getObject(11);
				var packetIngame:ResponseIngame = new ResponseIngame();
				packetIngame.subpackets = [];
				var team2Count:int = 0;
				for each (object2 in objects)
				{
					if (object2 != null && object2 is CharacterObject && object2.teamID == 2 && !object2.isDead && object2.ID > 0)
					{
						team2Count++;
						oEnemy = CharacterObject(object2);
						if (thanlongBaiViBullet.x + thanlongBaiViBullet.width >= oEnemy.x)
						{
							if(oEnemy.ID == 3)
							{
								ChangeHP(3, -oEnemy.getCurrentHP(),false);
							}

							var packet:IngamePacket = new IngamePacket();
							packet.objectID = oEnemy.ID;
							packet.type = IngamePacket.DESTROY_OBJECT;
							packetIngame.subpackets.push(packet);
						}
					}
				}

				processPacket(packetIngame);

				//Tieu diet het team Tay Doc
				if(team2Count == 0)
				{
					ChangeAnim(1, 0);
					ChangeAnim(2, 0);
					setTimeout(setEndIngameTutorial, 1000);
//					tutorialStep = 18;
				}
			}

//			//Step 4: Skill cua LMS bay ra day lui DQ va TLN
//			if (tutorialStep >= 15 && tutorialStep <= 16) {
//				for each (object in objects)
//				{
//					if (object != null && object is CharacterObject && !object.isDead && (object.ID == 1 || object.ID == 2))
//					{
//						oCharacter = CharacterObject(object);
//						if (oCharacter.isKnockBacking == true && oCharacter.currentVelocity >= 0)
//						{
//							ChangeAnim(oCharacter.ID, 1);
//							oCharacter.isKnockBacking = false;
//							if (oCharacter.ID == 1) {
//								CharacterMove(oCharacter.ID, oCharacter.x, 70, 0);
//							}else {
//								CharacterMove(oCharacter.ID, oCharacter.x, 50, 0);
//							}
//							tutorialStep++;
//							//tutorialStep = 17;
//							Utility.log( "DQ TNL knock back tutorialStep : " + tutorialStep );
//							Game.logService.requestTracking("1_" + (100 + tutorialStep), "DQ TLN knock back");
//						}
//					}
//				}
//			}

//			//Step 5: Duong Qua tung skill
//			if (tutorialStep == 17) {
//				characterCastSkill(1, 57);
//				setTimeout(releaseSkill, 2400, 1);
//				tutorialStep = 18;
//			}
//
//			//Step 6: Bullet cua Duong Qua cham vao LMS
//			if (tutorialStep == 19) {
//				for each (object in objects)
//				{
//					if (object != null && object.teamID == 1 && object.ID == 4)
//					{
//						for each (object2 in objects)
//						{
//							if (object2 != null && object2.teamID == 2 && !object2.isDead && object2 is CharacterObject)
//							{
//								if (object.x + 30 >= object2.x) {
//									destroyBullet(4);
//									tutorialStep = 20;
//								}
//							}
//						}
//					}
//				}
//			}
//
//			//Step 7: LMS trung skill DQ bi day lui
//			if (tutorialStep >= 20 && tutorialStep <= 24) {
//				for each (object in objects)
//				{
//					if (object != null && object is CharacterObject && !object.isDead && object.ID == 3)
//					{
//						oCharacter = CharacterObject(object);
//						if (oCharacter.isKnockBacking == true && oCharacter.currentVelocity <= 0)
//						{
//							ChangeAnim(oCharacter.ID, 1);
//							oCharacter.isKnockBacking = false;
//							CharacterMove(oCharacter.ID, oCharacter.x, -255, 0);
//							tutorialStep++;
//						}
//					}
//				}
//			}
//
//			//Step 8: DQ va TLN Combo Song Kiem Hop Bich
//			if (tutorialStep == 25) {
//				for each (object in objects)
//				{
//					if (object.ID == 1){
//						object.visible = true;
//						break;
//					}
//				}
//				DQTLNCastComboSkill();
//				setTimeout(releaseSkill, 2400, 1);
//				tutorialStep = 26;
//			}
//
//			//Step 9: DQ va TLN Combo Song Kiem Hop Bich
//			if (tutorialStep == 26) {
//				for each (object in objects)
//				{
//					if (object != null && object is CharacterObject && !object.isDead && object.ID == 3 && object.x <= 800)
//					{
//						ChangeAnim(3, 0);
//						CharacterMove(object.ID, object.x, 0, 0);
//						tutorialStep = 27;
//					}
//				}
//			}
		}
	}

}