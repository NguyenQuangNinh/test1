package game.ui.character_info 
{
	import core.event.EventEx;
	import core.util.FontUtil;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import game.data.model.Character;
	import game.enum.Font;
	import game.enum.UnitType;
	import game.ui.components.CharacterStar;
	import game.ui.components.CharacterStarsChain;
	import game.ui.components.LevelBarMov;
	import game.ui.components.StarChain;
	import game.ui.tooltip.TooltipEvent;
	import game.ui.tooltip.TooltipID;
	import game.utility.ElementUtil;
	import game.utility.UtilityUI;
	
	/**
	 * ...
	 * @author MaiPTT
	 */
	public class CharacterViewBase extends MovieClip 
	{
		public var txtName		:TextField;
		public var txtMainClass	:TextField;
		public var txtSubClass	:TextField;
		public var txtRanking	:TextField;
		public var txtEXP		:TextField;
		public var txtCurrentLevelBar	:TextField;
		public var txtMetalResistance	:TextField;
		public var txtWoodResistance	:TextField;
		public var txtWaterResistance	:TextField;
		public var txtFireResistance	:TextField;
		public var txtEarthResistance	:TextField;
		public var txtMetalDestroy	:TextField;
		public var txtWoodDestroy	:TextField;
		public var txtWaterDestroy	:TextField;
		public var txtFireDestroy	:TextField;
		public var txtEarthDestroy	:TextField;
		public var txtVitality			:TextField;
		public var txtStrength			:TextField;
		public var txtAgility			:TextField;
		public var txtIntelligent		:TextField;
		public var txtTransmissionEXP	:TextField;
		
		public var movMetalResist		:MovieClip;
		public var movEarthResist		:MovieClip;
		public var movFireResist		:MovieClip;
		public var movWoodResist		:MovieClip;
		public var movWaterResist		:MovieClip;
		public var movMetalDestroy		:MovieClip;
		public var movEarthDestroy		:MovieClip;
		public var movFireDestroy		:MovieClip;
		public var movWoodDestroy  	:MovieClip;
		public var movWaterDestroy		:MovieClip;
		public var movVitality			:MovieClip;
		public var movStrength			:MovieClip;
		public var movAgility			:MovieClip;
		public var movIntelligent		:MovieClip;
		
		public var movStars				:MovieClip;
		public var movRecursorInfo		:MovieClip;
		
		private var starChain	:CharacterStarsChain;
		private var levelBar	:LevelBarMov;
		private var _model		:Character;
		private var _glow		:GlowFilter;
		
		public function CharacterViewBase() {
			levelBar = new LevelBarMov();
			levelBar.x = 35;
			levelBar.y = 245;
			addChild(levelBar);
			
			FontUtil.setFont(txtAgility, Font.ARIAL);
			FontUtil.setFont(txtCurrentLevelBar, Font.ARIAL);
			FontUtil.setFont(txtEarthResistance, Font.ARIAL);
			FontUtil.setFont(txtEXP, Font.ARIAL);
			FontUtil.setFont(txtFireResistance, Font.ARIAL);
			FontUtil.setFont(txtIntelligent, Font.ARIAL);
			FontUtil.setFont(txtMainClass, Font.ARIAL);
			FontUtil.setFont(txtMetalResistance, Font.ARIAL);
			FontUtil.setFont(txtName, Font.ARIAL);
			FontUtil.setFont(txtRanking, Font.ARIAL);
			FontUtil.setFont(txtStrength, Font.ARIAL);
			FontUtil.setFont(txtSubClass, Font.ARIAL);
			FontUtil.setFont(txtVitality, Font.ARIAL);
			FontUtil.setFont(txtWaterResistance, Font.ARIAL);
			FontUtil.setFont(txtWoodResistance, Font.ARIAL);
			FontUtil.setFont(txtTransmissionEXP, Font.ARIAL);
			FontUtil.setFont(txtMetalDestroy, Font.ARIAL);
			FontUtil.setFont(txtWoodDestroy, Font.ARIAL);
			FontUtil.setFont(txtWaterDestroy, Font.ARIAL);
			FontUtil.setFont(txtFireDestroy, Font.ARIAL);
			FontUtil.setFont(txtEarthDestroy, Font.ARIAL);


			starChain = new CharacterStarsChain();
			movStars.addChild(starChain);
			movRecursorInfo.visible = false;
			
			_glow = new GlowFilter();
			_glow.strength = 10;
			_glow.blurX = _glow.blurY = 4;
			
			initHandlers();
		}
		
		private function initHandlers():void {
			movMetalResist.addEventListener(MouseEvent.ROLL_OVER, onMouseOverHdl);
			movMetalResist.addEventListener(MouseEvent.ROLL_OUT, onMouseOutHdl);
			movEarthResist.addEventListener(MouseEvent.ROLL_OVER, onMouseOverHdl);
			movEarthResist.addEventListener(MouseEvent.ROLL_OUT, onMouseOutHdl);
			movFireResist.addEventListener(MouseEvent.ROLL_OVER, onMouseOverHdl);
			movFireResist.addEventListener(MouseEvent.ROLL_OUT, onMouseOutHdl);
			movWaterResist.addEventListener(MouseEvent.ROLL_OVER, onMouseOverHdl);
			movWaterResist.addEventListener(MouseEvent.ROLL_OUT, onMouseOutHdl);
			movWoodResist.addEventListener(MouseEvent.ROLL_OVER, onMouseOverHdl);
			movWoodResist.addEventListener(MouseEvent.ROLL_OUT, onMouseOutHdl);
			movMetalDestroy.addEventListener(MouseEvent.ROLL_OVER, onMouseOverHdl);
			movMetalDestroy.addEventListener(MouseEvent.ROLL_OUT, onMouseOutHdl);
			movEarthDestroy.addEventListener(MouseEvent.ROLL_OVER, onMouseOverHdl);
			movEarthDestroy.addEventListener(MouseEvent.ROLL_OUT, onMouseOutHdl);
			movFireDestroy.addEventListener(MouseEvent.ROLL_OVER, onMouseOverHdl);
			movFireDestroy.addEventListener(MouseEvent.ROLL_OUT, onMouseOutHdl);
			movWaterDestroy.addEventListener(MouseEvent.ROLL_OVER, onMouseOverHdl);
			movWaterDestroy.addEventListener(MouseEvent.ROLL_OUT, onMouseOutHdl);
			movWoodDestroy.addEventListener(MouseEvent.ROLL_OVER, onMouseOverHdl);
			movWoodDestroy.addEventListener(MouseEvent.ROLL_OUT, onMouseOutHdl);
			movVitality.addEventListener(MouseEvent.ROLL_OVER, onMouseOverHdl);
			movVitality.addEventListener(MouseEvent.ROLL_OUT, onMouseOutHdl);
			movStrength.addEventListener(MouseEvent.ROLL_OVER, onMouseOverHdl);
			movStrength.addEventListener(MouseEvent.ROLL_OUT, onMouseOutHdl);
			movAgility.addEventListener(MouseEvent.ROLL_OVER, onMouseOverHdl);
			movAgility.addEventListener(MouseEvent.ROLL_OUT, onMouseOutHdl);
			movIntelligent.addEventListener(MouseEvent.ROLL_OVER, onMouseOverHdl);
			movIntelligent.addEventListener(MouseEvent.ROLL_OUT, onMouseOutHdl);
		}
		
		private function onMouseOutHdl(e:MouseEvent):void {
			dispatchEvent(new EventEx(TooltipEvent.HIDE_TOOLTIP, null, true));
		}
		
		private function formatText(txt:TextField, basicStats:int, additionStats:int, extraText:String = ""):void {
			if (additionStats > 0) {
				txt.htmlText = "<font color = '#43fe0f'>" + (basicStats + additionStats).toString() + extraText + "</font>";
			} else {
				txt.htmlText = "<font color = '#ffffff'>" + basicStats.toString() + extraText + "</font>";
			}
			
			FontUtil.setFont(txt, Font.ARIAL);
		}
		
		private function formatText2(txt:TextField, baseVal:int, additionVal:int, guildAdditionVal:int):void 
		{
			txt.htmlText = "<font color = '#ffffff'>" + baseVal + "</font>"
				+ (additionVal > 0 ? " + <font color = '#43fe0f'>" + additionVal + "</font>" : "")
				+ (guildAdditionVal > 0 ? " + <font color = '#ffff00'>" + guildAdditionVal + "</font>" : "");
			FontUtil.setFont(txt, Font.ARIAL);
		}
		
		private function onMouseOverHdl(e:MouseEvent):void {
			if (!_model) return;
			var description:String = "";
			switch(e.target) {
				case movEarthResist:
					description = getElementResistDesc(ElementUtil.EARTH, _model.earthResistance, _model.additionEarthResistance);
					break;
					
				case movFireResist:
					description = getElementResistDesc(ElementUtil.FIRE, _model.fireResistance, _model.additionFireResistance);
					break;
					
				case movMetalResist:
					description = getElementResistDesc(ElementUtil.METAL, _model.metalResistance, _model.additionMetalResistance);
					break;
					
				case movWaterResist:
					description = getElementResistDesc(ElementUtil.WATER, _model.waterResistance, _model.additionWaterResistance);
					break;
					
				case movWoodResist:
					description = getElementResistDesc(ElementUtil.WOOD, _model.woodResistance, _model.additionWoodResistance);
					break;

				case movEarthDestroy:
					description = getElementDestroyDesc(ElementUtil.EARTH, _model.earthDestroy, _model.additionEarthDestroy);
					break;

				case movFireDestroy:
					description = getElementDestroyDesc(ElementUtil.FIRE, _model.fireDestroy, _model.additionFireDestroy);
					break;

				case movMetalDestroy:
					description = getElementDestroyDesc(ElementUtil.METAL, _model.metalDestroy, _model.additionMetalDestroy);
					break;

				case movWaterDestroy:
					description = getElementDestroyDesc(ElementUtil.WATER, _model.waterDestroy, _model.additionWaterDestroy);
					break;

				case movWoodDestroy:
					description = getElementDestroyDesc(ElementUtil.WOOD, _model.woodDestroy, _model.additionWoodDestroy);
					break;
					
				case movVitality:
					description = "Tăng sinh Mệnh cơ bản cho nhân vật." + "\n\t" 
									+ _model.vitality + " + <font color = '#43fe0f'> (" 
									+ _model.additionVitality + ")</font>" + "<font color = '#ffff00'> (+" 
									+ _model.guildAdditionVitality + ")</font>";
					break;
					
				case movStrength:
					description = "Tăng Ngoại và Nội Công cho Thiếu Lâm và Cái Bang. \nTăng kháng Ngoại công cho nhân vật." + "\n\t" 
									+ _model.strength + "<font color = '#43fe0f'> (+" 
									+ _model.additionStrength + ")</font>" + "<font color = '#ffff00'> (+" 
									+ _model.guildAdditionStrength + ")</font>";
					break;
					
				case movAgility:
					description = "Tăng Ngoại và Nội Công cho Võ Đang và Ngũ Độc. \nTăng Đỡ và Xuyên cho nhân vật." + "\n\t"
									+ _model.agility + "<font color = '#43fe0f'> (+" 
									+ _model.additionAgility + ")</font>" + "<font color = '#ffff00'> (+" 
									+ _model.guildAdditionAgility + ")</font>";
					break;
					
					case movIntelligent:
					description = "Tăng Ngoại và Nội Công cho Nga Mi.\nTăng Kháng Phép cho nhân vật." + "\n\t" 
									+ _model.intelligent + "<font color = '#43fe0f'> (+" 
									+ _model.additionIntelligent + ")</font>" + "<font color = '#ffff00'> (+" 
									+ _model.guildAdditionIntelligent + ")</font>";
					break;
			}
			dispatchEvent(new EventEx(TooltipEvent.SHOW_TOOLTIP, { type:TooltipID.SIMPLE, value:description }, true ));
		}
		
		private function getElementResistDesc(element:int, baseValue:int, additionValue:int):String {
			var rs:String = "Giảm (-" + Math.abs(baseValue) + "% <font color = '#43fe0f'> +"
					+ Math.abs(additionValue) + "%</font>) sát thương khi đánh với hệ " 
					+ ElementUtil.getName(element);

			return rs;
		}

		private function getElementDestroyDesc(element:int, baseValue:int, additionValue:int):String {
				var rs:String = "Tăng (+" + Math.abs(baseValue) + "% <font color = '#43fe0f'> +"
					+ Math.abs(additionValue) + "%</font>) sát thương khi đánh với hệ "
					+ ElementUtil.getName(element);
			return rs;
		}
		
		public function set model(value:Character):void {
			_model = value;			
			if (_model && _model.xmlData && _model.unitClassXML) {
				var htmlText:String = "";
				htmlText = "<font color = '" + UtilityUI.getTxtColor(_model.rarity, _model.isMainCharacter, _model.isLegendary()) + "'>" + _model.name + "</font>";
				_glow.color = UtilityUI.getTxtGlowColor(_model.rarity, _model.isMainCharacter, _model.isLegendary());
				txtName.htmlText = htmlText;
				txtName.filters = [_glow];
				FontUtil.setFont(txtName, Font.ARIAL);
				
				txtMainClass.text = _model.unitClassXML.mainClassName;
				txtSubClass.text = _model.unitClassXML.subClassName;
				
				switch(_model.xmlData.type) {
					case UnitType.MASTER:
						txtCurrentLevelBar.visible = false;
						txtEXP.visible = false;
						starChain.visible = false;
						levelBar.visible = false;
						movRecursorInfo.visible = true;
						txtRanking.htmlText = "<font color = '0xe6e853'> Cao Nhân Ẩn Cư </font>";
						break;
						
					case UnitType.HERO:
						txtCurrentLevelBar.visible = true;
						txtEXP.visible = true;
						starChain.visible = true;
						levelBar.visible = true;
						movRecursorInfo.visible = false;
						txtRanking.htmlText = "<font color = '0xe61eff'> Huyền Thoại Võ Lâm </font>";
						break;
						
					default:
						txtCurrentLevelBar.visible = true;
						txtEXP.visible = true;
						starChain.visible = true;
						levelBar.visible = true;
						movRecursorInfo.visible = false;
						txtRanking.htmlText = "<font color = '0xffffff'> Uy Danh </font>";
						break;
				}
				
				FontUtil.setFont(txtRanking, Font.ARIAL);
				
				if (!(_model.level % 12)) {
					txtCurrentLevelBar.text = "12/12 Thành";
				} else {
					txtCurrentLevelBar.text = _model.level % 12 + "/12 Thành";	
				}
				
				txtEXP.text = _model.exp + "/" + _model.maxExp;
				levelBar.levelPercent = (Number) (_model.exp / _model.maxExp);
				formatText(txtMetalResistance, _model.metalResistance, _model.additionMetalResistance, "%");
				formatText(txtWoodResistance, _model.woodResistance, _model.additionWoodResistance, "%");
				formatText(txtWaterResistance, _model.waterResistance, _model.additionWaterResistance, "%");
				formatText(txtFireResistance, _model.fireResistance, _model.additionFireResistance, "%");
				formatText(txtEarthResistance, _model.earthResistance, _model.additionEarthResistance, "%");

				formatText(txtMetalDestroy, _model.metalDestroy, _model.additionMetalDestroy, "%");
				formatText(txtWoodDestroy, _model.woodDestroy, _model.additionWoodDestroy, "%");
				formatText(txtWaterDestroy, _model.waterDestroy, _model.additionWaterDestroy, "%");
				formatText(txtFireDestroy, _model.fireDestroy, _model.additionFireDestroy, "%");
				formatText(txtEarthDestroy, _model.earthDestroy, _model.additionEarthDestroy, "%");
				if (_model.isMainCharacter || (_model.xmlData.type == UnitType.HERO)) {
					txtTransmissionEXP.text = "(Không thể dùng truyền công)";
				} else {
					txtTransmissionEXP.text = "Điểm truyền công: " + _model.transmissionExp.toString();
				}
				
				formatText2(txtVitality, _model.vitality, _model.additionVitality, _model.guildAdditionVitality);
				formatText2(txtStrength, _model.strength, _model.additionStrength, _model.guildAdditionStrength);
				formatText2(txtAgility, _model.agility, _model.additionAgility, _model.guildAdditionAgility);
				formatText2(txtIntelligent, _model.intelligent, _model.additionIntelligent, _model.guildAdditionIntelligent);
				
				starChain.setCharacter(_model);
			} else {
				txtName.text = "";
				txtMainClass.text = "";
				txtSubClass.text = "";
				txtCurrentLevelBar.visible = false;
				txtEXP.visible = false;
				starChain.visible = false;
				levelBar.visible = false;
				movRecursorInfo.visible = false;
				txtRanking.text = "";
				txtCurrentLevelBar.text = "";
				txtEXP.text = "";
				levelBar.levelPercent = 0;
				txtMetalResistance.text = "";
				txtWoodResistance.text = "";
				txtWaterResistance.text = "";
				txtFireResistance.text = "";
				txtEarthResistance.text = "";
				txtMetalDestroy.text = "";
				txtWoodDestroy.text = "";
				txtWaterDestroy.text = "";
				txtFireDestroy.text = "";
				txtEarthDestroy.text = "";
				txtTransmissionEXP.text = "Điểm truyền công: 0";
				txtVitality.text = "";
				txtStrength.text = "";
				txtAgility.text = "";
				txtIntelligent.text = "";
				
				starChain.setCharacter(null);
			}
		}
		
	}

}