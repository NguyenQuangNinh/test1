package game.ui.hud.gui
{
	import core.util.FontUtil;
	import core.util.TextFieldUtil;
	
	import flash.text.TextField;
	import flash.text.TextFormatAlign;
	
	import game.Game;
	import game.enum.Font;
	import game.enum.GameConfigID;
	import game.ui.hud.HUDButtonID;
	
	/**
	 * ...
	 * @author anhtinh
	 */
	public class LuckyGiftBtn extends HUDButton
	{
		public var messageTf:TextField;
		
		public function LuckyGiftBtn()
		{
			FontUtil.setFont(messageTf, Font.ARIAL, false);
			updateMessage();
			ID = HUDButtonID.LUCKY_GIFT;
		}
		
		public function updateMessage():void
		{
			var nXuConsumeNeed:int = Game.database.gamedata.getConfigData(GameConfigID.CONSUME_XU_NEED_CHANGE_LUCKY_GIFT_TIME) as int;
			messageTf.text = Game.database.userdata.luckyGiftXu.toString() + "/" + nXuConsumeNeed.toString()
		}
	}

}