package game.ui.guild.popups 
{
	import components.popups.OKCancelPopup;
	import core.util.FontUtil;
	import flash.display.SimpleButton;
	import flash.text.TextField;
	import game.enum.Font;
	/**
	 * ...
	 * @author vu anh
	 */
	public class GuildAnnoucePopup extends OKCancelPopup
	{
		public var tf:TextField;
		public function GuildAnnoucePopup() 
		{
			FontUtil.setFont(tf, Font.ARIAL, true);
		}
		
	}

}