package game.ui.character_enhancement.character_upgrade
{
	import flash.display.MovieClip;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	
	import core.display.BitmapEx;
	import core.util.Enum;
	import core.util.FontUtil;
	
	import game.Game;
	import game.data.model.Character;
	import game.data.xml.DataType;
	import game.data.xml.ElementData;
	import game.enum.Element;
	import game.enum.ElementRelationship;
	import game.enum.Font;
	import game.enum.GameConfigID;
	import game.utility.ElementUtil;
	
	public class MaterialSlot extends MovieClip
	{
		public var avatarContainer:MovieClip;
		public var movElement:MovieClip;
		public var txtEXP:TextField;
		public var txtElementRelation:TextField;
		
		private var elementBg	:BitmapEx;
		private var avatar:BitmapEx;
		private var glowFilter:GlowFilter;
		private var character:Character;
		private var EXP:int;
		
		public function MaterialSlot()
		{
			avatar = new BitmapEx();
			avatarContainer.addChild(avatar);
			
			elementBg = new BitmapEx();
			movElement.addChild(elementBg);
			
			FontUtil.setFont(txtElementRelation, Font.TAHOMA, true);
			
			glowFilter = new GlowFilter(0, 1, 3, 3, 10);
		}
		
		public function getEXP():int { return EXP; }
		
		public function getData():Character { return character; }
		public function setData(materialCharacter:Character, mainCharacter:Character):void
		{
			character = materialCharacter;
			if(materialCharacter != null)
			{
				avatar.load(materialCharacter.xmlData.largeAvatarURLs[materialCharacter.sex]);
				var elementData:ElementData = Game.database.gamedata.getData(DataType.ELEMENT, materialCharacter.element) as ElementData;
				if (elementData) {
					elementBg.load(elementData.characterSlotImgURL);
				}
				if(mainCharacter != null)
				{
					setPowerTransfer(materialCharacter.transmissionExp, ElementUtil.getElementRelationship(materialCharacter.element, mainCharacter.element));
				}
				else
				{
					txtEXP.text = "";
					EXP = 0;
				}
			}
			else
			{
				avatar.reset();
				elementBg.reset();
				txtEXP.text = "";
				txtElementRelation.text = "";
				EXP = 0;
			}
		}
		
		private function setPowerTransfer(exp:int, elementRelationship:int):void
		{
			var penalty:int;
			var color:String;
			var glowColor:int;
			switch(elementRelationship)
			{
				case ElementRelationship.NORMAL:
				case ElementRelationship.GENERATED:
					penalty = 100;
					color = "#ffffff";
					glowColor = 0x000000;
					break;
				case ElementRelationship.GENERATING:
					penalty = 100 + Game.database.gamedata.getConfigData(GameConfigID.TRANMISSION_GENERATING_PERCENT);
					color = "#00ff00";
					glowColor = 0x003300;
					break;
				case ElementRelationship.RESIST:
					penalty = 100 - Game.database.gamedata.getConfigData(GameConfigID.TRANMISSION_OVERCOMING_PERCENT);
					color = "#999999";
					glowColor = 0x333333;
					break;
				case ElementRelationship.DESTROY:
					penalty = 0;
					color = "#ff0000";
					glowColor = 0x330000;
					break;
			}
			if(penalty > 0)
			{
				EXP = exp * (penalty / 100);
				if (Element(Enum.getEnum(Element, character.element))) {
					txtElementRelation.text = Element(Enum.getEnum(Element, character.element)).elementName + " " + penalty + "%";
				} else {
					txtElementRelation.text = "Vô Hệ 100%";
				}
				txtEXP.htmlText = "<font color = \'" + color + "\'>+" + EXP + "</font>";
			}
			else
			{
				txtEXP.htmlText = "<font color = \'" + color + "\'>xung khắc</font>";
				EXP = 0;
			}
			glowFilter.color = glowColor;
			txtEXP.filters = [glowFilter];
			FontUtil.setFont(txtEXP, Font.TAHOMA, true);
		}
	}
}