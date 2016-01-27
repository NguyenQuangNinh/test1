package game.ui.character_info 
{
	import components.scroll.VerScroll;
	import core.event.EventEx;
	import core.util.FontUtil;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import game.data.model.Character;
	import game.enum.Font;
	import game.Game;
	import game.ui.tooltip.TooltipEvent;
	import game.ui.tooltip.TooltipID;
	
	/**
	 * ...
	 * @author MaiPTT
	 */
	public class CharacterInfoInDetails extends MovieClip 
	{
		public var scrollbar	:MovieClip;
		public var contentMovie	:MovieClip;
		public var maskMovie	:MovieClip;
		private var _model		:Character;
		private var scroller:VerScroll;
		
		public function CharacterInfoInDetails() {
			initHdls();
			txtFontSetter();
			scroller = new VerScroll(maskMovie, contentMovie, scrollbar);
		}
		
		public function onTransIn():void {
		}
		
		private function initHdls():void {
			movArmorDef.addEventListener(MouseEvent.ROLL_OVER, onMouseOverHdl);
			movAttackRange.addEventListener(MouseEvent.ROLL_OVER, onMouseOverHdl);
			movCritChance.addEventListener(MouseEvent.ROLL_OVER, onMouseOverHdl);
			movCritDmg.addEventListener(MouseEvent.ROLL_OVER, onMouseOverHdl);
			movDodge.addEventListener(MouseEvent.ROLL_OVER, onMouseOverHdl);
			movHP.addEventListener(MouseEvent.ROLL_OVER, onMouseOverHdl);
			movMagDef.addEventListener(MouseEvent.ROLL_OVER, onMouseOverHdl);
			movMagDmgCritChance.addEventListener(MouseEvent.ROLL_OVER, onMouseOverHdl);
			movMagicAbility.addEventListener(MouseEvent.ROLL_OVER, onMouseOverHdl);
			movMagicCritDmg.addEventListener(MouseEvent.ROLL_OVER, onMouseOverHdl);
			movPhysicAccuracy.addEventListener(MouseEvent.ROLL_OVER, onMouseOverHdl);
			movPhysicDmg.addEventListener(MouseEvent.ROLL_OVER, onMouseOverHdl);
			movMovementSpeed.addEventListener(MouseEvent.ROLL_OVER, onMouseOverHdl);
			
			movArmorDef.addEventListener(MouseEvent.ROLL_OUT, onMouseOutHdl);
			movAttackRange.addEventListener(MouseEvent.ROLL_OUT, onMouseOutHdl);
			movCritChance.addEventListener(MouseEvent.ROLL_OUT, onMouseOutHdl);
			movCritDmg.addEventListener(MouseEvent.ROLL_OUT, onMouseOutHdl);
			movDodge.addEventListener(MouseEvent.ROLL_OUT, onMouseOutHdl);
			movHP.addEventListener(MouseEvent.ROLL_OUT, onMouseOutHdl);
			movMagDef.addEventListener(MouseEvent.ROLL_OUT, onMouseOutHdl);
			movMagDmgCritChance.addEventListener(MouseEvent.ROLL_OUT, onMouseOutHdl);
			movMagicAbility.addEventListener(MouseEvent.ROLL_OUT, onMouseOutHdl);
			movMagicCritDmg.addEventListener(MouseEvent.ROLL_OUT, onMouseOutHdl);
			movPhysicAccuracy.addEventListener(MouseEvent.ROLL_OUT, onMouseOutHdl);
			movPhysicDmg.addEventListener(MouseEvent.ROLL_OUT, onMouseOutHdl);
			movMovementSpeed.addEventListener(MouseEvent.ROLL_OUT, onMouseOutHdl);
		}
		
		private function onMouseOutHdl(e:MouseEvent):void {
			dispatchEvent(new EventEx(TooltipEvent.HIDE_TOOLTIP, null, true));
		}
		
		private function onMouseOverHdl(e:MouseEvent):void {
			if (!_model) return;
			
			var description:String = "";
			switch(e.target) {
				case movHP:
					description = "Sinh Mệnh cơ bản của nhân vật." + "\n\t" 
									+ _model.HP + "<font color = '#43fe0f'> (+" 
									+ _model.additionHP + ")</font>";
					break;
					
				case movPhysicDmg:
					description = "Ngoại Công: sát thương mỗi đòn đánh thường." + "\n\t" 
									+ _model.physicalDamage + "<font color = '#43fe0f'> (+" 
									+ _model.additionPhysicalDamage + ")</font>";
					break;
					
				case movPhysicAccuracy:
					description = "Xuyên: bỏ qua " + _model.physicalAccuracy + "<font color = '#43fe0f'> (+" 
									+ _model.additionPhysicalAccuracy + ")</font>" 
									+ " điểm đỡ đòn của đối phương";
					break;
					
				case movCritChance:
					description = "Tỷ lệ xảy ra bạo kích từ sát thương ngoại công." + "\n\t" 
									+ _model.physicalCriticalChance + "%<font color = '#43fe0f'> (+" 
									+ _model.additionPhysicalCriticalChance + "%)</font>";
					break;
					
				case movCritDmg:
					description = "% Sát thương ngoại công cộng thêm khi xảy ra bạo kích ngoại công." + "\n\t" 
									+ _model.physicalCriticalDamage + "%<font color = '#43fe0f'> (+" 
									+ _model.additionPhysicalCriticalDamage + "%)</font>";
					break;
					
				case movAttackRange:
					description = "Khoảng cách xuất chiêu ngoại công của nhân vật." + "\n\t" 
									+ Math.max(_model.rangerAttackRange, _model.meleeAttackRange) + "<font color = '#43fe0f'> (+" 
									+ Math.max(_model.additionRangerAttackRange, _model.additionMeleeAttackRange) + ")</font>";
					break;
					
				case movMagicAbility:
					description = "Nội Công: tăng thêm hiệu quả kỹ năng" + "\n\t" 
									+ _model.magicalPower + "<font color = '#43fe0f'> (+" 
									+ _model.additionMagicalPower + ")</font>";
					break;
					
				case movMagDmgCritChance:
					description = "Tỷ lệ xảy ra bạo kích kỹ năng." + "\n\t" 
									+ _model.magicalCriticalChance + "%<font color = '#43fe0f'> (+" 
									+ _model.additionMagicalCriticalChance + "%)</font>";
					break;
					
				case movMagicCritDmg:
					description = "% Hiệu quả kỹ năng tăng thêm khi xảy ra bạo kích kỹ năng." + "\n\t" 
									+ _model.magicalCriticalDamage + "%<font color = '#43fe0f'> (+" 
									+ _model.additionMagicalCriticalDamage + "%)</font>";
					break;
					
				case movArmorDef:
					description = "Giảm " + getArmorDef(_model.physicalArmor) + "%<font color = '#43fe0f'> (+" 
									+ getArmorDef(_model.additionPhysicalArmor) + "%)</font>" 
									+ " sát thương ngoại công của đối phương cùng cấp";
					break;
					
				case movDodge:
					description = "Có tỷ lệ " + getDodgeRate(_model.blockingChance) + "%<font color = '#43fe0f'> (+" 
									+ getDodgeRate(_model.additionBlockingChance) + "%)</font>"
									+ " né toàn bộ sát thương ngoại công nhận phải của đối phương cùng cấp";
					break;
					
				case movMagDef:
					description = "Giảm " + getArmorDef(_model.magicalArmor) + "%<font color = '#43fe0f'> (+" 
									+ getArmorDef(_model.additionMagicalArmor) + "%)</font>"
									+ " sát thương kỹ năng của đối phương cùng cấp";
					break;
					
				case movMovementSpeed:
					description = "Tốc độ di chuyển của nhân vật " + "\n\t" 
									+ _model.movementSpeed + "<font color = '#43fe0f'> (+" 
									+ _model.additionMovementSpeed + ")</font>";
					break;
			}
			
			dispatchEvent(new EventEx(TooltipEvent.SHOW_TOOLTIP, { type:TooltipID.SIMPLE, value:description }, true));
		}
		
		public function set model(_value:Character):void {
			_model = _value;
			if (_value) {
				if (_value.additionPhysicalDamage > 0) {
					txtPhysicDmg.htmlText = "<font color = '#43fe0f'>" + (_value.physicalDamage + _value.additionPhysicalDamage).toString() + "</font";
				} else {
					txtPhysicDmg.htmlText = "<font color = '#ffffff'>" + (_value.physicalDamage + _value.additionPhysicalDamage).toString() + "</font";
				}
				
				if (_value.additionPhysicalAccuracy > 0) {
					txtPhysicAccuracy.htmlText = "<font color = '#43fe0f'>" + (_value.physicalAccuracy + _value.additionPhysicalAccuracy).toString() + "</font";
				} else {
					txtPhysicAccuracy.htmlText = "<font color = '#ffffff'>" + (_value.physicalAccuracy + _value.additionPhysicalAccuracy).toString() + "</font";
				}
				
				if (_value.additionPhysicalCriticalChance > 0) {
					txtCritChance.htmlText = "<font color = '#43fe0f'>" + (_value.physicalCriticalChance + _value.additionPhysicalCriticalChance).toString() + "%</font";
				} else {
					txtCritChance.htmlText = "<font color = '#ffffff'>" + (_value.physicalCriticalChance + _value.additionPhysicalCriticalChance).toString() + "%</font";
				}
				
				if (_value.additionPhysicalCriticalDamage > 0) {
					txtCritDmg.htmlText = "<font color = '#43fe0f'>" + (_value.physicalCriticalDamage + _value.additionPhysicalCriticalDamage).toString() + "%</font";
				} else {
					txtCritDmg.htmlText = "<font color = '#ffffff'>" + (_value.physicalCriticalDamage + _value.additionPhysicalCriticalDamage).toString() + "%</font";
				}
				
				var attackRange:int = Math.max(_value.rangerAttackRange, _value.meleeAttackRange);
				var additionAttackRange:int = Math.max(_value.additionRangerAttackRange, _value.additionMeleeAttackRange);
				if (additionAttackRange > 0) {
					txtAttackRange.htmlText = "<font color = '#43fe0f'>" + (attackRange + additionAttackRange).toString() + "</font";
				} else {
					txtAttackRange.htmlText = "<font color = '#ffffff'>" + (attackRange + additionAttackRange).toString() + "</font";
				}
				
				if (attackRange < 200) {
					txtAttackType.text = "Đánh Gần";
				} else {
					txtAttackType.text = "Đánh Xa";
				}
				
				if (_value.additionMagicalPower > 0) {
					txtMagicAbility.htmlText = "<font color = '#43fe0f'>" + (_value.magicalPower + _value.additionMagicalPower).toString() + "</font";
				} else {
					txtMagicAbility.htmlText = "<font color = '#ffffff'>" + (_value.magicalPower + _value.additionMagicalPower).toString() + "</font";
				}
				
				if (_value.additionMagicalCriticalChance > 0) {
					txtMagDmgCritChance.htmlText = "<font color = '#43fe0f'>" + (_value.magicalCriticalChance + _value.additionMagicalCriticalChance).toString() + "%</font";
				} else {
					txtMagDmgCritChance.htmlText = "<font color = '#ffffff'>" + (_value.magicalCriticalChance + _value.additionMagicalCriticalChance).toString() + "%</font";
				}
				
				if (_value.additionMagicalCriticalDamage > 0) {
					txtMagCritDmg.htmlText = "<font color = '#43fe0f'>" + (_value.magicalCriticalDamage + _value.additionMagicalCriticalDamage).toString() + "%</font";
				} else {
					txtMagCritDmg.htmlText = "<font color = '#ffffff'>" + (_value.magicalCriticalDamage + _value.additionMagicalCriticalDamage).toString() + "%</font";
				}
				
				if (_value.additionPhysicalArmor > 0) {
					txtArmorDef.htmlText = "<font color = '#43fe0f'>" + (_value.physicalArmor + _value.additionPhysicalArmor).toString() + "</font";
				} else {
					txtArmorDef.htmlText = "<font color = '#ffffff'>" + (_value.physicalArmor + _value.additionPhysicalArmor).toString() + "</font";
				}
				
				if (_value.additionBlockingChance > 0) {
					txtDodge.htmlText = "<font color = '#43fe0f'>" + (_value.blockingChance + _value.additionBlockingChance).toString() + "</font";
				} else {
					txtDodge.htmlText = "<font color = '#ffffff'>" + (_value.blockingChance + _value.additionBlockingChance).toString() + "</font";
				}
				
				if (_value.additionMagicalArmor > 0) {
					txtMagDef.htmlText = "<font color = '#43fe0f'>" + (_value.magicalArmor + _value.additionMagicalArmor).toString() + "</font";
				} else {
					txtMagDef.htmlText = "<font color = '#ffffff'>" + (_value.magicalArmor + _value.additionMagicalArmor).toString() + "</font";
				}
				
				if (_value.additionHP > 0) {
					txtHP.htmlText = "<font color = '#43fe0f'>" + (_value.HP + _value.additionHP).toString() + "</font";
				} else {
					txtHP.htmlText = "<font color = '#ffffff'>" + (_value.HP + _value.additionHP).toString() + "</font";
				}
				
				if (_value.additionMovementSpeed > 0) {
					txtMovementSpeed.htmlText = "<font color = '#43fe0f'>" + (_value.movementSpeed + _value.additionMovementSpeed).toString() + "</font";
				} else {
					txtMovementSpeed.htmlText = "<font color = '#ffffff'>" + (_value.movementSpeed + _value.additionMovementSpeed).toString() + "</font";
				}
			}
			
			txtFontSetter();
			if (!scroller) {
				scroller = new VerScroll(maskMovie, contentMovie, scrollbar);
			} else {
				scroller.updateScroll();
			}
		}
		
		private function getArmorDef(value:Number):int {
			if (_model) {
				return (int(Number(value / (_model.level * 25 + value)) * 100));
			}
			return 0;
		}
		
		private function getDodgeRate(value:Number):Number {
			if (_model) {
				return (int(Number(value / (_model.level * 50 + value)) * 100));	
			}
			return 0;
		}
		
		private function txtFontSetter():void {
			FontUtil.setFont(txtPhysicDmg, Font.ARIAL);
			FontUtil.setFont(txtPhysicAccuracy, Font.ARIAL);
			FontUtil.setFont(txtCritChance, Font.ARIAL);
			FontUtil.setFont(txtCritDmg, Font.ARIAL);
			FontUtil.setFont(txtAttackRange, Font.ARIAL);
			FontUtil.setFont(txtMagicAbility, Font.ARIAL);
			FontUtil.setFont(txtMagDmgCritChance, Font.ARIAL);
			FontUtil.setFont(txtMagCritDmg, Font.ARIAL);
			FontUtil.setFont(txtArmorDef, Font.ARIAL);
			FontUtil.setFont(txtDodge, Font.ARIAL);
			FontUtil.setFont(txtMagDef, Font.ARIAL);
			FontUtil.setFont(txtHP, Font.ARIAL);
			FontUtil.setFont(txtAttackType, Font.ARIAL);
			FontUtil.setFont(txtMovementSpeed, Font.ARIAL);
		}
		
		private function get movMovementSpeed():MovieClip {
			return contentMovie.movMovementSpeed;
		}
		
		private function get txtMovementSpeed():TextField {
			return movMovementSpeed.txtMovementSpeed;
		}
		
		private function get movPhysicDmg():MovieClip {
			return contentMovie.movPhysicDmg;
		}
		
		private function get txtPhysicDmg():TextField {
			return movPhysicDmg.txtPhysicDmg;
		}
		
		private function get movPhysicAccuracy():MovieClip {
			return contentMovie.movPhysicAccuracy;
		}
		
		private function get txtPhysicAccuracy():TextField {
			return movPhysicAccuracy.txtPhysicAccuracy;
		}
		
		private function get movCritChance():MovieClip {
			return contentMovie.movCritChance;
		}
		
		private function get txtCritChance():TextField {
			return movCritChance.txtCritChance;
		}
		
		private function get movCritDmg():MovieClip {
			return contentMovie.movCritDmg;
		}
		
		private function get txtCritDmg():TextField {
			return movCritDmg.txtCritDmg;
		}
		
		private function get movAttackRange():MovieClip {
			return contentMovie.movAttackRange;
		}
		
		private function get txtAttackRange():TextField {
			return movAttackRange.txtAttackRange;
		}
		
		private function get movMagicAbility():MovieClip {
			return contentMovie.movMagicAbility;
		}
		
		private function get txtMagicAbility():TextField {
			return movMagicAbility.txtMagicAbility;
		}
		
		private function get movMagDmgCritChance():MovieClip {
			return contentMovie.movMagDmgCritChance;
		}
		
		private function get txtMagDmgCritChance():TextField {
			return movMagDmgCritChance.txtMagDmgCritChance;
		}
		
		private function get movMagicCritDmg():MovieClip {
			return contentMovie.movMagicCritDmg;
		}
		
		private function get txtMagCritDmg():TextField {
			return movMagicCritDmg.txtMagCritDmg;
		}
		
		private function get movArmorDef():MovieClip {
			return contentMovie.movArmorDef;
		}
		
		private function get txtArmorDef():TextField {
			return movArmorDef.txtArmorDef;
		}
		
		private function get movDodge():MovieClip {
			return contentMovie.movDodge;
		}
		
		private function get txtDodge():TextField {
			return movDodge.txtDodge;
		}
		
		private function get movMagDef():MovieClip {
			return contentMovie.movMagDef;
		}
		
		private function get txtMagDef():TextField {
			return movMagDef.txtMagDef;
		}
		
		private function get movHP():MovieClip {
			return contentMovie.movHP;
		}
		
		private function get txtHP():TextField {
			return movHP.txtHP;
		}
		
		private function get txtAttackType():TextField {
			return contentMovie.txtAttackType;
		}
	}

}