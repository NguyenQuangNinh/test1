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
	public class MessageGuildPopup extends OKCancelPopup
	{
		public function MessageGuildPopup() 
		{
			FontUtil.setFont(messageTf, Font.ARIAL, true);
		}
		
	}

}