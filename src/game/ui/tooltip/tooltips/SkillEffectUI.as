package game.ui.tooltip.tooltips 
{
	import core.util.FontUtil;
	import core.util.MovieClipUtils;
	import core.util.TextFieldUtil;
	import flash.display.MovieClip;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormatAlign;
	import game.data.model.Character;
	import game.data.xml.DataType;
	import game.data.xml.SkillEffectFormulaXML;
	import game.enum.Font;
	import game.Game;
	/**
	 * ...
	 * @author TrungLNM
	 */
	public class SkillEffectUI extends MovieClip
	{
		public var nameTf:TextField;
		public var deActiveTf:TextField;
		
		private var _descTf:TextField;
		private var _descMov:MovieClip;
		
		private var _info:XML;
		private var _inCharacterID:int;
		private var _characterSubClass:String;
		private var _skillID:int;
		private var _skillLevel:int;
		
		public function SkillEffectUI() 
		{
			initUI();
		}
		
		private function initUI():void 
		{			
			_descMov = new MovieClip();
			_descMov.x = 0;
			_descMov.y = 30;
			addChild(_descMov);
			
			var glow : GlowFilter = new GlowFilter();
		 	glow.color = 0x45240f;
		 	glow.strength = 2;
			glow.quality = 3;
		 	glow.blurX = glow.blurY = 2;
			
			_descTf = TextFieldUtil.createTextfield(Font.ARIAL, 12, 235, 50, 0xFFFFFF, true, TextFormatAlign.LEFT, [glow]);
			_descTf.multiline = true;
			_descTf.wordWrap = true;
			_descTf.antiAliasType = "advanced";
			_descTf.autoSize = TextFieldAutoSize.NONE;		
			_descMov.addChild(_descTf);			
			
			FontUtil.setFont(nameTf, Font.ARIAL);
			//FontUtil.setFont(_descTf, Font.ARIAL);
			FontUtil.setFont(deActiveTf, Font.ARIAL);
		}
		
		public function updateEffect(inCharacterID:int, characterSubClass:String, skillID:int, skillLevel:int, info:XML, nextLevel:Boolean = false, owner:Character = null):void {
			_inCharacterID = inCharacterID;
			_characterSubClass = characterSubClass;
			_skillID = skillID;
			_skillLevel = skillLevel;
			_info = info;
			if (info) {
				var require:int = parseInt(info.@require.toString());
				//var name:String = info.@name.toString();
				var desc:String = info.toString();
				
				var pattern:RegExp = /{(.*?)}/;
				var result:String = desc.slice();
				
				var paraName:Array = [];
				var paraValue:Array = [];
				var paraColor:Array = [];
				//var paraBold:Array = [];
				var obj:Array = pattern.exec(result);
				
				while (obj) {				
					paraName.push("var_" + obj[1].toString());
					result = result.split(obj[0])[1];
					//if(obj) {
						var effectFormula:SkillEffectFormulaXML = Game.database.gamedata.getData(DataType.SKILL_EFFECT_FORMULA, obj[1]) as SkillEffectFormulaXML;
						if (effectFormula) {
							var value:String = effectFormula.doVal(_inCharacterID, _skillID, nextLevel, owner).toFixed(2).toString();
							if (value.substr(value.length - 3, value.length) == ".00") {
								value = value.substr(0, value.length - 3);								
							}
							paraValue.push(value);
							paraColor.push(effectFormula.color);
						}
						//paraBold.push(effectFormula.bold);
					//}
					obj = pattern.exec(result);
				}
				
				result = desc.slice();
				result = result.replace(/{/g, "var_");
				result = result.replace(/}/g, "");
				/*<font color="#FF0000">{1} [+{2}]</font>*/
				for each(var name:String in paraName) {
					var index:int = paraName.indexOf(name);
					result = result.replace(name, index != -1 ? 
							//(paraBold[index] != 0 ? '<b>' : '') +
							('<font color="' + paraColor[index] + '">' + paraValue[index] + '</font>') : 0)
							//paraValue[index] +
							//(paraBold[index] != 0 ? '</b>' : '') : 0);
				}
				//_descTf.text = "cong hoa xa hoi chu nghia viet nam doc lap tu do hanh phuc cong hoa xa hoi chu nghia viet nam doc lap tu do hanh phuc cong hoa xa hoi chu nghia viet nam doc lap tu do hanh phuc";
				_descTf.htmlText = result;
				_descTf.height = _descTf.textHeight + 12;
//				FontUtil.setFont(_descTf, Font.ARIAL);
				
				//var needRequire:Boolean = _skillLevel < parseInt(_info.@require.toString());
				var character:Character = Game.database.userdata.getCharacter(_inCharacterID);				
				var needRequire:Boolean = character ? character.level < parseInt(_info.@require.toString()) : false;
				nameTf.text = _info.@name.toString() + (!needRequire ? (" " + _characterSubClass) : "");
				if (needRequire) {				
					deActiveTf.text = "(Tầng " + parseInt(_info.@require.toString()) + " sẽ mở)";	
					_descTf.textColor = 0x000000;
				}
				
			}
		}
		
		
		
	}

}