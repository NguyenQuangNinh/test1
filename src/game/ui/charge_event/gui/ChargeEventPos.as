package game.ui.charge_event.gui
{
	import core.util.FontUtil;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import game.enum.Font;
	
	/**
	 * ...
	 * @author chuongth2
	 */
	public class ChargeEventPos extends MovieClip
	{
		public var quantityTf:TextField;
		
		public function ChargeEventPos()
		{
			FontUtil.setFont(quantityTf, Font.ARIAL);
			quantityTf.text = "";
		}
		
		public function init(posX:int, quantity:int):void
		{
			this.x = posX;
			quantityTf.text = quantity.toString();
		}
	}

}