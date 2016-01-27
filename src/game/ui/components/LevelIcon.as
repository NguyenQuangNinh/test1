package game.ui.components 
{
	import core.util.FontUtil;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import game.enum.Font;
	
	/**
	 * ...
	 * @author MaiPTT
	 */
	public class LevelIcon extends MovieClip 
	{
		public var txtLevel		:TextField;

		public function LevelIcon() {
			FontUtil.setFont(txtLevel, Font.ARIAL, true);
		}
		
		public function set level(value:int):void {
			if (value > 0) {
				this.visible = true;
				if (value.toString().length == 1) {
					txtLevel.text = "0" + value.toString() + " tầng";	
				} else {
					txtLevel.text = value.toString() + " tầng";
				}
			} else {
				this.visible = false;
				txtLevel.text = "";
			}
		}
	}

}