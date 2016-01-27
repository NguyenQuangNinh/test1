package game.ui.dialog.dialogs.select_class 
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import core.Manager;
	import core.event.EventEx;
	import core.util.FontUtil;
	
	import game.Game;
	import game.data.model.Character;
	import game.data.vo.skill.Skill;
	import game.data.xml.CharacterXML;
	import game.data.xml.DataType;
	import game.data.xml.SkillXML;
	import game.data.xml.UnitClassXML;
	import game.enum.Font;
	import game.ui.components.CharacterSlot;
	import game.ui.components.ScrollBar;
	import game.ui.components.SkillSlotSimple;
	import game.ui.dialog.dialogs.DialogEvent;
	
	/**
	 * ...
	 * @author MaiPTT
	 */
	public class SubClassItem extends MovieClip 
	{
		private static const MAX_SKILLS_PER_LINE	:int = 2;
		
		public var movBackground		:MovieClip;
		public var characterSlotContainer	:MovieClip;
		
		public var txtDescription		:TextField;
		public var txtSubClassName		:TextField;
		public var scrollbarMov			:ScrollBar;
		public var activeSkillsContainer:MovieClip;
		public var passiveSkillsContainer:MovieClip;
		
		private var _character			:Character;
		private var _characterSlot		:CharacterSlot;
		private var _skillSlots			:Array;
		private var _isSelect			:Boolean;
		private var _index				:int;
		private var activeSkillSlots:Array = [];
		private var passiveSkillSlots:Array = [];
		
		public function SubClassItem() {
			_skillSlots = [];
			initUI();
			addEventListener(MouseEvent.CLICK, onItemSelectHdl);
		}
		
		private function onItemSelectHdl(e:MouseEvent):void {
			if (!_isSelect) {
				dispatchEvent(new EventEx(DialogEvent.SUB_CLASS_SELECTED, {index:_index, value:_character }));	
			}
		}
		
		private function initUI():void {
			_characterSlot = new CharacterSlot();
			_characterSlot.setData(null);
			characterSlotContainer.addChild(_characterSlot);
			
			FontUtil.setFont(txtDescription, Font.ARIAL);
			FontUtil.setFont(txtSubClassName, Font.ARIAL, true);
			
			this.buttonMode = true;
			movBackground.gotoAndStop(1);
			
			for(var i:int = 0; i < 3; ++i)
			{
				var skillSlot:SkillSlotSimple = new SkillSlotSimple();
				skillSlot.x = i * 45;
				activeSkillsContainer.addChild(skillSlot);
				activeSkillSlots.push(skillSlot);
			}
			for(i = 0; i < 1; ++i)
			{
				skillSlot = new SkillSlotSimple();
				passiveSkillsContainer.addChild(skillSlot);
				passiveSkillSlots.push(skillSlot);
			}
		}
		
		public function get isSelect():Boolean 	{
			return _isSelect;
		}
		
		public function set isSelect(value:Boolean):void {
			_isSelect = value;
			if (_isSelect) {
				movBackground.gotoAndStop(2);
			} else {
				movBackground.gotoAndStop(1);
			}
		}
		
		public function get index():int {
			return _index;
		}
		
		public function set index(value:int):void {
			_index = value;
		}
		
		public function getData():Character { return _character; }
		
		public function setData(character:Character):void
		{
			_character = character;
			
			if(character != null && character.xmlData != null)
			{
				_characterSlot.setData(character);
				var characterXML:CharacterXML = character.xmlData;
				var classXML:UnitClassXML = Game.database.gamedata.getData(DataType.UNITCLASS, characterXML.characterClass) as UnitClassXML;
				if(classXML != null)
				{
					txtDescription.text = classXML.description;
					txtSubClassName.text = classXML.subClassName;
				}
				
				var skillSlot:SkillSlotSimple;
				var skill:Skill;
				for(var i:int = 0; i < activeSkillSlots.length; ++i)
				{
					skillSlot = activeSkillSlots[i];
					skill = new Skill();
					skill.xmlData = Game.database.gamedata.getData(DataType.SKILL, characterXML.activeSkills[i]) as SkillXML;
					skillSlot.setData(skill);
				}
				for(i = 0; i < passiveSkillSlots.length; ++i)
				{
					skillSlot = passiveSkillSlots[i];
					skill = new Skill();
					skill.xmlData = Game.database.gamedata.getData(DataType.SKILL, characterXML.passiveSkill) as SkillXML;
					skillSlot.setData(skill);
				}
			}
		}
	}

}