package game.ui.hud.gui
{
	import core.util.FontUtil;
	import flash.text.TextField;
	import game.enum.Font;
	import game.ui.hud.HUDButtonID;

	public class ButtonChat extends HUDButton
	{
		public var msgTf:TextField;
		public function ButtonChat()
		{
			ID = HUDButtonID.CHAT;
			FontUtil.setFont(msgTf, Font.ARIAL, false);
			msgTf.text = "";
		}
		
		public function updateMessage(msg:String):void
		{
			msgTf.text = msg;
		}
	}
}