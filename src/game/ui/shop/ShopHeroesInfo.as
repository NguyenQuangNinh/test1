package game.ui.shop 
{
	import core.display.BitmapEx;
	import core.event.EventEx;
	import core.Manager;
	import core.util.Enum;
	import core.util.FontUtil;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import game.data.model.Character;
	import game.data.vo.skill.Skill;
	import game.data.xml.DataType;
	import game.data.xml.ElementData;
	import game.data.xml.UnitClassXML;
	import game.enum.CharacterRarity;
	import game.enum.Element;
	import game.enum.Font;
	import game.Game;
	import game.main.SkillSlot;
	import game.ui.components.CharacterStarsChain;
	import game.ui.components.LevelBarMov;
	import game.ui.tooltip.TooltipEvent;
	import game.ui.tooltip.TooltipID;
	
	/**
	 * ...
	 * @author MaiPTT
	 */
	public class ShopHeroesInfo extends MovieClip 
	{
		public var movMetalResist		:MovieClip;
		public var movWoodResist		:MovieClip;
		public var movWaterResist		:MovieClip;
		public var movFireResist		:MovieClip;
		public var movEarthResist		:MovieClip;
		public var movMetalDestroy		:MovieClip;
		public var movWoodDestroy		:MovieClip;
		public var movWaterDestroy		:MovieClip;
		public var movFireDestroy		:MovieClip;
		public var movEarthDestroy		:MovieClip;
		public var movVitality			:MovieClip;
		public var movStrength			:MovieClip;
		public var movAgility			:MovieClip;
		public var movIntelligence		:MovieClip;
		public var movStarChain			:MovieClip;
		public var movLevelBar			:MovieClip;
		public var movSkills			:MovieClip;
		public var movStarsDefault		:MovieClip;
		public var movElement			:MovieClip;
		public var txtName				:TextField;
		public var txtClassName			:TextField;
		public var txtEXP				:TextField;
		public var txtElement			:TextField;
		
		private var model				:Character;
		private var starChain			:CharacterStarsChain;
		private var levelBar			:LevelBarMov;
		private var skillsSlots			:Array;
		private var elementBitmap		:BitmapEx;
		
		public function ShopHeroesInfo() {
			initHandlers();
			
			starChain = new CharacterStarsChain();
			movStarChain.addChild(starChain);
			setCharacter(null);
			
			levelBar = new LevelBarMov();
			movLevelBar.addChild(levelBar);
			
			skillsSlots = [];
			elementBitmap = new BitmapEx();
			movElement.addChild(elementBitmap);
		}
		
		private function initHandlers():void {
			movMetalResist.addEventListener(MouseEvent.ROLL_OVER, onMovHoverHdl);
			movWoodResist.addEventListener(MouseEvent.ROLL_OVER, onMovHoverHdl);
			movWaterResist.addEventListener(MouseEvent.ROLL_OVER, onMovHoverHdl);
			movFireResist.addEventListener(MouseEvent.ROLL_OVER, onMovHoverHdl);
			movEarthResist.addEventListener(MouseEvent.ROLL_OVER, onMovHoverHdl);
			movMetalDestroy.addEventListener(MouseEvent.ROLL_OVER, onMovHoverHdl);
			movWoodDestroy.addEventListener(MouseEvent.ROLL_OVER, onMovHoverHdl);
			movWaterDestroy.addEventListener(MouseEvent.ROLL_OVER, onMovHoverHdl);
			movFireDestroy.addEventListener(MouseEvent.ROLL_OVER, onMovHoverHdl);
			movEarthDestroy.addEventListener(MouseEvent.ROLL_OVER, onMovHoverHdl);
			movVitality.addEventListener(MouseEvent.ROLL_OVER, onMovHoverHdl);
			movStrength.addEventListener(MouseEvent.ROLL_OVER, onMovHoverHdl);
			movAgility.addEventListener(MouseEvent.ROLL_OVER, onMovHoverHdl);
			movIntelligence.addEventListener(MouseEvent.ROLL_OVER, onMovHoverHdl);
			
			movMetalResist.addEventListener(MouseEvent.ROLL_OUT, onMovOutHdl);
			movWoodResist.addEventListener(MouseEvent.ROLL_OUT, onMovOutHdl);
			movWaterResist.addEventListener(MouseEvent.ROLL_OUT, onMovOutHdl);
			movFireResist.addEventListener(MouseEvent.ROLL_OUT, onMovOutHdl);
			movEarthResist.addEventListener(MouseEvent.ROLL_OUT, onMovOutHdl);
			movMetalDestroy.addEventListener(MouseEvent.ROLL_OUT, onMovOutHdl);
			movWoodDestroy.addEventListener(MouseEvent.ROLL_OUT, onMovOutHdl);
			movWaterDestroy.addEventListener(MouseEvent.ROLL_OUT, onMovOutHdl);
			movFireDestroy.addEventListener(MouseEvent.ROLL_OUT, onMovOutHdl);
			movEarthDestroy.addEventListener(MouseEvent.ROLL_OUT, onMovOutHdl);
			movVitality.addEventListener(MouseEvent.ROLL_OUT, onMovOutHdl);
			movStrength.addEventListener(MouseEvent.ROLL_OUT, onMovOutHdl);
			movAgility.addEventListener(MouseEvent.ROLL_OUT, onMovOutHdl);
			movIntelligence.addEventListener(MouseEvent.ROLL_OUT, onMovOutHdl);
			
			FontUtil.setFont(movMetalResist.txtValue, Font.ARIAL);
			FontUtil.setFont(movWoodResist.txtValue, Font.ARIAL);
			FontUtil.setFont(movWaterResist.txtValue, Font.ARIAL);
			FontUtil.setFont(movFireResist.txtValue, Font.ARIAL);
			FontUtil.setFont(movEarthResist.txtValue, Font.ARIAL);
			FontUtil.setFont(movMetalDestroy.txtValue, Font.ARIAL);
			FontUtil.setFont(movWoodDestroy.txtValue, Font.ARIAL);
			FontUtil.setFont(movWaterDestroy.txtValue, Font.ARIAL);
			FontUtil.setFont(movFireDestroy.txtValue, Font.ARIAL);
			FontUtil.setFont(movEarthDestroy.txtValue, Font.ARIAL);
			FontUtil.setFont(movVitality.txtValue, Font.ARIAL);
			FontUtil.setFont(movStrength.txtValue, Font.ARIAL);
			FontUtil.setFont(movAgility.txtValue, Font.ARIAL);
			FontUtil.setFont(movIntelligence.txtValue, Font.ARIAL);
			
			FontUtil.setFont(txtName, Font.ARIAL);
			FontUtil.setFont(txtClassName, Font.ARIAL);
			FontUtil.setFont(txtEXP, Font.ARIAL);
			FontUtil.setFont(txtRandomStars, Font.ARIAL);
			FontUtil.setFont(txtElement, Font.ARIAL, true);
		}
		
		private function get txtRandomStars():TextField {
			return movStarsDefault.txtRandomStars;
		}
		
		private function onMovOutHdl(e:MouseEvent):void {
			dispatchEvent(new EventEx(TooltipEvent.HIDE_TOOLTIP, null, true));
		}
		
		private function onMovHoverHdl(e:MouseEvent):void {
			if (model) {
				var description:String = "";
				switch(e.target) {
					case movMetalResist:
						description = "% Giảm sát thương ngoại công, nội công của đối phương hệ KIM." + "\n\t" 
									+ model.metalResistance + "%<font color = '#43fe0f'> (+" 
									+ model.additionMetalResistance + "%)</font>";
						break;
						
					case movWoodResist:
						description = "% Giảm sát thương ngoại công, nội công của đối phương hệ MỘC." + "\n\t" 
									+ model.woodResistance + "%<font color = '#43fe0f'> (+" 
									+ model.additionWoodResistance + "%)</font>";
						break;
						
					case movWaterResist:
						description = "% Giảm sát thương ngoại công, nội công của đối phương hệ THỦY." + "\n\t" 
									+ model.waterResistance + "%<font color = '#43fe0f'> (+" 
									+ model.additionWaterResistance + "%)</font>";
						break;
						
					case movFireResist:
						description = "% Giảm sát thương ngoại công, nội công của đối phương hệ HỎA." + "\n\t" 
									+ model.fireResistance + "%<font color = '#43fe0f'> (+" 
									+ model.additionFireResistance + "%)</font>";
						break;
						
					case movEarthResist:
						description = "% Giảm sát thương ngoại công, nội công của đối phương hệ THỔ." + "\n\t" 
									+ model.earthResistance + "%<font color = '#43fe0f'> (+" 
									+ model.additionEarthResistance + "%)</font>";
						break;

					case movMetalDestroy:
						description = "% Tăng sát thương ngoại công, nội công của đối phương hệ KIM." + "\n\t"
									+ model.metalDestroy + "%<font color = '#43fe0f'> (+"
									+ model.additionMetalDestroy + "%)</font>";
						break;

					case movWoodDestroy:
						description = "% Tăng sát thương ngoại công, nội công của đối phương hệ MỘC." + "\n\t"
									+ model.woodDestroy + "%<font color = '#43fe0f'> (+"
									+ model.additionWoodDestroy + "%)</font>";
						break;

					case movWaterDestroy:
						description = "% Tăng sát thương ngoại công, nội công của đối phương hệ THỦY." + "\n\t"
									+ model.waterDestroy + "%<font color = '#43fe0f'> (+"
									+ model.additionWaterDestroy + "%)</font>";
						break;

					case movFireDestroy:
						description = "% Tăng sát thương ngoại công, nội công của đối phương hệ HỎA." + "\n\t"
									+ model.fireDestroy + "%<font color = '#43fe0f'> (+"
									+ model.additionFireDestroy + "%)</font>";
						break;

					case movEarthDestroy:
						description = "% Tăng sát thương ngoại công, nội công của đối phương hệ THỔ." + "\n\t"
									+ model.earthDestroy + "%<font color = '#43fe0f'> (+"
									+ model.additionEarthDestroy + "%)</font>";
						break;
						
					case movVitality:
						description = "Tăng sinh Mệnh cơ bản cho nhân vật." + "\n\t" 
									+ model.vitality + "<font color = '#43fe0f'> (+" 
									+ model.additionVitality + ")</font>";
						break;
						
					case movStrength:
						description = "Tăng Ngoại và Nội Công cho Thiếu Lâm. \nTăng kháng Ngoại công cho nhân vật." + "\n\t" 
									+ model.strength + "<font color = '#43fe0f'> (+" 
									+ model.additionStrength + ")</font>";
						break;
						
					case movAgility:
						description = "Tăng Ngoại và Nội Công cho Võ Đang và Ngũ Độc. \nTăng Đỡ và Xuyên cho nhân vật." + "\n\t"
									+ model.agility + "<font color = '#43fe0f'> (+" 
									+ model.additionAgility + ")</font>";
						break;
						
					case movIntelligence:
						description = "Tăng Ngoại và Nội Công cho Nga Mi.\nTăng Kháng Phép cho nhân vật." + "\n\t" 
								+ model.intelligent + "<font color = '#43fe0f'> (+" 
								+ model.additionIntelligent + ")</font>";
						break;
				}
				
				dispatchEvent(new EventEx(TooltipEvent.SHOW_TOOLTIP, { type:TooltipID.SIMPLE, value:description }, true ));
			}
		}
		
		public function setCharacter(_value:Character):void {
			model = _value;
			txtElement.text = "";
			if (elementBitmap && elementBitmap.parent) {
				elementBitmap.parent.removeChild(elementBitmap);
			}
			if (model) {
				if (!model.isLegendary() && model.xmlData) {
					movStarChain.visible = false;
					movStarsDefault.visible = true;
					var quantity:int = model.xmlData.quality[0];
					var arrQuantity:Array = Game.database.gamedata.getConfigData(1) as Array;
					var arrMinStars:Array = Game.database.gamedata.getConfigData(2) as Array;
					var arrMaxStars:Array = Game.database.gamedata.getConfigData(3) as Array;
					if (arrQuantity && arrMinStars && arrMaxStars) {
						var quantityIndex:int = Utilities.getElementIndex(arrQuantity, quantity);
						if (quantityIndex != -1) {
							var minStars:int = arrMinStars[quantityIndex];
							var maxStars:int = arrMaxStars[quantityIndex];
						}
					}
					if (minStars < maxStars) {
						txtRandomStars.text = minStars + " đến " + maxStars;	
					} else if (minStars == maxStars) {
						txtRandomStars.text = maxStars.toString();
					}
					levelBar.visible = false;
					txtEXP.visible = false;
				} else {
					movStarChain.visible = true;
					movStarsDefault.visible = false;
					starChain.setCharacter(model);		
					levelBar.visible = true;
					txtEXP.visible = true;
				}
				
				var elementData:ElementData = Game.database.gamedata.getData(DataType.ELEMENT, model.element) as ElementData;
				if (elementData) {
					elementBitmap.load(elementData.characterTooltipImgURL);
					movElement.addChild(elementBitmap);
					var elementEnum:Element = Enum.getEnum(Element, model.element) as Element;
					if (elementEnum) {
						txtElement.text = elementEnum.elementName.toUpperCase();
					} else {
						txtElement.text = "VÔ HỆ";
					}
				}
				
				movMetalResist.txtValue.text = model.metalResistance + model.additionMetalResistance;
				movWoodResist.txtValue.text = model.woodResistance + model.additionWoodResistance;
				movWaterResist.txtValue.text = model.waterResistance + model.additionWaterResistance;
				movFireResist.txtValue.text = model.fireResistance + model.additionFireResistance;
				movEarthResist.txtValue.text = model.earthResistance + model.additionEarthResistance;

				movMetalDestroy.txtValue.text = model.metalDestroy + model.additionMetalDestroy;
				movWoodDestroy.txtValue.text = model.woodDestroy + model.additionWoodDestroy;
				movWaterDestroy.txtValue.text = model.waterDestroy + model.additionWaterDestroy;
				movFireDestroy.txtValue.text = model.fireDestroy + model.additionFireDestroy;
				movEarthDestroy.txtValue.text = model.earthDestroy + model.additionEarthDestroy;
				
				movVitality.txtValue.text = model.vitality + model.additionVitality;
				movStrength.txtValue.text = model.strength + model.additionStrength;
				movAgility.txtValue.text = model.agility + model.additionAgility;
				movIntelligence.txtValue.text = model.intelligent + model.additionIntelligent;
				
				txtName.text = model.xmlData.name;
				txtClassName.text = "Phái " + model.unitClassXML.mainClassName + " - " + model.unitClassXML.subClassName;
				
				levelBar.levelPercent = (Number)(model.exp / model.maxExp);
				txtEXP.text = model.exp + "/" + model.maxExp;
				
				for each (var skillSlot:SkillSlot in skillsSlots) {
					movSkills.removeChild(skillSlot);
					Manager.pool.push(skillSlot, SkillSlot);
				}
				
				skillsSlots.splice(0);
				
				var i:int = 0;
				for each (var skill:Skill in model.skills) {
					if (skill && skill.xmlData) {
						if (skill.isEquipped) {
							skillSlot = Manager.pool.pop(SkillSlot) as SkillSlot;
							skillSlot.setData(skill);
							skillSlot.showHotKey(false);
							skillSlot.x = i * 40;
							skillsSlots.push(skillSlot);
							movSkills.addChild(skillSlot);
							skill.owner = model;
							i++;
						}
					}
				}
			}
		}
	}

}