package game.ui.heal_hp.gui 
{
	import core.util.FontUtil;
	import core.util.TextFieldUtil;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import game.enum.Font;
	/**
	 * ...
	 * @author anhtinh
	 */
	public class FoodInfoPanel extends Sprite
	{
		private static const TEXT1 : String = "giúp hồi phục sinh lực cho toàn đội và cung cấp";
		private static const TEXT2 : String = "Sinh lực dự trữ";
		
		public var foodNameTf : TextField;
		public var totalHpTf : TextField;
		
		public function FoodInfoPanel() 
		{
			FontUtil.setFont(foodNameTf, Font.ARIAL, true);
			FontUtil.setFont(totalHpTf, Font.ARIAL, true);
		}
		
		public function setFoodName(foodName : String) : void {
			
			foodNameTf.text = foodName + " " + TEXT1;
			
			var length : int = foodName.length;
			TextFieldUtil.setColor(foodNameTf, 0, length, 0xFF00FF);
		}
		
		public function setTotalHp(totalHpStr : String) : void {
			totalHpTf.text = totalHpStr + " " + TEXT2;
			
			var length : int = totalHpStr.length;
			TextFieldUtil.setColor(totalHpTf, 0, length, 0x00FF00);
		}
		
	}

}