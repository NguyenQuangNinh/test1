/**
 * Created by NinhNQ on 11/6/2014.
 */
package game.ui.hud.gui
{
	import core.util.FontUtil;

	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.text.TextField;
	import game.enum.Font;

	public class ChargeBtn extends  MovieClip
	{
		public var text:TextField;
		public var btn:SimpleButton;

		public function ChargeBtn()
		{
			FontUtil.setFont(text,Font.ARIAL, true);
			text.mouseEnabled = false;
			text.wordWrap = true;
			text.multiline = true;
		}

		public function showFirstCharge(value:Boolean):void
		{
			text.text = value ? "Quà Nạp Lần Đầu" : "Nạp Vàng";
		}
	}
}
