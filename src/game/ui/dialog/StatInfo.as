package game.ui.dialog
{
	import core.util.FontUtil;
	
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	import game.enum.Font;
	
	public class StatInfo extends MovieClip
	{
		public var txtOldValue:TextField;
		public var txtNewValue:TextField;
		public var txtDelta:TextField;
		
		public function StatInfo()
		{
			FontUtil.setFont(txtOldValue, Font.TAHOMA);
			FontUtil.setFont(txtNewValue, Font.TAHOMA);
			FontUtil.setFont(txtDelta, Font.TAHOMA);
		}
		
		public function setData(oldValue:int, newValue:int):void
		{
			txtOldValue.text = oldValue.toString();
			txtNewValue.text = newValue.toString();
			var delta:int = newValue - oldValue;
			txtDelta.text = delta > 0 ? "(+" + delta + ")" : "";
		}
	}
}