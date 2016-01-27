package game.ui.components 
{
	import com.greensock.TweenMax;
	import core.display.BitmapEx;
	import core.event.EventEx;
	import core.Manager;
	import core.util.Utility;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import game.data.model.Character;
	import game.data.vo.skill.Skill;
	import game.data.xml.DataType;
	import game.data.xml.ElementData;
	import game.enum.SkillType;
	import game.enum.TeamID;
	import game.Game;
	import game.main.SkillSlot;
	import game.ui.ingame.CharacterObject;
	import game.ui.tutorial.TutorialEvent;
	
	
	

	//import game.main.SkillSlot;
	//import game.ui.components.SkillSlot;
	
	/**
	 * ...
	 * @author bangnd2
	 */
	public class CharacterAvatar extends MovieClip 
	{
		public static const USE_SKILL:String = "use_skill";
		public static const FOCUS_IN:String = "focus_in";
		public static const FOCUS_OUT:String = "focus_out";
		
		public var movHPBar:MovieClip;
		public var movManaBar:MovieClip;
		public var movAvatarContainer:MovieClip;
		public var movElement:MovieClip;
		public var skillSlot:SkillSlot;
		
		private var bmpAvatar:BitmapEx;
		private var bmpElement:BitmapEx;
		private var data:CharacterObject;
		
		public function CharacterAvatar() 
		{
			skillSlot.setType(SkillSlot.INGAME);
			skillSlot.setEnabled(false);
			
			bmpAvatar = new BitmapEx();
			bmpAvatar.addEventListener(BitmapEx.LOADED, onAvatarLoadedHdl);
			movAvatarContainer.addChild(bmpAvatar);
			
			bmpElement = new BitmapEx();
			movElement.addChild(bmpElement);

			addEventListener(MouseEvent.CLICK, onClicked);
			addEventListener(MouseEvent.MOUSE_OVER, skillSlot_mouseOver);
			addEventListener(MouseEvent.MOUSE_OUT, skillSlot_mouseOut);
			
			mouseChildren = false;
		}
		
		private function onAvatarLoadedHdl(e:Event):void {
			if (!data) return;
			switch(data.teamID) {
				case TeamID.RIGHT:
					bmpAvatar.scaleX = -1;
					bmpAvatar.x = bmpAvatar.width / 2;
					bmpAvatar.y = - bmpAvatar.height / 2;
					break;
					
				default:
					bmpAvatar.scaleX = 1;
					bmpAvatar.x = - bmpAvatar.width / 2;
					bmpAvatar.y = - bmpAvatar.height / 2;
					break;
			}
		}
		
		private function skillSlot_mouseOver(e:MouseEvent):void 
		{
			if(data != null && data.ID != 0)
				dispatchEvent(new Event(FOCUS_IN, true));
		}
		
		private function skillSlot_mouseOut(e:MouseEvent):void 
		{
			if(data != null && data.ID != 0)
				dispatchEvent(new Event(FOCUS_OUT, true));
		}
		
		public function cooldownSkill(time:Number):void
		{
			skillSlot.cooldown(time);
		}
		
		public function reset():void
		{
			setData(null);
		}
		
		private function onClicked(e:MouseEvent):void 
		{
			dispatchEvent(new Event(USE_SKILL, true));
			e.stopPropagation();
		}
		
		public function setData(data:CharacterObject):void
		{
			if (this.data != null)
			{
				this.data.removeEventListener(CharacterObject.DIE, onDie);
				this.data.removeEventListener(CharacterObject.HP_CHANGED, onHPChanged);
				this.data.removeEventListener(CharacterObject.MP_CHANGED, onMPChanged);
			}

			this.data = data;
			if (data != null && data.getData() != null)
			{
				var character:Character = data.getData();
				bmpAvatar.visible = true;
				bmpAvatar.load(character.xmlData.smallAvatarURLs[character.sex]);
				
				var elementData:ElementData = Game.database.gamedata.getData(DataType.ELEMENT, character.element) as ElementData;
				if (elementData) {
					bmpElement.load(elementData.formationSlotImgURL);
				}
				var skill:Skill = character.getEquipSkill(SkillType.ACTIVE);
				//Utility.log("init skill for character " + character.ID + " is " + (skill != null ? skill.xmlData.name : " null"));
				if (skill != null && skill.xmlData != null)
				{
					skillSlot.setData(skill);
				} else {
					skillSlot.setData(null);
				}
				
				data.addEventListener(CharacterObject.DIE, onDie);
				data.addEventListener(CharacterObject.HP_CHANGED, onHPChanged);
				data.addEventListener(CharacterObject.MP_CHANGED, onMPChanged);
				TweenMax.to(this, 0, { colorMatrixFilter: { saturation:1 }} );
			}
			else
			{
				skillSlot.setData(null);
				skillSlot.setEnabled(false);
				bmpAvatar.visible = false;
				TweenMax.to(this, 0, { colorMatrixFilter: { saturation:0 }} );
			}
			updateHPBar();
			updateMPBar();
		}

		private function onDie(event:Event):void
		{
			data.removeEventListener(CharacterObject.DIE, onDie);
			data.removeEventListener(CharacterObject.HP_CHANGED, onHPChanged);
			data.removeEventListener(CharacterObject.MP_CHANGED, onMPChanged);
		}
		
		private function onHPChanged(e:Event):void 
		{
			updateHPBar();
		}
		
		private function onMPChanged(e:Event):void 
		{
			updateMPBar();
		}
		
		private function updateHPBar():void
		{
			var scale:Number = 0;
			if (data != null && data.getMaxHP() > 0)
			{
				scale = data.getCurrentHP() / data.getMaxHP();
			}
			TweenMax.to(movHPBar, 0.2, { scaleX:scale });
		}
		
		private function updateMPBar():void
		{
			var scale:Number = 0;
			if (data != null) scale = data.getCurrentMP() / CharacterObject.MAX_MP;
			TweenMax.to(movManaBar, 0.2, { scaleX:scale } );
			skillSlot.setEnabled(scale == 1);
			if (scale == 1 && skillSlot.getData() && data) {
				dispatchEvent(new EventEx(TutorialEvent.EVENT, { type:TutorialEvent.SKILL_ACTIVED, 
																x:(350 + data.formationIndex * (movAvatarContainer.width + 5)),
																y:528,
																index:data.formationIndex}, true));
			}
		}
		
		public function getData():CharacterObject
		{
			return data;
		}
	}
}