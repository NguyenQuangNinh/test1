package game.ui.tooltip.tooltips 
{
	import core.util.FontUtil;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import game.enum.Font;
	import game.ui.tooltip.TooltipBase;
	
	/**
	 * ...
	 * @author MaiPTT
	 */
	public class SimpleTooltip extends TooltipBase 
	{
		private static const MAX_WIDTH	:int = 200;
		public var movBackground	:MovieClip;
		public var txtContent		:TextField;
		
		public function SimpleTooltip() {
			FontUtil.setFont(txtContent, Font.ARIAL);
			txtContent.autoSize = TextFieldAutoSize.LEFT;
		}
		
		public function set content(value:String):void {
			txtContent.htmlText = value;
			FontUtil.setFont(txtContent, Font.ARIAL);
			txtContent.width = 182;
			
			if (txtContent.textWidth < txtContent.width)
			{
				txtContent.width = txtContent.textWidth + 15;
			}
			
			movBackground.height = txtContent.textHeight + 15;
			if (txtContent.textWidth < MAX_WIDTH) {
				movBackground.width = txtContent.textWidth + 15;
			} else {
				movBackground.width = MAX_WIDTH;
			}
		}
	}

}