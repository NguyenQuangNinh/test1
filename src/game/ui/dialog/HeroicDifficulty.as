package game.ui.dialog
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	import core.util.FontUtil;
	import core.util.Utility;
	
	import game.Game;
	import game.enum.Font;
	import game.ui.components.CheckBox;
	
	public class HeroicDifficulty extends MovieClip
	{
		public var checkbox:CheckBox;
		public var label:MovieClip;
		public var txtLevelRequired:TextField;
		
		public function HeroicDifficulty()
		{
			checkbox.setBackgroundStype(CheckBox.BACKGROUND_STYLE_ROUND);
			FontUtil.setFont(txtLevelRequired, Font.ARIAL, true);
		}
		
		public function setData(data:int):void
		{
			label.gotoAndStop(data);
		}
		
		public function setLevelRequired(value:int):void
		{
			txtLevelRequired.text = "Lv." + value;
			if(Game.database.userdata.level < value)
			{
				checkbox.mouseEnabled = false;
				checkbox.mouseChildren = false;
				Utility.setGrayscale(this, true);
			}
			else
			{
				checkbox.mouseEnabled = true;
				checkbox.mouseChildren = true;
				Utility.setGrayscale(this, false);
			}
		}
	}
}