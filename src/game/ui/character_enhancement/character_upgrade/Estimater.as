/**
 * Created by NinhNQ on 11/21/2014.
 */
package game.ui.character_enhancement.character_upgrade
{

	import core.util.FontUtil;

	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

	import game.Game;

	import game.data.model.Character;

	import game.enum.Font;
	import game.enum.GameConfigID;
	import game.utility.ElementUtil;
	import game.utility.GameUtil;

	public class Estimater extends MovieClip
	{
		public var currTf:TextField;
		public var nextTf:TextField;
		private var mainChar:Character;

		public function Estimater()
		{
			FontUtil.setFont(currTf, Font.ARIAL, true);
			FontUtil.setFont(nextTf, Font.ARIAL, true);

			currTf.autoSize = TextFieldAutoSize.LEFT;
			nextTf.autoSize = TextFieldAutoSize.LEFT;

			currTf.text = "";
			nextTf.text = "";
		}

		public function setMainChar(character:Character):void
		{
			mainChar = character;
			if(character != null)
			{
				var currentLevel:int = (character.level % 12 == 0) ? 12 : character.level % 12;
				currTf.text = "Tầng " + currentLevel + ": " + character.exp + " điểm.";
			}
		}

		public function updateMaterials(charIDs:Array):void
		{
			var ID:int;
			var materialCharacter:Character;
			var totalExp:int = 0;
			if(mainChar)
			{
				if(!isEmpty(charIDs))
				{

					for(var i:int = 0, length:int = charIDs.length; i < length; ++i)
					{
						ID = charIDs[i];
						materialCharacter = Game.database.userdata.getCharacter(ID);
						if(materialCharacter)
						{
							totalExp += GameUtil.getTotalPowerTransmission(materialCharacter.transmissionExp, ElementUtil.getElementRelationship(materialCharacter.element, mainChar.element));
						}
					}

					totalExp += mainChar.exp;

					var expTable:Array = Game.database.gamedata.getConfigData(GameConfigID.EXP_TABLE);
					var nextLevel:int = mainChar.level;
					var nextMaxExp:int = 0;

					while(true)
					{
						if (nextLevel % 12 == 0 && nextLevel > 0) break;
						nextMaxExp = expTable[nextLevel + 1];
						
						if(totalExp - nextMaxExp >= 0)
						{
							nextLevel++;
							totalExp -= nextMaxExp;
						}
						else break;
					}
					if (nextLevel % 12 == 0)
					{
						if (totalExp > expTable[nextLevel + 1]) nextTf.text = "Tầng " + 12 + ": dư " + (totalExp - expTable[nextLevel + 1]) + " điểm.";
						else nextTf.text = "Tầng " + 12 + ": " + (totalExp) + " điểm.";
					}
					else nextTf.text = "Tầng " + (nextLevel % 12) + ": " + (totalExp) + " điểm.";
				}
				else
				{
					nextTf.text = "";
				}
			}
		}

		private function isEmpty(charIDs:Array):Boolean
		{
			for each (var id:int in charIDs)
			{
				if(id != -1) return false;;
			}

			return true;
		}
	}
}
