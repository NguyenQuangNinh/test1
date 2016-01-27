package game.ui.present.gui 
{
	import core.util.FontUtil;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import game.enum.Font;
	/**
	 * ...
	 * @author chuongth2
	 */
	public class PresentTopContentTop extends MovieClip
	{
		public var msgTf:TextField;
		public var exprieTimeTf:TextField;
		public function PresentTopContentTop() 
		{
			FontUtil.setFont(exprieTimeTf, Font.ARIAL, true);
			FontUtil.setFont(msgTf, Font.ARIAL, false);
		}
	}

}