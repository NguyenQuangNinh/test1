package game.ui.tooltip.tooltips 
{
	import core.util.FontUtil;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import game.data.vo.skill.Skill;
	import game.data.vo.skill.Stance;
	import game.enum.Font;
	import game.ui.tooltip.TooltipBase;
	
	/**
	 * ...
	 * @author MaiPTT
	 */
	public class SkillSlotTooltip extends TooltipBase 
	{
		public var txtName			:TextField;
		public var txtDescription	:TextField;
		public var txtLevel			:TextField;
		public var movBackground	:MovieClip;
		//public var txtStance1		:TextField;
		//public var txtStance2		:TextField;
		//public var txtStance3		:TextField;
		//public var txtStanceDesc1	:TextField;
		//public var txtStanceDesc2	:TextField;
		//public var txtStanceDesc3	:TextField;
		private var txtStances		:Array;
		private var txtStancesDesc	:Array;
		private var _model			:Skill;
		
		private static const EFFECT_START_FROM_X:int = 5;
		private static const EFFECT_START_FROM_Y:int = 120;
		
		private var _effectUIArr:Array = [];
		
		public function SkillSlotTooltip() {
			initUI();
		}
		
		private function initUI():void {
			FontUtil.setFont(txtName, Font.ARIAL);
			FontUtil.setFont(txtDescription, Font.ARIAL);
			FontUtil.setFont(txtLevel, Font.ARIAL);
			/*FontUtil.setFont(txtStance1, Font.ARIAL);
			FontUtil.setFont(txtStance2, Font.ARIAL);
			FontUtil.setFont(txtStance3, Font.ARIAL);
			FontUtil.setFont(txtStanceDesc1, Font.ARIAL);
			FontUtil.setFont(txtStanceDesc2, Font.ARIAL);
			FontUtil.setFont(txtStanceDesc3, Font.ARIAL);*/
			
			txtStances = [];
			txtStancesDesc = [];
			
			/*txtStances.push(txtStance1);
			txtStances.push(txtStance2);
			txtStances.push(txtStance3);
			
			txtStancesDesc.push(txtStanceDesc1);
			txtStancesDesc.push(txtStanceDesc2);
			txtStancesDesc.push(txtStanceDesc3);*/
		}
		
		public function set model(value:Skill):void {
			_model = value;
			
			//clear effect UI
			for each(var effectUI:SkillEffectUI in _effectUIArr) {
				removeChild(effectUI);
			}
			_effectUIArr = [];
			
			if (_model && _model.xmlData) {
				txtName.text = _model.xmlData.name;
				txtDescription.text = _model.xmlData.desc.toString();
				txtLevel.text = _model.level.toString();
				/*if (_model.stances) {
					var i:int = 0;
					for each (var stance:Stance in _model.stances) {
						if (stance && stance.xmlData) {
							txtStances[i].text = stance.xmlData.name;
							txtStancesDesc[i].text = stance.xmlData.desc;
							
							i++;
						}
					}
				}*/
				
				var bgHeight:int = txtDescription.y + txtDescription.textHeight + 10;
				var i:int = 0;
				for each(var effect:XML in _model.xmlData.effectArr) {
					effectUI = new SkillEffectUI();
					effectUI.x = EFFECT_START_FROM_X;
					effectUI.y = bgHeight + (effectUI.height + 10)* i;
					effectUI.updateEffect(_model.inCharacterID, _model.inCharacterSubClass, _model.xmlData.ID, _model.level, effect, false, _model.owner);
					addChild(effectUI);
					_effectUIArr.push(effectUI);
					bgHeight += effectUI.height
				}
				
				movBackground.height = bgHeight + 10;
			} else {
				visible = false;
			}
		}
	}

}