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
	public class RewardLevelContent extends MovieClip
	{
		public var contentTf:TextField;
		public function RewardLevelContent() 
		{
			FontUtil.setFont(contentTf, Font.ARIAL, true);
		}
		
	}

}