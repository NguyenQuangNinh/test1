package game.ui.metal_furnace.gui 
{
	import core.util.FontUtil;
	import core.util.Utility;
	import flash.display.Sprite;
	import flash.text.TextField;
	import game.enum.Font;
	/**
	 * ...
	 * @author anhtinh
	 */
	public class ScrollInfo extends Sprite
	{
		public var xuTf : TextField;
		public var goldTf : TextField;
		
		public function ScrollInfo() 
		{
			FontUtil.setFont(xuTf, Font.ARIAL, true);
			FontUtil.setFont(goldTf, Font.ARIAL, true);
		}
		
		public function setData(xu : int, gold : int) : void {
			xuTf.text = Utility.math.formatInteger(xu);
			goldTf.text = Utility.math.formatInteger(gold);
		}
	}

}