package game.ui.player_profile
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	import core.util.FontUtil;
	
	import game.Game;
	import game.data.xml.BonusAttrNameMappingXML;
	import game.data.xml.DataType;
	import game.enum.Font;
	import game.utility.GameUtil;
	
	public class FormationEffect extends MovieClip
	{
		public var txtEffect:TextField;
		
		public function FormationEffect()
		{
			FontUtil.setFont(txtEffect, Font.ARIAL, true);
		}
		
		public function setData(data:Object):void
		{
			if(data != null)
			{
				var xmlData:BonusAttrNameMappingXML = Game.database.gamedata.getData(DataType.BONUS_ATTR_NAME_MAPPING, data.buffType) as BonusAttrNameMappingXML;
				if(xmlData != null) 
				{
					//txtEffect.text = "+" + data.buffValue + " " + xmlData.name;
					txtEffect.text = GameUtil.getBonusTextByValue(data.buffType, data.buffValueType, data.buffValue, data.targetType, data.buffTargetTypes);
					txtEffect.autoSize = TextFieldAutoSize.LEFT;
				}
			}
		}
	}
}