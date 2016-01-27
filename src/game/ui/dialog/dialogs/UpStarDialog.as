package game.ui.dialog.dialogs 
{
	import core.event.EventEx;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import game.ui.tutorial.TutorialEvent;
	
	import core.Manager;
	import core.util.FontUtil;
	
	import game.Game;
	import game.data.model.Character;
	import game.data.vo.skill.Skill;
	import game.data.xml.DataType;
	import game.data.xml.SkillXML;
	import game.enum.Font;
	import game.main.SkillSlot;
	import game.ui.components.ScrollBar;
	import game.ui.dialog.dialogs.select_class.SkillInfoDetails;
	import game.utility.UtilityUI;
	
	/**
	 * ...
	 * @author MaiPTT
	 */
	public class UpStarDialog extends Dialog 
	{
		public var btnOk		:SimpleButton;
		public var movScrollbar	:ScrollBar;
		public var maskMovie	:MovieClip;
		public var contentMovie	:MovieClip;
		public var txtDescription	:TextField;
		public var txtClassName		:TextField;
		
		private var _skillSlots		:Array;
		private var _skillDatas		:Array;
		private var _character		:Character;
		
		public function UpStarDialog() {
			_skillSlots = [];
			initUI();
			initHandlers();
		}
		
		private function initUI():void {
			btnOk = UtilityUI.getComponent(UtilityUI.OK_BTN) as SimpleButton;
			btnOk.x = 109;
			btnOk.y = 352;
			addChild(btnOk);
			
			FontUtil.setFont(txtClassName, Font.ARIAL, true);
			FontUtil.setFont(txtDescription, Font.ARIAL);
			
			movScrollbar.init(contentMovie, maskMovie, "vertical", true, false, false, 0, 0, 0);
		}
		
		private function initHandlers():void {
			btnOk.addEventListener(MouseEvent.CLICK, onOK);
		}
		
		override public function get visible():Boolean {
			return super.visible;
		}
		
		override public function set visible(value:Boolean):void {
			super.visible = value;
			if (visible && data) {
				var character:Character = null;
				try {
					character = data as Character;
				}
				catch(e:Error) {}
				if(character != null)
				{
					txtDescription.text = "Chuyển chức trách thành công. \n Nhân vật " + character.name
						+ " của bạn đã nhận được chức trách";
					
					txtClassName.text = character.unitClassXML.subClassName;
					
					var skillSlot:SkillInfoDetails;
					for (var i:int = 0; i < _skillSlots.length; i++) {
						skillSlot = _skillSlots[i];
						contentMovie.removeChild(skillSlot);
						Manager.pool.push(skillSlot, SkillInfoDetails);
					}
					
					_skillSlots.splice(0);
					var skill:Skill;
					var skillID:int;
					for (i = 0; i < character.xmlData.activeSkills.length; i++) 
					{
						skillID = character.xmlData.activeSkills[i];
						if(skillID > 0)
						{
							skill = new Skill();
							skill.xmlData = Game.database.gamedata.getData(DataType.SKILL, character.xmlData.activeSkills[i]) as SkillXML;
							skillSlot = Manager.pool.pop(SkillInfoDetails) as SkillInfoDetails;
							skillSlot.model = skill;
							skillSlot.y = (SkillSlot.HEIGHT + 5) * _skillSlots.length;
							_skillSlots.push(skillSlot);
							contentMovie.addChild(skillSlot);
						}
					}
					
					if (!movScrollbar.isInit) {
						movScrollbar.init(contentMovie, maskMovie, "vertical", true, false, false, 0, 0, 0);
					} else {
						movScrollbar.reInit();
					}
				}
			}
		}
	}
}