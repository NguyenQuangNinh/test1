package game.ui.dialog.dialogs.select_class 
{
	import core.util.FontUtil;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import game.data.vo.skill.Skill;
	import game.enum.Font;
	import game.main.SkillSlot;
	
	/**
	 * ...
	 * @author MaiPTT
	 */
	public class SkillInfoDetails extends MovieClip 
	{
		public var movSkillSlotContainer		:MovieClip;
		public var txtSkillName					:TextField;
		private var skillSlot					:SkillSlot;
		
		public function SkillInfoDetails()	{
			FontUtil.setFont(txtSkillName, Font.ARIAL);
			skillSlot = new SkillSlot();
			movSkillSlotContainer.addChild(skillSlot);
		}
		
		public function set model(value:Skill):void {
			if (value && value.xmlData) {
				txtSkillName.text = value.xmlData.name;
				skillSlot.setData(value);
			}
		}
	}

}