package game.ui.tooltip.tooltips 
{
	import core.display.BitmapEx;
	import core.Manager;
	import core.util.Enum;
	import core.util.FontUtil;
	import core.util.Utility;
	import flash.display.MovieClip;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import game.data.model.Character;
	import game.data.vo.skill.Skill;
	import game.data.xml.DataType;
	import game.data.xml.ElementData;
	import game.data.xml.SkillXML;
	import game.enum.Element;
	import game.enum.Font;
	import game.enum.SkillType;
	import game.enum.UnitType;
	import game.Game;
	import game.main.SkillSlot;
	import game.ui.tooltip.TooltipBase;
	import game.utility.UtilityUI;
	
	/**
	 * ...
	 * @author MaiPTT
	 */
	public class CharacterSlotTooltip extends TooltipBase 
	{
		public var txtName			:TextField;
		public var txtMainClass		:TextField;
		public var txtSubClass		:TextField;
		public var txtCurrentStar	:TextField;
		public var txtElement		:TextField;
		public var txtEXP			:TextField;
		public var skillSlotsContainer	:MovieClip;
		public var movBackground		:MovieClip;
		public var movElement			:MovieClip;
		public var movStar				:MovieClip;
		public var movInfo				:MovieClip;
		public var movMystery			:MovieClip;
		
		private var _glow			:GlowFilter;
		private var _skillSlots		:Array;
		private var _elementBitmapEx	:BitmapEx;
		private var _elementData		:ElementData;
		
		public function CharacterSlotTooltip() 	{
			FontUtil.setFont(txtName, Font.ARIAL);
			FontUtil.setFont(txtMainClass, Font.ARIAL );
			FontUtil.setFont(txtSubClass, Font.ARIAL);
			FontUtil.setFont(txtCurrentStar, Font.ARIAL, true);
			FontUtil.setFont(txtEXP, Font.ARIAL, true);
			FontUtil.setFont(txtVitality, Font.ARIAL, true);
			FontUtil.setFont(txtStrength, Font.ARIAL, true);
			FontUtil.setFont(txtAgility, Font.ARIAL, true);
			FontUtil.setFont(txtIntelligence, Font.ARIAL, true);
			FontUtil.setFont(txtBattlePoint, Font.UVN_THANGVU, true);
			FontUtil.setFont(txtElement, Font.ARIAL, true);
			
			_glow = new GlowFilter();
			_glow.strength = 10;
			_glow.blurX = _glow.blurY = 4;
			
			_skillSlots = [];
			
			_elementBitmapEx = new BitmapEx();
			movElement.addChild(_elementBitmapEx);
		}
		
		public function set model(_value:Character):void {
			var htmlText:String;
			if (_value && _value.xmlData && _value.unitClassXML) {
				skillSlotsContainer.visible = false;
				movBackground.height = 350;
				
				switch(_value.xmlData.type) {
					case UnitType.HERO:
					case UnitType.COMMON:
						movStar.visible = true;
						htmlText = "<font color = '#ffffff'>" + _value.currentStar.toString() + "/" + _value.maxStar.toString() + "</font>";
						_glow.color = 0x000000;
						txtCurrentStar.htmlText = htmlText;
						txtCurrentStar.filters = [_glow];
						movInfo.visible = true;
						movMystery.visible = false;
						break;
						
					case UnitType.MASTER:
						movStar.visible = false;
						txtCurrentStar.htmlText = "";
						movInfo.visible = false;
						movMystery.visible = true;
						movBackground.height = 180;
						break;
				}
				
				FontUtil.setFont(txtCurrentStar, Font.ARIAL, true);
				
				htmlText = "<font color = '" + UtilityUI.getTxtColor(_value.rarity, _value.isMainCharacter, _value.isLegendary()) + "'>" + _value.name + "</font>";
				_glow.color = UtilityUI.getTxtGlowColor(_value.rarity, _value.isMainCharacter, _value.isLegendary());
				txtName.filters = [_glow];
				txtName.htmlText = htmlText;
				txtMainClass.text = _value.unitClassXML.mainClassName;
				txtSubClass.text = _value.unitClassXML.subClassName;
				txtEXP.text = Utility.math.formatInteger(_value.transmissionExp);
				txtBattlePoint.text = Utility.math.formatInteger(_value.battlePoint);
				formatText(txtVitality, _value.vitality, _value.additionVitality, _value.guildAdditionVitality);
				formatText(txtStrength, _value.strength, _value.additionStrength, _value.guildAdditionStrength);
				formatText(txtAgility, _value.agility, _value.additionAgility, _value.guildAdditionAgility);
				formatText(txtIntelligence, _value.intelligent, _value.additionIntelligent, _value.guildAdditionIntelligent);
				if (_value.element) {
					txtElement.text = Element(Enum.getEnum(Element, _value.element)).elementName.toUpperCase();
				} else {
					txtElement.text = "";
				}
				
				FontUtil.setFont(txtElement, Font.ARIAL, true);
				FontUtil.setFont(txtName, Font.ARIAL, true);
				
				_elementData = Game.database.gamedata.getData(DataType.ELEMENT, _value.element) as ElementData;
				if (_elementData) {
					_elementBitmapEx.load(_elementData.characterTooltipImgURL);
				}
			}
		}
		
		private function formatText(txt:TextField, baseVal:int, additionVal:int, guildAdditionVal:int):void 
		{
			txt.htmlText = "<font color = '#ffffff'>" + baseVal + "</font>"
				+ (additionVal > 0 ? " + <font color = '#43fe0f'>" + additionVal + "</font>" : "")
				+ (guildAdditionVal > 0 ? " + <font color = '#ffff00'>" + guildAdditionVal + "</font>" : "");
				
			if (additionVal > 0 || guildAdditionVal > 0) {
				_glow.color = 0x0a4411;
			} else {
				_glow.color = 0x000000;
			}
			
			txt.filters = [_glow];
			FontUtil.setFont(txt, Font.ARIAL, true);
		}
		
		private function get passiveSkillContainer():MovieClip {
			return skillSlotsContainer.passiveSkillContainer;
		}
		
		private function get activeSkillsContainer():MovieClip {
			return skillSlotsContainer.activeSkillsContainer;
		}
		
		private function get txtVitality():TextField {
			return movInfo.txtVitality;
		}
		
		private function get txtStrength():TextField {
			return movInfo.txtStrength;
		}
		
		private function get txtAgility():TextField {
			return movInfo.txtAgility;
		}
		
		private function get txtIntelligence():TextField {
			return movInfo.txtIntelligence;
		}
		
		private function get txtBattlePoint():TextField {
			return movInfo.txtBattlePoint;
		}
	}

}