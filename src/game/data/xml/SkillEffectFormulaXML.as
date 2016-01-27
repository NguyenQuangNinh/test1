package game.data.xml 
{
	import game.data.model.Character;
	import game.data.vo.skill.Skill;
	import game.Game;
	import math.CompiledObject;
	import math.MathParser;
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class SkillEffectFormulaXML extends XMLData
	{
		public var formula:String = "";		
		public var variables:XMLList;
		public var color:String = "";
		//public var bold:int;
		private var skillOwner:Character = null;

		private var _varArr:Array = [];
		private var _varVal:Array = [];
		
		private static const VAR_LEVEL:String = "LVL";
		private static const VAR_AP:String = "AP";
		
		public function SkillEffectFormulaXML() 
		{
			
		}
		
		override public function parseXML(xml:XML):void 
		{
			super.parseXML(xml);
			formula = xml.Formula.toString();
			color = xml.Color.toString();
			variables = xml.Var as XMLList;
			//bold = parseInt(xml.Bold.toString());
			
			for each(var variable:XML in variables) {
				_varArr.push(variable.@name.toString());
				_varVal.push(parseFloat(variable.@value.toString()));
			}
		}
		
		public function doVal(characterID:int, skillID:int, nextLevel:Boolean = false, owner:Character = null):Number {
			var result:Number = -1;
			skillOwner = owner;
			//EDIT: In case you wanted variables
			var varArr:Array = _varArr.concat(["lvl", "ap"]);
			var varVal:Array = _varVal.concat([nextLevel ? getSkillLevel(characterID, skillID) + 1 
														: getSkillLevel(characterID, skillID),
												getCharacterAP(characterID)]);
            var parser:MathParser = new MathParser(varArr);
            var compileObj:CompiledObject = parser.doCompile(formula);
            result = parser.doEval(compileObj.PolishArray, varVal);

			skillOwner = null;
			//var xyParser:MathParser = new MathParser(["x", "y"]);
            //var xyCompiledObj:CompiledObject = xyParser.doCompile("(x/3)*y+10");
            //var xyAnswer:Number = xyParser.doEval(xyCompiledObj.PolishArray, [10, 4]);
			//result = xyAnswer;
			return result;
		}
		
		private function getSkillLevel(characterID: int, skillID:int):int {
			var result:int = 0;
			var char:Character = Game.database.userdata.getCharacter(characterID);
			var skill:Skill;
			if (char && char.skills) {
				for each(skill in char.skills) {
					if (skill && skill.xmlData && skill.xmlData.ID == skillID){
						result = skill ? skill.level : result;
						break;
					}
				}
			}
			return result;
		}
		
		private function getCharacterAP(characterID: int):int {
			var result:int = 0;
			var char:Character = (skillOwner) ? skillOwner : Game.database.userdata.getCharacter(characterID);
			if (char) {
				result = char.magicalPower + char.additionMagicalPower;
			}
			return result;
		}
	}	

}