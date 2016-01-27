package game.ui.tooltip.tooltips
{
	import core.util.FontUtil;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import game.enum.Font;
	
	/**
	 * ...
	 * @author chuongth2
	 */
	public class ConsumeEventTooltip extends MovieClip
	{
		public var consumeGoldTf:TextField;
		public var consumeXuTf:TextField;
		
		public var payGoldTf:TextField;
		public var payXuTf:TextField;
		
		public function ConsumeEventTooltip()
		{
			FontUtil.setFont(consumeGoldTf, Font.ARIAL);
			FontUtil.setFont(consumeXuTf, Font.ARIAL);
			FontUtil.setFont(payGoldTf, Font.ARIAL);
			FontUtil.setFont(payXuTf, Font.ARIAL);
		}
		
		public function update(obj:Object):void
		{
			if (obj)
			{
				consumeGoldTf.text = obj["consumeGold"] + " bạc";
				consumeXuTf.text = obj["consumeXu"] + " vàng";
				payGoldTf.text = obj["payGold"] + " bạc";
				payXuTf.text = obj["payXu"] + " vàng";
			}
		}
	}

}