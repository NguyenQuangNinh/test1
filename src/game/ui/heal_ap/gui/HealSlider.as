package game.ui.heal_ap.gui 
{
	import core.display.animation.Animator;
	import core.display.BitmapEx;
	import core.util.TextFieldUtil;
	import core.util.Utility;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormatAlign;
	import game.enum.Font;
	/**
	 * ...
	 * @author anhtinh
	 */
	public class HealSlider extends Sprite
	{
		private var amountTf : TextField;
		
		public function HealSlider() 
		{
			var sliderAnim : BitmapEx = new BitmapEx();
			sliderAnim.load("resource/image/chuot.png");
			sliderAnim.x = -20;
			this.addChild(sliderAnim);
			
			amountTf = TextFieldUtil.createTextfield(Font.ARIAL, 16, 60, 25, 0x00FF00, true, TextFormatAlign.RIGHT);
			amountTf.text = "+0";
			amountTf.x = -43;
			amountTf.y = -48;
			this.addChild(amountTf);
			this.buttonMode = true;
		}
		
		public function setAddedAmount(amount : int) : void {
			amountTf.text = "+" + Utility.math.formatInteger(amount);
		}
		
	}

}